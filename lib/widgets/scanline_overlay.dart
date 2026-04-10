import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ScanlineOverlay extends StatelessWidget {
  const ScanlineOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScanlinePainter(),
      child: const SizedBox.expand(),
    );
  }
}

class ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Scanlines - greatly reduced opacity
    final scanlinePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.015)
      ..style = PaintingStyle.fill;

    for (double y = 0; y < size.height; y += 3) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), scanlinePaint);
    }

    // Vignette effect - greatly reduced
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final vignettePaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width / 2, size.height / 2),
        size.width * 0.8,
        [
          const ui.Color(0x00000000),
          const ui.Color(0x0D000000),
        ],
      );

    canvas.drawRect(rect, vignettePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
