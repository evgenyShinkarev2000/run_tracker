import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:run_tracker/Core/export.dart';

void main() {
  test("enqueue overflow dequeue", (){
    final buffer = CircularBuffer<int>(3);
    for(var i in Iterable.generate(6, (i) => i + 1)){
      buffer.enqueue(i);
    }
    var result = buffer.toList();
    expect(listEquals(result, [4, 5, 6]), true, reason: "different list elements");

    final four = buffer.dequeue();
    expect(four, 4);
    result = buffer.toList();
    expect(listEquals(result, [5, 6]), true);

    buffer.dequeue();
    final six = buffer.dequeue();
    expect(six, 6);
    result = buffer.toList();
    expect(result.isEmpty, true);
  });
}
