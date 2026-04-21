import 'dart:math';
import 'dart:typed_data';

import 'package:fftea/fftea.dart';

class FFTHelper {
  final int size;
  final double durationSeconds;
  final double wantedFrequencyAccuracy;

  late final FFT fft;
  late final int padSize;
  late final double minFrequencyAccuracy;
  late final Float64x2List _buffer;
  late final Float64List _view;

  FFTHelper({
    required this.size,
    required this.durationSeconds,
    required this.wantedFrequencyAccuracy,
  }) : assert(durationSeconds != 0),
       assert(size > 0),
       assert(wantedFrequencyAccuracy > 0) {
    final currentFrequencyAccuracy = 1 / durationSeconds;
    minFrequencyAccuracy = min(
      currentFrequencyAccuracy,
      wantedFrequencyAccuracy,
    );

    final paddedSize = max(
      (size / (minFrequencyAccuracy / currentFrequencyAccuracy)).floor(),
      size,
    );
    padSize = paddedSize - size;

    _buffer = Float64x2List(paddedSize);
    _view = _buffer.buffer.asFloat64List();
    fft = FFT(paddedSize);
  }

  static int frequencyToIndexByAccuracy(
    double frequency,
    double minFrequencyAccuracy,
  ) {
    if (frequency <= minFrequencyAccuracy) {
      return 0;
    }
    return ((frequency - minFrequencyAccuracy) / minFrequencyAccuracy).floor();
  }

  static double indexToFrequencyByAccuracy(
    int index,
    double minFrequencyAccuracy,
  ) => ++index * minFrequencyAccuracy;

  int frequencyToIndex(double frequency) =>
      frequencyToIndexByAccuracy(frequency, minFrequencyAccuracy);

  double indexToFrequency(int index) =>
      indexToFrequencyByAccuracy(index, minFrequencyAccuracy);

  FindSpectogramResult findSpectogram(
    List<double> values, {
    double? minFrequency,
    double? maxFrequency,
  }) {
    assert(values.length == size);

    for (var i = 0; i < size; ++i) {
      _view[i * 2] = values[i];
      _view[i * 2 + 1] = 0;
    }
    _view.fillRange(size * 2, _view.length, 0);

    fft.inPlaceFft(_buffer);

    Iterable<Float64x2> iterable = _buffer;
    int? minIndex;
    int? maxIndex;
    if (maxFrequency != null) {
      maxIndex = frequencyToIndex(maxFrequency);
      iterable = iterable.take(maxIndex);
    }
    if (minFrequency != null) {
      minIndex = frequencyToIndex(minFrequency);
      iterable = iterable.skip(minIndex);
    }
    final spectogram = iterable.map((e) => e.x * e.x + e.y * e.y).toList();

    return FindSpectogramResult(
      spectogram: spectogram,
      minIndex: minIndex ?? 0,
      maxIndex: maxIndex ?? spectogram.length,
      minFrequencyAccuracy: minFrequencyAccuracy,
    );
  }
}

class FindSpectogramResult {
  final List<double> spectogram;
  final int minIndex;
  final int maxIndex;
  final double minFrequencyAccuracy;

  FindSpectogramResult({
    required this.spectogram,
    required this.minIndex,
    required this.maxIndex,
    required this.minFrequencyAccuracy,
  });

  int frequencyToIndex(double frequency) =>
      FFTHelper.frequencyToIndexByAccuracy(frequency, minFrequencyAccuracy) + minIndex;

  double indexToFrequency(int index) =>
      FFTHelper.indexToFrequencyByAccuracy(index + minIndex, minFrequencyAccuracy);
}
