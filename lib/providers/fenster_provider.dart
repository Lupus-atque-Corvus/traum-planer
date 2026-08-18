import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/tray_service.dart';

/// Ob das App-Fenster gerade sichtbar ist (siehe `TrayService.
/// fensterSichtbarNotifier`). Steuert zusammen mit dem
/// Aktivierungswort-Hintergrundmodus, ob die Aktivierungswort-Erkennung
/// laufen soll (siehe `wakeword_provider.dart`).
final fensterSichtbarProvider = StreamProvider<bool>((ref) {
  if (!(Platform.isWindows || Platform.isLinux)) {
    return Stream.value(true);
  }
  final notifier = TrayService.instance.fensterSichtbarNotifier;
  final controller = StreamController<bool>();
  controller.add(notifier.value);
  void listener() => controller.add(notifier.value);
  notifier.addListener(listener);
  ref.onDispose(() {
    notifier.removeListener(listener);
    controller.close();
  });
  return controller.stream;
});
