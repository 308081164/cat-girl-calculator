import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/cat_state.dart';

class CatCharacter extends StatefulWidget {
  final CatState catState;
  const CatCharacter({super.key, required this.catState});

  @override
  State<CatCharacter> createState() => _CatCharacterState();
}

class _CatCharacterState extends State<CatCharacter> with SingleTickerProviderStateMixin {
  late AnimationController _frameController;
  int _currentFrame = 0;

  // Animation frame counts per state
  static const _frameCounts = {
    CatState.idle: 4,
    CatState.happy: 4,
    CatState.confused: 3,
    CatState.pushedAway: 3,
    CatState.sleeping: 2,
    CatState.squished: 3,
    CatState.shocked: 4,
    CatState.celebrating: 6,
  };

  // Frame durations in ms per state
  static const _frameDurations = {
    CatState.idle: 400,
    CatState.happy: 250,
    CatState.confused: 500,
    CatState.pushedAway: 200,
    CatState.sleeping: 800,
    CatState.squished: 300,
    CatState.shocked: 150,
    CatState.celebrating: 200,
  };

  @override
  void initState() {
    super.initState();
    _frameController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _frameDurations[widget.catState] ?? 400),
    )..repeat();
    _frameController.addListener(_onFrame);
  }

  void _onFrame() {
    final frameCount = _frameCounts[widget.catState] ?? 4;
    final newFrame = (_frameController.value * frameCount).floor() % frameCount;
    if (newFrame != _currentFrame) {
      setState(() => _currentFrame = newFrame);
    }
  }

  @override
  void didUpdateWidget(CatCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.catState != widget.catState) {
      _currentFrame = 0;
      _frameController.duration = Duration(milliseconds: _frameDurations[widget.catState] ?? 400);
    }
  }

  @override
  void dispose() {
    _frameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: CatGirlPainter(
          state: widget.catState,
          frame: _currentFrame,
        ),
      ),
    );
  }
}

class CatGirlPainter extends CustomPainter {
  final CatState state;
  final int frame;

  CatGirlPainter({required this.state, required this.frame});

  // === Kawaii Cat Girl Color Palette (128x128) ===

  // Hair - golden/light brown, 5 layers
  static const hairLight = Color(0xFFF5D585);   // golden highlight
  static const hairBase = Color(0xFFD4A040);    // golden base
  static const hairMid = Color(0xFFC89838);     // mid tone
  static const hairDark = Color(0xFFB08030);    // dark golden shadow
  static const hairShadow = Color(0xFF8B6914);  // deepest shadow

  // Face - warm pink skin, 4 layers
  static const skinLight = Color(0xFFFFF5E5);   // highlight (cream white)
  static const skinBase = Color(0xFFF5D5C5);    // base (warm pink)
  static const skinShadow = Color(0xFFE5B5A5);  // shadow (reddish brown)
  static const skinDark = Color(0xFFD5A595);    // deep shadow

  // Eyes - purple big round eyes, 6 layers
  static const eyeWhite = Color(0xFFE5F0FF);    // eye white (blue-white)
  static const eyeIris = Color(0xFFA5B5E5);     // iris (light purple)
  static const eyeIrisDark = Color(0xFF7585C5); // iris dark
  static const eyePupil = Color(0xFF454565);    // pupil (near-black purple)
  static const eyeHighlight = Color(0xFFFFFFFF); // highlight (pure white)
  static const eyeLower = Color(0xFFC5D0E5);    // lower eyelid (aegyo sal)

  // Blush
  static const blush = Color(0xFFF5A5B5);       // pink blush

  // Mouth - omega smile
  static const mouth = Color(0xFFE8836B);       // coral color

  // Clothing - dark coat, 4 layers
  static const clothBase = Color(0xFF555565);   // dark gray-blue base
  static const clothLight = Color(0xFF707080);  // light highlight
  static const clothDark = Color(0xFF404050);   // dark shadow
  static const clothAccent = Color(0xFF8888A0); // accent

  // Ribbon decoration
  static const ribbon = Color(0xFF333340);      // dark ribbon

  // Gold accents
  static const goldAccent = Color(0xFFE5C565);  // gold
  static const goldLight = Color(0xFFF5E5A5);   // light gold

  // Cat ears
  static const earInner = Color(0xFFFFD5D5);    // ear inner pink
  static const earFur = Color(0xFFF0C8C8);      // ear inner fur

  // ============================================================
  // Anti-aliased drawing helper methods
  // ============================================================

  /// Smooth pixel - uses rounded rectangle with slight inset and anti-aliasing
  void _drawPixel(Canvas canvas, double x, double y, Color color) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 0.02, y + 0.02, 0.96, 0.96),
        const Radius.circular(0.15),
      ),
      paint,
    );
  }

  /// Smooth rectangle block - with rounded corners and anti-aliasing
  void _drawPixelRect(Canvas canvas, double x, double y, double w, double h, Color color) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 0.02, y + 0.02, w - 0.04, h - 0.04),
        const Radius.circular(0.15),
      ),
      paint,
    );
  }

  /// Smooth ellipse - for eyes, blush, etc.
  void _drawEllipse(Canvas canvas, double cx, double cy, double rx, double ry, Color color) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: rx * 2, height: ry * 2),
      paint,
    );
  }

  /// Smooth line - for hair highlights, outlines, etc.
  void _drawLine(Canvas canvas, double x1, double y1, double x2, double y2, Color color, {double width = 0.8}) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }

  /// Smooth arc - for eyebrows, mouth, etc.
  void _drawArc(Canvas canvas, double cx, double cy, double rx, double ry, double startAngle, double sweepAngle, Color color, {double width = 0.8}) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy), width: rx * 2, height: ry * 2),
      startAngle, sweepAngle, false, paint,
    );
  }

  /// Smooth dot - for highlights, small decorations
  void _drawDot(Canvas canvas, double cx, double cy, double r, Color color) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true;
    canvas.drawCircle(Offset(cx, cy), r, paint);
  }

  /// Transition pixel - semi-transparent blend at color boundaries
  void _drawBlendPixel(Canvas canvas, double x, double y, Color color, {double alpha = 0.4}) {
    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..isAntiAlias = true;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x, y, 1, 1), const Radius.circular(0.2)),
      paint,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 128, size.height / 128);

    switch (state) {
      case CatState.idle:
        _drawIdle(canvas);
        break;
      case CatState.happy:
        _drawHappy(canvas);
        break;
      case CatState.confused:
        _drawConfused(canvas);
        break;
      case CatState.pushedAway:
        _drawPushedAway(canvas);
        break;
      case CatState.sleeping:
        _drawSleeping(canvas);
        break;
      case CatState.squished:
        _drawSquished(canvas);
        break;
      case CatState.shocked:
        _drawShocked(canvas);
        break;
      case CatState.celebrating:
        _drawCelebrating(canvas);
        break;
    }
  }

  // ============================================================
  // Helper: Draw cat ears (hoodie style, large triangles 10 rows high)
  // ============================================================
  void _drawEars(Canvas canvas, double offX, double offY, {bool rightDroopy = false}) {
    // Left ear - tall triangle, 10 rows high, 8 cols wide
    // Row 0 (tip)
    _drawPixelRect(canvas, 38 + offX, 4 + offY, 2, 1, hairLight);
    _drawPixelRect(canvas, 36 + offX, 4 + offY, 2, 1, hairBase);
    // Row 1
    _drawPixelRect(canvas, 35 + offX, 5 + offY, 6, 1, hairBase);
    _drawPixelRect(canvas, 37 + offX, 5 + offY, 2, 1, hairLight);
    // Row 2
    _drawPixelRect(canvas, 34 + offX, 6 + offY, 8, 1, hairBase);
    _drawPixelRect(canvas, 36 + offX, 6 + offY, 3, 1, hairLight);
    // Row 3
    _drawPixelRect(canvas, 33 + offX, 7 + offY, 10, 1, hairBase);
    _drawPixelRect(canvas, 35 + offX, 7 + offY, 4, 1, hairLight);
    // Row 4
    _drawPixelRect(canvas, 33 + offX, 8 + offY, 10, 1, hairBase);
    _drawPixelRect(canvas, 34 + offX, 8 + offY, 3, 1, hairMid);
    // Row 5
    _drawPixelRect(canvas, 34 + offX, 9 + offY, 8, 1, hairBase);
    _drawPixelRect(canvas, 34 + offX, 9 + offY, 2, 1, hairMid);
    // Row 6
    _drawPixelRect(canvas, 35 + offX, 10 + offY, 6, 1, hairBase);
    // Row 7
    _drawPixelRect(canvas, 36 + offX, 11 + offY, 4, 1, hairBase);
    // Row 8
    _drawPixelRect(canvas, 37 + offX, 12 + offY, 2, 1, hairBase);
    // Row 9 (base)
    _drawPixelRect(canvas, 37 + offX, 13 + offY, 2, 1, hairDark);

    // Left ear inner (pink) - use ellipse for smooth inner area
    _drawEllipse(canvas, 38 + offX, 8 + offY, 2.5, 2.5, earInner);
    _drawEllipse(canvas, 38 + offX, 9.5 + offY, 2, 1.5, earFur);

    // Left ear outline - smooth lines for edges
    _drawLine(canvas, 39 + offX, 4.5 + offY, 33 + offX, 13.5 + offY, hairShadow, width: 0.6);
    _drawLine(canvas, 39 + offX, 4.5 + offY, 43 + offX, 13.5 + offY, hairShadow, width: 0.6);

    // Blend pixels at ear base transition
    _drawBlendPixel(canvas, 36 + offX, 13 + offY, hairShadow, alpha: 0.25);
    _drawBlendPixel(canvas, 40 + offX, 13 + offY, hairShadow, alpha: 0.25);

    // Right ear
    if (rightDroopy) {
      // Droopy right ear - tilted to the side
      _drawPixelRect(canvas, 78 + offX, 12 + offY, 8, 1, hairBase);
      _drawPixelRect(canvas, 82 + offX, 12 + offY, 2, 1, hairLight);
      _drawPixelRect(canvas, 80 + offX, 11 + offY, 6, 1, hairBase);
      _drawPixelRect(canvas, 82 + offX, 11 + offY, 2, 1, hairLight);
      _drawPixelRect(canvas, 82 + offX, 10 + offY, 4, 1, hairBase);
      _drawPixelRect(canvas, 83 + offX, 9 + offY, 2, 1, hairBase);
      // Droopy ear inner
      _drawEllipse(canvas, 82 + offX, 11 + offY, 1.5, 1, earInner);
      _drawEllipse(canvas, 83 + offX, 10 + offY, 1, 0.8, earFur);
      // Droopy ear outline
      _drawLine(canvas, 78 + offX, 12.5 + offY, 83.5 + offX, 9.5 + offY, hairShadow, width: 0.6);
      _drawLine(canvas, 86 + offX, 12.5 + offY, 83.5 + offX, 9.5 + offY, hairShadow, width: 0.6);
    } else {
      // Normal right ear - tall triangle, 10 rows high, 8 cols wide
      // Row 0 (tip)
      _drawPixelRect(canvas, 88 + offX, 4 + offY, 2, 1, hairBase);
      _drawPixelRect(canvas, 90 + offX, 4 + offY, 2, 1, hairLight);
      // Row 1
      _drawPixelRect(canvas, 87 + offX, 5 + offY, 6, 1, hairBase);
      _drawPixelRect(canvas, 89 + offX, 5 + offY, 2, 1, hairLight);
      // Row 2
      _drawPixelRect(canvas, 86 + offX, 6 + offY, 8, 1, hairBase);
      _drawPixelRect(canvas, 89 + offX, 6 + offY, 3, 1, hairLight);
      // Row 3
      _drawPixelRect(canvas, 85 + offX, 7 + offY, 10, 1, hairBase);
      _drawPixelRect(canvas, 89 + offX, 7 + offY, 4, 1, hairLight);
      // Row 4
      _drawPixelRect(canvas, 85 + offX, 8 + offY, 10, 1, hairBase);
      _drawPixelRect(canvas, 91 + offX, 8 + offY, 3, 1, hairMid);
      // Row 5
      _drawPixelRect(canvas, 86 + offX, 9 + offY, 8, 1, hairBase);
      _drawPixelRect(canvas, 92 + offX, 9 + offY, 2, 1, hairMid);
      // Row 6
      _drawPixelRect(canvas, 87 + offX, 10 + offY, 6, 1, hairBase);
      // Row 7
      _drawPixelRect(canvas, 88 + offX, 11 + offY, 4, 1, hairBase);
      // Row 8
      _drawPixelRect(canvas, 89 + offX, 12 + offY, 2, 1, hairBase);
      // Row 9 (base)
      _drawPixelRect(canvas, 89 + offX, 13 + offY, 2, 1, hairDark);

      // Right ear inner (pink) - smooth ellipse
      _drawEllipse(canvas, 90 + offX, 8 + offY, 2.5, 2.5, earInner);
      _drawEllipse(canvas, 90 + offX, 9.5 + offY, 2, 1.5, earFur);

      // Right ear outline - smooth lines
      _drawLine(canvas, 89 + offX, 4.5 + offY, 85 + offX, 13.5 + offY, hairShadow, width: 0.6);
      _drawLine(canvas, 89 + offX, 4.5 + offY, 95 + offX, 13.5 + offY, hairShadow, width: 0.6);

      // Blend pixels at ear base transition
      _drawBlendPixel(canvas, 88 + offX, 13 + offY, hairShadow, alpha: 0.25);
      _drawBlendPixel(canvas, 92 + offX, 13 + offY, hairShadow, alpha: 0.25);
    }
  }

  // ============================================================
  // Helper: Draw hair (golden, layered, with detailed bangs and side hair)
  // ============================================================
  void _drawHair(Canvas canvas, double offX, double offY) {
    // Top hair volume - back layer (darkest)
    _drawPixelRect(canvas, 34 + offX, 8 + offY, 60, 4, hairShadow);

    // Top hair volume - main layer
    _drawPixelRect(canvas, 32 + offX, 8 + offY, 64, 5, hairBase);
    // Top highlight streak
    _drawPixelRect(canvas, 44 + offX, 8 + offY, 16, 1, hairLight);
    _drawPixelRect(canvas, 58 + offX, 9 + offY, 8, 1, hairLight);
    _drawPixelRect(canvas, 48 + offX, 9 + offY, 6, 1, hairMid);
    // Secondary highlight
    _drawPixelRect(canvas, 38 + offX, 9 + offY, 4, 1, hairLight);

    // Bangs - layered strands (each 2-3px wide)
    // Left bangs group
    _drawPixelRect(canvas, 32 + offX, 13 + offY, 3, 4, hairBase);
    _drawPixelRect(canvas, 32 + offX, 13 + offY, 2, 1, hairLight);
    _drawPixelRect(canvas, 35 + offX, 13 + offY, 3, 5, hairBase);
    _drawPixelRect(canvas, 35 + offX, 13 + offY, 1, 1, hairLight);
    _drawPixelRect(canvas, 35 + offX, 16 + offY, 2, 2, hairMid);
    _drawPixelRect(canvas, 38 + offX, 13 + offY, 3, 4, hairDark);
    _drawPixelRect(canvas, 38 + offX, 13 + offY, 1, 1, hairBase);
    _drawPixelRect(canvas, 38 + offX, 15 + offY, 2, 2, hairMid);
    // Center-left bangs
    _drawPixelRect(canvas, 41 + offX, 13 + offY, 3, 5, hairBase);
    _drawPixelRect(canvas, 41 + offX, 13 + offY, 2, 1, hairLight);
    _drawPixelRect(canvas, 41 + offX, 16 + offY, 2, 2, hairMid);
    // Center bangs
    _drawPixelRect(canvas, 44 + offX, 13 + offY, 4, 4, hairBase);
    _drawPixelRect(canvas, 45 + offX, 13 + offY, 2, 1, hairLight);
    _drawPixelRect(canvas, 44 + offX, 15 + offY, 2, 2, hairMid);
    // Center-right bangs
    _drawPixelRect(canvas, 48 + offX, 13 + offY, 4, 5, hairBase);
    _drawPixelRect(canvas, 48 + offX, 13 + offY, 2, 1, hairLight);
    _drawPixelRect(canvas, 50 + offX, 16 + offY, 2, 2, hairMid);
    // Right bangs group
    _drawPixelRect(canvas, 52 + offX, 13 + offY, 3, 4, hairBase);
    _drawPixelRect(canvas, 52 + offX, 13 + offY, 1, 1, hairLight);
    _drawPixelRect(canvas, 55 + offX, 13 + offY, 3, 5, hairDark);
    _drawPixelRect(canvas, 55 + offX, 13 + offY, 1, 1, hairBase);
    _drawPixelRect(canvas, 55 + offX, 15 + offY, 2, 2, hairMid);
    _drawPixelRect(canvas, 58 + offX, 13 + offY, 3, 4, hairBase);
    _drawPixelRect(canvas, 58 + offX, 13 + offY, 1, 1, hairLight);
    _drawPixelRect(canvas, 61 + offX, 13 + offY, 3, 5, hairBase);
    _drawPixelRect(canvas, 61 + offX, 13 + offY, 2, 1, hairLight);
    _drawPixelRect(canvas, 61 + offX, 16 + offY, 2, 2, hairMid);
    _drawPixelRect(canvas, 64 + offX, 13 + offY, 3, 4, hairBase);
    _drawPixelRect(canvas, 64 + offX, 13 + offY, 1, 1, hairLight);
    _drawPixelRect(canvas, 67 + offX, 13 + offY, 3, 4, hairDark);
    _drawPixelRect(canvas, 67 + offX, 13 + offY, 1, 1, hairBase);
    _drawPixelRect(canvas, 70 + offX, 13 + offY, 3, 4, hairBase);
    _drawPixelRect(canvas, 70 + offX, 13 + offY, 2, 1, hairLight);
    _drawPixelRect(canvas, 73 + offX, 13 + offY, 3, 4, hairBase);
    _drawPixelRect(canvas, 73 + offX, 13 + offY, 1, 1, hairLight);
    _drawPixelRect(canvas, 76 + offX, 13 + offY, 3, 4, hairBase);
    _drawPixelRect(canvas, 76 + offX, 13 + offY, 2, 1, hairLight);
    _drawPixelRect(canvas, 79 + offX, 13 + offY, 3, 4, hairBase);
    _drawPixelRect(canvas, 79 + offX, 13 + offY, 1, 1, hairLight);
    _drawPixelRect(canvas, 82 + offX, 13 + offY, 3, 4, hairBase);
    _drawPixelRect(canvas, 82 + offX, 13 + offY, 2, 1, hairLight);
    _drawPixelRect(canvas, 85 + offX, 13 + offY, 3, 4, hairDark);
    _drawPixelRect(canvas, 85 + offX, 13 + offY, 1, 1, hairBase);
    _drawPixelRect(canvas, 88 + offX, 13 + offY, 3, 4, hairBase);
    _drawPixelRect(canvas, 88 + offX, 13 + offY, 2, 1, hairLight);
    _drawPixelRect(canvas, 91 + offX, 13 + offY, 3, 3, hairBase);
    _drawPixelRect(canvas, 91 + offX, 13 + offY, 1, 1, hairLight);

    // Highlight lines on bangs - use smooth lines instead of rectangles
    _drawLine(canvas, 36.5 + offX, 14 + offY, 36.5 + offX, 16 + offY, hairLight, width: 0.7);
    _drawLine(canvas, 46.5 + offX, 14 + offY, 46.5 + offX, 16 + offY, hairLight, width: 0.7);
    _drawLine(canvas, 63.5 + offX, 14 + offY, 63.5 + offX, 16 + offY, hairLight, width: 0.7);
    _drawLine(canvas, 77.5 + offX, 14 + offY, 77.5 + offX, 16 + offY, hairLight, width: 0.7);

    // Side hair - left (long flowing to y~75)
    _drawPixelRect(canvas, 30 + offX, 14 + offY, 4, 28, hairBase);
    _drawPixelRect(canvas, 30 + offX, 14 + offY, 2, 8, hairLight);
    _drawPixelRect(canvas, 28 + offX, 22 + offY, 2, 20, hairBase);
    _drawPixelRect(canvas, 28 + offX, 22 + offY, 1, 6, hairDark);
    _drawPixelRect(canvas, 30 + offX, 34 + offY, 2, 8, hairDark);
    _drawPixelRect(canvas, 28 + offX, 38 + offY, 2, 6, hairShadow);
    _drawPixelRect(canvas, 30 + offX, 42 + offY, 2, 4, hairShadow);
    // Hair strand highlight - smooth line
    _drawLine(canvas, 31.5 + offX, 18 + offY, 31.5 + offX, 24 + offY, hairLight, width: 0.8);
    _drawLine(canvas, 29.5 + offX, 28 + offY, 29.5 + offX, 32 + offY, hairMid, width: 0.6);

    // Side hair - right (long flowing to y~75)
    _drawPixelRect(canvas, 94 + offX, 14 + offY, 4, 28, hairBase);
    _drawPixelRect(canvas, 96 + offX, 14 + offY, 2, 8, hairLight);
    _drawPixelRect(canvas, 98 + offX, 22 + offY, 2, 20, hairBase);
    _drawPixelRect(canvas, 99 + offX, 22 + offY, 1, 6, hairDark);
    _drawPixelRect(canvas, 96 + offX, 34 + offY, 2, 8, hairDark);
    _drawPixelRect(canvas, 98 + offX, 38 + offY, 2, 6, hairShadow);
    _drawPixelRect(canvas, 96 + offX, 42 + offY, 2, 4, hairShadow);
    // Hair strand highlight - smooth line
    _drawLine(canvas, 96.5 + offX, 18 + offY, 96.5 + offX, 24 + offY, hairLight, width: 0.8);
    _drawLine(canvas, 98.5 + offX, 28 + offY, 98.5 + offX, 32 + offY, hairMid, width: 0.6);

    // Blend pixels at hair-to-face transition edges
    _drawBlendPixel(canvas, 32 + offX, 17 + offY, hairShadow, alpha: 0.2);
    _drawBlendPixel(canvas, 94 + offX, 17 + offY, hairShadow, alpha: 0.2);
    _drawBlendPixel(canvas, 30 + offX, 42 + offY, hairShadow, alpha: 0.3);
    _drawBlendPixel(canvas, 98 + offX, 42 + offY, hairShadow, alpha: 0.3);
  }

  // ============================================================
  // Helper: Draw face with detailed 6-layer eyes, blush, nose, mouth
  // ============================================================
  void _drawFace(
    Canvas canvas,
    double offX,
    double offY, {
    bool blink = false,
    bool starEyes = false,
    bool bigEyes = false,
    bool closedEyes = false,
    bool xxEyes = false,
    bool openMouth = false,
    bool wavyMouth = false,
    bool bigSmile = false,
  }) {
    // Face base
    _drawPixelRect(canvas, 38 + offX, 16 + offY, 52, 28, skinBase);
    // Face highlight (forehead and cheeks)
    _drawPixelRect(canvas, 42 + offX, 16 + offY, 20, 4, skinLight);
    _drawPixelRect(canvas, 46 + offX, 17 + offY, 12, 2, skinLight);
    // Cheek highlights
    _drawPixelRect(canvas, 40 + offX, 28 + offY, 8, 4, skinLight);
    _drawPixelRect(canvas, 80 + offX, 28 + offY, 8, 4, skinLight);
    // Face shadow (sides and chin)
    _drawPixelRect(canvas, 38 + offX, 16 + offY, 4, 20, skinShadow);
    _drawPixelRect(canvas, 86 + offX, 16 + offY, 4, 20, skinShadow);
    _drawPixelRect(canvas, 42 + offX, 40 + offY, 44, 4, skinShadow);
    _drawPixelRect(canvas, 46 + offX, 42 + offY, 36, 2, skinDark);

    // Blend pixels at face contour edges
    _drawBlendPixel(canvas, 37 + offX, 20 + offY, skinShadow, alpha: 0.2);
    _drawBlendPixel(canvas, 37 + offX, 28 + offY, skinShadow, alpha: 0.15);
    _drawBlendPixel(canvas, 90 + offX, 20 + offY, skinShadow, alpha: 0.2);
    _drawBlendPixel(canvas, 90 + offX, 28 + offY, skinShadow, alpha: 0.15);
    _drawBlendPixel(canvas, 50 + offX, 43 + offY, skinDark, alpha: 0.2);
    _drawBlendPixel(canvas, 70 + offX, 43 + offY, skinDark, alpha: 0.2);

    // Eyes
    if (xxEyes) {
      // X_X dizzy eyes - use smooth lines for X shape
      // Left X
      _drawLine(canvas, 46 + offX, 29 + offY, 51 + offX, 32 + offY, eyeIris, width: 1.2);
      _drawLine(canvas, 51 + offX, 29 + offY, 46 + offX, 32 + offY, eyeIris, width: 1.2);
      // Right X
      _drawLine(canvas, 73 + offX, 29 + offY, 78 + offX, 32 + offY, eyeIris, width: 1.2);
      _drawLine(canvas, 78 + offX, 29 + offY, 73 + offX, 32 + offY, eyeIris, width: 1.2);
    } else if (blink) {
      // Blinking - smooth arc for closed eye
      _drawArc(canvas, 49 + offX, 33 + offY, 5, 1.5, math.pi, -math.pi, eyeIris, width: 1.2);
      _drawArc(canvas, 79 + offX, 33 + offY, 5, 1.5, math.pi, -math.pi, eyeIris, width: 1.2);
      // Eyelashes on blink - smooth dots
      _drawDot(canvas, 43 + offX, 31.5 + offY, 0.8, eyeIrisDark);
      _drawDot(canvas, 84 + offX, 31.5 + offY, 0.8, eyeIrisDark);
    } else if (starEyes) {
      // Star-shaped happy eyes - use smooth shapes
      // Left star eye
      _drawEllipse(canvas, 49 + offX, 30 + offY, 3.5, 3.5, goldLight);
      _drawDot(canvas, 49 + offX, 30 + offY, 1.5, goldAccent);
      // Star points
      _drawLine(canvas, 49 + offX, 26.5 + offY, 49 + offX, 33.5 + offY, goldAccent, width: 0.8);
      _drawLine(canvas, 45.5 + offX, 30 + offY, 52.5 + offX, 30 + offY, goldAccent, width: 0.8);
      _drawDot(canvas, 46.5 + offX, 27.5 + offY, 0.6, goldAccent);
      _drawDot(canvas, 51.5 + offX, 27.5 + offY, 0.6, goldAccent);
      _drawDot(canvas, 46.5 + offX, 32.5 + offY, 0.6, goldAccent);
      _drawDot(canvas, 51.5 + offX, 32.5 + offY, 0.6, goldAccent);
      // Right star eye
      _drawEllipse(canvas, 79 + offX, 30 + offY, 3.5, 3.5, goldLight);
      _drawDot(canvas, 79 + offX, 30 + offY, 1.5, goldAccent);
      _drawLine(canvas, 79 + offX, 26.5 + offY, 79 + offX, 33.5 + offY, goldAccent, width: 0.8);
      _drawLine(canvas, 75.5 + offX, 30 + offY, 82.5 + offX, 30 + offY, goldAccent, width: 0.8);
      _drawDot(canvas, 76.5 + offX, 27.5 + offY, 0.6, goldAccent);
      _drawDot(canvas, 81.5 + offX, 27.5 + offY, 0.6, goldAccent);
      _drawDot(canvas, 76.5 + offX, 32.5 + offY, 0.6, goldAccent);
      _drawDot(canvas, 81.5 + offX, 32.5 + offY, 0.6, goldAccent);
    } else if (bigEyes) {
      // Big round shocked eyes - use smooth ellipses and circles
      // Left eye
      _drawEllipse(canvas, 49 + offX, 31 + offY, 7, 5, eyeWhite);
      _drawEllipse(canvas, 49 + offX, 32 + offY, 5, 4, eyeIris);
      _drawEllipse(canvas, 49 + offX, 32 + offY, 3, 2, eyeIrisDark);
      _drawDot(canvas, 49 + offX, 32 + offY, 1.2, eyePupil);
      // Highlight
      _drawDot(canvas, 46 + offX, 28 + offY, 1.5, eyeHighlight);
      _drawDot(canvas, 47 + offX, 29 + offY, 0.7, eyeHighlight);
      // Lower eyelid (aegyo sal) - smooth arc
      _drawArc(canvas, 49 + offX, 35 + offY, 5, 1.5, 0.2, math.pi - 0.4, eyeLower, width: 1.0);
      // Upper eyelid line - smooth arc
      _drawArc(canvas, 49 + offX, 27 + offY, 7, 2, math.pi + 0.3, -math.pi - 0.6, eyeIrisDark, width: 1.0);
      // Eyelashes - smooth dots
      _drawDot(canvas, 42 + offX, 26 + offY, 0.8, eyeIrisDark);
      _drawDot(canvas, 56 + offX, 26 + offY, 0.8, eyeIrisDark);

      // Right eye
      _drawEllipse(canvas, 79 + offX, 31 + offY, 7, 5, eyeWhite);
      _drawEllipse(canvas, 79 + offX, 32 + offY, 5, 4, eyeIris);
      _drawEllipse(canvas, 79 + offX, 32 + offY, 3, 2, eyeIrisDark);
      _drawDot(canvas, 79 + offX, 32 + offY, 1.2, eyePupil);
      // Highlight
      _drawDot(canvas, 76 + offX, 28 + offY, 1.5, eyeHighlight);
      _drawDot(canvas, 77 + offX, 29 + offY, 0.7, eyeHighlight);
      // Lower eyelid (aegyo sal)
      _drawArc(canvas, 79 + offX, 35 + offY, 5, 1.5, 0.2, math.pi - 0.4, eyeLower, width: 1.0);
      // Upper eyelid line
      _drawArc(canvas, 79 + offX, 27 + offY, 7, 2, math.pi + 0.3, -math.pi - 0.6, eyeIrisDark, width: 1.0);
      // Eyelashes
      _drawDot(canvas, 72 + offX, 26 + offY, 0.8, eyeIrisDark);
      _drawDot(canvas, 86 + offX, 26 + offY, 0.8, eyeIrisDark);
    } else if (closedEyes) {
      // Peaceful closed eyes - smooth arcs
      _drawArc(canvas, 49 + offX, 33 + offY, 5, 2, math.pi + 0.3, -math.pi - 0.6, eyeIris, width: 1.2);
      _drawArc(canvas, 79 + offX, 33 + offY, 5, 2, math.pi + 0.3, -math.pi - 0.6, eyeIris, width: 1.2);
    } else {
      // Normal big round purple eyes - use smooth ellipses and circles
      // Left eye
      // Eye white - ellipse
      _drawEllipse(canvas, 50 + offX, 33 + offY, 6, 5, eyeWhite);
      // Iris - ellipse
      _drawEllipse(canvas, 50 + offX, 33 + offY, 4, 3.5, eyeIris);
      // Dark iris - ellipse
      _drawEllipse(canvas, 50 + offX, 33 + offY, 2.5, 2, eyeIrisDark);
      // Pupil - dot
      _drawDot(canvas, 50 + offX, 33 + offY, 1.2, eyePupil);
      // Highlight (top-left) - dots
      _drawDot(canvas, 47 + offX, 29.5 + offY, 1.3, eyeHighlight);
      _drawDot(canvas, 47.5 + offX, 30.5 + offY, 0.6, eyeHighlight);
      // Lower eyelid (aegyo sal) - smooth arc
      _drawArc(canvas, 50 + offX, 37 + offY, 4.5, 1.2, 0.15, math.pi - 0.3, eyeLower, width: 1.0);
      // Upper eyelid line - smooth arc
      _drawArc(canvas, 50 + offX, 28 + offY, 6.5, 2, math.pi + 0.2, -math.pi - 0.4, eyeIrisDark, width: 1.0);
      // Eyelashes - smooth dots
      _drawDot(canvas, 43.5 + offX, 27 + offY, 0.8, eyeIrisDark);
      _drawDot(canvas, 56 + offX, 27 + offY, 0.8, eyeIrisDark);
      _drawDot(canvas, 44.5 + offX, 26 + offY, 0.6, eyeIrisDark);

      // Right eye
      // Eye white - ellipse
      _drawEllipse(canvas, 78 + offX, 33 + offY, 6, 5, eyeWhite);
      // Iris - ellipse
      _drawEllipse(canvas, 78 + offX, 33 + offY, 4, 3.5, eyeIris);
      // Dark iris - ellipse
      _drawEllipse(canvas, 78 + offX, 33 + offY, 2.5, 2, eyeIrisDark);
      // Pupil - dot
      _drawDot(canvas, 78 + offX, 33 + offY, 1.2, eyePupil);
      // Highlight (top-left) - dots
      _drawDot(canvas, 75 + offX, 29.5 + offY, 1.3, eyeHighlight);
      _drawDot(canvas, 75.5 + offX, 30.5 + offY, 0.6, eyeHighlight);
      // Lower eyelid (aegyo sal) - smooth arc
      _drawArc(canvas, 78 + offX, 37 + offY, 4.5, 1.2, 0.15, math.pi - 0.3, eyeLower, width: 1.0);
      // Upper eyelid line - smooth arc
      _drawArc(canvas, 78 + offX, 28 + offY, 6.5, 2, math.pi + 0.2, -math.pi - 0.4, eyeIrisDark, width: 1.0);
      // Eyelashes - smooth dots
      _drawDot(canvas, 71.5 + offX, 27 + offY, 0.8, eyeIrisDark);
      _drawDot(canvas, 84 + offX, 27 + offY, 0.8, eyeIrisDark);
      _drawDot(canvas, 83.5 + offX, 26 + offY, 0.6, eyeIrisDark);
    }

    // Nose - smooth small dot
    _drawDot(canvas, 64 + offX, 39 + offY, 0.8, skinShadow);

    // Blush - smooth semi-transparent ellipses
    _drawEllipse(canvas, 46 + offX, 37.5 + offY, 4, 2.5, blush.withValues(alpha: 0.3));
    _drawEllipse(canvas, 82 + offX, 37.5 + offY, 4, 2.5, blush.withValues(alpha: 0.3));

    // Mouth
    if (openMouth) {
      // O-shaped open mouth - smooth ellipse
      _drawEllipse(canvas, 62 + offX, 44 + offY, 4, 5, mouth);
      _drawEllipse(canvas, 62 + offX, 44 + offY, 2.5, 3, skinDark);
    } else if (wavyMouth) {
      // Wavy confused mouth - smooth arcs
      _drawArc(canvas, 58 + offX, 43 + offY, 2, 1, math.pi + 0.3, -math.pi - 0.6, mouth, width: 1.0);
      _drawArc(canvas, 64 + offX, 45 + offY, 2, 1, 0.3, math.pi - 0.6, mouth, width: 1.0);
      _drawArc(canvas, 70 + offX, 43 + offY, 2, 1, math.pi + 0.3, -math.pi - 0.6, mouth, width: 1.0);
    } else if (bigSmile) {
      // Big arc smile - smooth arc
      _drawArc(canvas, 62 + offX, 40 + offY, 10, 5, 0.3, math.pi - 0.6, mouth, width: 1.2);
      // Inner mouth shadow
      _drawArc(canvas, 62 + offX, 41 + offY, 6, 3, 0.4, math.pi - 0.8, skinDark, width: 0.8);
    } else {
      // Omega-shaped smile - smooth arcs for the omega shape
      // Left curve of omega
      _drawArc(canvas, 58 + offX, 42 + offY, 2.5, 2, math.pi + 0.2, -math.pi - 0.4, mouth, width: 1.0);
      // Right curve of omega
      _drawArc(canvas, 66 + offX, 42 + offY, 2.5, 2, math.pi + 0.2, -math.pi - 0.4, mouth, width: 1.0);
      // Bottom connecting arc
      _drawArc(canvas, 62 + offX, 44 + offY, 3, 1.5, 0.2, math.pi - 0.4, mouth, width: 1.0);
    }
  }

  // ============================================================
  // Helper: Draw body with dark coat, ribbon, gold embroidery, white inner collar
  // ============================================================
  void _drawBody(Canvas canvas, double offX, double offY) {
    // Coat body - main
    _drawPixelRect(canvas, 38 + offX, 50 + offY, 52, 30, clothBase);
    // Coat highlight (center chest)
    _drawPixelRect(canvas, 50 + offX, 50 + offY, 16, 6, clothLight);
    _drawPixelRect(canvas, 54 + offX, 56 + offY, 8, 4, clothLight);
    // Coat accent layer
    _drawPixelRect(canvas, 46 + offX, 54 + offY, 4, 10, clothAccent);
    _drawPixelRect(canvas, 78 + offX, 54 + offY, 4, 10, clothAccent);
    // Coat shadow (sides)
    _drawPixelRect(canvas, 38 + offX, 50 + offY, 6, 26, clothDark);
    _drawPixelRect(canvas, 84 + offX, 50 + offY, 6, 26, clothDark);
    // Coat bottom shadow
    _drawPixelRect(canvas, 42 + offX, 76 + offY, 44, 4, clothDark);

    // Blend pixels at body contour edges
    _drawBlendPixel(canvas, 37 + offX, 55 + offY, clothDark, alpha: 0.2);
    _drawBlendPixel(canvas, 37 + offX, 65 + offY, clothDark, alpha: 0.15);
    _drawBlendPixel(canvas, 90 + offX, 55 + offY, clothDark, alpha: 0.2);
    _drawBlendPixel(canvas, 90 + offX, 65 + offY, clothDark, alpha: 0.15);
    _drawBlendPixel(canvas, 50 + offX, 79 + offY, clothDark, alpha: 0.2);
    _drawBlendPixel(canvas, 70 + offX, 79 + offY, clothDark, alpha: 0.2);

    // Collar / neckline with white inner collar
    _drawPixelRect(canvas, 46 + offX, 48 + offY, 36, 4, clothLight);
    _drawPixelRect(canvas, 50 + offX, 48 + offY, 28, 2, skinBase);
    // White inner collar peek
    _drawPixelRect(canvas, 52 + offX, 49 + offY, 24, 2, skinLight);

    // Ribbon at collar - use ellipse + dot for smooth bow
    _drawEllipse(canvas, 62 + offX, 50 + offY, 4, 2.5, ribbon);
    _drawEllipse(canvas, 57 + offX, 51 + offY, 2, 1.5, ribbon);
    _drawEllipse(canvas, 67 + offX, 51 + offY, 2, 1.5, ribbon);
    _drawDot(canvas, 62 + offX, 51 + offY, 1.2, goldAccent);
    // Ribbon tails - smooth lines
    _drawLine(canvas, 59 + offX, 52 + offY, 58 + offX, 57 + offY, ribbon, width: 1.2);
    _drawLine(canvas, 65 + offX, 52 + offY, 66 + offX, 57 + offY, ribbon, width: 1.2);

    // Gold embroidery lines - smooth lines
    _drawLine(canvas, 45 + offX, 54 + offY, 45 + offX, 66 + offY, goldAccent, width: 0.8);
    _drawLine(canvas, 83 + offX, 54 + offY, 83 + offX, 66 + offY, goldAccent, width: 0.8);
    _drawLine(canvas, 48 + offX, 65 + offY, 80 + offX, 65 + offY, goldAccent, width: 0.8);
    // Additional gold detail
    _drawLine(canvas, 50 + offX, 68.5 + offY, 78 + offX, 68.5 + offY, goldLight, width: 0.6);

    // Arms
    _drawPixelRect(canvas, 32 + offX, 54 + offY, 6, 20, clothBase);
    _drawPixelRect(canvas, 32 + offX, 54 + offY, 2, 8, clothLight);
    _drawPixelRect(canvas, 90 + offX, 54 + offY, 6, 20, clothBase);
    _drawPixelRect(canvas, 94 + offX, 54 + offY, 2, 8, clothLight);
    // Hands (skin with shading)
    _drawPixelRect(canvas, 32 + offX, 74 + offY, 6, 4, skinBase);
    _drawPixelRect(canvas, 32 + offX, 74 + offY, 2, 2, skinLight);
    _drawPixelRect(canvas, 32 + offX, 76 + offY, 2, 2, skinShadow);
    _drawPixelRect(canvas, 90 + offX, 74 + offY, 6, 4, skinBase);
    _drawPixelRect(canvas, 94 + offX, 74 + offY, 2, 2, skinLight);
    _drawPixelRect(canvas, 94 + offX, 76 + offY, 2, 2, skinShadow);

    // Blend at arm edges
    _drawBlendPixel(canvas, 31 + offX, 60 + offY, clothDark, alpha: 0.2);
    _drawBlendPixel(canvas, 97 + offX, 60 + offY, clothDark, alpha: 0.2);

    // Gold armbands - smooth lines
    _drawLine(canvas, 32 + offX, 55 + offY, 38 + offX, 55 + offY, goldAccent, width: 1.0);
    _drawLine(canvas, 90 + offX, 55 + offY, 96 + offX, 55 + offY, goldAccent, width: 1.0);
  }

  // ============================================================
  // Helper: Draw legs and shoes
  // ============================================================
  void _drawLegs(Canvas canvas, double offX, double offY) {
    // Legs
    _drawPixelRect(canvas, 46 + offX, 80 + offY, 8, 14, skinBase);
    _drawPixelRect(canvas, 74 + offX, 80 + offY, 8, 14, skinBase);
    // Leg highlight
    _drawPixelRect(canvas, 46 + offX, 80 + offY, 2, 6, skinLight);
    _drawPixelRect(canvas, 74 + offX, 80 + offY, 2, 6, skinLight);
    // Leg shadow
    _drawPixelRect(canvas, 46 + offX, 90 + offY, 8, 4, skinShadow);
    _drawPixelRect(canvas, 74 + offX, 90 + offY, 8, 4, skinShadow);
    // Shoes
    _drawPixelRect(canvas, 44 + offX, 94 + offY, 12, 6, clothDark);
    _drawPixelRect(canvas, 72 + offX, 94 + offY, 12, 6, clothDark);
    // Shoe highlight
    _drawPixelRect(canvas, 46 + offX, 94 + offY, 8, 2, clothBase);
    _drawPixelRect(canvas, 74 + offX, 94 + offY, 8, 2, clothBase);
    // Shoe top detail
    _drawPixelRect(canvas, 44 + offX, 94 + offY, 12, 2, clothBase);
    _drawPixelRect(canvas, 72 + offX, 94 + offY, 12, 2, clothBase);
    // Gold buckles - smooth dots
    _drawDot(canvas, 50 + offX, 95 + offY, 1.5, goldAccent);
    _drawDot(canvas, 78 + offX, 95 + offY, 1.5, goldAccent);
    // Shoe sole
    _drawPixelRect(canvas, 44 + offX, 98 + offY, 12, 2, hairDark);
    _drawPixelRect(canvas, 72 + offX, 98 + offY, 12, 2, hairDark);

    // Blend at leg-shoe transition
    _drawBlendPixel(canvas, 46 + offX, 93 + offY, skinShadow, alpha: 0.2);
    _drawBlendPixel(canvas, 74 + offX, 93 + offY, skinShadow, alpha: 0.2);
  }

  // ============================================================
  // Helper: Draw tail
  // ============================================================
  void _drawTail(Canvas canvas, double offX, double offY, {double wagX = 0}) {
    _drawPixelRect(canvas, 10 + offX + wagX, 62 + offY, 6, 2, hairBase);
    _drawPixelRect(canvas, 8 + offX + wagX, 60 + offY, 4, 2, hairBase);
    _drawPixelRect(canvas, 6 + offX + wagX, 58 + offY, 4, 2, hairBase);
    _drawPixelRect(canvas, 6 + offX + wagX, 56 + offY, 4, 2, hairLight);
    // Tail tip
    _drawPixelRect(canvas, 4 + offX + wagX, 54 + offY, 4, 2, hairLight);
    // Tail highlight - smooth line
    _drawLine(canvas, 9 + offX + wagX, 58 + offY, 9 + offX + wagX, 60 + offY, hairLight, width: 0.8);

    // Blend at tail base
    _drawBlendPixel(canvas, 10 + offX + wagX, 61 + offY, hairShadow, alpha: 0.25);
  }

  // ============================================================
  // IDLE: Standing with breathing animation
  // ============================================================
  void _drawIdle(Canvas canvas) {
    // Breathing: frame 0,2 body down 1; frame 1,3 body up 1
    final breathOffset = (frame == 1 || frame == 3) ? -1.0 : 1.0;
    final blink = frame == 2;

    // Tail
    _drawTail(canvas, 0, breathOffset);

    // Legs
    _drawLegs(canvas, 0, breathOffset);

    // Body
    _drawBody(canvas, 0, breathOffset);

    // Head / Face
    _drawFace(canvas, 0, breathOffset, blink: blink);

    // Hair
    _drawHair(canvas, 0, breathOffset);

    // Cat ears
    _drawEars(canvas, 0, breathOffset);
  }

  // ============================================================
  // HAPPY: Star eyes, big smile, bouncing
  // ============================================================
  void _drawHappy(Canvas canvas) {
    final bounce = [0.0, -4.0, 0.0, -2.0][frame];

    // Tail (wagging)
    final tailWag = [0.0, 3.0, 0.0, -3.0][frame];
    _drawTail(canvas, 0, bounce, wagX: tailWag);

    // Legs
    _drawLegs(canvas, 0, bounce);

    // Body
    _drawBody(canvas, 0, bounce);

    // Arms UP (happy pose)
    _drawPixelRect(canvas, 32, 34 + bounce, 6, 16, clothBase);
    _drawPixelRect(canvas, 32, 34 + bounce, 2, 6, clothLight);
    _drawPixelRect(canvas, 28, 30 + bounce, 6, 4, clothBase);
    _drawPixelRect(canvas, 28, 28 + bounce, 6, 4, clothBase);
    _drawPixelRect(canvas, 90, 34 + bounce, 6, 16, clothBase);
    _drawPixelRect(canvas, 94, 34 + bounce, 2, 6, clothLight);
    _drawPixelRect(canvas, 94, 30 + bounce, 6, 4, clothBase);
    _drawPixelRect(canvas, 94, 28 + bounce, 6, 4, clothBase);
    // Hands
    _drawPixelRect(canvas, 28, 26 + bounce, 6, 4, skinBase);
    _drawPixelRect(canvas, 28, 26 + bounce, 2, 2, skinLight);
    _drawPixelRect(canvas, 94, 26 + bounce, 6, 4, skinBase);
    _drawPixelRect(canvas, 98, 26 + bounce, 2, 2, skinLight);
    // Gold armbands - smooth lines
    _drawLine(canvas, 32, 35 + bounce, 38, 35 + bounce, goldAccent, width: 1.0);
    _drawLine(canvas, 90, 35 + bounce, 96, 35 + bounce, goldAccent, width: 1.0);

    // Head / Face with star eyes and big smile
    _drawFace(canvas, 0, bounce, starEyes: true, bigSmile: true);

    // Hair
    _drawHair(canvas, 0, bounce);

    // Cat ears
    _drawEars(canvas, 0, bounce);

    // Sparkles - smooth dots
    if (frame % 2 == 0) {
      _drawDot(canvas, 21, 17 + bounce, 1.2, goldLight);
      _drawDot(canvas, 105, 21 + bounce, 1.2, goldLight);
      _drawDot(canvas, 15, 37 + bounce, 1.0, goldAccent);
      _drawDot(canvas, 109, 33 + bounce, 1.0, goldAccent);
    }
  }

  // ============================================================
  // CONFUSED: One ear droopy, wavy mouth, head tilt
  // ============================================================
  void _drawConfused(Canvas canvas) {
    final tilt = frame == 1 ? 2.0 : 0.0;

    // Tail (droopy)
    _drawPixelRect(canvas, 10, 68, 6, 2, hairBase);
    _drawPixelRect(canvas, 8, 70, 4, 2, hairDark);
    _drawPixelRect(canvas, 6, 72, 4, 2, hairShadow);

    // Legs
    _drawLegs(canvas, 0, 0);

    // Body
    _drawBody(canvas, 0, 0);

    // Arms - one scratching head
    _drawPixelRect(canvas, 32, 54, 6, 20, clothBase);
    _drawPixelRect(canvas, 32, 54, 2, 8, clothLight);
    _drawPixelRect(canvas, 32, 74, 6, 4, skinBase);
    _drawLine(canvas, 32, 55, 38, 55, goldAccent, width: 1.0);
    _drawPixelRect(canvas, 90, 30, 6, 16, clothBase);
    _drawPixelRect(canvas, 94, 30, 2, 6, clothLight);
    _drawPixelRect(canvas, 90, 46, 6, 4, skinBase);
    _drawLine(canvas, 90, 31, 96, 31, goldAccent, width: 1.0);

    // Head / Face with wavy mouth
    _drawFace(canvas, tilt, 0, wavyMouth: true);

    // Hair
    _drawHair(canvas, tilt, 0);

    // Cat ears - right ear droopy
    _drawEars(canvas, tilt, 0, rightDroopy: true);

    // Question mark - smooth line + dot
    _drawLine(canvas, 99, 10, 101, 10, goldAccent, width: 1.2);
    _drawLine(canvas, 101, 10, 101, 16, goldAccent, width: 1.2);
    _drawLine(canvas, 101, 16, 99, 18, goldAccent, width: 1.2);
    _drawDot(canvas, 99.5, 20.5, 0.8, goldAccent);
  }

  // ============================================================
  // PUSHED AWAY: Body leaning back, arms pushing forward, sweat
  // ============================================================
  void _drawPushedAway(Canvas canvas) {
    final slideX = frame * 3.0;

    // Tail
    _drawTail(canvas, -slideX, 0);

    // Legs (running pose - spread)
    _drawPixelRect(canvas, 42 - slideX, 80, 8, 14, skinBase);
    _drawPixelRect(canvas, 42 - slideX, 90, 8, 4, skinShadow);
    _drawPixelRect(canvas, 78 - slideX, 80, 8, 14, skinBase);
    _drawPixelRect(canvas, 78 - slideX, 90, 8, 4, skinShadow);
    _drawPixelRect(canvas, 40 - slideX, 94, 12, 6, clothDark);
    _drawPixelRect(canvas, 76 - slideX, 94, 12, 6, clothDark);
    _drawPixelRect(canvas, 42 - slideX, 94, 8, 2, clothBase);
    _drawPixelRect(canvas, 78 - slideX, 94, 8, 2, clothBase);

    // Body (leaning back)
    _drawBody(canvas, -slideX, 0);

    // Arms pushing forward
    _drawPixelRect(canvas, 90 - slideX, 50, 12, 4, skinBase);
    _drawPixelRect(canvas, 90 - slideX, 50, 4, 2, skinLight);
    _drawPixelRect(canvas, 100 - slideX, 48, 4, 8, skinBase);
    _drawPixelRect(canvas, 100 - slideX, 48, 2, 2, skinLight);
    _drawPixelRect(canvas, 32 - slideX, 54, 6, 20, clothBase);
    _drawPixelRect(canvas, 32 - slideX, 74, 6, 4, skinBase);

    // Head / Face
    _drawFace(canvas, -slideX, 0, openMouth: true);

    // Hair
    _drawHair(canvas, -slideX, 0);

    // Cat ears (alert)
    _drawEars(canvas, -slideX, 0);

    // Sweat drop - smooth ellipse
    _drawEllipse(canvas, 96 - slideX, 24, 2, 3, Color(0xFF66CCFF));
    _drawDot(canvas, 95 - slideX, 21, 1, Color(0xFF88DDFF));
    _drawDot(canvas, 97 - slideX, 19, 0.7, Color(0xFFAAEEFF));

    // Motion lines - smooth lines
    for (int i = 0; i < 3; i++) {
      _drawLine(canvas, 107 + i * 4 - slideX, 36 + i * 8, 107 + i * 4 - slideX, 42 + i * 8, Color(0xFFFFFFFF).withValues(alpha: 0.5), width: 0.8);
    }
  }

  // ============================================================
  // SLEEPING: Eyes closed, body lying down, Zzz
  // ============================================================
  void _drawSleeping(Canvas canvas) {
    final breathe = frame == 0 ? 0.0 : 1.0;

    // Tail curled
    _drawPixelRect(canvas, 6, 66, 8, 2, hairBase);
    _drawPixelRect(canvas, 4, 64, 4, 2, hairBase);
    _drawPixelRect(canvas, 4, 62, 4, 2, hairLight);
    _drawPixelRect(canvas, 2, 60, 4, 2, hairLight);

    // Body (lying down, wider)
    _drawPixelRect(canvas, 16, 66 + breathe, 68, 12, clothBase);
    _drawPixelRect(canvas, 20, 64 + breathe, 60, 4, clothLight);
    _drawPixelRect(canvas, 24, 66 + breathe, 52, 2, goldAccent);
    _drawPixelRect(canvas, 28, 70 + breathe, 44, 1, goldLight);
    // Body shadow
    _drawPixelRect(canvas, 16, 74 + breathe, 68, 4, clothDark);

    // Blend at body edges
    _drawBlendPixel(canvas, 15, 68 + breathe, clothDark, alpha: 0.2);
    _drawBlendPixel(canvas, 84, 68 + breathe, clothDark, alpha: 0.2);

    // Head (resting on side)
    _drawPixelRect(canvas, 8, 54 + breathe, 24, 16, skinBase);
    _drawPixelRect(canvas, 12, 54 + breathe, 12, 4, skinLight);
    _drawPixelRect(canvas, 8, 66 + breathe, 24, 4, skinShadow);

    // Hair (flowing while lying down)
    _drawPixelRect(canvas, 4, 50 + breathe, 32, 8, hairBase);
    _drawPixelRect(canvas, 8, 50 + breathe, 16, 2, hairLight);
    _drawPixelRect(canvas, 4, 58 + breathe, 4, 12, hairBase);
    _drawPixelRect(canvas, 4, 58 + breathe, 2, 6, hairLight);
    _drawPixelRect(canvas, 4, 66 + breathe, 4, 4, hairDark);
    _drawPixelRect(canvas, 4, 70 + breathe, 2, 2, hairShadow);

    // Cat ear (one visible)
    _drawPixelRect(canvas, 8, 46 + breathe, 6, 4, hairBase);
    _drawEllipse(canvas, 11 + 0, 47 + breathe, 1.5, 1, earInner);
    _drawEllipse(canvas, 11 + 0, 49 + breathe, 1, 0.8, earFur);

    // Closed eyes (peaceful arcs) - smooth arcs
    _drawArc(canvas, 18 + 0, 61 + breathe, 4, 1.5, math.pi + 0.3, -math.pi - 0.6, eyeIris, width: 1.2);

    // Peaceful mouth - smooth arc
    _drawArc(canvas, 19 + 0, 65 + breathe, 3, 1, 0.3, math.pi - 0.6, mouth, width: 0.8);

    // Blush - smooth semi-transparent ellipses
    _drawEllipse(canvas, 15 + 0, 63 + breathe, 3, 1.2, blush.withValues(alpha: 0.25));
    _drawEllipse(canvas, 27 + 0, 63 + breathe, 3, 1.2, blush.withValues(alpha: 0.25));

    // Feet
    _drawPixelRect(canvas, 82, 68 + breathe, 8, 6, skinBase);
    _drawPixelRect(canvas, 82, 72 + breathe, 8, 2, skinShadow);

    // Zzz (floating) - smooth dots
    _drawDot(canvas, 38, 48 + breathe, 1.5, goldLight);
    _drawDot(canvas, 44, 42 + breathe, 1.8, goldLight);
    _drawDot(canvas, 51, 36 + breathe, 2.2, goldLight);
    _drawDot(canvas, 59, 30 + breathe, 2.5, goldLight);
  }

  // ============================================================
  // SQUISHED: Body horizontally compressed, X_X eyes
  // ============================================================
  void _drawSquished(Canvas canvas) {
    // Body (wider +8, shorter -4)
    _drawPixelRect(canvas, 24, 66 + frame * 0.5, 80, 20, clothBase);
    _drawPixelRect(canvas, 32, 66 + frame * 0.5, 64, 6, clothLight);
    _drawPixelRect(canvas, 24, 66 + frame * 0.5, 8, 16, clothDark);
    _drawPixelRect(canvas, 96, 66 + frame * 0.5, 8, 16, clothDark);
    _drawPixelRect(canvas, 28, 82 + frame * 0.5, 72, 4, clothDark);
    // Gold belt
    _drawPixelRect(canvas, 32, 72 + frame * 0.5, 64, 2, goldAccent);
    _drawPixelRect(canvas, 36, 74 + frame * 0.5, 56, 1, goldLight);

    // Blend at body edges
    _drawBlendPixel(canvas, 23, 72 + frame * 0.5, clothDark, alpha: 0.2);
    _drawBlendPixel(canvas, 104, 72 + frame * 0.5, clothDark, alpha: 0.2);

    // Arms (spread out)
    _drawPixelRect(canvas, 12, 72, 12, 4, clothBase);
    _drawPixelRect(canvas, 12, 72, 4, 4, skinBase);
    _drawPixelRect(canvas, 12, 72, 2, 2, skinLight);
    _drawPixelRect(canvas, 104, 72, 12, 4, clothBase);
    _drawPixelRect(canvas, 112, 72, 4, 4, skinBase);
    _drawPixelRect(canvas, 114, 72, 2, 2, skinLight);

    // Head (wider)
    _drawPixelRect(canvas, 28, 42, 72, 24, skinBase);
    _drawPixelRect(canvas, 36, 42, 40, 6, skinLight);
    _drawPixelRect(canvas, 28, 42, 8, 16, skinShadow);
    _drawPixelRect(canvas, 92, 42, 8, 16, skinShadow);
    _drawPixelRect(canvas, 36, 62, 56, 4, skinShadow);
    _drawPixelRect(canvas, 40, 64, 48, 2, skinDark);

    // Blend at face edges
    _drawBlendPixel(canvas, 27, 50, skinShadow, alpha: 0.2);
    _drawBlendPixel(canvas, 100, 50, skinShadow, alpha: 0.2);

    // Hair (spread out)
    _drawPixelRect(canvas, 24, 34, 80, 12, hairBase);
    _drawPixelRect(canvas, 32, 34, 28, 4, hairLight);
    _drawPixelRect(canvas, 64, 36, 16, 2, hairMid);
    _drawPixelRect(canvas, 24, 42, 4, 16, hairBase);
    _drawPixelRect(canvas, 100, 42, 4, 16, hairBase);
    _drawPixelRect(canvas, 24, 42, 80, 2, hairDark);
    // Hair highlight lines - smooth lines
    _drawLine(canvas, 37, 36, 37, 40, hairLight, width: 0.8);
    _drawLine(canvas, 69, 38, 69, 42, hairLight, width: 0.8);

    // Cat ears (flattened)
    _drawPixelRect(canvas, 20, 30, 12, 6, hairBase);
    _drawEllipse(canvas, 27, 32, 3, 2, earInner);
    _drawEllipse(canvas, 27, 33, 2, 1, earFur);
    _drawPixelRect(canvas, 96, 30, 12, 6, hairBase);
    _drawEllipse(canvas, 103, 32, 3, 2, earInner);
    _drawEllipse(canvas, 103, 33, 2, 1, earFur);

    // X_X eyes - smooth lines
    _drawLine(canvas, 43, 51, 49, 51, eyeIris, width: 1.2);
    _drawLine(canvas, 49, 51, 45, 53, eyeIris, width: 1.2);
    _drawLine(canvas, 45, 53, 39, 53, eyeIris, width: 1.2);
    _drawLine(canvas, 39, 53, 43, 51, eyeIris, width: 1.2);
    _drawLine(canvas, 83, 51, 89, 51, eyeIris, width: 1.2);
    _drawLine(canvas, 89, 51, 85, 53, eyeIris, width: 1.2);
    _drawLine(canvas, 85, 53, 79, 53, eyeIris, width: 1.2);
    _drawLine(canvas, 79, 53, 83, 51, eyeIris, width: 1.2);

    // Wavy mouth - smooth arcs
    _drawArc(canvas, 57, 57, 3, 1, math.pi + 0.3, -math.pi - 0.6, mouth, width: 1.0);
    _drawArc(canvas, 69, 57, 3, 1, math.pi + 0.3, -math.pi - 0.6, mouth, width: 1.0);

    // Blush - smooth semi-transparent ellipses
    _drawEllipse(canvas, 42, 56, 4, 2.5, blush.withValues(alpha: 0.3));
    _drawEllipse(canvas, 88, 56, 4, 2.5, blush.withValues(alpha: 0.3));

    // Legs (spread)
    _drawPixelRect(canvas, 32, 86, 8, 6, skinBase);
    _drawPixelRect(canvas, 88, 86, 8, 6, skinBase);
    _drawPixelRect(canvas, 32, 90, 8, 2, skinShadow);
    _drawPixelRect(canvas, 88, 90, 8, 2, skinShadow);
  }

  // ============================================================
  // SHOCKED: Bigger eyes, O mouth, body shaking
  // ============================================================
  void _drawShocked(Canvas canvas) {
    final shake = [0.0, -1.0, 1.0, 0.0][frame];

    // Tail
    _drawTail(canvas, shake, 0);

    // Legs
    _drawLegs(canvas, shake, 0);

    // Body
    _drawBody(canvas, shake, 0);

    // Arms (up in shock)
    _drawPixelRect(canvas, 26 + shake, 38, 6, 12, clothBase);
    _drawPixelRect(canvas, 24 + shake, 34, 4, 4, clothBase);
    _drawPixelRect(canvas, 24 + shake, 32, 4, 4, skinBase);
    _drawPixelRect(canvas, 24 + shake, 32, 2, 2, skinLight);
    _drawPixelRect(canvas, 96 + shake, 38, 6, 12, clothBase);
    _drawPixelRect(canvas, 100 + shake, 34, 4, 4, clothBase);
    _drawPixelRect(canvas, 100 + shake, 32, 4, 4, skinBase);
    _drawPixelRect(canvas, 102 + shake, 32, 2, 2, skinLight);
    _drawLine(canvas, 26 + shake, 39, 32 + shake, 39, goldAccent, width: 1.0);
    _drawLine(canvas, 96 + shake, 39, 102 + shake, 39, goldAccent, width: 1.0);

    // Head / Face with big eyes and O mouth
    _drawFace(canvas, shake, 0, bigEyes: true, openMouth: true);

    // Hair
    _drawHair(canvas, shake, 0);

    // Cat ears (straight up, alert)
    _drawEars(canvas, shake, 0);

    // Sweat drops - smooth ellipses
    _drawEllipse(canvas, 96 + shake, 23, 2, 3, Color(0xFF66CCFF));
    _drawDot(canvas, 95 + shake, 19, 1, Color(0xFF88DDFF));
    _drawDot(canvas, 97 + shake, 17, 0.7, Color(0xFFAAEEFF));
    _drawEllipse(canvas, 39 + shake, 22, 1.5, 2, Color(0xFF66CCFF));
    _drawDot(canvas, 39 + shake, 19, 0.8, Color(0xFF88DDFF));

    // Exclamation marks - smooth lines + dots
    _drawLine(canvas, 103, 8, 103, 16, goldAccent, width: 1.2);
    _drawDot(canvas, 103, 17, 0.8, goldAccent);
    _drawLine(canvas, 109, 10, 109, 18, goldAccent, width: 1.2);
    _drawDot(canvas, 109, 19, 0.8, goldAccent);
  }

  // ============================================================
  // CELEBRATING: Hands up, star eyes, jumping
  // ============================================================
  void _drawCelebrating(Canvas canvas) {
    final jumpHeight = [0.0, -6.0, -8.0, -6.0, 0.0, -4.0][frame];
    final spin = frame < 3;

    // Tail (wagging)
    final tailWag = [0.0, 4.0, 0.0, -4.0, 0.0, 2.0][frame];
    _drawTail(canvas, 0, jumpHeight, wagX: tailWag);

    // Legs (slightly apart when jumping)
    _drawPixelRect(canvas, 42, 80 + jumpHeight, 8, 14, skinBase);
    _drawPixelRect(canvas, 42, 90 + jumpHeight, 8, 4, skinShadow);
    _drawPixelRect(canvas, 78, 80 + jumpHeight, 8, 14, skinBase);
    _drawPixelRect(canvas, 78, 90 + jumpHeight, 8, 4, skinShadow);
    _drawPixelRect(canvas, 40, 94 + jumpHeight, 12, 6, clothDark);
    _drawPixelRect(canvas, 76, 94 + jumpHeight, 12, 6, clothDark);
    _drawPixelRect(canvas, 42, 94 + jumpHeight, 8, 2, clothBase);
    _drawPixelRect(canvas, 78, 94 + jumpHeight, 8, 2, clothBase);

    // Body
    _drawBody(canvas, 0, jumpHeight);

    // Arms (alternating up)
    if (spin) {
      // Left arm up, right arm out
      _drawPixelRect(canvas, 26, 30 + jumpHeight, 6, 20, clothBase);
      _drawPixelRect(canvas, 26, 30 + jumpHeight, 2, 6, clothLight);
      _drawPixelRect(canvas, 22, 26 + jumpHeight, 6, 6, clothBase);
      _drawPixelRect(canvas, 22, 22 + jumpHeight, 6, 6, clothBase);
      _drawPixelRect(canvas, 22, 20 + jumpHeight, 6, 4, skinBase);
      _drawPixelRect(canvas, 22, 20 + jumpHeight, 2, 2, skinLight);
      _drawLine(canvas, 26, 31 + jumpHeight, 32, 31 + jumpHeight, goldAccent, width: 1.0);
      _drawPixelRect(canvas, 96, 54 + jumpHeight, 6, 16, clothBase);
      _drawPixelRect(canvas, 96, 70 + jumpHeight, 6, 4, skinBase);
      _drawLine(canvas, 96, 55 + jumpHeight, 102, 55 + jumpHeight, goldAccent, width: 1.0);
    } else {
      // Right arm up, left arm out
      _drawPixelRect(canvas, 96, 30 + jumpHeight, 6, 20, clothBase);
      _drawPixelRect(canvas, 100, 30 + jumpHeight, 2, 6, clothLight);
      _drawPixelRect(canvas, 100, 26 + jumpHeight, 6, 6, clothBase);
      _drawPixelRect(canvas, 100, 22 + jumpHeight, 6, 6, clothBase);
      _drawPixelRect(canvas, 100, 20 + jumpHeight, 6, 4, skinBase);
      _drawPixelRect(canvas, 104, 20 + jumpHeight, 2, 2, skinLight);
      _drawLine(canvas, 96, 31 + jumpHeight, 102, 31 + jumpHeight, goldAccent, width: 1.0);
      _drawPixelRect(canvas, 26, 54 + jumpHeight, 6, 16, clothBase);
      _drawPixelRect(canvas, 26, 70 + jumpHeight, 6, 4, skinBase);
      _drawLine(canvas, 26, 55 + jumpHeight, 32, 55 + jumpHeight, goldAccent, width: 1.0);
    }

    // Head / Face with star eyes and big smile
    _drawFace(canvas, 0, jumpHeight, starEyes: true, bigSmile: true);

    // Hair
    _drawHair(canvas, 0, jumpHeight);

    // Cat ears
    _drawEars(canvas, 0, jumpHeight);

    // Sparkles around - smooth dots
    if (frame % 2 == 0) {
      _drawDot(canvas, 14, 14 + jumpHeight, 1.5, goldLight);
      _drawDot(canvas, 114, 18 + jumpHeight, 1.5, goldLight);
      _drawDot(canvas, 9, 39 + jumpHeight, 1.0, goldAccent);
      _drawDot(canvas, 117, 33 + jumpHeight, 1.0, goldAccent);
    } else {
      _drawDot(canvas, 17, 25 + jumpHeight, 1.0, goldLight);
      _drawDot(canvas, 109, 11 + jumpHeight, 1.0, goldLight);
      _drawDot(canvas, 11, 51 + jumpHeight, 1.0, goldAccent);
      _drawDot(canvas, 115, 45 + jumpHeight, 1.0, goldAccent);
    }
  }

  @override
  bool shouldRepaint(covariant CatGirlPainter oldDelegate) {
    return oldDelegate.state != state || oldDelegate.frame != frame;
  }
}
