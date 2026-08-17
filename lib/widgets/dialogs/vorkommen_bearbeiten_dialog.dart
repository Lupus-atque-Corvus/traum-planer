import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/tables.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../models/vorkommen.dart';
import '../../providers/database_provider.dart';
import '../../providers/einstellungen_provider.dart';
import '../../theme/tokens.dart';
import '../../utils/zeit_format.dart';
import 'aenderungsumfang_dialog.dart';
import 'aufgabe_dialog.dart';

/// Wird beim Bearbeiten eines Vorkommens aus Woche/Heute aufgerufen: fragt
/// erst per [aenderungsUmfangDialogZeigen] "Nur diese Woche" vs. "Immer
/// ändern" und verzweigt dann entsprechend. "Immer ändern" öffnet den
/// normalen Aufgabe-Dialog (Vorlage), "Nur diese Woche" schreibt eine
/// [Ausnahme] für genau dieses Datum.
Future<void> vorkommenBearbeitenZeigen(BuildContext context, WidgetRef ref, Vorkommen v) async {
  final umfang = await aenderungsUmfangDialogZeigen(context);
  if (umfang == null || !context.mounted) return;

  if (umfang == AenderungsUmfang.immer) {
    await aufgabeDialogZeigen(context, ref, planId: v.plan.id, vorhandeneAufgabe: v.aufgabe);
    return;
  }

  if (!context.mounted) return;
  await showDialog(
    context: context,
    builder: (_) => _EinzelvorkommenDialog(vorkommen: v),
  );
}

class _EinzelvorkommenDialog extends ConsumerStatefulWidget {
  final Vorkommen vorkommen;
  const _EinzelvorkommenDialog({required this.vorkommen});

  @override
  ConsumerState<_EinzelvorkommenDialog> createState() => _EinzelvorkommenDialogState();
}

class _EinzelvorkommenDialogState extends ConsumerState<_EinzelvorkommenDialog> {
  late final TextEditingController _titelController;
  late TimeOfDay? _uhrzeit;

  @override
  void initState() {
    super.initState();
    _titelController = TextEditingController(text: widget.vorkommen.titel);
    final minuten = widget.vorkommen.uhrzeitMinuten;
    _uhrzeit = minuten != null ? TimeOfDay(hour: minuten ~/ 60, minute: minuten % 60) : null;
  }

  @override
  void dispose() {
    _titelController.dispose();
    super.dispose();
  }

  Future<void> _speichern() async {
    final titel = _titelController.text.trim();
    if (titel.isEmpty) return;
    final v = widget.vorkommen;

    await ref.read(databaseProvider).ausnahmeSpeichern(AusnahmenCompanion.insert(
          aufgabeId: v.aufgabe.id,
          datum: v.datum,
          typ: AusnahmeTyp.geaendert,
          neuerTitel: Value(titel == v.aufgabe.titel ? null : titel),
          neueUhrzeitMinuten: Value(_uhrzeit == null ? null : _uhrzeit!.hour * 60 + _uhrzeit!.minute),
        ));

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ist24h = (ref.watch(zeitformatProvider).valueOrNull ?? '24h') == '24h';

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
              Text(l10n.aufgabeBearbeiten, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _titelController,
                autofocus: true,
                decoration: InputDecoration(labelText: l10n.aufgabeTitelFeld),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Switch(
                    value: _uhrzeit != null,
                    onChanged: (v) => setState(() {
                      _uhrzeit = v ? const TimeOfDay(hour: 8, minute: 0) : null;
                    }),
                    activeTrackColor: AppColors.brandPrimary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l10n.aufgabeUhrzeitFestlegen, style: const TextStyle(fontSize: 14)),
                  const Spacer(),
                  if (_uhrzeit != null)
                    OutlinedButton(
                      onPressed: () async {
                        final gewaehlt = await showTimePicker(context: context, initialTime: _uhrzeit!);
                        if (gewaehlt != null) setState(() => _uhrzeit = gewaehlt);
                      },
                      child: Text(formatiereUhrzeit(_uhrzeit!.hour * 60 + _uhrzeit!.minute, ist24h: ist24h)),
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
                  ElevatedButton(onPressed: _speichern, child: Text(l10n.aktionSpeichern)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
