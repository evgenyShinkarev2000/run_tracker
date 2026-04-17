import 'package:run_tracker/Core/Math/CompressorGeneric.dart';
import 'package:test/test.dart';

void main() {
  test("Compressor liner map", () {
    expect(CompressorFunctions.linearMap(1, 5, 10), 10);
    expect(CompressorFunctions.linearMap(0, 5, 10), 5);
    expect(CompressorFunctions.linearMap(0.2, 5, 10), 6);
    expect(CompressorFunctions.linearMap(0.2, 10, 5), 9);
  });

  test("Compressor transform", (){
    final transform = CompressorFunctions.buildTransform((x) => x);
    expect(transform(100, 5, 10, 100), 10);
    expect(transform(5, 5, 10, 100), 5);
    expect(transform(0, 50, 0, -50), 25);
    expect(transform(50, 50, 0, -50), 50);
    expect(transform(-50, 50, 0, -50), 0);
  });
}
