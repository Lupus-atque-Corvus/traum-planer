import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/wiederholung_logik.dart';
import 'database_provider.dart';
import 'kalender_provider.dart';

/// Globaler Streak: Anzahl aufeinanderfolgender Tage bis einschließlich
/// heute, an denen alle fälligen Vorkommen erledigt wurden (pünktlich oder
/// verspätet nachgeholt zählt beides als "erledigt an dem Tag"). Ein Tag
/// ohne fällige Aufgaben unterbricht die Kette nicht.
final globalerStreakProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(vorkommenRepositoryProvider);
  final heute = ref.watch(heutigesDatumProvider).valueOrNull ?? nurDatum(DateTime.now());
  final von = heute.subtract(const Duration(days: 90));

  return repo.beobachteZeitraum(von, heute).map((vorkommen) {
    final proTag = <DateTime, List<bool>>{};
    for (final v in vorkommen) {
      proTag.putIfAbsent(v.datum, () => []).add(v.istErledigt);
    }

    var streak = 0;
    for (var tag = heute; !tag.isBefore(von); tag = tag.subtract(const Duration(days: 1))) {
      final eintraege = proTag[tag];
      final alleErledigt = eintraege == null || eintraege.isEmpty || eintraege.every((e) => e);
      if (!alleErledigt) {
        if (tag == heute) continue; // heutiger, noch laufender Tag zählt erst am Ende
        break;
      }
      if (eintraege != null && eintraege.isNotEmpty) streak++;
    }
    return streak;
  });
});
