import 'package:go_router/go_router.dart';

import '../screens/einstellungen_screen.dart';
import '../screens/heute_screen.dart';
import '../screens/monat_screen.dart';
import '../screens/plaene_screen.dart';
import '../screens/verlauf_screen.dart';
import '../screens/woche_screen.dart';
import '../widgets/app_shell.dart';

class AppRoutes {
  const AppRoutes._();

  static const heute = '/heute';
  static const woche = '/woche';
  static const monat = '/monat';
  static const verlauf = '/verlauf';
  static const plaene = '/plaene';
  static const einstellungen = '/einstellungen';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.heute,
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: AppRoutes.heute, builder: (context, state) => const HeuteScreen()),
        GoRoute(path: AppRoutes.woche, builder: (context, state) => const WocheScreen()),
        GoRoute(path: AppRoutes.monat, builder: (context, state) => const MonatScreen()),
        GoRoute(path: AppRoutes.verlauf, builder: (context, state) => const VerlaufScreen()),
        GoRoute(path: AppRoutes.plaene, builder: (context, state) => const PlaeneScreen()),
        GoRoute(
          path: AppRoutes.einstellungen,
          builder: (context, state) => const EinstellungenScreen(),
        ),
      ],
    ),
  ],
);
