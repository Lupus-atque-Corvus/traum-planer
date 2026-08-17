import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/database.dart';
import '../../data/wiederholung_logik.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../providers/database_provider.dart';
import '../../providers/einstellungen_provider.dart';
import '../../theme/tokens.dart';
import '../../utils/zeit_format.dart';

/// Dialog "Termin erstellen/bearbeiten" (Spec Bildschirm 8). Kein
/// Kategoriefeld — Termine sind planunabhängig.
Future<void> terminDialogZeigen(BuildContext context, WidgetRef ref, {DateTime? initialDatum, Termin? vorhandenerTermin}) {
  return showDialog(
    context: context,
    builder: (_) => _TerminDialog(initialDatum: initialDatum, vorhandenerTermin: vorhandenerTermin),
  );
}

class _TerminDialog extends ConsumerStatefulWidget {
  final DateTime? initialDatum;
  final Termin? vorhandenerTermin;

  const _TerminDialog({this.initialDatum, this.vorhandenerTermin});

  @override
  ConsumerState<_TerminDialog> createState() => _TerminDialogState();
}

class _TerminDialogState extends ConsumerState<_TerminDialog> {
  late final TextEditingController _titelController;
  late final TextEditingController _ortController;
  late DateTime _datum;
  TimeOfDay? _uhrzeit;

  @override
  void initState() {
    super.initState();
    final t = widget.vorhandenerTermin;
    _titelController = TextEditingController(text: t?.titel ?? '');
    _ortController = TextEditingController(text: t?.ort ?? '');
    _datum = nurDatum(t?.datum ?? widget.initialDatum ?? DateTime.now());
    if (t?.uhrzeitMinuten != null) {
      _uhrzeit = TimeOfDay(hour: t!.uhrzeitMinuten! ~/ 60, minute: t.uhrzeitMinuten! % 60);
    }
  }

  @override
  void dispose() {
    _titelController.dispose();
    _ortController.dispose();
    super.dispose();
  }

  Future<void> _datumWaehlen() async {
    final gewaehlt = await showDatePicker(
      context: context,
      initialDate: _datum,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (gewaehlt != null) setState(() => _datum = DateTime(gewaehlt.year, gewaehlt.month, gewaehlt.day));
  }

  Future<void> _speichern() async {
    final titel = _titelController.text.trim();
    if (titel.isEmpty) return;

    await ref.read(databaseProvider).terminSpeichern(TermineCompanion(
          id: widget.vorhandenerTermin != null
              ? Value(widget.vorhandenerTermin!.id)
              : const Value.absent(),
          titel: Value(titel),
          datum: Value(nurDatum(_datum)),
          uhrzeitMinuten: Value(_uhrzeit == null ? null : _uhrzeit!.hour * 60 + _uhrzeit!.minute),
          ort: Value(_ortController.text.trim().isEmpty ? null : _ortController.text.trim()),
        ));

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
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
              Text(
                widget.vorhandenerTermin != null ? l10n.terminBearbeiten : l10n.terminNeu,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _titelController,
                autofocus: true,
                decoration: InputDecoration(labelText: l10n.terminTitelFeld),
              ),
              const SizedBox(height: AppSpacing.md),
              InkWell(
                onTap: _datumWaehlen,
                child: InputDecorator(
                  decoration: InputDecoration(labelText: l10n.terminDatumFeld),
                  child: Text(DateFormat.yMMMd(locale).format(_datum)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Switch(
                    value: _uhrzeit != null,
                    onChanged: (v) => setState(() {
                      _uhrzeit = v ? const TimeOfDay(hour: 9, minute: 0) : null;
                    }),
                    activeTrackColor: AppColors.brandPrimary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l10n.terminUhrzeitFeld, style: const TextStyle(fontSize: 14)),
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
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _ortController,
                decoration: InputDecoration(labelText: l10n.terminOrtFeld),
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
