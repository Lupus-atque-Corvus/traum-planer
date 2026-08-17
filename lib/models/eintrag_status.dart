/// Status einer Aufgaben-Instanz an einem bestimmten Tag.
enum EintragStatus {
  /// Noch offen, Fälligkeitstag ist heute oder in der Zukunft (oder heute
  /// noch nicht erledigt).
  offen,

  /// Erledigt am Fälligkeitstag selbst.
  erledigtPuenktlich,

  /// Erledigt, aber an einem anderen Tag als dem Fälligkeitstag nachgeholt.
  erledigtVerspaetet,

  /// Fälligkeitstag liegt in der Vergangenheit, kein Erledigt-Eintrag vorhanden.
  verpasst,
}
