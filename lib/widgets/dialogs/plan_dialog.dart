import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../providers/database_provider.dart';
import '../../theme/tokens.dart';

/// Zeigt den Dialog "Plan erstellen/bearbeiten" (Spec Bildschirm 5).
/// [vorhandenerPlan] == null -> Neuanlage.
Future<void> planDialogZeigen(BuildContext context, WidgetRef ref, {Plan? vorhandenerPlan}) {
  return showDialog(
    context: context,
    builder: (_) => _PlanDialog(vorhandenerPlan: vorhandenerPlan),
  );
}

class _PlanDialog extends ConsumerStatefulWidget {
  final Plan? vorhandenerPlan;
  const _PlanDialog({this.vorhandenerPlan});

  @override
  ConsumerState<_PlanDialog> createState() => _PlanDialogState();
}

class _PlanDialogState extends ConsumerState<_PlanDialog> {
  late final TextEditingController _titelController;
  late final TextEditingController _kategorieController;
  late Color _akzentfarbe;

  @override
  void initState() {
    super.initState();
    _titelController = TextEditingController(text: widget.vorhandenerPlan?.titel ?? '');
    _kategorieController = TextEditingController(text: widget.vorhandenerPlan?.kategorie ?? '');
    _akzentfarbe = widget.vorhandenerPlan != null
        ? Color(widget.vorhandenerPlan!.akzentfarbe)
        : AppColors.kategorieRotation[
            DateTime.now().millisecondsSinceEpoch % AppColors.kategorieRotation.length];
  }

  @override
  void dispose() {
    _titelController.dispose();
    _kategorieController.dispose();
    super.dispose();
  }

  Future<void> _eigeneFarbeWaehlen() async {
    Color temp = _akzentfarbe;
    final gewaehlt = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSurfaceRaised,
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: temp,
            onColorChanged: (c) => temp = c,
            enableAlpha: false,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).aktionAbbrechen),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(temp),
            child: Text(AppLocalizations.of(context).aktionSpeichern),
          ),
        ],
      ),
    );
    if (gewaehlt != null) setState(() => _akzentfarbe = gewaehlt);
  }

  Future<void> _speichern() async {
    final db = ref.read(databaseProvider);
    final titel = _titelController.text.trim();
    if (titel.isEmpty) return;

    await db.planSpeichern(PlaeneCompanion(
      id: widget.vorhandenerPlan != null ? Value(widget.vorhandenerPlan!.id) : const Value.absent(),
      titel: Value(titel),
      kategorie: Value(_kategorieController.text.trim().isEmpty
          ? titel
          : _kategorieController.text.trim()),
      akzentfarbe: Value(_akzentfarbe.toARGB32()),
    ));

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bearbeitenModus = widget.vorhandenerPlan != null;

    return Dialog(
      backgroundColor: AppColors.bgSurfaceRaised,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.dialog)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bearbeitenModus ? l10n.planBearbeiten : l10n.planNeu,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _titelController,
                autofocus: true,
                decoration: InputDecoration(labelText: l10n.planTitelFeld),
                onSubmitted: (_) => _speichern(),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _kategorieController,
                decoration: InputDecoration(labelText: l10n.planKategorieFeld),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.planAkzentfarbeFeld, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final farbe in AppColors.kategorieRotation) _Swatch(
                    farbe: farbe,
                    ausgewaehlt: farbe.toARGB32() == _akzentfarbe.toARGB32(),
                    onTap: () => setState(() => _akzentfarbe = farbe),
                  ),
                  GestureDetector(
                    onTap: _eigeneFarbeWaehlen,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _akzentfarbe,
                        border: Border.all(color: AppColors.borderStrong),
                      ),
                      child: const Icon(Icons.colorize, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.aktionAbbrechen),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ValueListenableBuilder(
                    valueListenable: _titelController,
                    builder: (context, value, _) => ElevatedButton(
                      onPressed: value.text.trim().isEmpty ? null : _speichern,
                      child: Text(l10n.aktionSpeichern),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  final Color farbe;
  final bool ausgewaehlt;
  final VoidCallback onTap;

  const _Swatch({required this.farbe, required this.ausgewaehlt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: farbe,
          border: Border.all(
            color: ausgewaehlt ? AppColors.textPrimary : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
