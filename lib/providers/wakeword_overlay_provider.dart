import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart' show Amplitude;

import '../services/assistent_orchestrator.dart';
import '../services/ollama_service.dart';
import '../services/stt_service.dart';
import '../services/tts_service.dart';
import 'assistent_chat_provider.dart';
import 'einstellungen_provider.dart';
import 'wakeword_provider.dart';

/// Zustände des Aktivierungswort-Overlays (siehe Plan "Aktivierungswort
/// für den Sprachassistenten", Abschnitt 4).
enum WakeWordUeberlagerungZustand {
  idle,
  hoerendAufAnfrage,
  erkannteAnfrageAngezeigt,
  denktNach,
  antwortAngezeigtUndSpricht,
  folgefensterOffen,
}

class WakeWordUeberlagerungState {
  final WakeWordUeberlagerungZustand zustand;
  final String anfrageText;
  final String antwortText;

  const WakeWordUeberlagerungState({
    this.zustand = WakeWordUeberlagerungZustand.idle,
    this.anfrageText = '',
    this.antwortText = '',
  });

  bool get istOffen => zustand != WakeWordUeberlagerungZustand.idle;

  WakeWordUeberlagerungState kopieren({
    WakeWordUeberlagerungZustand? zustand,
    String? anfrageText,
    String? antwortText,
  }) {
    return WakeWordUeberlagerungState(
      zustand: zustand ?? this.zustand,
      anfrageText: anfrageText ?? this.anfrageText,
      antwortText: antwortText ?? this.antwortText,
    );
  }
}

/// Treibt das Aktivierungswort-Overlay: reagiert auf Treffer von
/// `WakeWordService`, nimmt die Anfrage über `SttService` auf (inkl.
/// automatischem Stopp bei Stille), lässt sie von `AssistentOrchestrator`
/// beantworten, spricht die Antwort über `TtsService` und öffnet danach
/// kurz ein Folgefenster für Anschlussfragen ohne erneutes
/// Aktivierungswort. Jeder Rundenstart erhöht [_generation] — laufende
/// Continuations prüfen sie und brechen sauber ab, sobald manuell
/// geschlossen oder eine neue Runde gestartet wird.
class WakeWordUeberlagerungController extends StateNotifier<WakeWordUeberlagerungState> {
  final Ref _ref;
  StreamSubscription<void>? _trefferAbo;
  int _generation = 0;

  static const _wartenAufSprachbeginn = Duration(seconds: 2);
  static const _folgefensterWartezeit = Duration(seconds: 7);
  static const _stilleBisAufnahmeEnde = Duration(milliseconds: 800);
  static const _maxAufnahmeDauer = Duration(seconds: 8);
  static const _autoSchliessenNachFehler = Duration(seconds: 4);
  // dBFS-Schwelle für "es wird gerade gesprochen" — braucht reales
  // Mikrofon-Tuning, siehe Plan-Risiken.
  static const _stilleSchwelleDbfs = -35.0;

  WakeWordUeberlagerungController(this._ref) : super(const WakeWordUeberlagerungState()) {
    _trefferAbo = _ref.read(wakeWordServiceProvider).treffer.listen((_) => _ausgeloest());
  }

  SttService get _stt => _ref.read(sttServiceProvider);
  AssistentOrchestrator get _orchestrator => _ref.read(assistentOrchestratorProvider);
  TtsService get _tts => _ref.read(ttsServiceProvider);

  void _mikrofonSperren(bool gesperrt) {
    _ref.read(wakeWordMikrofonBelegtProvider.notifier).state = gesperrt;
  }

  Future<void> _ausgeloest() async {
    if (state.istOffen) return; // schon in einer laufenden Interaktion
    _generation++;
    final generation = _generation;
    _mikrofonSperren(true);
    await _ref.read(wakeWordServiceProvider).stoppen();
    if (generation != _generation) return;
    await _rundeAusfuehren(generation, istFolgefrage: false);
  }

  Future<void> _rundeAusfuehren(int generation, {required bool istFolgefrage}) async {
    state = state.kopieren(
      zustand: istFolgefrage
          ? WakeWordUeberlagerungZustand.folgefensterOffen
          : WakeWordUeberlagerungZustand.hoerendAufAnfrage,
      anfrageText: istFolgefrage ? state.anfrageText : '',
      antwortText: istFolgefrage ? state.antwortText : '',
    );

    final berechtigt = await _stt.mikrofonBerechtigungVorhanden();
    if (!berechtigt || generation != _generation) {
      _schliessenIntern(generation);
      return;
    }

    await _stt.aufnahmeStarten();
    final gesprochen = await _bisStilleWarten(
      generation,
      wartenAufSprachbeginn: istFolgefrage ? _folgefensterWartezeit : _wartenAufSprachbeginn,
    );
    if (generation != _generation) return;

    if (!gesprochen) {
      await _stt.aufnahmeAbbrechen();
      _schliessenIntern(generation);
      return;
    }

    state = state.kopieren(zustand: WakeWordUeberlagerungZustand.erkannteAnfrageAngezeigt);
    final text = await _stt.aufnahmeStoppenUndErkennen();
    if (generation != _generation) return;

    if (text.trim().isEmpty) {
      _schliessenIntern(generation);
      return;
    }

    state = state.kopieren(anfrageText: text, zustand: WakeWordUeberlagerungZustand.denktNach);
    await _anfrageBeantworten(text, generation);
  }

  /// Wartet bis zu [wartenAufSprachbeginn] auf Sprachbeginn (sonst
  /// `false`), danach auf [_stilleBisAufnahmeEnde] durchgehende Stille
  /// (dann `true`) — über `record`s vorhandenen Lautstärke-Stream, siehe
  /// Plan Abschnitt 5. Harte Obergrenze [_maxAufnahmeDauer] unabhängig
  /// vom Sprachbeginn.
  Future<bool> _bisStilleWarten(int generation, {required Duration wartenAufSprachbeginn}) async {
    final completer = Completer<bool>();
    var sprachbegonnen = false;
    Timer? sprachbeginnTimeout;
    Timer? stilleTimer;
    late StreamSubscription<Amplitude> sub;

    void beenden(bool ergebnis) {
      sprachbeginnTimeout?.cancel();
      stilleTimer?.cancel();
      sub.cancel();
      if (!completer.isCompleted) completer.complete(ergebnis);
    }

    sprachbeginnTimeout = Timer(wartenAufSprachbeginn, () {
      if (!sprachbegonnen) beenden(false);
    });
    final harteObergrenze = Timer(_maxAufnahmeDauer, () => beenden(true));

    sub = _stt.lautstaerkeStream().listen((amp) {
      if (generation != _generation) {
        beenden(false);
        return;
      }
      if (amp.current > _stilleSchwelleDbfs) {
        sprachbegonnen = true;
        sprachbeginnTimeout?.cancel();
        stilleTimer?.cancel();
        stilleTimer = null;
      } else if (sprachbegonnen) {
        stilleTimer ??= Timer(_stilleBisAufnahmeEnde, () => beenden(true));
      }
    });

    final ergebnis = await completer.future;
    harteObergrenze.cancel();
    return ergebnis;
  }

  Future<void> _anfrageBeantworten(String text, int generation) async {
    try {
      final verlauf = [OllamaNachricht(rolle: 'user', inhalt: text)];
      final antwort = await _orchestrator.nachrichtSenden(verlauf);
      if (generation != _generation) return;
      state = state.kopieren(
        antwortText: antwort,
        zustand: WakeWordUeberlagerungZustand.antwortAngezeigtUndSpricht,
      );

      if (_ref.read(ttsAktivProvider)) {
        final sprache = _ref.read(spracheProvider).valueOrNull ?? 'de';
        await _tts.sprechen(antwort, sprache: sprache == 'en' ? 'en' : 'de');
      }
      if (generation != _generation) return;
      await _rundeAusfuehren(generation, istFolgefrage: true);
    } catch (e) {
      if (generation != _generation) return;
      state = state.kopieren(
        antwortText: '⚠ $e',
        zustand: WakeWordUeberlagerungZustand.antwortAngezeigtUndSpricht,
      );
      Timer(_autoSchliessenNachFehler, () {
        if (generation == _generation) _schliessenIntern(generation);
      });
    }
  }

  void _schliessenIntern(int generation) {
    if (generation != _generation) return;
    state = const WakeWordUeberlagerungState();
    _mikrofonSperren(false);
  }

  /// Manuelles Schließen (Klick außerhalb/Esc), jederzeit möglich. Bricht
  /// eine laufende Aufnahme ab; kann eine bereits laufende TTS-Wiedergabe
  /// nicht stoppen (bestehende `TtsService`-Einschränkung, siehe Plan-
  /// Risiken).
  Future<void> schliessenManuell() async {
    final vorherigerZustand = state.zustand;
    _generation++;
    if (vorherigerZustand == WakeWordUeberlagerungZustand.hoerendAufAnfrage ||
        vorherigerZustand == WakeWordUeberlagerungZustand.erkannteAnfrageAngezeigt ||
        vorherigerZustand == WakeWordUeberlagerungZustand.folgefensterOffen) {
      await _stt.aufnahmeAbbrechen();
    }
    state = const WakeWordUeberlagerungState();
    _mikrofonSperren(false);
  }

  @override
  void dispose() {
    _trefferAbo?.cancel();
    super.dispose();
  }
}

final wakeWordUeberlagerungProvider =
    StateNotifierProvider<WakeWordUeberlagerungController, WakeWordUeberlagerungState>((ref) {
  return WakeWordUeberlagerungController(ref);
});
