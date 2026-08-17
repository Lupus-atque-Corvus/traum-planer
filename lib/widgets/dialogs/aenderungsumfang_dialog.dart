import 'package:flutter/material.dart';

import '../../l10n/gen/app_localizations.dart';
import '../../theme/tokens.dart';

enum AenderungsUmfang { nurDieseWoche, immer }

/// Bildschirm 7 der Spec: "Nur diese Woche" vs. "Immer ändern" — zwei
/// gleich große Karten UNTEREINANDER (keine Spalten, bewusst gegen
/// Fehlklicks), kein vorfokussierter Zustand.
Future<AenderungsUmfang?> aenderungsUmfangDialogZeigen(BuildContext context) {
  return showDialog<AenderungsUmfang>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return Dialog(
        backgroundColor: AppColors.bgSurfaceRaised,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.dialog)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.aenderungsUmfangTitel, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.lg),
                _AuswahlKarte(
                  titel: l10n.aenderungsUmfangNurWoche,
                  subtext: l10n.aenderungsUmfangNurWocheSubtext,
                  onTap: () => Navigator.of(context).pop(AenderungsUmfang.nurDieseWoche),
                ),
                const SizedBox(height: AppSpacing.md),
                _AuswahlKarte(
                  titel: l10n.aenderungsUmfangImmer,
                  subtext: l10n.aenderungsUmfangImmerSubtext,
                  onTap: () => Navigator.of(context).pop(AenderungsUmfang.immer),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _AuswahlKarte extends StatefulWidget {
  final String titel;
  final String subtext;
  final VoidCallback onTap;

  const _AuswahlKarte({required this.titel, required this.subtext, required this.onTap});

  @override
  State<_AuswahlKarte> createState() => _AuswahlKarteState();
}

class _AuswahlKarteState extends State<_AuswahlKarte> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: _hover ? AppColors.borderStrong : AppColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.titel, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.subtext,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
