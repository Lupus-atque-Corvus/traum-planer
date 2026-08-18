import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart' show Amplitude;

import '../../l10n/gen/app_localizations.dart';
import '../../providers/einstellungen_provider.dart';
import '../../providers/wakeword_provider.dart';
import '../../services/wakeword/wakeword_enrollment_service.dart';
import '../../theme/tokens.dart';

/// Öffnet den geführten 3-Schritte-Aufnahme-Dialog fürs Aktivierungswort
/// (siehe Plan "Aktivierungswort für den Sprachassistenten", Abschnitt 2).
/// Sperrt währenddessen das Mikrofon für `WakeWordService` (ein Gerät,
/// kein gleichzeitiger Zugriff) — die Freigabe erfolgt automatisch beim
/// Schließen des Dialogs, unabhängig davon, wie er geschlossen wurde.
Future<void> aktivierungswortDialogZeigen(BuildContext context, WidgetRef ref) {
  ref.read(wakeWordMikrofonBelegtProvider.notifier).state = true;
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const _AktivierungswortDialog(),
  ).whenComplete(() {
    ref.read(wakeWordMikrofonBelegtProvider.notifier).state = false;
  });
}

class _AktivierungswortDialog extends ConsumerStatefulWidget {
  const _AktivierungswortDialog();

  @override
  ConsumerState<_AktivierungswortDialog> createState() => _AktivierungswortDialogState();
}

class _AktivierungswortDialogState extends ConsumerState<_AktivierungswortDialog> {
  int _schritt = 1;
  bool _nimmtAuf = false;
  String? _fehlerText;

  Future<void> _aufnahmeUmschalten() async {
    final enrollment = ref.read(wakeWordEnrollmentServiceProvider);
    if (_nimmtAuf) {
      setState(() => _nimmtAuf = false);
      final erfolgreich = await enrollment.aufnahmeStoppenUndSpeichern(_schritt);
      if (!mounted) return;

      if (!erfolgreich) {
        setState(() => _fehlerText = AppLocalizations.of(context).einstellungenAktivierungswortZuKurz);
        return;
      }

      if (_schritt >= WakeWordEnrollmentService.anzahlProben) {
        await _abschliessen();
      } else {
        setState(() {
          _fehlerText = null;
          _schritt++;
        });
      }
      return;
    }

    final berechtigt = await enrollment.mikrofonBerechtigungVorhanden();
    if (!berechtigt || !mounted) return;
    setState(() => _fehlerText = null);
    await enrollment.aufnahmeStarten();
    if (!mounted) return;
    setState(() => _nimmtAuf = true);
  }

  Future<void> _abschliessen() async {
    await ref.read(einstellungenControllerProvider).aktivierungswortAufgenommenAmSetzen(DateTime.now());
    ref.read(wakeWordLifecycleProvider).vorlagenUngueltigMachen();
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _abbrechen() async {
    if (_nimmtAuf) {
      await ref.read(wakeWordEnrollmentServiceProvider).aufnahmeAbbrechen();
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final enrollment = ref.watch(wakeWordEnrollmentServiceProvider);

    return AlertDialog(
      backgroundColor: AppColors.bgSurfaceRaised,
      title: Text(l10n.einstellungenAktivierungswortSchritt(_schritt)),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_nimmtAuf)
              StreamBuilder<Amplitude>(
                stream: enrollment.pegelStream(),
                builder: (context, snapshot) {
                  final pegel = snapshot.data?.current ?? -60.0;
                  final anteil = ((pegel + 60) / 60).clamp(0.0, 1.0);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: LinearProgressIndicator(value: anteil, color: AppColors.brandPrimary),
                  );
                },
              ),
            if (_fehlerText != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.sm),
                child: Text(
                  _fehlerText!,
                  style: const TextStyle(color: AppColors.destructive, fontSize: 12),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: _aufnahmeUmschalten,
              icon: Icon(_nimmtAuf ? Icons.stop_circle_outlined : Icons.mic_none_outlined),
              label: Text(
                _nimmtAuf
                    ? l10n.einstellungenAktivierungswortAufnahmeStoppen
                    : l10n.einstellungenAktivierungswortAufnahmeStarten,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _abbrechen,
          child: Text(l10n.einstellungenAktivierungswortAbbrechen),
        ),
      ],
    );
  }
}
