import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../l10n/gen/app_localizations.dart';
import '../providers/database_provider.dart';
import '../theme/tokens.dart';
import '../widgets/dialogs/aufgabe_dialog.dart';
import '../widgets/dialogs/plan_dialog.dart';

final _alleplaeneProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(databaseProvider).alleplaeneBeobachten();
});

final _aufgabenFuerPlanProvider =
    StreamProvider.autoDispose.family<List<Aufgabe>, int>((ref, planId) {
  return ref.watch(databaseProvider).aufgabenFuerPlanBeobachten(planId);
});

class PlaeneScreen extends ConsumerWidget {
  const PlaeneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final plaeneAsync = ref.watch(_alleplaeneProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.plaeneTitel, style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => planDialogZeigen(context, ref),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.planNeu),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: plaeneAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('$e')),
              data: (plaene) {
                if (plaene.isEmpty) {
                  return Center(
                    child: Text(l10n.plaeneKeineEintraege,
                        style: const TextStyle(color: AppColors.textTertiary)),
                  );
                }
                return ListView.separated(
                  itemCount: plaene.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
                  itemBuilder: (context, i) => _PlanKarte(plan: plaene[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanKarte extends ConsumerWidget {
  final Plan plan;
  const _PlanKarte({required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final aufgabenAsync = ref.watch(_aufgabenFuerPlanProvider(plan.id));

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
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Color(plan.akzentfarbe),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(plan.titel, style: Theme.of(context).textTheme.titleMedium),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: () => planDialogZeigen(context, ref, vorhandenerPlan: plan),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                tooltip: l10n.aufgabeNeu,
                onPressed: () => aufgabeDialogZeigen(context, ref, planId: plan.id),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.destructive),
                onPressed: () => _planLoeschenBestaetigen(context, ref, plan),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          aufgabenAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, st) => Text('$e'),
            data: (aufgaben) {
              if (aufgaben.isEmpty) return const SizedBox.shrink();
              return Column(
                children: [
                  for (final a in aufgaben)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(a.titel, style: const TextStyle(fontSize: 14)),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        onPressed: () => aufgabeDialogZeigen(
                          context,
                          ref,
                          planId: plan.id,
                          vorhandeneAufgabe: a,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _planLoeschenBestaetigen(BuildContext context, WidgetRef ref, Plan plan) async {
    final l10n = AppLocalizations.of(context);
    final bestaetigt = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSurfaceRaised,
        title: Text(l10n.planLoeschen),
        content: Text(l10n.planLoeschenBestaetigung),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.aktionAbbrechen),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.destructive),
            child: Text(l10n.aktionLoeschen),
          ),
        ],
      ),
    );
    if (bestaetigt == true) {
      await ref.read(databaseProvider).planLoeschen(plan.id);
    }
  }
}
