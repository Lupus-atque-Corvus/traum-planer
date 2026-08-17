import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/wiederholung_logik.dart';
import '../l10n/gen/app_localizations.dart';
import '../models/eintrag_status.dart';
import '../models/vorkommen.dart';
import '../providers/database_provider.dart';
import '../providers/kalender_provider.dart';
import '../theme/tokens.dart';

DateTime _ersterDesMonats(DateTime d) => DateTime(d.year, d.month, 1);
DateTime _letzterDesMonats(DateTime d) => DateTime(d.year, d.month + 1, 0);

final _monatDatenProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(vorkommenRepositoryProvider);
  final anker = ref.watch(ausgewaehltesDatumProvider);
  final erster = _ersterDesMonats(anker);
  final letzter = _letzterDesMonats(anker);
  // Raster zeigt auch Tage aus Vor-/Folgemonat zum Auffüllen der Wochenzeile.
  final rasterStart = erster.subtract(Duration(days: erster.weekday - 1));
  final rasterEnde = letzter.add(Duration(days: 7 - letzter.weekday));
  return repo.beobachteZeitraum(rasterStart, rasterEnde);
});

class MonatScreen extends ConsumerWidget {
  const MonatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final anker = ref.watch(ausgewaehltesDatumProvider);
    final heute = ref.watch(heutigesDatumProvider).valueOrNull ?? nurDatum(DateTime.now());
    final vorkommenAsync = ref.watch(_monatDatenProvider);

    final erster = _ersterDesMonats(anker);
    final letzter = _letzterDesMonats(anker);
    final rasterStart = erster.subtract(Duration(days: erster.weekday - 1));
    final rasterEnde = letzter.add(Duration(days: 7 - letzter.weekday));
    final tage = <DateTime>[
      for (var t = rasterStart; !t.isAfter(rasterEnde); t = t.add(const Duration(days: 1))) t,
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                DateFormat.yMMMM(locale).format(anker),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              IconButton(
                tooltip: l10n.monatVorheriger,
                icon: const Icon(Icons.chevron_left),
                onPressed: () => ref.read(ausgewaehltesDatumProvider.notifier).state =
                    DateTime(anker.year, anker.month - 1, 1),
              ),
              IconButton(
                tooltip: l10n.monatNaechster,
                icon: const Icon(Icons.chevron_right),
                onPressed: () => ref.read(ausgewaehltesDatumProvider.notifier).state =
                    DateTime(anker.year, anker.month + 1, 1),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: Center(
                    child: Text(
                      DateFormat.E(locale).format(rasterStart.add(Duration(days: i))),
                      style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: vorkommenAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('$e')),
              data: (vorkommen) {
                final proTag = <DateTime, List<Vorkommen>>{};
                for (final v in vorkommen) {
                  proTag.putIfAbsent(v.datum, () => []).add(v);
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.15,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: tage.length,
                  itemBuilder: (context, i) {
                    final tag = tage[i];
                    return _TagKachel(
                      tag: tag,
                      imAktuellenMonat: tag.month == anker.month,
                      istHeute: tag.isAtSameMomentAs(heute),
                      istVergangen: tag.isBefore(heute),
                      vorkommen: proTag[tag] ?? const [],
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _Legende(l10n: l10n),
        ],
      ),
    );
  }
}

class _TagKachel extends StatelessWidget {
  final DateTime tag;
  final bool imAktuellenMonat;
  final bool istHeute;
  final bool istVergangen;
  final List<Vorkommen> vorkommen;

  const _TagKachel({
    required this.tag,
    required this.imAktuellenMonat,
    required this.istHeute,
    required this.istVergangen,
    required this.vorkommen,
  });

  @override
  Widget build(BuildContext context) {
    final ohneEintragVergangen = istVergangen && vorkommen.isEmpty;

    return Container(
      decoration: BoxDecoration(
        color: ohneEintragVergangen ? AppColors.bgBase : AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: istHeute ? Border.all(color: AppColors.brandPrimary, width: 1.5) : null,
      ),
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${tag.day}',
            style: TextStyle(
              fontSize: 12,
              color: imAktuellenMonat ? AppColors.textSecondary : AppColors.textTertiary,
            ),
          ),
          const Spacer(),
          if (vorkommen.isNotEmpty) _Segmentbalken(vorkommen: vorkommen),
        ],
      ),
    );
  }
}

class _Segmentbalken extends StatelessWidget {
  final List<Vorkommen> vorkommen;

  const _Segmentbalken({required this.vorkommen});

  @override
  Widget build(BuildContext context) {
    final gesamt = vorkommen.length;
    final puenktlich = vorkommen.where((v) => v.status == EintragStatus.erledigtPuenktlich).length;
    final verspaetet = vorkommen.where((v) => v.status == EintragStatus.erledigtVerspaetet).length;
    final verpasst = vorkommen.where((v) => v.status == EintragStatus.verpasst).length;
    final offen = gesamt - puenktlich - verspaetet - verpasst;

    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 4,
        child: Row(
          children: [
            if (puenktlich > 0)
              Expanded(flex: puenktlich, child: Container(color: AppColors.statusDoneOnTime)),
            if (verspaetet > 0)
              Expanded(flex: verspaetet, child: Container(color: AppColors.statusDoneLate)),
            if (offen > 0) Expanded(flex: offen, child: Container(color: AppColors.statusOpen)),
            if (verpasst > 0)
              Expanded(flex: verpasst, child: Container(color: AppColors.statusMissed)),
          ],
        ),
      ),
    );
  }
}

class _Legende extends StatelessWidget {
  final AppLocalizations l10n;
  const _Legende({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      children: [
        _LegendeEintrag(farbe: AppColors.statusDoneOnTime, text: l10n.monatLegendePuenktlich),
        _LegendeEintrag(farbe: AppColors.statusDoneLate, text: l10n.monatLegendeVerspaetet),
        _LegendeEintrag(farbe: AppColors.statusOpen, text: l10n.monatLegendeOffen),
        _LegendeEintrag(farbe: AppColors.statusMissed, text: l10n.monatLegendeVerpasst),
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
