import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../l10n/gen/app_localizations.dart';
import '../router/app_router.dart';
import '../theme/tokens.dart';

class _NavEintrag {
  final String pfad;
  final IconData icon;
  final String Function(AppLocalizations) label;

  const _NavEintrag(this.pfad, this.icon, this.label);
}

const _hauptNav = [
  _NavEintrag(AppRoutes.heute, Icons.today_outlined, _lHeute),
  _NavEintrag(AppRoutes.woche, Icons.view_week_outlined, _lWoche),
  _NavEintrag(AppRoutes.monat, Icons.calendar_month_outlined, _lMonat),
  _NavEintrag(AppRoutes.verlauf, Icons.insights_outlined, _lVerlauf),
];

const _zweiteNav = [
  _NavEintrag(AppRoutes.plaene, Icons.checklist_outlined, _lPlaene),
  _NavEintrag(AppRoutes.einstellungen, Icons.settings_outlined, _lEinstellungen),
];

String _lHeute(AppLocalizations l10n) => l10n.navHeute;
String _lWoche(AppLocalizations l10n) => l10n.navWoche;
String _lMonat(AppLocalizations l10n) => l10n.navMonat;
String _lVerlauf(AppLocalizations l10n) => l10n.navVerlauf;
String _lPlaene(AppLocalizations l10n) => l10n.navPlaene;
String _lEinstellungen(AppLocalizations l10n) => l10n.navEinstellungen;

/// Seitenleiste (224px), siehe Design-Doc "Gemeinsames App-Gerüst".
class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final aktuellerPfad = GoRouterState.of(context).uri.toString();

    return Container(
      width: AppLayout.sidebarWidth,
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(right: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.lg),
            child: Row(
              children: [
                SvgPicture.asset('assets/logo/logo-mark.svg', width: 24, height: 24),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.appName,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          for (final eintrag in _hauptNav)
            _NavZeile(eintrag: eintrag, aktiv: aktuellerPfad == eintrag.pfad),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Divider(height: 1, color: AppColors.borderSubtle),
          ),
          for (final eintrag in _zweiteNav)
            _NavZeile(eintrag: eintrag, aktiv: aktuellerPfad == eintrag.pfad),
        ],
      ),
    );
  }
}

class _NavZeile extends StatelessWidget {
  final _NavEintrag eintrag;
  final bool aktiv;

  const _NavZeile({required this.eintrag, required this.aktiv});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.button),
          onTap: () => context.go(eintrag.pfad),
          hoverColor: AppColors.bgSurfaceRaised,
          child: Container(
            decoration: BoxDecoration(
              color: aktiv ? AppColors.bgOverlay : null,
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: aktiv
                  ? const Border(left: BorderSide(color: AppColors.brandPrimary, width: 3))
                  : const Border(left: BorderSide(color: Colors.transparent, width: 3)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              children: [
                Icon(
                  eintrag.icon,
                  size: 18,
                  color: aktiv ? AppColors.textPrimary : AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  eintrag.label(l10n),
                  style: TextStyle(
                    fontSize: 14,
                    color: aktiv ? AppColors.textPrimary : AppColors.textSecondary,
                    fontWeight: aktiv ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
