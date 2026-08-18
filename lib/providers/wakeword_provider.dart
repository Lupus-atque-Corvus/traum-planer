import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/wakeword/wakeword_enrollment_service.dart';
import '../services/wakeword/wakeword_service.dart';
import 'einstellungen_provider.dart';
import 'fenster_provider.dart';

final wakeWordEnrollmentServiceProvider = Provider<WakeWordEnrollmentService>((ref) {
  final service = WakeWordEnrollmentService();
  ref.onDispose(service.dispose);
  return service;
});

final wakeWordServiceProvider = Provider<WakeWordService>((ref) {
  final service = WakeWordService();
  ref.onDispose(service.dispose);
  return service;
});

/// Ob gerade etwas anderes das Mikrofon exklusiv braucht: der Aufnahme-
/// Dialog in den Einstellungen (`aktivierungswort_dialog.dart`) oder das
/// Aktivierungswort-Overlay selbst, nachdem es ausgelöst wurde
/// (`wakeword_overlay_provider.dart`). In beiden Fällen muss
/// `WakeWordService` pausieren — ein Gerät, kein gleichzeitiger Zugriff.
final wakeWordMikrofonBelegtProvider = StateProvider<bool>((ref) => false);

/// Ob alle 3 Proben aufgenommen wurden — aus dem Zeitstempel abgeleitet
/// statt eines eigenen Dateisystem-Checks (der Zeitstempel wird zusammen
/// mit den Proben aktuell gehalten, siehe `aktivierungswort_dialog.dart`).
final aktivierungswortSamplesVorhandenProvider = Provider<bool>((ref) {
  return ref.watch(aktivierungswortAufgenommenAmProvider).valueOrNull != null;
});

/// Ob die Aktivierungswort-Erkennung laut aktuellen Einstellungen,
/// Fenster-Sichtbarkeit und Mikrofon-Belegung laufen soll (siehe Plan
/// "Aktivierungswort für den Sprachassistenten", Abschnitt 7). Der
/// eigentliche Start/Stopp erfolgt imperativ in
/// `_HintergrunddiensteBootstrapState.build()`, analog zum bestehenden
/// `benachrichtigungServiceProvider`-Muster.
final wakeWortSollLauschenProvider = Provider<bool>((ref) {
  final aktiv = ref.watch(aktivierungswortAktivProvider).valueOrNull ?? false;
  final vorhanden = ref.watch(aktivierungswortSamplesVorhandenProvider);
  final modus = ref.watch(aktivierungswortHintergrundModusProvider).valueOrNull ?? 'nurFenster';
  final fensterSichtbar = ref.watch(fensterSichtbarProvider).valueOrNull ?? true;
  final mikrofonBelegt = ref.watch(wakeWordMikrofonBelegtProvider);
  return aktiv && vorhanden && !mikrofonBelegt && (modus == 'auchTray' || fensterSichtbar);
});

final wakeWordLifecycleProvider = Provider<WakeWordLifecycle>((ref) {
  return WakeWordLifecycle(
    service: ref.watch(wakeWordServiceProvider),
    enrollment: ref.watch(wakeWordEnrollmentServiceProvider),
    empfindlichkeit: () => ref.read(aktivierungswortEmpfindlichkeitProvider).valueOrNull ?? 1.4,
  );
});

/// Startet/stoppt [WakeWordService] idempotent passend zu
/// [wakeWortSollLauschenProvider]. Läuft nie zwei Synchronisierungen
/// gleichzeitig; kommt während einer laufenden ein neuer Zielzustand
/// herein, wird er danach nachgeholt statt verworfen.
class WakeWordLifecycle {
  final WakeWordService service;
  final WakeWordEnrollmentService enrollment;
  final double Function() empfindlichkeit;

  WakeWordLifecycle({required this.service, required this.enrollment, required this.empfindlichkeit});

  bool _laeuftGerade = false;
  bool? _ausstehenderZustand;
  bool _vorlagenGeladen = false;

  void synchronisieren(bool sollLauschen) {
    if (_laeuftGerade) {
      _ausstehenderZustand = sollLauschen;
      return;
    }
    _laeuftGerade = true;
    _synchronisierenAsync(sollLauschen).whenComplete(() {
      _laeuftGerade = false;
      final naechster = _ausstehenderZustand;
      _ausstehenderZustand = null;
      if (naechster != null) synchronisieren(naechster);
    });
  }

  Future<void> _synchronisierenAsync(bool sollLauschen) async {
    if (sollLauschen && !service.istAktiv) {
      if (!_vorlagenGeladen) {
        final proben = await enrollment.probenLaden();
        service.vorlagenSetzen(proben, empfindlichkeit: empfindlichkeit());
        _vorlagenGeladen = proben.isNotEmpty;
      }
      if (_vorlagenGeladen) {
        await service.starten();
      }
    } else if (!sollLauschen && service.istAktiv) {
      await service.stoppen();
    }
  }

  /// Erzwingt ein Neuladen der Vorlagen beim nächsten Start (nach einer
  /// Neuaufnahme/Löschung in den Einstellungen).
  void vorlagenUngueltigMachen() {
    _vorlagenGeladen = false;
  }
}
