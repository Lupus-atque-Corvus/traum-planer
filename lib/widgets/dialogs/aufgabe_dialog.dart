import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/tables.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../providers/database_provider.dart';
import '../../providers/einstellungen_provider.dart';
import '../../theme/tokens.dart';
import '../../utils/zeit_format.dart';

/// Dialog "Aufgabe erstellen/bearbeiten" (Spec Bildschirm 6). Bearbeitet
/// immer die Vorlage (Aufgabe + Wiederholungsregel) — entspricht "Immer
/// ändern" aus Bildschirm 7. Für Einzelvorkommen siehe
/// `vorkommen_bearbeiten_dialog.dart`.
Future<void> aufgabeDialogZeigen(
  BuildContext context,
  WidgetRef ref, {
  required int planId,
  Aufgabe? vorhandeneAufgabe,
}) async {
  Wiederholungsregel? vorhandeneRegel;
  if (vorhandeneAufgabe != null) {
    vorhandeneRegel = await ref.read(databaseProvider).regelLaden(vorhandeneAufgabe.wiederholungsregelId);
  }
  if (!context.mounted) return;
  await showDialog(
    context: context,
    builder: (_) => _AufgabeDialog(
      planId: planId,
      vorhandeneAufgabe: vorhandeneAufgabe,
      vorhandeneRegel: vorhandeneRegel,
    ),
  );
}

class _AufgabeDialog extends ConsumerStatefulWidget {
  final int planId;
  final Aufgabe? vorhandeneAufgabe;
  final Wiederholungsregel? vorhandeneRegel;

  const _AufgabeDialog({required this.planId, this.vorhandeneAufgabe, this.vorhandeneRegel});

  @override
  ConsumerState<_AufgabeDialog> createState() => _AufgabeDialogState();
}

class _AufgabeDialogState extends ConsumerState<_AufgabeDialog> {
  late final TextEditingController _titelController;
  bool _uhrzeitAktiv = false;
  TimeOfDay _uhrzeit = const TimeOfDay(hour: 8, minute: 0);
  WiederholungsTyp _typ = WiederholungsTyp.taeglich;
  int _wochentagBitmaske = Wochentag.alle;
  int _monatsTag = 1;

  @override
  void initState() {
    super.initState();
    _titelController = TextEditingController(text: widget.vorhandeneAufgabe?.titel ?? '');

    final minuten = widget.vorhandeneAufgabe?.uhrzeitMinuten;
    if (minuten != null) {
      _uhrzeitAktiv = true;
      _uhrzeit = TimeOfDay(hour: minuten ~/ 60, minute: minuten % 60);
    }

    final regel = widget.vorhandeneRegel;
    if (regel != null) {
      _typ = regel.typ;
      _wochentagBitmaske = regel.wochentagBitmaske ?? Wochentag.alle;
      _monatsTag = regel.monatsTag ?? DateTime.now().day;
    }
  }

  @override
  void dispose() {
    _titelController.dispose();
    super.dispose();
  }

  Future<void> _uhrzeitWaehlen() async {
    final gewaehlt = await showTimePicker(context: context, initialTime: _uhrzeit);
    if (gewaehlt != null) setState(() => _uhrzeit = gewaehlt);
  }

  void _weekdayUmschalten(int bit) {
    setState(() {
      _wochentagBitmaske ^= bit;
      _typ = _wochentagBitmaske == Wochentag.alle
          ? WiederholungsTyp.taeglich
          : WiederholungsTyp.wochentage;
    });
  }

  Future<void> _speichern() async {
    final titel = _titelController.text.trim();
    if (titel.isEmpty) return;
    final db = ref.read(databaseProvider);

    final regelId = await db.regelSpeichern(WiederholungsregelnCompanion(
      id: widget.vorhandeneRegel != null ? Value(widget.vorhandeneRegel!.id) : const Value.absent(),
      typ: Value(_typ),
      wochentagBitmaske: Value(_typ == WiederholungsTyp.monatlich ? null : _wochentagBitmaske),
      monatsTag: Value(_typ == WiederholungsTyp.monatlich ? _monatsTag : null),
    ));

    await db.aufgabeSpeichern(AufgabenCompanion(
      id: widget.vorhandeneAufgabe != null ? Value(widget.vorhandeneAufgabe!.id) : const Value.absent(),
      planId: Value(widget.planId),
      titel: Value(titel),
      uhrzeitMinuten: Value(_uhrzeitAktiv ? _uhrzeit.hour * 60 + _uhrzeit.minute : null),
      wiederholungsregelId: Value(regelId),
    ));

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _loeschen() async {
    final l10n = AppLocalizations.of(context);
    final bestaetigt = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSurfaceRaised,
        title: Text(l10n.aufgabeLoeschen),
        content: Text(l10n.aufgabeLoeschenBestaetigung),
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
    if (bestaetigt == true && widget.vorhandeneAufgabe != null) {
      await ref.read(databaseProvider).aufgabeLoeschen(widget.vorhandeneAufgabe!.id);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bearbeitenModus = widget.vorhandeneAufgabe != null;
    final ist24h = (ref.watch(zeitformatProvider).valueOrNull ?? '24h') == '24h';

    final wochentage = [
      (Wochentag.montag, l10n.aufgabeMontag),
      (Wochentag.dienstag, l10n.aufgabeDienstag),
      (Wochentag.mittwoch, l10n.aufgabeMittwoch),
      (Wochentag.donnerstag, l10n.aufgabeDonnerstag),
      (Wochentag.freitag, l10n.aufgabeFreitag),
      (Wochentag.samstag, l10n.aufgabeSamstag),
      (Wochentag.sonntag, l10n.aufgabeSonntag),
    ];

    return Dialog(
      backgroundColor: AppColors.bgSurfaceRaised,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.dialog)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bearbeitenModus ? l10n.aufgabeBearbeiten : l10n.aufgabeNeu,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
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
                    value: _uhrzeitAktiv,
                    onChanged: (v) => setState(() => _uhrzeitAktiv = v),
                    activeTrackColor: AppColors.brandPrimary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l10n.aufgabeUhrzeitFestlegen, style: const TextStyle(fontSize: 14)),
                  const Spacer(),
                  if (_uhrzeitAktiv)
                    OutlinedButton(
                      onPressed: _uhrzeitWaehlen,
                      child: Text(formatiereUhrzeit(_uhrzeit.hour * 60 + _uhrzeit.minute, ist24h: ist24h)),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  ChoiceChip(
                    label: Text(l10n.aufgabeWiederholungTaeglich),
                    selected: _typ == WiederholungsTyp.taeglich,
                    onSelected: (_) => setState(() {
                      _typ = WiederholungsTyp.taeglich;
                      _wochentagBitmaske = Wochentag.alle;
                    }),
                  ),
                  ChoiceChip(
                    label: Text(l10n.aufgabeWiederholungWoechentlich),
                    selected: _typ == WiederholungsTyp.wochentage &&
                        _popcount(_wochentagBitmaske) == 1,
                    onSelected: (_) => setState(() {
                      _typ = WiederholungsTyp.wochentage;
                      _wochentagBitmaske = Wochentag.montag;
                    }),
                  ),
                  ChoiceChip(
                    label: Text(l10n.aufgabeWiederholungMonatlich),
                    selected: _typ == WiederholungsTyp.monatlich,
                    onSelected: (_) => setState(() => _typ = WiederholungsTyp.monatlich),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (_typ == WiederholungsTyp.monatlich)
                DropdownButton<int>(
                  value: _monatsTag,
                  dropdownColor: AppColors.bgSurfaceRaised,
                  items: [
                    for (var tag = 1; tag <= 31; tag++)
                      DropdownMenuItem(value: tag, child: Text('$tag.')),
                  ],
                  onChanged: (v) => setState(() => _monatsTag = v ?? 1),
                )
              else
                Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    for (final (bit, label) in wochentage)
                      ChoiceChip(
                        label: Text(label),
                        selected: _wochentagBitmaske & bit != 0,
                        onSelected: (_) => _weekdayUmschalten(bit),
                      ),
                  ],
                ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  if (bearbeitenModus)
                    TextButton(
                      onPressed: _loeschen,
                      style: TextButton.styleFrom(foregroundColor: AppColors.destructive),
                      child: Text(l10n.aufgabeLoeschen),
                    ),
                  const Spacer(),
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

  int _popcount(int n) {
    var count = 0;
    while (n != 0) {
      count += n & 1;
      n >>= 1;
    }
    return count;
  }
}
