import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'l10n/gen/app_localizations.dart';
import 'providers/einstellungen_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

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
    );
  }
}
