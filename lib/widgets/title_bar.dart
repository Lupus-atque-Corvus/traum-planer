import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../l10n/gen/app_localizations.dart';
import '../theme/tokens.dart';

/// Eigene 40px-Titelleiste, siehe Design-Doc "Gemeinsames App-Gerüst":
/// links App-Name, rechts die drei Standard-Fenstersteuerungen.
class AppTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTitleBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(AppLayout.titleBarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final istDesktop = Platform.isWindows || Platform.isLinux;

    return Container(
      height: AppLayout.titleBarHeight,
      decoration: const BoxDecoration(
        color: AppColors.bgBase,
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          Expanded(
            child: DragToMoveArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    Text(
                      l10n.appName,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (istDesktop) ...[
            _FensterKnopf(
              icon: Icons.remove,
              tooltip: l10n.fensterMinimieren,
              onTap: windowManager.minimize,
            ),
            _FensterKnopf(
              icon: Icons.crop_square,
              tooltip: l10n.fensterMaximieren,
              onTap: () async {
                if (await windowManager.isMaximized()) {
                  await windowManager.unmaximize();
                } else {
                  await windowManager.maximize();
                }
              },
            ),
            _FensterKnopf(
              icon: Icons.close,
              tooltip: l10n.fensterSchliessen,
              onTap: windowManager.close,
              hoverColor: const Color(0xFFE5484D),
            ),
          ],
        ],
      ),
    );
  }
}

class _FensterKnopf extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? hoverColor;

  const _FensterKnopf({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.hoverColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        hoverColor: hoverColor ?? AppColors.bgOverlay,
        child: SizedBox(
          width: 46,
          height: AppLayout.titleBarHeight,
          child: Icon(icon, size: 16, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
