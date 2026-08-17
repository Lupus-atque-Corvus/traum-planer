import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/wiederholung_logik.dart';
import '../models/eintrag_status.dart';
import 'database_provider.dart';

/// Aktuelles Kalenderdatum (nur Datum, keine Uhrzeit) — aktualisiert sich
/// automatisch bei Tageswechsel um Mitternacht (Phase 3, "Tageswechsel um
/// Mitternacht automatisch").
final heutigesDatumProvider = StreamProvider<DateTime>((ref) async* {
  DateTime aktuell = nurDatum(DateTime.now());
  yield aktuell;
  while (true) {
    final morgenMitternacht = DateTime(aktuell.year, aktuell.month, aktuell.day + 1);
    final wartezeit = morgenMitternacht.difference(DateTime.now());
    await Future.delayed(wartezeit.isNegative ? const Duration(seconds: 1) : wartezeit);
    aktuell = nurDatum(DateTime.now());
    yield aktuell;
  }
});

/// Vom Nutzer per Navigation gewähltes Datum in der Tages-/Wochen-/
/// Monatsansicht. Startet auf "heute", kann vor und zurück (auch in die
/// Vergangenheit) bewegt werden.
final ausgewaehltesDatumProvider = StateProvider<DateTime>((ref) => nurDatum(DateTime.now()));

/// Noch offene, für heute fällige Vorkommen mit Uhrzeit — Grundlage für die
/// Erinnerungsbenachrichtigungen (Phase 6).
final heuteOffeneVorkommenProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(vorkommenRepositoryProvider);
  final heute = ref.watch(heutigesDatumProvider).valueOrNull ?? nurDatum(DateTime.now());
  return repo
      .beobachteZeitraum(heute, heute)
      .map((liste) => liste.where((v) => v.status == EintragStatus.offen).toList());
});

DateTime montagDerWoche(DateTime datum) => datum.subtract(Duration(days: datum.weekday - 1));

List<DateTime> wochenTage(DateTime irgendeinTagDerWoche) {
  final montag = montagDerWoche(irgendeinTagDerWoche);
  return List.generate(7, (i) => montag.add(Duration(days: i)));
}
