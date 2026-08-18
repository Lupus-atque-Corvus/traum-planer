import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/wiederholung_logik.dart';
import '../l10n/gen/app_localizations.dart';
import '../providers/database_provider.dart';
import '../providers/einstellungen_provider.dart';
import '../providers/kalender_provider.dart';
import '../providers/wakeword_provider.dart';
import '../services/backup_service.dart';
import '../services/html_export_service.dart';
import '../theme/app_theme.dart';
import '../theme/tokens.dart';
import '../widgets/dialogs/aktivierungswort_dialog.dart';

class EinstellungenScreen extends ConsumerWidget {
  const EinstellungenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sprache = ref.watch(spracheProvider).valueOrNull ?? 'system';
    final zeitformat = ref.watch(zeitformatProvider).valueOrNull ?? '24h';
    final autostart = ref.watch(autostartProvider).valueOrNull ?? false;
    final vorlauf = ref.watch(benachrichtigungVorlaufProvider).valueOrNull ?? 10;
    final controller = ref.watch(einstellungenControllerProvider);
    final istDesktop = Platform.isWindows || Platform.isLinux;

    final aktivierungswortAktiv = ref.watch(aktivierungswortAktivProvider).valueOrNull ?? false;
    final aktivierungswortVorhanden = ref.watch(aktivierungswortSamplesVorhandenProvider);
    final aktivierungswortAufgenommenAm = ref.watch(aktivierungswortAufgenommenAmProvider).valueOrNull;
    final aktivierungswortHintergrundModus =
        ref.watch(aktivierungswortHintergrundModusProvider).valueOrNull ?? 'nurFenster';
    final aktivierungswortEmpfindlichkeit =
        ref.watch(aktivierungswortEmpfindlichkeitProvider).valueOrNull ?? 1.4;
    final textChatPanelAktiv = ref.watch(textChatPanelAktivProvider).valueOrNull ?? true;

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
          if (istDesktop) ...[
            const SizedBox(height: AppSpacing.lg),
            _EinstellungsKarte(
              titel: l10n.einstellungenAutostart,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Switch(
                  value: autostart,
                  activeTrackColor: AppColors.brandPrimary,
                  onChanged: controller.autostartSetzen,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          _EinstellungsKarte(
            titel: l10n.einstellungenBenachrichtigungen,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.einstellungenBenachrichtigungenVorlauf(vorlauf),
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove, size: 18),
                  onPressed: vorlauf > 0
                      ? () => controller.benachrichtigungVorlaufSetzen((vorlauf - 5).clamp(0, 180))
                      : null,
                ),
                Text('$vorlauf', style: monoTextStyle.copyWith(fontSize: 14)),
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () => controller.benachrichtigungVorlaufSetzen((vorlauf + 5).clamp(0, 180)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _EinstellungsKarte(
            titel: l10n.einstellungenAktivierungswort,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.einstellungenAktivierungswortBeschreibung,
                  style: const TextStyle(fontSize: 12, color: AppColors.textTertiary, height: 1.4),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  aktivierungswortAufgenommenAm != null
                      ? l10n.einstellungenAktivierungswortStatusVorhanden(
                          DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
                              .format(aktivierungswortAufgenommenAm),
                        )
                      : l10n.einstellungenAktivierungswortStatusFehlt,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => aktivierungswortDialogZeigen(context, ref),
                      icon: const Icon(Icons.mic_none_outlined, size: 16),
                      label: Text(
                        aktivierungswortVorhanden
                            ? l10n.einstellungenAktivierungswortNeuAufnehmen
                            : l10n.einstellungenAktivierungswortAufnehmen,
                      ),
                    ),
                    if (aktivierungswortVorhanden)
                      OutlinedButton.icon(
                        onPressed: () => _aktivierungswortLoeschen(ref),
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.destructive),
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: Text(l10n.einstellungenAktivierungswortLoeschen),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(child: Text(l10n.einstellungenAktivierungswortAktiv)),
                    Switch(
                      value: aktivierungswortAktiv,
                      activeTrackColor: AppColors.brandPrimary,
                      onChanged: aktivierungswortVorhanden
                          ? (v) => controller.aktivierungswortAktivSetzen(v)
                          : null,
                    ),
                  ],
                ),
                if (aktivierungswortAktiv) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.einstellungenAktivierungswortHintergrund, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: AppSpacing.sm),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'nurFenster',
                        label: Text(l10n.einstellungenAktivierungswortHintergrundNurFenster),
                      ),
                      ButtonSegment(
                        value: 'auchTray',
                        label: Text(l10n.einstellungenAktivierungswortHintergrundAuchTray),
                      ),
                    ],
                    selected: {aktivierungswortHintergrundModus},
                    onSelectionChanged: (s) => controller.aktivierungswortHintergrundModusSetzen(s.first),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.einstellungenAktivierungswortEmpfindlichkeit, style: const TextStyle(fontSize: 12)),
                  Slider(
                    value: aktivierungswortEmpfindlichkeit.clamp(1.0, 2.0),
                    min: 1.0,
                    max: 2.0,
                    divisions: 20,
                    activeColor: AppColors.brandPrimary,
                    label: aktivierungswortEmpfindlichkeit.toStringAsFixed(2),
                    onChanged: (v) => controller.aktivierungswortEmpfindlichkeitSetzen(v),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _EinstellungsKarte(
            titel: l10n.einstellungenTextchatPanel,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.einstellungenTextchatPanelBeschreibung,
                    style: const TextStyle(fontSize: 12, color: AppColors.textTertiary, height: 1.4),
                  ),
                ),
                Switch(
                  value: textChatPanelAktiv,
                  activeTrackColor: AppColors.brandPrimary,
                  onChanged: (v) => controller.textChatPanelAktivSetzen(v),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _EinstellungsKarte(
            titel: l10n.einstellungenExport,
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _htmlExportieren(context, ref),
                  icon: const Icon(Icons.print_outlined, size: 16),
                  label: Text(l10n.einstellungenExportHtml),
                ),
                OutlinedButton.icon(
                  onPressed: () => _jsonExportieren(context, ref),
                  icon: const Icon(Icons.save_outlined, size: 16),
                  label: Text(l10n.einstellungenExportJson),
                ),
                OutlinedButton.icon(
                  onPressed: () => _jsonImportieren(context, ref),
                  icon: const Icon(Icons.upload_file_outlined, size: 16),
                  label: Text(l10n.einstellungenImportJson),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _htmlExportieren(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final ist24h = (ref.read(zeitformatProvider).valueOrNull ?? '24h') == '24h';
    final heute = ref.read(heutigesDatumProvider).valueOrNull ?? nurDatum(DateTime.now());
    final tage = wochenTage(heute);
    final repo = ref.read(vorkommenRepositoryProvider);

    final vorkommen = await repo.beobachteZeitraum(tage.first, tage.last).first;
    final termine = await repo.beobachteTermine(tage.first, tage.last).first;

    final html = HtmlExportService.wochenblatt(
      anker: heute,
      vorkommen: vorkommen,
      termine: termine,
      l10n: l10n,
      locale: locale,
      ist24h: ist24h,
    );

    final ziel = await getSaveLocation(
      suggestedName: 'wochenplan.html',
      acceptedTypeGroups: const [
        XTypeGroup(label: 'HTML', extensions: ['html']),
      ],
    );
    if (ziel == null) return;

    await File(ziel.path).writeAsString(html);
    if (context.mounted) _snack(context, l10n.einstellungenExportErfolgreich);
  }

  Future<void> _jsonExportieren(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final backup = BackupService(ref.read(databaseProvider));
    final json = await backup.exportieren();

    final ziel = await getSaveLocation(
      suggestedName: 'traum-planer-backup.json',
      acceptedTypeGroups: const [
        XTypeGroup(label: 'JSON', extensions: ['json']),
      ],
    );
    if (ziel == null) return;

    await File(ziel.path).writeAsString(json);
    if (context.mounted) _snack(context, l10n.einstellungenExportErfolgreich);
  }

  Future<void> _jsonImportieren(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final datei = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(label: 'JSON', extensions: ['json']),
      ],
    );
    if (datei == null) return;
    if (!context.mounted) return;

    final bestaetigt = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSurfaceRaised,
        title: Text(l10n.einstellungenImportJson),
        content: Text(l10n.einstellungenImportBestaetigung),
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
    if (bestaetigt != true) return;

    final inhalt = await datei.readAsString();
    final backup = BackupService(ref.read(databaseProvider));
    await backup.importieren(inhalt);
    if (context.mounted) _snack(context, l10n.einstellungenImportErfolgreich);
  }

  Future<void> _aktivierungswortLoeschen(WidgetRef ref) async {
    await ref.read(einstellungenControllerProvider).aktivierungswortAktivSetzen(false);
    await ref.read(einstellungenControllerProvider).aktivierungswortAufgenommenAmLoeschen();
    await ref.read(wakeWordEnrollmentServiceProvider).probenLoeschen();
    ref.read(wakeWordLifecycleProvider).vorlagenUngueltigMachen();
  }

  void _snack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
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
