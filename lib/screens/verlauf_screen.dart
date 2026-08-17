import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/wiederholung_logik.dart';
import '../l10n/gen/app_localizations.dart';
import '../models/eintrag_status.dart';
import '../models/vorkommen.dart';
import '../providers/database_provider.dart';
import '../providers/kalender_provider.dart';
import '../theme/app_theme.dart';
import '../theme/tokens.dart';

enum _Zeitraum { woche, monat, jahr }

final _zeitraumProvider = StateProvider.autoDispose((ref) => _Zeitraum.woche);

(DateTime, DateTime) _spanneFuer(_Zeitraum z, DateTime heute) {
  switch (z) {
    case _Zeitraum.woche:
      final montag = montagDerWoche(heute);
      return (montag, montag.add(const Duration(days: 6)));
    case _Zeitraum.monat:
      return (DateTime(heute.year, heute.month, 1), DateTime(heute.year, heute.month + 1, 0));
    case _Zeitraum.jahr:
      return (DateTime(heute.year, 1, 1), DateTime(heute.year, 12, 31));
  }
}

final _verlaufDatenProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(vorkommenRepositoryProvider);
  final heute = ref.watch(heutigesDatumProvider).valueOrNull ?? nurDatum(DateTime.now());
  final zeitraum = ref.watch(_zeitraumProvider);
  final (von, bis) = _spanneFuer(zeitraum, heute);
  return repo.beobachteZeitraum(von, bis);
});

class VerlaufScreen extends ConsumerWidget {
  const VerlaufScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final zeitraum = ref.watch(_zeitraumProvider);
    final heute = ref.watch(heutigesDatumProvider).valueOrNull ?? nurDatum(DateTime.now());
    final (von, bis) = _spanneFuer(zeitraum, heute);
    final vorkommenAsync = ref.watch(_verlaufDatenProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.verlaufTitel, style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              SegmentedButton<_Zeitraum>(
                segments: [
                  ButtonSegment(value: _Zeitraum.woche, label: Text(l10n.verlaufZeitraumWoche)),
                  ButtonSegment(value: _Zeitraum.monat, label: Text(l10n.verlaufZeitraumMonat)),
                  ButtonSegment(value: _Zeitraum.jahr, label: Text(l10n.verlaufZeitraumJahr)),
                ],
                selected: {zeitraum},
                onSelectionChanged: (s) => ref.read(_zeitraumProvider.notifier).state = s.first,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: vorkommenAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('$e')),
              data: (vorkommen) {
                if (vorkommen.isEmpty) {
                  return Center(
                    child: Text(l10n.verlaufKeineDaten,
                        style: const TextStyle(color: AppColors.textTertiary)),
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: _PlaeneListe(vorkommen: vorkommen)),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      flex: 6,
                      child: _VerlaufChart(vorkommen: vorkommen, von: von, bis: bis, l10n: l10n),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaeneListe extends StatelessWidget {
  final List<Vorkommen> vorkommen;

  const _PlaeneListe({required this.vorkommen});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final proPlan = <int, List<Vorkommen>>{};
    for (final v in vorkommen) {
      proPlan.putIfAbsent(v.plan.id, () => []).add(v);
    }

    return ListView(
      children: [
        for (final entry in proPlan.entries)
          _PlanZeile(
            titel: entry.value.first.plan.titel,
            farbe: entry.value.first.kategorieFarbe,
            vorkommen: entry.value,
            l10n: l10n,
          ),
      ],
    );
  }
}

class _PlanZeile extends StatelessWidget {
  final String titel;
  final Color farbe;
  final List<Vorkommen> vorkommen;
  final AppLocalizations l10n;

  const _PlanZeile({required this.titel, required this.farbe, required this.vorkommen, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final gesamt = vorkommen.length;
    final erledigt = vorkommen.where((v) => v.istErledigt).length;
    final quote = gesamt == 0 ? 0.0 : erledigt / gesamt;
    final streak = _streakBerechnen(vorkommen);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 16, color: farbe),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(titel, style: const TextStyle(fontSize: 13))),
              Text(
                '${(quote * 100).round()}%',
                style: monoTextStyle.copyWith(fontSize: 16, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: quote,
              minHeight: 4,
              backgroundColor: AppColors.bgOverlay,
              valueColor: AlwaysStoppedAnimation(farbe),
            ),
          ),
          if (streak > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.bgOverlay,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  l10n.verlaufStreakTage(streak),
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  int _streakBerechnen(List<Vorkommen> vorkommen) {
    final proTag = <DateTime, List<Vorkommen>>{};
    for (final v in vorkommen) {
      proTag.putIfAbsent(v.datum, () => []).add(v);
    }
    final tage = proTag.keys.toList()..sort((a, b) => b.compareTo(a));
    var streak = 0;
    for (final tag in tage) {
      final alleErledigt = proTag[tag]!.every((v) => v.istErledigt);
      if (!alleErledigt) break;
      streak++;
    }
    return streak;
  }
}

class _VerlaufChart extends StatelessWidget {
  final List<Vorkommen> vorkommen;
  final DateTime von;
  final DateTime bis;
  final AppLocalizations l10n;

  const _VerlaufChart({required this.vorkommen, required this.von, required this.bis, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final proTag = <DateTime, List<Vorkommen>>{};
    for (var t = von; !t.isAfter(bis); t = t.add(const Duration(days: 1))) {
      proTag[t] = [];
    }
    for (final v in vorkommen) {
      proTag[v.datum]?.add(v);
    }
    final tage = proTag.keys.toList()..sort();
    final locale = Localizations.localeOf(context).languageCode;

    final gruppen = <BarChartGroupData>[];
    for (var i = 0; i < tage.length; i++) {
      final eintraege = proTag[tage[i]]!;
      final puenktlich = eintraege.where((v) => v.status == EintragStatus.erledigtPuenktlich).length;
      final verspaetet = eintraege.where((v) => v.status == EintragStatus.erledigtVerspaetet).length;
      gruppen.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: (puenktlich + verspaetet).toDouble(),
              width: tage.length > 31 ? 4 : 14,
              borderRadius: BorderRadius.circular(2),
              rodStackItems: [
                BarChartRodStackItem(0, puenktlich.toDouble(), AppColors.statusDoneOnTime),
                BarChartRodStackItem(
                  puenktlich.toDouble(),
                  (puenktlich + verspaetet).toDouble(),
                  AppColors.statusDoneLate,
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              barGroups: gruppen,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: tage.length <= 31,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= tage.length) return const SizedBox.shrink();
                      if (tage.length > 14 && i % 2 != 0) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormat.Md(locale).format(tage[i]),
                          style: const TextStyle(fontSize: 9, color: AppColors.textTertiary),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _LegendeEintrag(farbe: AppColors.statusDoneOnTime, text: l10n.verlaufLegendePuenktlich),
            const SizedBox(width: AppSpacing.lg),
            _LegendeEintrag(farbe: AppColors.statusDoneLate, text: l10n.verlaufLegendeVerspaetet),
          ],
        ),
      ],
    );
  }
}

class _LegendeEintrag extends StatelessWidget {
  final Color farbe;
  final String text;
  const _LegendeEintrag({required this.farbe, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: farbe, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
      ],
    );
  }
}
