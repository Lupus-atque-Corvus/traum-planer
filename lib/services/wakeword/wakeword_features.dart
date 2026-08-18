import 'dart:math' as math;
import 'dart:typed_data';

import 'package:fftea/fftea.dart';

/// Leichtgewichtige Log-Mel-Merkmalsextraktion für die Aktivierungswort-
/// Erkennung (Muster-Matching gegen selbst aufgenommene Proben, siehe Plan
/// "Aktivierungswort für den Sprachassistenten"). Bewusst deutlich kleiner
/// als eine volle ASR-Pipeline (32 statt z. B. 80 Mel-Bänder) — hier geht es
/// nur darum, ein einzelnes kurzes Wort wiederzuerkennen, nicht beliebige
/// Sprache zu transkribieren.
class WakeWordFeatures {
  const WakeWordFeatures._();

  static const sampleRate = 16000;
  static const frameSize = 512; // ~32 ms bei 16 kHz, Radix-2-FFT-tauglich
  static const hopSize = 160; // 10 ms
  static const melBands = 32;

  static final Float64List _fenster = Window.hanning(frameSize);
  static final FFT _fft = FFT(frameSize);
  static final _MelFilterbank _melFilter = _MelFilterbank(
    fftSize: frameSize,
    sampleRate: sampleRate,
    numBands: melBands,
  );

  /// RMS-Energie eines Rohframes (Werte in [-1, 1]), für die einfache
  /// Sprachaktivitätserkennung (Start/Ende eines Kandidatensegments).
  static double rms(Float64List frame) {
    var summe = 0.0;
    for (final s in frame) {
      summe += s * s;
    }
    return math.sqrt(summe / frame.length);
  }

  /// Wandelt einen Rohframe der Länge [frameSize] in einen
  /// [melBands]-dimensionalen Log-Mel-Merkmalsvektor um.
  static Float64List logMel(Float64List frame) {
    final gefenstert = Float64List(frameSize);
    for (var i = 0; i < frameSize; i++) {
      gefenstert[i] = frame[i] * _fenster[i];
    }
    final spektrum = _fft.realFft(gefenstert).discardConjugates().magnitudes();
    return _melFilter.apply(spektrum);
  }
}

/// Klassische Dreiecks-Mel-Filterbank über die FFT-Magnituden.
class _MelFilterbank {
  final List<Float64List> _dreiecke;

  _MelFilterbank({required int fftSize, required int sampleRate, required int numBands})
      : _dreiecke = _bauen(fftSize, sampleRate, numBands);

  static double _hzZuMel(double hz) => 2595 * math.log(1 + hz / 700) / math.ln10;
  static double _melZuHz(double mel) => 700 * (math.pow(10, mel / 2595) - 1);

  static List<Float64List> _bauen(int fftSize, int sampleRate, int numBands) {
    final anzahlBins = fftSize ~/ 2 + 1;
    final melMin = _hzZuMel(0);
    final melMax = _hzZuMel(sampleRate / 2);
    final melPunkte = List.generate(
      numBands + 2,
      (i) => melMin + (melMax - melMin) * i / (numBands + 1),
    );
    final binPunkte = melPunkte
        .map(_melZuHz)
        .map((hz) => (hz * fftSize / sampleRate).round().clamp(0, anzahlBins - 1))
        .toList();

    final filter = List.generate(numBands, (_) => Float64List(anzahlBins));
    for (var b = 0; b < numBands; b++) {
      final links = binPunkte[b];
      final mitte = binPunkte[b + 1];
      final rechts = binPunkte[b + 2];
      for (var k = links; k < mitte; k++) {
        if (mitte > links) filter[b][k] = (k - links) / (mitte - links);
      }
      for (var k = mitte; k < rechts; k++) {
        if (rechts > mitte) filter[b][k] = (rechts - k) / (rechts - mitte);
      }
    }
    return filter;
  }

  Float64List apply(Float64List magnitudes) {
    final out = Float64List(_dreiecke.length);
    for (var b = 0; b < _dreiecke.length; b++) {
      var summe = 0.0;
      final filter = _dreiecke[b];
      final grenze = math.min(filter.length, magnitudes.length);
      for (var k = 0; k < grenze; k++) {
        summe += filter[k] * magnitudes[k];
      }
      out[b] = math.log(summe + 1e-6);
    }
    return out;
  }
}
