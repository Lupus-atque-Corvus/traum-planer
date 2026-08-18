import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../l10n/gen/app_localizations.dart';
import '../providers/wakeword_overlay_provider.dart';
import '../theme/tokens.dart';

/// Vollbild-Overlay für die Aktivierungswort-Interaktion: weichgezeichneter
/// Hintergrund, zentrierte Karte mit erkanntem Anfrage-Text, Antwort-Text
/// und Sprachausgabe (siehe Plan "Aktivierungswort für den
/// Sprachassistenten", Abschnitt 4). Wird an der Wurzel von
/// `_HintergrunddiensteBootstrap` in `lib/main.dart` eingehängt, damit sie
/// wirklich das ganze Fenster überdeckt, unabhängig von der aktuellen
/// Route.
class WakeWordUeberlagerung extends ConsumerWidget {
  const WakeWordUeberlagerung({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(wakeWordUeberlagerungProvider);
    final controller = ref.read(wakeWordUeberlagerungProvider.notifier);

    return Positioned.fill(
      child: GestureDetector(
        onTap: controller.schliessenManuell,
        child: Shortcuts(
          shortcuts: const {SingleActivator(LogicalKeyboardKey.escape): _SchliessenIntent()},
          child: Actions(
            actions: {
              _SchliessenIntent: CallbackAction<_SchliessenIntent>(
                onInvoke: (_) => controller.schliessenManuell(),
              ),
            },
            child: Focus(
              autofocus: true,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {}, // Klick auf die Karte schließt nicht
                    child: _UeberlagerungsKarte(state: state, l10n: l10n),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SchliessenIntent extends Intent {
  const _SchliessenIntent();
}

class _UeberlagerungsKarte extends StatelessWidget {
  final WakeWordUeberlagerungState state;
  final AppLocalizations l10n;

  const _UeberlagerungsKarte({required this.state, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      constraints: const BoxConstraints(minHeight: 260),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.dialog),
        border: Border.all(color: AppColors.borderStrong),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 32, offset: Offset(0, 12))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/logo/logo-mark.svg', width: 40, height: 40),
          const SizedBox(height: AppSpacing.lg),
          _StatusText(state: state, l10n: l10n),
          if (state.anfrageText.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              state.anfrageText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.4),
            ),
          ],
          if (state.antwortText.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              state.antwortText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: AppColors.textPrimary, height: 1.5),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.wakewortUeberlagerungSchliessenHinweis,
            style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _StatusText extends StatelessWidget {
  final WakeWordUeberlagerungState state;
  final AppLocalizations l10n;

  const _StatusText({required this.state, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final text = switch (state.zustand) {
      WakeWordUeberlagerungZustand.hoerendAufAnfrage => l10n.wakewortUeberlagerungHoert,
      WakeWordUeberlagerungZustand.erkannteAnfrageAngezeigt => l10n.wakewortUeberlagerungDenkt,
      WakeWordUeberlagerungZustand.denktNach => l10n.wakewortUeberlagerungDenkt,
      WakeWordUeberlagerungZustand.antwortAngezeigtUndSpricht => null,
      WakeWordUeberlagerungZustand.folgefensterOffen => l10n.wakewortUeberlagerungFolgefrage,
      WakeWordUeberlagerungZustand.idle => null,
    };
    if (text == null) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (state.zustand == WakeWordUeberlagerungZustand.hoerendAufAnfrage ||
            state.zustand == WakeWordUeberlagerungZustand.erkannteAnfrageAngezeigt ||
            state.zustand == WakeWordUeberlagerungZustand.denktNach) ...[
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.brandPrimary),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(text, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
      ],
    );
  }
}
