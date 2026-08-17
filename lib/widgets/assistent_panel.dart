import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/gen/app_localizations.dart';
import '../providers/assistent_provider.dart';
import '../theme/tokens.dart';

/// Bildschirm 10 der Spec: schwebendes Panel (360×480), Kopfzeile
/// "Assistent", leerer Nachrichtenverlauf, Eingabezeile mit
/// Mikrofon-/Senden-Button. Laut Design-Doc "wird in dieser Runde nicht
/// weiter ausgearbeitet" — bewusst als Platzhalter gehalten, bis Phase 8
/// (lokales STT/TTS/LLM) umgesetzt wird.
class AssistentPanel extends ConsumerWidget {
  const AssistentPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: 360,
      height: 480,
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.dialog),
        border: Border.all(color: AppColors.borderStrong),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 24, offset: Offset(0, 8))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.sm, AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Text(l10n.assistentTitel, style: Theme.of(context).textTheme.titleMedium),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  tooltip: l10n.assistentSchliessen,
                  onPressed: () => ref.read(assistentPanelSichtbarProvider.notifier).state = false,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderSubtle),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l10n.assistentPlatzhalterHinweis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: AppColors.textTertiary, height: 1.5),
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.borderSubtle),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: l10n.assistentEingabePlatzhalter,
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                IconButton(
                  icon: const Icon(Icons.mic_none_outlined, size: 18),
                  tooltip: l10n.assistentMikrofonHinweis,
                  onPressed: null,
                ),
                IconButton(
                  icon: const Icon(Icons.send_outlined, size: 18),
                  onPressed: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
