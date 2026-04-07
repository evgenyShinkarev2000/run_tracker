import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:run_tracker/Core/Exceptions/export.dart';

class CameraFrameBrightness {
  final int width;
  final int height;

  int? _prevBufferLength;
  int? _prevBytesPerRow;
  int? _widthStart;
  int? _widthEnd;
  int? _heightStart;
  int? _heightEnd;

  CameraFrameBrightness({this.width = 64, this.height = 64});

  double findBrightness(CameraImage image) {
    return switch (image.format.group) {
      ImageFormatGroup.nv21 ||
      ImageFormatGroup.yuv420 => _findAverageLumyYuv(image.planes),
      _ => throw NotSupportedException(),
    };
  }

  double _findAverageLumyYuv(List<Plane> planes) {
    final lumyPlane = planes.first;
    if (_prevBytesPerRow != lumyPlane.bytesPerRow) {
      assert(lumyPlane.bytesPerRow > 0);
      _prevBytesPerRow = lumyPlane.bytesPerRow;
      _updateWidthCrop();
    }
    if (_prevBufferLength != lumyPlane.bytes.length) {
      _prevBufferLength = lumyPlane.bytes.length;
      _updateHeightCrop();
    }

    return _findCenterAverageLumy(lumyPlane.bytes);
  }

  double _findCenterAverageLumy(Uint8List bytes) {
    final widthStart = _widthStart!;
    final widthEnd = _widthEnd!;
    final heightStart = _heightStart!;
    final heightEnd = _heightEnd!;
    final rowLength = _prevBytesPerRow!;

    var widthIndex = 0;
    var heightIndex = 0;
    var lumySum = 0;

    for (var byte in bytes) {
      if (heightIndex >= heightStart &&
          widthStart <= widthIndex &&
          widthIndex <= widthEnd) {
        lumySum += byte;
      }
      ++widthIndex;
      if (widthIndex == rowLength) {
        widthIndex = 0;
        ++heightIndex;
        if (heightIndex > heightEnd) {
          break;
        }
      }
    }

    return lumySum / ((widthEnd - widthStart) * (heightEnd - heightStart));
  }

  void _updateWidthCrop() {
    final result = _findStartEndIndex(width, _prevBytesPerRow!);
    _widthStart = result.$1;
    _widthEnd = result.$2;
  }

  void _updateHeightCrop() {
    final frameHeight = (_prevBufferLength! / _prevBytesPerRow!).floor();
    final result = _findStartEndIndex(height, frameHeight);
    _heightStart = result.$1;
    _heightEnd = result.$2;
  }

  static (int, int) _findStartEndIndex(int centerLength, int maxLength) {
    if (centerLength > maxLength) {
      return (0, maxLength);
    }

    final offset = ((maxLength - centerLength) / 2).floor();
    final startIndex = (maxLength / 2).floor() - offset;

    return (startIndex, startIndex + offset);
  }
}
