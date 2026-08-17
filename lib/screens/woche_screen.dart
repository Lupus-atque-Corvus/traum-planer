import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../data/wiederholung_logik.dart';
import '../l10n/gen/app_localizations.dart';
import '../models/eintrag_status.dart';
import '../models/vorkommen.dart';
import '../providers/database_provider.dart';
import '../providers/einstellungen_provider.dart';
import '../providers/kalender_provider.dart';
import '../theme/app_theme.dart';
import '../theme/tokens.dart';
import '../utils/zeit_format.dart';
import '../widgets/dialogs/vorkommen_bearbeiten_dialog.dart';

final _wocheDatenProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(vorkommenRepositoryProvider);
  final anker = ref.watch(ausgewaehltesDatumProvider);
  final tage = wochenTage(anker);
  return Rx.combineLatest2<List<Vorkommen>, List<TerminEintrag>, (List<Vorkommen>, List<TerminEintrag>)>(
    repo.beobachteZeitraum(tage.first, tage.last),
    repo.beobachteTermine(tage.first, tage.last),
    (a, b) => (a, b),
  );
});

class WocheScreen extends ConsumerWidget {
  const WocheScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final anker = ref.watch(ausgewaehltesDatumProvider);
    final heute = ref.watch(heutigesDatumProvider).valueOrNull ?? nurDatum(DateTime.now());
    final tage = wochenTage(anker);
    final ist24h = (ref.watch(zeitformatProvider).valueOrNull ?? '24h') == '24h';
    final datenAsync = ref.watch(_wocheDatenProvider);

    final spanne = '${DateFormat.Md(locale).format(tage.first)} – ${DateFormat.yMMMd(locale).format(tage.last)}';

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.wocheTitel, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(width: AppSpacing.md),
              Text(spanne, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const Spacer(),
              IconButton(
                tooltip: l10n.wocheVorherige,
                icon: const Icon(Icons.chevron_left),
                onPressed: () => ref.read(ausgewaehltesDatumProvider.notifier).state =
                    anker.subtract(const Duration(days: 7)),
              ),
              TextButton(
                onPressed: () => ref.read(ausgewaehltesDatumProvider.notifier).state = heute,
                child: Text(l10n.wocheDiese),
              ),
              IconButton(
                tooltip: l10n.wocheNaechste,
                icon: const Icon(Icons.chevron_right),
                onPressed: () => ref.read(ausgewaehltesDatumProvider.notifier).state =
                    anker.add(const Duration(days: 7)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: datenAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('$e')),
              data: (daten) {
                final (vorkommen, termine) = daten;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final tag in tage)
                      Expanded(
                        child: _TagSpalte(
                          tag: tag,
                          istHeute: tag.isAtSameMomentAs(heute),
                          vorkommen: vorkommen.where((v) => v.datum.isAtSameMomentAs(tag)).toList(),
                          termine: termine.where((t) => t.datum.isAtSameMomentAs(tag)).toList(),
                          ist24h: ist24h,
                          locale: locale,
                          l10n: l10n,
                          onVorkommenTap: (v) => vorkommenBearbeitenZeigen(context, ref, v),
                        ),
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

class _TagSpalte extends StatelessWidget {
  final DateTime tag;
  final bool istHeute;
  final List<Vorkommen> vorkommen;
  final List<TerminEintrag> termine;
  final bool ist24h;
  final String locale;
  final AppLocalizations l10n;
  final void Function(Vorkommen v) onVorkommenTap;

  const _TagSpalte({
    required this.tag,
    required this.istHeute,
    required this.vorkommen,
    required this.termine,
    required this.ist24h,
    required this.locale,
    required this.l10n,
    required this.onVorkommenTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderSubtle),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: istHeute ? AppColors.brandPrimary : AppColors.borderSubtle,
                  width: istHeute ? 2 : 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat.E(locale).format(tag),
                  style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                ),
                Text(
                  '${tag.day}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: istHeute ? AppColors.brandPrimary : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                children: [
                  for (final v in vorkommen)
                    _Chip(
                      titel: v.titel,
                      uhrzeitMinuten: v.uhrzeitMinuten,
                      farbe: v.kategorieFarbe,
                      erledigt: v.status == EintragStatus.erledigtPuenktlich ||
                          v.status == EintragStatus.erledigtVerspaetet,
                      gestrichelt: false,
                      ist24h: ist24h,
                      onTap: () => onVorkommenTap(v),
                    ),
                  for (final t in termine)
                    _Chip(
                      titel: t.titel,
                      uhrzeitMinuten: t.uhrzeitMinuten,
                      farbe: AppColors.borderStrong,
                      erledigt: false,
                      gestrichelt: true,
                      ist24h: ist24h,
                      onTap: null,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String titel;
  final int? uhrzeitMinuten;
  final Color farbe;
  final bool erledigt;
  final bool gestrichelt;
  final bool ist24h;
  final VoidCallback? onTap;

  const _Chip({
    required this.titel,
    required this.uhrzeitMinuten,
    required this.farbe,
    required this.erledigt,
    required this.gestrichelt,
    required this.ist24h,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: erledigt ? 0.55 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border(
            left: BorderSide(
              color: farbe,
              width: 3,
              style: gestrichelt ? BorderStyle.solid : BorderStyle.solid,
            ),
          ),
        ),
        child: Row(
          children: [
            if (erledigt)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.check, size: 11, color: AppColors.statusDoneOnTime),
              ),
            Expanded(
              child: Text(
                titel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
              ),
            ),
            if (uhrzeitMinuten != null) ...[
              const SizedBox(width: 4),
              Text(
                formatiereUhrzeit(uhrzeitMinuten!, ist24h: ist24h),
                style: monoTextStyle.copyWith(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
        ),
      ),
    );
  }
}
