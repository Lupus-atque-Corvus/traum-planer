import 'package:flutter/widgets.dart';

/// Design-Tokens aus der Spezifikation (Abschnitt 5). Einzige Quelle der
/// Wahrheit für Farben außerhalb von [AppTheme] — Screens greifen nie auf
/// rohe Hex-Werte zu, sondern immer über diese Tokens.
class AppColors {
  const AppColors._();

  // Neutral
  static const bgBase = Color(0xFF14161C);
  static const bgSurface = Color(0xFF1B1E26);
  static const bgSurfaceRaised = Color(0xFF232630);
  static const bgOverlay = Color(0xFF2A2E3A);
  static const borderSubtle = Color(0xFF262A34);
  static const borderStrong = Color(0xFF3A4050);
  static const textPrimary = Color(0xFFECEEF2);
  static const textSecondary = Color(0xFFA6ACBB);
  static const textTertiary = Color(0xFF6B7180);

  // Status
  static const statusOpen = Color(0xFF7A8194);
  static const statusDoneOnTime = Color(0xFF57C97F);
  static const statusDoneLate = Color(0xFFEAAE49);
  static const statusMissed = Color(0xFF4A4F5C);

  // Kategorie-Akzente (Rotation für neue Kategorien)
  static const kategorieErnaehrung = Color(0xFFE8735A);
  static const kategorieMorgen = Color(0xFFF0C550);
  static const kategorieAbend = Color(0xFF8B7CF0);
  static const kategorieHaushalt = Color(0xFF4FB8D6);
  static const kategorieFrei1 = Color(0xFFE876B8);
  static const kategorieFrei2 = Color(0xFF52C79A);

  static const kategorieRotation = [
    kategorieErnaehrung,
    kategorieMorgen,
    kategorieAbend,
    kategorieHaushalt,
    kategorieFrei1,
    kategorieFrei2,
  ];

  // Marke
  static const brandPrimary = Color(0xFF6C8EF5);
  static const brandPrimaryHover = Color(0xFF7E9CF7);

  // Löschen-Aktion (aus Design-Doc, Abschnitt "Aufgabe erstellen/bearbeiten")
  static const destructive = Color(0xFFD4695E);
}

class AppRadius {
  const AppRadius._();

  static const button = 8.0;
  static const card = 12.0;
  static const dialog = 16.0;
  static const pill = 999.0;
}

class AppSpacing {
  const AppSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 48.0;
}

class AppLayout {
  const AppLayout._();

  static const titleBarHeight = 40.0;
  static const sidebarWidth = 224.0;
}
