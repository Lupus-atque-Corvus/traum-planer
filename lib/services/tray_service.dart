import 'dart:io';

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
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'oeffnen':
        windowManager.show();
        windowManager.focus();
        break;
      case 'heute':
        appRouter.go(AppRoutes.heute);
        windowManager.show();
        windowManager.focus();
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
    await windowManager.hide();
  }
}
