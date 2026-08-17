import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/gen/app_localizations.dart';
import '../router/app_router.dart';
import '../theme/tokens.dart';
import 'dialogs/termin_dialog.dart';
import 'sidebar.dart';
import 'title_bar.dart';

/// Gemeinsames App-Gerüst: eigene Titelleiste oben, Seitenleiste links,
/// Inhalt rechts. Wird per [ShellRoute] um jeden Bildschirm gelegt.
/// Trägt außerdem den einzigen Einstiegspunkt für "Termin erstellen"
/// (Bildschirm 8) als schwebenden Button — Aufgaben/Pläne werden auf dem
/// Pläne-Bildschirm angelegt, der bereits einen eigenen Button hat.
class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pfad = GoRouterState.of(context).uri.toString();
    final zeigeTerminFab = pfad != AppRoutes.einstellungen && pfad != AppRoutes.plaene;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: const AppTitleBar(),
      body: Row(
        children: [
          const AppSidebar(),
          Expanded(
            child: Stack(
              children: [
                child,
                if (zeigeTerminFab)
                  Positioned(
                    right: AppSpacing.xl,
                    bottom: AppSpacing.xl,
                    child: FloatingActionButton(
                      backgroundColor: AppColors.brandPrimary,
                      tooltip: l10n.terminNeu,
                      onPressed: () => terminDialogZeigen(context, ref),
                      child: const Icon(Icons.add),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
