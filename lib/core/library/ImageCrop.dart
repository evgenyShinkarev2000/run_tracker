import 'package:flutter/foundation.dart';
import 'package:run_tracker/helpers/extensions/IterableExtension.dart';

class ImageCrop {
  Uint8List crop(Uint8List lumies, int sourceWidth, int sourceHeight, int targetWidth, int targetHeight) {
    assert(targetWidth >= 0);
    assert(targetHeight >= 0);
    assert(targetWidth <= sourceWidth);
    assert(targetHeight <= sourceHeight);
    assert(lumies.length == sourceWidth * sourceHeight);

    final leftLimit = (sourceWidth / 2 - targetWidth / 2).round();
    final rightLimit = (sourceWidth / 2 + targetWidth / 2).round();
    final topLimit = (sourceHeight / 2 - targetHeight / 2).round();
    final bottomLimit = (sourceHeight / 2 + targetHeight / 2).round();

    final buffer = WriteBuffer(startCapacity: targetWidth * targetHeight);

    var startIndex = leftLimit + sourceWidth * topLimit;
    var endIndex = rightLimit + sourceWidth * topLimit;
    for (var _ in DSIterable.ray(topLimit, bottomLimit)) {
      final range = lumies.sublist(startIndex, endIndex);
      for (var uint8 in range) {
        buffer.putUint8(uint8);
      }

      startIndex += sourceWidth;
      endIndex += sourceWidth;
    }

    return buffer.done().buffer.asUint8List();
  }

  Iterable<int> uint8Iterator(
      Uint8List lumies, int sourceWidth, int sourceHeight, int targetWidth, int targetHeight) sync* {
    assert(targetWidth >= 0);
    assert(targetHeight >= 0);
    assert(targetWidth <= sourceWidth);
    assert(targetHeight <= sourceHeight);
    assert(lumies.length == sourceWidth * sourceHeight);

    final leftLimit = (sourceWidth / 2 - targetWidth / 2).round();
    final rightLimit = (sourceWidth / 2 + targetWidth / 2).round();
    final topLimit = (sourceHeight / 2 - targetHeight / 2).round();
    final bottomLimit = (sourceHeight / 2 + targetHeight / 2).round();

    var startIndex = leftLimit + sourceWidth * topLimit;
    var endIndex = rightLimit + sourceWidth * topLimit;
    for (var _ in DSIterable.ray(topLimit, bottomLimit)) {
      final range = lumies.sublist(startIndex, endIndex);
      for (var uint8 in range) {
        yield uint8;
      }

      startIndex += sourceWidth;
      endIndex += sourceWidth;
    }
  }
}
