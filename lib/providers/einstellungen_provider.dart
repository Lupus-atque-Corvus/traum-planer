import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database_provider.dart';

/// Schlüssel der `Einstellungen`-Tabelle (Key-Value).
class EinstellungenSchluessel {
  const EinstellungenSchluessel._();

  static const sprache = 'sprache'; // 'de' | 'en' | 'system'
  static const zeitformat = 'zeitformat'; // '12h' | '24h'
}

/// Aktuell gewählte Sprache: 'de', 'en' oder 'system' (Default).
final spracheProvider = StreamProvider<String>((ref) {
  final db = ref.watch(databaseProvider);
  return db.einstellungBeobachten(EinstellungenSchluessel.sprache).map((v) => v ?? 'system');
});

/// Zeitformat: '12h' oder '24h'. Unabhängig von der UI-Sprache wählbar
/// (siehe Spec Abschnitt 7) — Default '24h'.
final zeitformatProvider = StreamProvider<String>((ref) {
  final db = ref.watch(databaseProvider);
  return db.einstellungBeobachten(EinstellungenSchluessel.zeitformat).map((v) => v ?? '24h');
});

final einstellungenControllerProvider = Provider((ref) => EinstellungenController(ref));

class EinstellungenController {
  final Ref ref;
  EinstellungenController(this.ref);

  Future<void> spracheSetzen(String wert) => ref
      .read(databaseProvider)
      .einstellungSpeichern(EinstellungenSchluessel.sprache, wert);

  Future<void> zeitformatSetzen(String wert) => ref
      .read(databaseProvider)
      .einstellungSpeichern(EinstellungenSchluessel.zeitformat, wert);
}
