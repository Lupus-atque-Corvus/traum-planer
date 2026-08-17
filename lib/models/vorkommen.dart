import 'package:flutter/material.dart' show Color;

import '../data/database.dart';
import 'eintrag_status.dart';

/// Ein konkretes Vorkommen einer Aufgabe an einem bestimmten Tag —
/// Ergebnis der Wiederholungsregel-Expansion plus ggf. angewandter
/// [Ausnahme] und [ErledigtEintrag]. Nutzeroberflächen arbeiten
/// ausschließlich mit diesem Modell, nie direkt mit den Rohtabellen.
class Vorkommen {
  final Aufgabe aufgabe;
  final Plan plan;
  final DateTime datum;
  final String titel;
  final int? uhrzeitMinuten;
  final EintragStatus status;
  final DateTime? erledigtAm;

  const Vorkommen({
    required this.aufgabe,
    required this.plan,
    required this.datum,
    required this.titel,
    required this.uhrzeitMinuten,
    required this.status,
    required this.erledigtAm,
  });

  Color get kategorieFarbe => Color(plan.akzentfarbe);

  bool get istErledigt =>
      status == EintragStatus.erledigtPuenktlich || status == EintragStatus.erledigtVerspaetet;
}

/// Ein einmaliges Ereignis an einem Tag (aus [Termin]), im UI einheitlich
/// neben [Vorkommen] dargestellt.
class TerminEintrag {
  final Termin termin;

  const TerminEintrag(this.termin);

  DateTime get datum => termin.datum;
  int? get uhrzeitMinuten => termin.uhrzeitMinuten;
  String get titel => termin.titel;
}
