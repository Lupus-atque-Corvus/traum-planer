import 'dart:math' as math;
import 'dart:typed_data';

/// Dynamic-Time-Warping-Distanz zwischen zwei Log-Mel-Merkmalssequenzen,
/// mit Sakoe-Chiba-Band zur Begrenzung des Rechenaufwands (siehe Plan
/// "Aktivierungswort für den Sprachassistenten", Abschnitt 1). Nur ein
/// rollendes Zeilenpaar statt der vollen n×m-Tabelle — O(n·Band) Zeit,
/// O(m) Speicher.
class WakeWordMatcher {
  const WakeWordMatcher._();

  static double distanz(
    List<Float64List> a,
    List<Float64List> b, {
    double bandAnteil = 0.2,
  }) {
    final n = a.length;
    final m = b.length;
    if (n == 0 || m == 0) return double.infinity;
    final band = math.max(1, (math.max(n, m) * bandAnteil).round());

    var vorherigeZeile = Float64List(m + 1);
    var aktuelleZeile = Float64List(m + 1);
    for (var j = 0; j <= m; j++) {
      vorherigeZeile[j] = double.infinity;
    }
    vorherigeZeile[0] = 0;

    for (var i = 1; i <= n; i++) {
      for (var j = 0; j <= m; j++) {
        aktuelleZeile[j] = double.infinity;
      }
      final jVon = math.max(1, i - band);
      final jBis = math.min(m, i + band);
      for (var j = jVon; j <= jBis; j++) {
        final kosten = _euklidisch(a[i - 1], b[j - 1]);
        final minVorgaenger = math.min(
          aktuelleZeile[j - 1],
          math.min(vorherigeZeile[j], vorherigeZeile[j - 1]),
        );
        aktuelleZeile[j] = kosten + minVorgaenger;
      }
      final tausch = vorherigeZeile;
      vorherigeZeile = aktuelleZeile;
      aktuelleZeile = tausch;
    }

    final gesamtkosten = vorherigeZeile[m];
    if (gesamtkosten.isInfinite) return double.infinity;
    return gesamtkosten / (n + m); // längen-normalisiert
  }

  static double _euklidisch(Float64List x, Float64List y) {
    var summe = 0.0;
    for (var i = 0; i < x.length; i++) {
      final d = x[i] - y[i];
      summe += d * d;
    }
    return math.sqrt(summe);
  }
}
