import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/gen/app_localizations.dart';
import '../providers/einstellungen_provider.dart';
import '../theme/tokens.dart';

class EinstellungenScreen extends ConsumerWidget {
  const EinstellungenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sprache = ref.watch(spracheProvider).valueOrNull ?? 'system';
    final zeitformat = ref.watch(zeitformatProvider).valueOrNull ?? '24h';
    final controller = ref.watch(einstellungenControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: ListView(
        children: [
          Text(l10n.einstellungenTitel, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xl),
          _EinstellungsKarte(
            titel: l10n.einstellungenSprache,
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'system', label: Text(l10n.einstellungenSpracheSystem)),
                ButtonSegment(value: 'de', label: Text(l10n.einstellungenSpracheDeutsch)),
                ButtonSegment(value: 'en', label: Text(l10n.einstellungenSpracheEnglisch)),
              ],
              selected: {sprache},
              onSelectionChanged: (s) => controller.spracheSetzen(s.first),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _EinstellungsKarte(
            titel: l10n.einstellungenZeitformat,
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: '24h', label: Text(l10n.einstellungenZeitformat24h)),
                ButtonSegment(value: '12h', label: Text(l10n.einstellungenZeitformat12h)),
              ],
              selected: {zeitformat},
              onSelectionChanged: (s) => controller.zeitformatSetzen(s.first),
            ),
          ),
        ],
      ),
    );
  }
}

class _EinstellungsKarte extends StatelessWidget {
  final String titel;
  final Widget child;

  const _EinstellungsKarte({required this.titel, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titel, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}
