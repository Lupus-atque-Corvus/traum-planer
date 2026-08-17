/// Formatiert Minuten seit Mitternacht als Uhrzeit-Text, abhängig von der
/// Nutzereinstellung 12h/24h (siehe Spec Phase 7 — unabhängig von der
/// UI-Sprache, der Nutzer entscheidet selbst).
String formatiereUhrzeit(int minuten, {required bool ist24h}) {
  final stunde = minuten ~/ 60;
  final minute = minuten % 60;
  final minuteStr = minute.toString().padLeft(2, '0');

  if (ist24h) {
    return '${stunde.toString().padLeft(2, '0')}:$minuteStr';
  }

  final stunde12 = stunde % 12 == 0 ? 12 : stunde % 12;
  final suffix = stunde < 12 ? 'AM' : 'PM';
  return '$stunde12:$minuteStr $suffix';
}
