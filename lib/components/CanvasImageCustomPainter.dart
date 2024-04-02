import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

class CanvasImageCustomPainter extends CustomPainter {
  final ui.Image image;
  CanvasImageCustomPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    // size.center(Offset(-image.width.toDouble(), image.height.toDouble()));
    canvas.scale(0.6);
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is CanvasImageCustomPainter) {
      return oldDelegate.image.hashCode != image.hashCode;
    }
    return true;
  }
}
