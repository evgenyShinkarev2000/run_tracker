import 'package:run_tracker/Pages/PulseDev/FFTHelper.dart';
import 'package:test/test.dart';

void main() {
  FFTHelper buildHelper() {
    return FFTHelper(
      size: 60,
      durationSeconds: 2,
      wantedFrequencyAccuracy: 1 / 60,
    );
  }

  test("fft helper create", () {
    final fftHelper = buildHelper();
    expect(fftHelper.padSize, 1740);
    expect(fftHelper.minFrequencyAccuracy, 1 / 60);
    expect(fftHelper.fft.size, 1800);
  });

  test("fft helper frequency to index", () {
    final fftHelper = buildHelper();

    expect(fftHelper.frequencyToIndex(1 / 60), 0);
    expect(fftHelper.frequencyToIndex(1), 59);
  });
  test("fft helper index to frequency", () {
    final fftHelper = buildHelper();

    expect(fftHelper.indexToFrequency(0), 1 / 60);
    expect(fftHelper.indexToFrequency(1), 2 / 60);
    expect(fftHelper.indexToFrequency(59), 1);
  });
}
