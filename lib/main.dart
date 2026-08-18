import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:window_manager/window_manager.dart';

import 'l10n/gen/app_localizations.dart';
import 'providers/benachrichtigung_provider.dart';
import 'providers/einstellungen_provider.dart';
import 'providers/kalender_provider.dart';
import 'providers/wakeword_overlay_provider.dart';
import 'providers/wakeword_provider.dart';
import 'router/app_router.dart';
import 'services/tray_service.dart';
import 'theme/app_theme.dart';
import 'widgets/wakeword_overlay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      size: Size(1280, 800),
      minimumSize: Size(960, 640),
      center: true,
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.hidden,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    await TrayService.instance.init();

    launchAtStartup.setup(
      appName: 'TRAUM Planer',
      appPath: Platform.resolvedExecutable,
    );
  }

  runApp(const ProviderScope(child: TraumPlanerApp()));
}

/// Unterstützte UI-Sprachen. Fallback ist Englisch, falls die Systemsprache
/// weder Deutsch noch Englisch ist (siehe Spec Phase 0).
const _unterstuetzteLocales = [Locale('de'), Locale('en')];

class TraumPlanerApp extends ConsumerWidget {
  const TraumPlanerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spracheAsync = ref.watch(spracheProvider);
    final gewaehlteSprache = spracheAsync.valueOrNull ?? 'system';
    final locale = gewaehlteSprache == 'system' ? null : Locale(gewaehlteSprache);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      locale: locale,
      supportedLocales: _unterstuetzteLocales,
      localeResolutionCallback: (deviceLocale, supported) {
        if (deviceLocale != null) {
          for (final l in supported) {
            if (l.languageCode == deviceLocale.languageCode) return l;
          }
        }
        return const Locale('en');
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
      builder: (context, child) => _HintergrunddiensteBootstrap(child: child),
    );
  }
}

/// Hält Tray-Menü-Texte und geplante Erinnerungsbenachrichtigungen mit den
/// aktuellen Daten/Einstellungen synchron. Rein technischer Wrapper ohne
/// eigenes UI — rendert nur [child] durch.
class _HintergrunddiensteBootstrap extends ConsumerStatefulWidget {
  final Widget? child;
  const _HintergrunddiensteBootstrap({required this.child});

  @override
  ConsumerState<_HintergrunddiensteBootstrap> createState() => _HintergrunddiensteBootstrapState();
}

class _HintergrunddiensteBootstrapState extends ConsumerState<_HintergrunddiensteBootstrap> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Platform.isWindows || Platform.isLinux) {
      TrayService.instance.menueAktualisieren(AppLocalizations.of(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ist24h = (ref.watch(zeitformatProvider).valueOrNull ?? '24h') == '24h';
    final vorlauf = ref.watch(benachrichtigungVorlaufProvider).valueOrNull ?? 10;
    final offeneHeute = ref.watch(heuteOffeneVorkommenProvider).valueOrNull ?? const [];

    ref.watch(benachrichtigungServiceProvider).aktualisieren(
          offeneVorkommenHeute: offeneHeute,
          vorlaufMinuten: vorlauf,
          ist24h: ist24h,
          l10n: l10n,
        );

    final sollLauschen = ref.watch(wakeWortSollLauschenProvider);
    ref.watch(wakeWordLifecycleProvider).synchronisieren(sollLauschen);
    final ueberlagerungOffen = ref.watch(wakeWordUeberlagerungProvider).istOffen;

    return Stack(
      children: [
        widget.child ?? const SizedBox.shrink(),
        if (ueberlagerungOffen) const WakeWordUeberlagerung(),
      ],
    );
  }
}
