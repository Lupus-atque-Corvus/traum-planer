import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sichtbarkeit des Assistent-Panels (Bildschirm 10). Reiner UI-Zustand,
/// kein Speicherbedarf — die App bleibt ohne LLM voll nutzbar, das Panel
/// ist rein optisch abschaltbar (Spec Phase 8, letzter Punkt).
final assistentPanelSichtbarProvider = StateProvider<bool>((ref) => false);
