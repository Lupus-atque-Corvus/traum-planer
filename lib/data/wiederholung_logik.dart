import 'database.dart';
import 'tables.dart';

/// Reines Berechnungsmodul: liest niemals aus der Datenbank, wandelt nur
/// eine [Wiederholungsregel] plus Datum in "fällig ja/nein" um.
class WiederholungLogik {
  const WiederholungLogik._();

  static int bitFuerWochentag(int dartWeekday) => 1 << (dartWeekday - 1);

  static bool istFaelligAm(Wiederholungsregel regel, DateTime datum) {
    switch (regel.typ) {
      case WiederholungsTyp.taeglich:
        return true;
      case WiederholungsTyp.wochentage:
      case WiederholungsTyp.woechentlich:
        final maske = regel.wochentagBitmaske ?? 0;
        return maske & bitFuerWochentag(datum.weekday) != 0;
      case WiederholungsTyp.monatlich:
        return datum.day == regel.monatsTag;
    }
  }
}

DateTime nurDatum(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
