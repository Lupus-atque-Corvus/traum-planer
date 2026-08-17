import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../data/database.dart';
import '../data/wiederholung_logik.dart';
import '../l10n/gen/app_localizations.dart';
import '../models/eintrag_status.dart';
import '../models/vorkommen.dart';
import '../providers/database_provider.dart';
import '../providers/einstellungen_provider.dart';
import '../providers/kalender_provider.dart';
import '../providers/streak_provider.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';
import '../theme/tokens.dart';
import '../utils/zeit_format.dart';
import '../widgets/status_kreis.dart';

class _HeuteEintrag {
  final String titel;
  final int? uhrzeitMinuten;
  final EintragStatus? status; // null = Termin (keine Erledigt-Semantik)
  final Color kategorieFarbe;
  final String kategorieLabel;
  final bool istTermin;
  final VoidCallback? onToggle;

  const _HeuteEintrag({
    required this.titel,
    required this.uhrzeitMinuten,
    required this.status,
    required this.kategorieFarbe,
    required this.kategorieLabel,
    required this.istTermin,
    this.onToggle,
  });

  bool get istErledigt =>
      status == EintragStatus.erledigtPuenktlich || status == EintragStatus.erledigtVerspaetet;
}

final _heuteDatenProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(vorkommenRepositoryProvider);
  final heute = ref.watch(heutigesDatumProvider).valueOrNull ?? nurDatum(DateTime.now());
  return Rx.combineLatest2<List<Vorkommen>, List<TerminEintrag>, (List<Vorkommen>, List<TerminEintrag>)>(
    repo.beobachteZeitraum(heute, heute),
    repo.beobachteTermine(heute, heute),
    (a, b) => (a, b),
  );
});

class HeuteScreen extends ConsumerWidget {
  const HeuteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final heute = ref.watch(heutigesDatumProvider).valueOrNull ?? nurDatum(DateTime.now());
    final datenAsync = ref.watch(_heuteDatenProvider);
    final ist24h = (ref.watch(zeitformatProvider).valueOrNull ?? '24h') == '24h';
    final streak = ref.watch(globalerStreakProvider).valueOrNull ?? 0;
    final db = ref.watch(databaseProvider);

    final locale = Localizations.localeOf(context).languageCode;
    final datumText = DateFormat.yMMMMEEEEd(locale).format(heute);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _grossAnfangsbuchstabe(datumText),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              if (streak > 0) _StreakPill(anzahl: streak, l10n: l10n),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: datenAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('$e')),
              data: (daten) {
                final (vorkommen, termine) = daten;
                if (vorkommen.isEmpty && termine.isEmpty) {
                  return _KeinEintragHeute(l10n: l10n);
                }

                final offene = <_HeuteEintrag>[];
                final erledigte = <_HeuteEintrag>[];

                for (final v in vorkommen) {
                  final eintrag = _HeuteEintrag(
                    titel: v.titel,
                    uhrzeitMinuten: v.uhrzeitMinuten,
                    status: v.status,
                    kategorieFarbe: v.kategorieFarbe,
                    kategorieLabel: v.plan.kategorie,
                    istTermin: false,
                    onToggle: () => _umschalten(db, v),
                  );
                  (eintrag.istErledigt ? erledigte : offene).add(eintrag);
                }
                for (final t in termine) {
                  offene.add(_HeuteEintrag(
                    titel: t.titel,
                    uhrzeitMinuten: t.uhrzeitMinuten,
                    status: null,
                    kategorieFarbe: AppColors.borderStrong,
                    kategorieLabel: l10n.terminLabel,
                    istTermin: true,
                  ));
                }

                offene.sort(_nachUhrzeit);
                erledigte.sort(_nachUhrzeit);

                return ListView(
                  children: [
                    _Abschnitt(
                      titel: l10n.heuteNochOffen(offene.length),
                      leer: offene.isEmpty
                          ? (erledigte.isEmpty ? null : l10n.heuteAllesErledigt)
                          : null,
                      eintraege: offene,
                      ist24h: ist24h,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _Abschnitt(
                      titel: l10n.heuteBereitsErledigt(erledigte.length),
                      leer: erledigte.isEmpty ? l10n.heuteNochNichtsErledigt : null,
                      eintraege: erledigte,
                      ist24h: ist24h,
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

  Future<void> _umschalten(AppDatabase db, Vorkommen v) async {
    if (v.istErledigt) {
      await db.erledigtRueckgaengigMachen(v.aufgabe.id, v.datum);
    } else {
      await db.alsErledigtMarkieren(v.aufgabe.id, v.datum);
    }
  }

  static int _nachUhrzeit(_HeuteEintrag a, _HeuteEintrag b) {
    if (a.uhrzeitMinuten == null && b.uhrzeitMinuten == null) return 0;
    if (a.uhrzeitMinuten == null) return 1;
    if (b.uhrzeitMinuten == null) return -1;
    return a.uhrzeitMinuten!.compareTo(b.uhrzeitMinuten!);
  }

  static String _grossAnfangsbuchstabe(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _StreakPill extends StatelessWidget {
  final int anzahl;
  final AppLocalizations l10n;

  const _StreakPill({required this.anzahl, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Text(
        l10n.heuteStreakTageInFolge(anzahl),
        style: monoTextStyle.copyWith(fontSize: 12, color: AppColors.textSecondary),
      ),
    );
  }
}

class _KeinEintragHeute extends StatelessWidget {
  final AppLocalizations l10n;
  const _KeinEintragHeute({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.heuteKeinEintrag,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => context.go(AppRoutes.woche),
            child: Text(l10n.heuteZurWoche),
          ),
        ],
      ),
    );
  }
}

class _Abschnitt extends StatelessWidget {
  final String titel;
  final String? leer;
  final List<_HeuteEintrag> eintraege;
  final bool ist24h;

  const _Abschnitt({
    required this.titel,
    required this.leer,
    required this.eintraege,
    required this.ist24h,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titel, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        if (leer != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Center(
              child: Text(leer!, style: const TextStyle(color: AppColors.textTertiary, fontSize: 13)),
            ),
          )
        else
          ...eintraege.map((e) => _EintragZeile(eintrag: e, ist24h: ist24h)),
      ],
    );
  }
}

class _EintragZeile extends StatelessWidget {
  final _HeuteEintrag eintrag;
  final bool ist24h;

  const _EintragZeile({required this.eintrag, required this.ist24h});

  @override
  Widget build(BuildContext context) {
    final erledigt = eintrag.istErledigt;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: erledigt ? AppColors.bgBase : AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          _Leiste(farbe: eintrag.kategorieFarbe, gestrichelt: eintrag.istTermin),
          const SizedBox(width: AppSpacing.md),
          if (eintrag.status != null)
            StatusKreis(status: eintrag.status!, onTap: eintrag.onToggle)
          else
            const SizedBox(width: 20, height: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              eintrag.titel,
              style: TextStyle(
                fontSize: 14,
                color: erledigt ? AppColors.textTertiary : AppColors.textPrimary,
                decoration: erledigt ? TextDecoration.lineThrough : null,
                decorationColor: AppColors.textTertiary,
              ),
            ),
          ),
          if (eintrag.uhrzeitMinuten != null) ...[
            Text(
              formatiereUhrzeit(eintrag.uhrzeitMinuten!, ist24h: ist24h),
              style: monoTextStyle.copyWith(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Text(
            eintrag.kategorieLabel,
            style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _Leiste extends StatelessWidget {
  final Color farbe;
  final bool gestrichelt;

  const _Leiste({required this.farbe, required this.gestrichelt});

  @override
  Widget build(BuildContext context) {
    if (!gestrichelt) {
      return Container(
        width: 4,
        height: 28,
        decoration: BoxDecoration(color: farbe, borderRadius: BorderRadius.circular(4)),
      );
    }
    return SizedBox(
      width: 4,
      height: 28,
      child: Column(
        children: List.generate(5, (i) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: i == 4 ? 0 : 2),
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
