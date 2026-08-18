import 'dart:io';

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '../l10n/gen/app_localizations.dart';
import '../router/app_router.dart';

/// Verwaltet Tray-Icon, Tray-Menü (Bildschirm 9) und das "Schließen
/// versteckt statt beendet"-Verhalten (Phase 6). Singleton, da es genau
/// eine Fensterinstanz/ein Tray-Icon pro Prozess gibt.
class TrayService with TrayListener, WindowListener {
  TrayService._();
  static final TrayService instance = TrayService._();

  bool _wirklichBeenden = false;

  /// Ob das Fenster gerade sichtbar ist (nicht minimiert/nicht in den Tray
  /// versteckt). `window_manager` 0.4.3 hat kein `onWindowHide`/
  /// `onWindowShow`-Callback — die Tray-Verstecken/Zeigen-Transition ist
  /// nur bekannt, weil dieser Service sie selbst auslöst. Wird von
  /// `fenster_provider.dart` beobachtet, um die Aktivierungswort-Erkennung
  /// je nach Hintergrund-Modus zu starten/stoppen (siehe Plan, Abschnitt 6).
  final fensterSichtbarNotifier = ValueNotifier<bool>(true);

  Future<void> init() async {
    if (!(Platform.isWindows || Platform.isLinux)) return;

    trayManager.addListener(this);
    windowManager.addListener(this);
    await windowManager.setPreventClose(true);

    final iconPath = await _iconDateiBereitstellen();
    await trayManager.setIcon(iconPath);
  }

  Future<String> _iconDateiBereitstellen() async {
    final assetKey = Platform.isWindows ? 'assets/icon/app_icon.ico' : 'assets/icon/app_icon.png';
    final dateiName = Platform.isWindows ? 'tray_icon.ico' : 'tray_icon.png';
    final verzeichnis = await getApplicationSupportDirectory();
    final ziel = File(p.join(verzeichnis.path, dateiName));

    final bytes = await rootBundle.load(assetKey);
    await ziel.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    return ziel.path;
  }

  Future<void> menueAktualisieren(AppLocalizations l10n) async {
    if (!(Platform.isWindows || Platform.isLinux)) return;
    await trayManager.setToolTip(l10n.appName);
    await trayManager.setContextMenu(Menu(items: [
      MenuItem(key: 'oeffnen', label: l10n.trayFensterOeffnen),
      MenuItem(key: 'heute', label: l10n.trayHeuteAnzeigen),
      MenuItem.separator(),
      MenuItem(key: 'beenden', label: l10n.trayBeenden),
    ]));
  }

  @override
  void onTrayIconMouseDown() {
    windowManager.show();
    windowManager.focus();
    fensterSichtbarNotifier.value = true;
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'oeffnen':
        windowManager.show();
        windowManager.focus();
        fensterSichtbarNotifier.value = true;
        break;
      case 'heute':
        appRouter.go(AppRoutes.heute);
        windowManager.show();
        windowManager.focus();
        fensterSichtbarNotifier.value = true;
        break;
      case 'beenden':
        _wirklichBeenden = true;
        windowManager.close();
        break;
    }
  }

  @override
  void onWindowClose() async {
    if (_wirklichBeenden) {
      await trayManager.destroy();
      await windowManager.destroy();
      return;
    }
    fensterSichtbarNotifier.value = false;
    await windowManager.hide();
  }

  @override
  void onWindowMinimize() {
    fensterSichtbarNotifier.value = false;
  }

  @override
  void onWindowRestore() {
    fensterSichtbarNotifier.value = true;
  }
}
