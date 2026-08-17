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
                return ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  itemCount: plaene.length,
                  itemBuilder: (context, i) => Padding(
                    key: ValueKey('plan-${plaene[i].id}'),
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: _PlanKarte(plan: plaene[i], reorderIndex: i),
                  ),
                  onReorderItem: (alt, neu) async {
                    final reihenfolge = [for (final p in plaene) p.id];
                    final id = reihenfolge.removeAt(alt);
                    reihenfolge.insert(neu, id);
                    await ref.read(databaseProvider).plaeneNeuSortieren(reihenfolge);
                  },
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
  final int reorderIndex;
  const _PlanKarte({required this.plan, required this.reorderIndex});

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
              ReorderableDragStartListener(
                index: reorderIndex,
                child: const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.sm),
                  child: Icon(Icons.drag_indicator, size: 18, color: AppColors.textTertiary),
                ),
              ),
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
              return ReorderableListView.builder(
                shrinkWrap: true,
                primary: false,
                buildDefaultDragHandles: false,
                itemCount: aufgaben.length,
                itemBuilder: (context, i) => _AufgabeZeile(
                  key: ValueKey('aufgabe-${aufgaben[i].id}'),
                  planId: plan.id,
                  aufgabe: aufgaben[i],
                  reorderIndex: i,
                ),
                onReorderItem: (alt, neu) async {
                  final reihenfolge = [for (final a in aufgaben) a.id];
                  final id = reihenfolge.removeAt(alt);
                  reihenfolge.insert(neu, id);
                  await ref.read(databaseProvider).aufgabenNeuSortieren(reihenfolge);
                },
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

class _AufgabeZeile extends ConsumerWidget {
  final int planId;
  final Aufgabe aufgabe;
  final int reorderIndex;

  const _AufgabeZeile({
    required super.key,
    required this.planId,
    required this.aufgabe,
    required this.reorderIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: ReorderableDragStartListener(
        index: reorderIndex,
        child: const Icon(Icons.drag_indicator, size: 16, color: AppColors.textTertiary),
      ),
      title: Text(aufgabe.titel, style: const TextStyle(fontSize: 14)),
      trailing: IconButton(
        icon: const Icon(Icons.edit_outlined, size: 16),
        onPressed: () => aufgabeDialogZeigen(
          context,
          ref,
          planId: planId,
          vorhandeneAufgabe: aufgabe,
        ),
      ),
    );
  }
}
