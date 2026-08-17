import 'dart:async';
import 'dart:io';

import 'package:local_notifier/local_notifier.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/vorkommen.dart';
import '../utils/zeit_format.dart';

/// Plant lokale Desktop-Benachrichtigungen X Minuten vor Fälligkeit
/// (Phase 6). Rein clientseitiger Timer — kein Polling, ein `Timer` pro
/// noch nicht ausgelöster Erinnerung.
class BenachrichtigungService {
  final Set<String> _geplant = {};
  final Map<String, Timer> _timers = {};

  Future<void> init() async {
    if (Platform.isWindows || Platform.isLinux) {
      await localNotifier.setup(appName: 'TRAUM Planer');
    }
  }

  void aktualisieren({
    required List<Vorkommen> offeneVorkommenHeute,
    required int vorlaufMinuten,
    required bool ist24h,
    required AppLocalizations l10n,
  }) {
    final jetzt = DateTime.now();
    for (final v in offeneVorkommenHeute) {
      final minuten = v.uhrzeitMinuten;
      if (minuten == null) continue;

      final schluessel = '${v.aufgabe.id}_${v.datum.toIso8601String()}_$minuten';
      if (_geplant.contains(schluessel)) continue;

      final faelligZeitpunkt =
          DateTime(v.datum.year, v.datum.month, v.datum.day).add(Duration(minutes: minuten));
      final erinnerungsZeitpunkt = faelligZeitpunkt.subtract(Duration(minutes: vorlaufMinuten));
      final wartezeit = erinnerungsZeitpunkt.difference(jetzt);
      if (wartezeit.isNegative) continue;

      _geplant.add(schluessel);
      _timers[schluessel] = Timer(wartezeit, () {
        _timers.remove(schluessel);
        LocalNotification(
          title: l10n.benachrichtigungAufgabeFaelligTitel(v.titel),
          body: l10n.benachrichtigungAufgabeFaelligKoerper(
            formatiereUhrzeit(minuten, ist24h: ist24h),
          ),
        ).show();
      });
    }
  }

  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _geplant.clear();
  }
}
