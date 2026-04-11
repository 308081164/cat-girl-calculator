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

  // Hair - golden/light brown, 5 layers + highlight
  static const hairLight = Color(0xFFF5D585);   // golden highlight
  static const hairBase = Color(0xFFD4A040);    // golden base
  static const hairMid = Color(0xFFC89838);     // mid tone
  static const hairDark = Color(0xFFB08030);    // dark golden shadow
  static const hairShadow = Color(0xFF8B6914);  // deepest shadow
  static const hairHighlight = Color(0xFFFFE8B0); // hair highlight gradient

  // Face - warm pink skin, 4 layers
  static const skinLight = Color(0xFFFFF5E5);   // highlight (cream white)
  static const skinBase = Color(0xFFF5D5C5);    // base (warm pink)
  static const skinShadow = Color(0xFFE5B5A5);  // shadow (reddish brown)
  static const skinDark = Color(0xFFD5A595);    // deep shadow

  // Eyes - purple big round eyes, 6 layers + outline
  static const eyeWhite = Color(0xFFE5F0FF);    // eye white (blue-white)
  static const eyeIris = Color(0xFFA5B5E5);     // iris (light purple)
  static const eyeIrisDark = Color(0xFF7585C5); // iris dark
  static const eyePupil = Color(0xFF454565);    // pupil (near-black purple)
  static const eyeHighlight = Color(0xFFFFFFFF); // highlight (pure white)
  static const eyeLower = Color(0xFFC5D0E5);    // lower eyelid (aegyo sal)
  static const eyeOutline = Color(0xFF3A3A55);  // eye outline

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

  // Sweat drop
  static const sweatLight = Color(0xFF88DDFF);
  static const sweatBase = Color(0xFF66CCFF);
  static const sweatTip = Color(0xFFAAEEFF);

  // ============================================================
  // Vector drawing helper methods
  // ============================================================

  /// Draw a smooth filled path
  void _drawFilledPath(Canvas canvas, Path path, Color color) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  /// Draw a gradient-filled path
  void _drawGradientPath(Canvas canvas, Path path, List<Color> colors,
      {Offset? from, Offset? to}) {
    final rect = path.getBounds();
    final paint = Paint()
      ..shader = LinearGradient(
        begin: from ?? Offset(rect.left, rect.top),
        end: to ?? Offset(rect.right, rect.bottom),
        colors: colors,
      )
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  /// Draw a radial-gradient ellipse (for eyes)
  void _drawRadialEllipse(Canvas canvas, Offset center, double rx, double ry,
      List<Color> colors) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: center,
        radius: rx,
        colors: colors,
      )
      ..isAntiAlias = true;
    canvas.drawOval(
        Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
        paint);
  }

  /// Draw a stroked path
  void _drawStrokePath(Canvas canvas, Path path, Color color,
      {double width = 1.0}) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  /// Draw a smooth ellipse
  void _drawEllipse(Canvas canvas, Offset center, double rx, double ry,
      Color color) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true;
    canvas.drawOval(
        Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
        paint);
  }

  /// Draw a circle dot
  void _drawDot(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true;
    canvas.drawCircle(center, radius, paint);
  }

  /// Draw an arc stroke
  void _drawArcStroke(Canvas canvas, Offset center, double rx, double ry,
      double startAngle, double sweepAngle, Color color,
      {double width = 1.0}) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
      startAngle, sweepAngle, false, paint,
    );
  }

  /// Draw a smooth line
  void _drawLine(Canvas canvas, Offset from, Offset to, Color color,
      {double width = 1.0}) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(from, to, paint);
  }

  /// Draw a five-pointed star path at center with given outer/inner radius
  Path _starPath(Offset center, double outerR, double innerR) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = -math.pi / 2 + i * 2 * math.pi / 5;
      final innerAngle = outerAngle + math.pi / 5;
      final ox = center.dx + math.cos(outerAngle) * outerR;
      final oy = center.dy + math.sin(outerAngle) * outerR;
      final ix = center.dx + math.cos(innerAngle) * innerR;
      final iy = center.dy + math.sin(innerAngle) * innerR;
      if (i == 0) {
        path.moveTo(ox, oy);
      } else {
        path.lineTo(ox, oy);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    return path;
  }

  // ============================================================
  // Shared drawing components
  // ============================================================

  /// Draw hair with bezier curves and gradient fills
  void _drawHair(Canvas canvas, double offX, double offY) {
    // Back hair - large arc path
    Path backHair = Path();
    backHair.moveTo(30 + offX, 20 + offY);
    backHair.quadraticBezierTo(20 + offX, 50 + offY, 25 + offX, 80 + offY);
    backHair.lineTo(103 + offX, 80 + offY);
    backHair.quadraticBezierTo(108 + offX, 50 + offY, 98 + offX, 20 + offY);
    backHair.close();
    _drawGradientPath(canvas, backHair, [hairLight, hairBase, hairDark],
        from: Offset(64 + offX, 15 + offY), to: Offset(64 + offX, 80 + offY));

    // Bangs - multiple curved strands
    for (int i = 0; i < 5; i++) {
      Path bang = Path();
      double startX = 35 + i * 12 + offX;
      bang.moveTo(startX, 18 + offY);
      bang.quadraticBezierTo(startX + 6, 35 + offY, startX + 2, 42 + offY);
      bang.quadraticBezierTo(startX - 2, 35 + offY, startX - 4, 18 + offY);
      bang.close();
      _drawFilledPath(canvas, bang, i % 2 == 0 ? hairBase : hairMid);
    }

    // Additional bang strands for fullness
    for (int i = 0; i < 4; i++) {
      Path bang = Path();
      double startX = 41 + i * 12 + offX;
      bang.moveTo(startX, 16 + offY);
      bang.quadraticBezierTo(startX + 5, 30 + offY, startX + 1, 38 + offY);
      bang.quadraticBezierTo(startX - 3, 30 + offY, startX - 3, 16 + offY);
      bang.close();
      _drawFilledPath(canvas, bang, i % 2 == 0 ? hairLight : hairBase);
    }

    // Side hair - left flowing curve
    Path leftSideHair = Path();
    leftSideHair.moveTo(30 + offX, 20 + offY);
    leftSideHair.quadraticBezierTo(24 + offX, 40 + offY, 26 + offX, 65 + offY);
    leftSideHair.quadraticBezierTo(27 + offX, 78 + offY, 30 + offX, 80 + offY);
    leftSideHair.lineTo(34 + offX, 80 + offY);
    leftSideHair.quadraticBezierTo(31 + offX, 60 + offY, 34 + offX, 20 + offY);
    leftSideHair.close();
    _drawGradientPath(canvas, leftSideHair, [hairBase, hairDark],
        from: Offset(30 + offX, 20 + offY), to: Offset(30 + offX, 80 + offY));

    // Side hair - right flowing curve
    Path rightSideHair = Path();
    rightSideHair.moveTo(98 + offX, 20 + offY);
    rightSideHair.quadraticBezierTo(104 + offX, 40 + offY, 102 + offX, 65 + offY);
    rightSideHair.quadraticBezierTo(101 + offX, 78 + offY, 98 + offX, 80 + offY);
    rightSideHair.lineTo(94 + offX, 80 + offY);
    rightSideHair.quadraticBezierTo(97 + offX, 60 + offY, 94 + offX, 20 + offY);
    rightSideHair.close();
    _drawGradientPath(canvas, rightSideHair, [hairBase, hairDark],
        from: Offset(98 + offX, 20 + offY), to: Offset(98 + offX, 80 + offY));

    // Highlight lines - semi-transparent strokes
    Paint highlightPaint = Paint()
      ..color = hairHighlight.withValues(alpha: 0.4)
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(45 + offX, 22 + offY), Offset(42 + offX, 38 + offY), highlightPaint);
    canvas.drawLine(Offset(75 + offX, 20 + offY), Offset(73 + offX, 36 + offY), highlightPaint);
    canvas.drawLine(Offset(60 + offX, 18 + offY), Offset(59 + offX, 32 + offY), highlightPaint);
  }

  /// Draw cat ears with bezier curves
  void _drawEars(Canvas canvas, double offX, double offY,
      {bool rightDroopy = false}) {
    // Left ear - triangular path with rounded curves
    Path leftEar = Path();
    leftEar.moveTo(40 + offX, 22 + offY);
    leftEar.quadraticBezierTo(35 + offX, 8 + offY, 42 + offX, 4 + offY);
    leftEar.quadraticBezierTo(48 + offX, 8 + offY, 52 + offX, 22 + offY);
    leftEar.close();
    _drawGradientPath(canvas, leftEar, [hairBase, hairDark],
        from: Offset(46 + offX, 4 + offY), to: Offset(46 + offX, 22 + offY));

    // Left ear inner - pink ellipse
    _drawEllipse(canvas, Offset(46 + offX, 14 + offY), 5, 6, earInner.withValues(alpha: 0.7));
    _drawEllipse(canvas, Offset(46 + offX, 15 + offY), 3, 4, earFur.withValues(alpha: 0.5));

    // Left ear outline
    _drawStrokePath(canvas, leftEar, hairShadow, width: 0.8);

    // Right ear
    if (rightDroopy) {
      // Droopy right ear - tilted to the side
      Path rightEar = Path();
      rightEar.moveTo(76 + offX, 22 + offY);
      rightEar.quadraticBezierTo(82 + offX, 18 + offY, 90 + offX, 20 + offY);
      rightEar.quadraticBezierTo(96 + offX, 22 + offY, 94 + offX, 28 + offY);
      rightEar.quadraticBezierTo(88 + offX, 26 + offY, 82 + offX, 24 + offY);
      rightEar.close();
      _drawGradientPath(canvas, rightEar, [hairBase, hairMid],
          from: Offset(85 + offX, 18 + offY), to: Offset(88 + offX, 28 + offY));

      // Droopy ear inner
      _drawEllipse(canvas, Offset(86 + offX, 23 + offY), 4, 3, earInner.withValues(alpha: 0.6));
      _drawStrokePath(canvas, rightEar, hairShadow, width: 0.8);
    } else {
      // Normal right ear
      Path rightEar = Path();
      rightEar.moveTo(88 + offX, 22 + offY);
      rightEar.quadraticBezierTo(92 + offX, 8 + offY, 86 + offX, 4 + offY);
      rightEar.quadraticBezierTo(80 + offX, 8 + offY, 76 + offX, 22 + offY);
      rightEar.close();
      _drawGradientPath(canvas, rightEar, [hairBase, hairDark],
          from: Offset(82 + offX, 4 + offY), to: Offset(82 + offX, 22 + offY));

      // Right ear inner - pink ellipse
      _drawEllipse(canvas, Offset(82 + offX, 14 + offY), 5, 6, earInner.withValues(alpha: 0.7));
      _drawEllipse(canvas, Offset(82 + offX, 15 + offY), 3, 4, earFur.withValues(alpha: 0.5));

      // Right ear outline
      _drawStrokePath(canvas, rightEar, hairShadow, width: 0.8);
    }
  }

  /// Draw face with ellipses, arcs, and gradients
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
    // Face - large ellipse
    _drawEllipse(canvas, Offset(64 + offX, 38 + offY), 28, 24, skinBase);

    // Face highlight - upper area lighter ellipse
    _drawEllipse(canvas, Offset(64 + offX, 33 + offY), 22, 16, skinLight.withValues(alpha: 0.3));

    // Face shadow - sides
    _drawEllipse(canvas, Offset(40 + offX, 40 + offY), 6, 14, skinShadow.withValues(alpha: 0.2));
    _drawEllipse(canvas, Offset(88 + offX, 40 + offY), 6, 14, skinShadow.withValues(alpha: 0.2));

    // Chin shadow
    _drawEllipse(canvas, Offset(64 + offX, 56 + offY), 16, 4, skinShadow.withValues(alpha: 0.25));

    // Eyes
    if (xxEyes) {
      // X_X dizzy eyes
      _drawLine(canvas, Offset(48 + offX, 32 + offY), Offset(56 + offX, 38 + offY), eyeIris, width: 1.5);
      _drawLine(canvas, Offset(56 + offX, 32 + offY), Offset(48 + offX, 38 + offY), eyeIris, width: 1.5);
      _drawLine(canvas, Offset(72 + offX, 32 + offY), Offset(80 + offX, 38 + offY), eyeIris, width: 1.5);
      _drawLine(canvas, Offset(80 + offX, 32 + offY), Offset(72 + offX, 38 + offY), eyeIris, width: 1.5);
    } else if (blink) {
      // Blinking - curved arcs
      _drawArcStroke(canvas, Offset(52 + offX, 35 + offY), 6, 3, math.pi * 0.8, math.pi * 0.4, eyeIris, width: 1.5);
      _drawArcStroke(canvas, Offset(76 + offX, 35 + offY), 6, 3, math.pi * 0.8, math.pi * 0.4, eyeIris, width: 1.5);
      // Eyelashes
      _drawDot(canvas, Offset(45 + offX, 33 + offY), 1.5, eyeOutline);
      _drawDot(canvas, Offset(83 + offX, 33 + offY), 1.5, eyeOutline);
    } else if (starEyes) {
      // Star-shaped happy eyes using path
      Path leftStar = _starPath(Offset(52 + offX, 35 + offY), 7, 3);
      _drawFilledPath(canvas, leftStar, goldLight);
      _drawStrokePath(canvas, leftStar, goldAccent, width: 0.8);
      _drawDot(canvas, Offset(52 + offX, 35 + offY), 2, goldAccent);

      Path rightStar = _starPath(Offset(76 + offX, 35 + offY), 7, 3);
      _drawFilledPath(canvas, rightStar, goldLight);
      _drawStrokePath(canvas, rightStar, goldAccent, width: 0.8);
      _drawDot(canvas, Offset(76 + offX, 35 + offY), 2, goldAccent);
    } else if (bigEyes) {
      // Big round shocked eyes
      // Left eye
      _drawRadialEllipse(canvas, Offset(52 + offX, 35 + offY), 10, 11, [eyeWhite, eyeWhite]);
      _drawRadialEllipse(canvas, Offset(53 + offX, 36 + offY), 7, 8, [eyeIris, eyeIrisDark]);
      _drawDot(canvas, Offset(54 + offX, 37 + offY), 3, eyePupil);
      _drawDot(canvas, Offset(49 + offX, 31 + offY), 2.5, eyeHighlight);
      _drawDot(canvas, Offset(56 + offX, 33 + offY), 1.2, eyeHighlight.withValues(alpha: 0.7));
      _drawArcStroke(canvas, Offset(52 + offX, 35 + offY), 11, 12, math.pi * 0.85, math.pi * 0.3, eyeOutline, width: 1.5);
      _drawEllipse(canvas, Offset(52 + offX, 43 + offY), 8, 3, eyeLower.withValues(alpha: 0.5));
      _drawDot(canvas, Offset(42 + offX, 28 + offY), 1.5, eyeOutline);

      // Right eye
      _drawRadialEllipse(canvas, Offset(76 + offX, 35 + offY), 10, 11, [eyeWhite, eyeWhite]);
      _drawRadialEllipse(canvas, Offset(75 + offX, 36 + offY), 7, 8, [eyeIris, eyeIrisDark]);
      _drawDot(canvas, Offset(74 + offX, 37 + offY), 3, eyePupil);
      _drawDot(canvas, Offset(71 + offX, 31 + offY), 2.5, eyeHighlight);
      _drawDot(canvas, Offset(78 + offX, 33 + offY), 1.2, eyeHighlight.withValues(alpha: 0.7));
      _drawArcStroke(canvas, Offset(76 + offX, 35 + offY), 11, 12, math.pi * 0.85, math.pi * 0.3, eyeOutline, width: 1.5);
      _drawEllipse(canvas, Offset(76 + offX, 43 + offY), 8, 3, eyeLower.withValues(alpha: 0.5));
      _drawDot(canvas, Offset(86 + offX, 28 + offY), 1.5, eyeOutline);
    } else if (closedEyes) {
      // Peaceful closed eyes - gentle arcs
      _drawArcStroke(canvas, Offset(52 + offX, 35 + offY), 6, 3, math.pi * 1.1, -math.pi * 0.2, eyeIris, width: 1.5);
      _drawArcStroke(canvas, Offset(76 + offX, 35 + offY), 6, 3, math.pi * 1.1, -math.pi * 0.2, eyeIris, width: 1.5);
    } else {
      // Normal big round purple eyes
      // Left eye
      _drawRadialEllipse(canvas, Offset(52 + offX, 35 + offY), 9, 10, [eyeWhite, eyeWhite]);
      _drawRadialEllipse(canvas, Offset(53 + offX, 36 + offY), 6, 7, [eyeIris, eyeIrisDark]);
      _drawDot(canvas, Offset(54 + offX, 37 + offY), 2.5, eyePupil);
      _drawDot(canvas, Offset(56 + offX, 33 + offY), 2, eyeHighlight);
      _drawDot(canvas, Offset(50 + offX, 38 + offY), 1.2, eyeHighlight.withValues(alpha: 0.7));
      // Upper eyelid line
      _drawArcStroke(canvas, Offset(52 + offX, 35 + offY), 10, 11, math.pi * 0.85, math.pi * 0.3, eyeOutline, width: 1.5);
      // Lower eyelid (aegyo sal)
      _drawEllipse(canvas, Offset(52 + offX, 42 + offY), 7, 2.5, eyeLower.withValues(alpha: 0.5));
      // Eyelash
      _drawDot(canvas, Offset(43 + offX, 30 + offY), 1.5, eyeOutline);

      // Right eye
      _drawRadialEllipse(canvas, Offset(76 + offX, 35 + offY), 9, 10, [eyeWhite, eyeWhite]);
      _drawRadialEllipse(canvas, Offset(75 + offX, 36 + offY), 6, 7, [eyeIris, eyeIrisDark]);
      _drawDot(canvas, Offset(74 + offX, 37 + offY), 2.5, eyePupil);
      _drawDot(canvas, Offset(72 + offX, 33 + offY), 2, eyeHighlight);
      _drawDot(canvas, Offset(78 + offX, 38 + offY), 1.2, eyeHighlight.withValues(alpha: 0.7));
      // Upper eyelid line
      _drawArcStroke(canvas, Offset(76 + offX, 35 + offY), 10, 11, math.pi * 0.85, math.pi * 0.3, eyeOutline, width: 1.5);
      // Lower eyelid (aegyo sal)
      _drawEllipse(canvas, Offset(76 + offX, 42 + offY), 7, 2.5, eyeLower.withValues(alpha: 0.5));
      // Eyelash
      _drawDot(canvas, Offset(85 + offX, 30 + offY), 1.5, eyeOutline);
    }

    // Blush - semi-transparent ellipses
    _drawEllipse(canvas, Offset(42 + offX, 43 + offY), 7, 3.5, blush.withValues(alpha: 0.25));
    _drawEllipse(canvas, Offset(86 + offX, 43 + offY), 7, 3.5, blush.withValues(alpha: 0.25));

    // Nose
    _drawDot(canvas, Offset(64 + offX, 42 + offY), 1.2, skinShadow);

    // Mouth
    if (openMouth) {
      // O-shaped open mouth
      _drawEllipse(canvas, Offset(64 + offX, 48 + offY), 4, 5, mouth);
      _drawEllipse(canvas, Offset(64 + offX, 48 + offY), 2.5, 3, skinDark);
    } else if (wavyMouth) {
      // Wavy confused mouth - three small arcs
      _drawArcStroke(canvas, Offset(57 + offX, 47 + offY), 3, 2, math.pi * 1.2, -math.pi * 0.4, mouth, width: 1.0);
      _drawArcStroke(canvas, Offset(64 + offX, 49 + offY), 3, 2, 0, math.pi, mouth, width: 1.0);
      _drawArcStroke(canvas, Offset(71 + offX, 47 + offY), 3, 2, math.pi * 1.2, -math.pi * 0.4, mouth, width: 1.0);
    } else if (bigSmile) {
      // Big arc smile
      _drawArcStroke(canvas, Offset(64 + offX, 44 + offY), 12, 6, 0.2, math.pi - 0.4, mouth, width: 1.5);
      _drawArcStroke(canvas, Offset(64 + offX, 45 + offY), 8, 4, 0.3, math.pi - 0.6, skinDark, width: 0.8);
    } else {
      // Omega-shaped smile - three arcs
      _drawArcStroke(canvas, Offset(59 + offX, 47 + offY), 4, 3, 0, math.pi, mouth, width: 1.2);
      _drawArcStroke(canvas, Offset(64 + offX, 48 + offY), 2, 1.5, math.pi, math.pi * 0.5, mouth, width: 1.0);
      _drawArcStroke(canvas, Offset(69 + offX, 47 + offY), 4, 3, 0, -math.pi, mouth, width: 1.2);
    }
  }

  /// Draw body with path curves and gradient fills
  void _drawBody(Canvas canvas, double offX, double offY) {
    // Body - trapezoid path with curves
    Path body = Path();
    body.moveTo(45 + offX, 60 + offY); // left shoulder
    body.quadraticBezierTo(40 + offX, 75 + offY, 42 + offX, 90 + offY); // left side
    body.lineTo(86 + offX, 90 + offY); // bottom
    body.quadraticBezierTo(88 + offX, 75 + offY, 83 + offX, 60 + offY); // right side
    body.close();
    _drawGradientPath(canvas, body, [clothLight, clothBase, clothDark],
        from: Offset(64 + offX, 60 + offY), to: Offset(64 + offX, 90 + offY));

    // White inner collar - V shape
    Path collar = Path();
    collar.moveTo(55 + offX, 60 + offY);
    collar.lineTo(64 + offX, 72 + offY);
    collar.lineTo(73 + offX, 60 + offY);
    _drawStrokePath(canvas, collar, skinLight, width: 2);

    // Collar fill
    Path collarFill = Path();
    collarFill.moveTo(57 + offX, 60 + offY);
    collarFill.lineTo(64 + offX, 70 + offY);
    collarFill.lineTo(71 + offX, 60 + offY);
    collarFill.close();
    _drawFilledPath(canvas, collarFill, skinBase.withValues(alpha: 0.5));

    // Bow - two ellipses + center dot
    _drawEllipse(canvas, Offset(58 + offX, 63 + offY), 5, 3.5, ribbon);
    _drawEllipse(canvas, Offset(70 + offX, 63 + offY), 5, 3.5, ribbon);
    _drawDot(canvas, Offset(64 + offX, 63 + offY), 2, goldAccent);

    // Bow tails
    Path leftTail = Path();
    leftTail.moveTo(60 + offX, 65 + offY);
    leftTail.quadraticBezierTo(58 + offX, 70 + offY, 56 + offX, 72 + offY);
    _drawStrokePath(canvas, leftTail, ribbon, width: 1.5);
    Path rightTail = Path();
    rightTail.moveTo(68 + offX, 65 + offY);
    rightTail.quadraticBezierTo(70 + offX, 70 + offY, 72 + offX, 72 + offY);
    _drawStrokePath(canvas, rightTail, ribbon, width: 1.5);

    // Gold embroidery - collar arc
    _drawArcStroke(canvas, Offset(64 + offX, 60 + offY), 15, 3, math.pi * 0.15, math.pi * 0.7, goldAccent, width: 0.8);

    // Gold embroidery - side lines
    _drawLine(canvas, Offset(45 + offX, 65 + offY), Offset(45 + offX, 82 + offY), goldAccent, width: 0.8);
    _drawLine(canvas, Offset(83 + offX, 65 + offY), Offset(83 + offX, 82 + offY), goldAccent, width: 0.8);
    _drawLine(canvas, Offset(48 + offX, 82 + offY), Offset(80 + offX, 82 + offY), goldAccent, width: 0.8);

    // Gold belt
    _drawLine(canvas, Offset(44 + offX, 78 + offY), Offset(84 + offX, 78 + offY), goldAccent, width: 1.0);
    _drawLine(canvas, Offset(46 + offX, 80 + offY), Offset(82 + offX, 80 + offY), goldLight, width: 0.6);

    // Arms - curved paths
    // Left arm
    Path leftArm = Path();
    leftArm.moveTo(45 + offX, 63 + offY);
    leftArm.quadraticBezierTo(32 + offX, 72 + offY, 35 + offX, 82 + offY);
    _drawStrokePath(canvas, leftArm, clothBase, width: 7);
    _drawStrokePath(canvas, leftArm, clothLight, width: 4);
    // Left hand
    _drawDot(canvas, Offset(35 + offX, 83 + offY), 3.5, skinBase);
    _drawDot(canvas, Offset(34 + offX, 82 + offY), 1.5, skinLight);
    // Left armband
    _drawArcStroke(canvas, Offset(38 + offX, 66 + offY), 5, 3, math.pi * 0.5, math.pi, goldAccent, width: 1.0);

    // Right arm
    Path rightArm = Path();
    rightArm.moveTo(83 + offX, 63 + offY);
    rightArm.quadraticBezierTo(96 + offX, 72 + offY, 93 + offX, 82 + offY);
    _drawStrokePath(canvas, rightArm, clothBase, width: 7);
    _drawStrokePath(canvas, rightArm, clothLight, width: 4);
    // Right hand
    _drawDot(canvas, Offset(93 + offX, 83 + offY), 3.5, skinBase);
    _drawDot(canvas, Offset(94 + offX, 82 + offY), 1.5, skinLight);
    // Right armband
    _drawArcStroke(canvas, Offset(90 + offX, 66 + offY), 5, 3, 0, math.pi * 0.5, goldAccent, width: 1.0);
  }

  /// Draw legs and shoes with curves
  void _drawLegs(Canvas canvas, double offX, double offY) {
    // Left leg
    Path leftLeg = Path();
    leftLeg.moveTo(50 + offX, 90 + offY);
    leftLeg.lineTo(48 + offX, 100 + offY);
    leftLeg.lineTo(56 + offX, 100 + offY);
    leftLeg.lineTo(54 + offX, 90 + offY);
    leftLeg.close();
    _drawGradientPath(canvas, leftLeg, [skinBase, skinShadow],
        from: Offset(52 + offX, 90 + offY), to: Offset(52 + offX, 100 + offY));

    // Right leg
    Path rightLeg = Path();
    rightLeg.moveTo(74 + offX, 90 + offY);
    rightLeg.lineTo(72 + offX, 100 + offY);
    rightLeg.lineTo(80 + offX, 100 + offY);
    rightLeg.lineTo(78 + offX, 90 + offY);
    rightLeg.close();
    _drawGradientPath(canvas, rightLeg, [skinBase, skinShadow],
        from: Offset(76 + offX, 90 + offY), to: Offset(76 + offX, 100 + offY));

    // Left shoe
    Path leftShoe = Path();
    leftShoe.moveTo(46 + offX, 100 + offY);
    leftShoe.quadraticBezierTo(44 + offX, 104 + offY, 46 + offX, 106 + offY);
    leftShoe.lineTo(58 + offX, 106 + offY);
    leftShoe.quadraticBezierTo(60 + offX, 104 + offY, 58 + offX, 100 + offY);
    leftShoe.close();
    _drawGradientPath(canvas, leftShoe, [clothBase, clothDark],
        from: Offset(52 + offX, 100 + offY), to: Offset(52 + offX, 106 + offY));
    // Shoe sole
    _drawLine(canvas, Offset(46 + offX, 106 + offY), Offset(58 + offX, 106 + offY), hairDark, width: 1.5);
    // Gold buckle
    _drawDot(canvas, Offset(52 + offX, 102 + offY), 1.5, goldAccent);

    // Right shoe
    Path rightShoe = Path();
    rightShoe.moveTo(70 + offX, 100 + offY);
    rightShoe.quadraticBezierTo(68 + offX, 104 + offY, 70 + offX, 106 + offY);
    rightShoe.lineTo(82 + offX, 106 + offY);
    rightShoe.quadraticBezierTo(84 + offX, 104 + offY, 82 + offX, 100 + offY);
    rightShoe.close();
    _drawGradientPath(canvas, rightShoe, [clothBase, clothDark],
        from: Offset(76 + offX, 100 + offY), to: Offset(76 + offX, 106 + offY));
    // Shoe sole
    _drawLine(canvas, Offset(70 + offX, 106 + offY), Offset(82 + offX, 106 + offY), hairDark, width: 1.5);
    // Gold buckle
    _drawDot(canvas, Offset(76 + offX, 102 + offY), 1.5, goldAccent);
  }

  /// Draw tail with bezier curves
  void _drawTail(Canvas canvas, double offX, double offY, {double wagX = 0}) {
    Path tail = Path();
    tail.moveTo(30 + offX + wagX, 75 + offY);
    tail.quadraticBezierTo(20 + offX + wagX, 70 + offY, 14 + offX + wagX, 62 + offY);
    tail.quadraticBezierTo(8 + offX + wagX, 54 + offY, 10 + offX + wagX, 48 + offY);
    tail.quadraticBezierTo(6 + offX + wagX, 42 + offY, 8 + offX + wagX, 38 + offY);
    _drawStrokePath(canvas, tail, hairBase, width: 5);
    _drawStrokePath(canvas, tail, hairLight, width: 3);

    // Tail tip highlight
    _drawDot(canvas, Offset(8 + offX + wagX, 38 + offY), 3, hairHighlight.withValues(alpha: 0.6));
  }

  // ============================================================
  // State drawing methods
  // ============================================================

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
  // IDLE: Standing with breathing animation
  // ============================================================
  void _drawIdle(Canvas canvas) {
    final breathOffset = (frame == 1 || frame == 3) ? -1.0 : 1.0;
    final blink = frame == 2;

    _drawTail(canvas, 0, breathOffset);
    _drawLegs(canvas, 0, breathOffset);
    _drawBody(canvas, 0, breathOffset);
    _drawFace(canvas, 0, breathOffset, blink: blink);
    _drawHair(canvas, 0, breathOffset);
    _drawEars(canvas, 0, breathOffset);
  }

  // ============================================================
  // HAPPY: Star eyes, big smile, bouncing
  // ============================================================
  void _drawHappy(Canvas canvas) {
    final bounce = [0.0, -3.0, 0.0, -2.0][frame];

    // Tail wagging
    final tailWag = [0.0, 3.0, 0.0, -3.0][frame];
    _drawTail(canvas, 0, bounce, wagX: tailWag);

    _drawLegs(canvas, 0, bounce);
    _drawBody(canvas, 0, bounce);

    // Arms UP - curved paths raised
    Path leftArmUp = Path();
    leftArmUp.moveTo(45, 63 + bounce);
    leftArmUp.quadraticBezierTo(28, 50 + bounce, 24, 36 + bounce);
    _drawStrokePath(canvas, leftArmUp, clothBase, width: 7);
    _drawStrokePath(canvas, leftArmUp, clothLight, width: 4);
    _drawDot(canvas, Offset(24, 35 + bounce), 3.5, skinBase);
    _drawDot(canvas, Offset(23, 34 + bounce), 1.5, skinLight);
    _drawArcStroke(canvas, Offset(36, 58 + bounce), 6, 3, math.pi * 0.6, math.pi * 0.8, goldAccent, width: 1.0);

    Path rightArmUp = Path();
    rightArmUp.moveTo(83, 63 + bounce);
    rightArmUp.quadraticBezierTo(100, 50 + bounce, 104, 36 + bounce);
    _drawStrokePath(canvas, rightArmUp, clothBase, width: 7);
    _drawStrokePath(canvas, rightArmUp, clothLight, width: 4);
    _drawDot(canvas, Offset(104, 35 + bounce), 3.5, skinBase);
    _drawDot(canvas, Offset(105, 34 + bounce), 1.5, skinLight);
    _drawArcStroke(canvas, Offset(92, 58 + bounce), 6, 3, -math.pi * 0.4, math.pi * 0.8, goldAccent, width: 1.0);

    _drawFace(canvas, 0, bounce, starEyes: true, bigSmile: true);
    _drawHair(canvas, 0, bounce);
    _drawEars(canvas, 0, bounce);

    // Sparkles
    if (frame % 2 == 0) {
      _drawDot(canvas, Offset(21, 17 + bounce), 1.5, goldLight);
      _drawDot(canvas, Offset(107, 21 + bounce), 1.5, goldLight);
      _drawDot(canvas, Offset(15, 40 + bounce), 1.2, goldAccent);
      _drawDot(canvas, Offset(113, 36 + bounce), 1.2, goldAccent);
      // Small star sparkles
      Path spark1 = _starPath(Offset(18, 28 + bounce), 2.5, 1);
      _drawFilledPath(canvas, spark1, goldLight.withValues(alpha: 0.8));
      Path spark2 = _starPath(Offset(110, 28 + bounce), 2.5, 1);
      _drawFilledPath(canvas, spark2, goldLight.withValues(alpha: 0.8));
    }
  }

  // ============================================================
  // CONFUSED: One ear droopy, wavy mouth, head tilt
  // ============================================================
  void _drawConfused(Canvas canvas) {
    final tilt = frame == 1 ? 2.0 : 0.0;

    // Tail droopy
    Path droopyTail = Path();
    droopyTail.moveTo(30, 75);
    droopyTail.quadraticBezierTo(22, 76, 16, 78);
    droopyTail.quadraticBezierTo(10, 80, 8, 84);
    _drawStrokePath(canvas, droopyTail, hairBase, width: 5);
    _drawStrokePath(canvas, droopyTail, hairDark, width: 3);

    _drawLegs(canvas, 0, 0);
    _drawBody(canvas, 0, 0);

    // Left arm normal
    Path leftArmN = Path();
    leftArmN.moveTo(45, 63);
    leftArmN.quadraticBezierTo(32, 72, 35, 82);
    _drawStrokePath(canvas, leftArmN, clothBase, width: 7);
    _drawStrokePath(canvas, leftArmN, clothLight, width: 4);
    _drawDot(canvas, Offset(35, 83), 3.5, skinBase);
    _drawArcStroke(canvas, Offset(38, 66), 5, 3, math.pi * 0.5, math.pi, goldAccent, width: 1.0);

    // Right arm scratching head
    Path rightArmScratch = Path();
    rightArmScratch.moveTo(83, 63);
    rightArmScratch.quadraticBezierTo(92, 50, 88, 36);
    _drawStrokePath(canvas, rightArmScratch, clothBase, width: 7);
    _drawStrokePath(canvas, rightArmScratch, clothLight, width: 4);
    _drawDot(canvas, Offset(88, 35), 3.5, skinBase);
    _drawDot(canvas, Offset(89, 34), 1.5, skinLight);
    _drawArcStroke(canvas, Offset(90, 58), 5, 3, 0, math.pi * 0.5, goldAccent, width: 1.0);

    _drawFace(canvas, tilt, 0, wavyMouth: true);
    _drawHair(canvas, tilt, 0);
    _drawEars(canvas, tilt, 0, rightDroopy: true);

    // Question mark - drawn with path
    Path questionMark = Path();
    questionMark.moveTo(100, 10);
    questionMark.quadraticBezierTo(104, 10, 104, 14);
    questionMark.quadraticBezierTo(104, 18, 100, 20);
    questionMark.quadraticBezierTo(98, 22, 98, 24);
    _drawStrokePath(canvas, questionMark, goldAccent, width: 1.5);
    _drawDot(canvas, Offset(99, 27), 1, goldAccent);
  }

  // ============================================================
  // PUSHED AWAY: Body leaning back, arms pushing forward, sweat
  // ============================================================
  void _drawPushedAway(Canvas canvas) {
    final slideX = frame * 3.0;

    _drawTail(canvas, -slideX, 0);

    // Legs in running pose
    Path leftLegRun = Path();
    leftLegRun.moveTo(50 - slideX, 90);
    leftLegRun.lineTo(46 - slideX, 100);
    leftLegRun.lineTo(54 - slideX, 100);
    leftLegRun.lineTo(52 - slideX, 90);
    leftLegRun.close();
    _drawGradientPath(canvas, leftLegRun, [skinBase, skinShadow]);

    Path rightLegRun = Path();
    rightLegRun.moveTo(78 - slideX, 90);
    rightLegRun.lineTo(80 - slideX, 100);
    rightLegRun.lineTo(88 - slideX, 100);
    rightLegRun.lineTo(82 - slideX, 90);
    rightLegRun.close();
    _drawGradientPath(canvas, rightLegRun, [skinBase, skinShadow]);

    // Shoes
    Path leftShoeRun = Path();
    leftShoeRun.moveTo(44 - slideX, 100);
    leftShoeRun.quadraticBezierTo(42 - slideX, 104, 44 - slideX, 106);
    leftShoeRun.lineTo(56 - slideX, 106);
    leftShoeRun.quadraticBezierTo(58 - slideX, 104, 56 - slideX, 100);
    leftShoeRun.close();
    _drawGradientPath(canvas, leftShoeRun, [clothBase, clothDark]);

    Path rightShoeRun = Path();
    rightShoeRun.moveTo(78 - slideX, 100);
    rightShoeRun.quadraticBezierTo(76 - slideX, 104, 78 - slideX, 106);
    rightShoeRun.lineTo(90 - slideX, 106);
    rightShoeRun.quadraticBezierTo(92 - slideX, 104, 90 - slideX, 100);
    rightShoeRun.close();
    _drawGradientPath(canvas, rightShoeRun, [clothBase, clothDark]);

    _drawBody(canvas, -slideX, 0);

    // Left arm - normal position
    Path leftArmBack = Path();
    leftArmBack.moveTo(45 - slideX, 63);
    leftArmBack.quadraticBezierTo(32 - slideX, 72, 35 - slideX, 82);
    _drawStrokePath(canvas, leftArmBack, clothBase, width: 7);
    _drawStrokePath(canvas, leftArmBack, clothLight, width: 4);
    _drawDot(canvas, Offset(35 - slideX, 83), 3.5, skinBase);

    // Right arm - pushing forward
    Path rightArmPush = Path();
    rightArmPush.moveTo(83 - slideX, 63);
    rightArmPush.quadraticBezierTo(96 - slideX, 58, 106 - slideX, 52);
    _drawStrokePath(canvas, rightArmPush, clothBase, width: 7);
    _drawStrokePath(canvas, rightArmPush, clothLight, width: 4);
    _drawDot(canvas, Offset(107 - slideX, 51), 3.5, skinBase);
    _drawDot(canvas, Offset(108 - slideX, 50), 1.5, skinLight);

    _drawFace(canvas, -slideX, 0, openMouth: true);
    _drawHair(canvas, -slideX, 0);
    _drawEars(canvas, -slideX, 0);

    // Sweat drop - teardrop shape
    Path sweatDrop = Path();
    sweatDrop.moveTo(96 - slideX, 20);
    sweatDrop.quadraticBezierTo(100 - slideX, 24, 98 - slideX, 28);
    sweatDrop.quadraticBezierTo(94 - slideX, 28, 96 - slideX, 20);
    sweatDrop.close();
    _drawGradientPath(canvas, sweatDrop, [sweatTip, sweatBase]);
    _drawDot(canvas, Offset(96 - slideX, 18), 1, sweatTip);

    // Motion lines
    for (int i = 0; i < 3; i++) {
      _drawLine(
        canvas,
        Offset(110 + i * 4 - slideX, 36 + i * 8),
        Offset(110 + i * 4 - slideX, 44 + i * 8),
        const Color(0xFFFFFFFF).withValues(alpha: 0.5),
        width: 1.0,
      );
    }
  }

  // ============================================================
  // SLEEPING: Eyes closed, body lying down, Zzz
  // ============================================================
  void _drawSleeping(Canvas canvas) {
    final breathe = frame == 0 ? 0.0 : 1.0;

    canvas.save();
    // Shift everything down for lying pose
    canvas.translate(0, 10);

    // Tail curled
    Path curledTail = Path();
    curledTail.moveTo(6, 66);
    curledTail.quadraticBezierTo(2, 62, 4, 58);
    curledTail.quadraticBezierTo(6, 54, 10, 56);
    _drawStrokePath(canvas, curledTail, hairBase, width: 5);
    _drawStrokePath(canvas, curledTail, hairLight, width: 3);

    // Body lying down - wider ellipse
    _drawEllipse(canvas, Offset(54, 72 + breathe), 38, 10, clothBase);
    _drawEllipse(canvas, Offset(54, 70 + breathe), 34, 6, clothLight);
    // Body shadow
    _drawEllipse(canvas, Offset(54, 78 + breathe), 36, 4, clothDark);
    // Gold embroidery
    _drawLine(canvas, Offset(22, 72 + breathe), Offset(86, 72 + breathe), goldAccent, width: 0.8);
    _drawLine(canvas, Offset(26, 74 + breathe), Offset(82, 74 + breathe), goldLight, width: 0.6);

    // Head resting on side
    _drawEllipse(canvas, Offset(18, 62 + breathe), 16, 12, skinBase);
    _drawEllipse(canvas, Offset(16, 59 + breathe), 10, 6, skinLight.withValues(alpha: 0.3));
    _drawEllipse(canvas, Offset(18, 70 + breathe), 12, 4, skinShadow.withValues(alpha: 0.3));

    // Hair flowing while lying
    Path lyingHair = Path();
    lyingHair.moveTo(4, 52 + breathe);
    lyingHair.quadraticBezierTo(8, 48 + breathe, 20, 50 + breathe);
    lyingHair.quadraticBezierTo(30, 52 + breathe, 32, 56 + breathe);
    lyingHair.lineTo(32, 62 + breathe);
    lyingHair.quadraticBezierTo(28, 66 + breathe, 18, 68 + breathe);
    lyingHair.lineTo(4, 68 + breathe);
    lyingHair.quadraticBezierTo(2, 60 + breathe, 4, 52 + breathe);
    lyingHair.close();
    _drawGradientPath(canvas, lyingHair, [hairLight, hairBase, hairDark],
        from: Offset(18, 50 + breathe), to: Offset(18, 68 + breathe));

    // Cat ear (one visible)
    Path lyingEar = Path();
    lyingEar.moveTo(8, 50 + breathe);
    lyingEar.quadraticBezierTo(4, 42 + breathe, 10, 40 + breathe);
    lyingEar.quadraticBezierTo(14, 42 + breathe, 16, 50 + breathe);
    lyingEar.close();
    _drawGradientPath(canvas, lyingEar, [hairBase, hairDark]);
    _drawEllipse(canvas, Offset(11, 45 + breathe), 3, 3, earInner.withValues(alpha: 0.7));

    // Closed eyes - peaceful arcs
    _drawArcStroke(canvas, Offset(16, 62 + breathe), 5, 2, math.pi * 1.1, -math.pi * 0.2, eyeIris, width: 1.5);

    // Peaceful mouth
    _drawArcStroke(canvas, Offset(18, 66 + breathe), 3, 1.5, 0.2, math.pi - 0.4, mouth, width: 0.8);

    // Blush
    _drawEllipse(canvas, Offset(12, 64 + breathe), 4, 2, blush.withValues(alpha: 0.25));
    _drawEllipse(canvas, Offset(26, 64 + breathe), 4, 2, blush.withValues(alpha: 0.25));

    // Feet
    _drawEllipse(canvas, Offset(88, 72 + breathe), 6, 4, skinBase);
    _drawEllipse(canvas, Offset(88, 74 + breathe), 5, 2, skinShadow.withValues(alpha: 0.3));

    // Zzz - floating letters drawn as dots of increasing size
    _drawDot(canvas, Offset(38, 48 + breathe), 1.5, goldLight);
    _drawDot(canvas, Offset(44, 42 + breathe), 1.8, goldLight);
    _drawDot(canvas, Offset(51, 36 + breathe), 2.2, goldLight);
    _drawDot(canvas, Offset(59, 30 + breathe), 2.5, goldLight);

    canvas.restore();
  }

  // ============================================================
  // SQUISHED: Body horizontally compressed, X_X eyes
  // ============================================================
  void _drawSquished(Canvas canvas) {
    canvas.save();
    canvas.translate(64, 64);
    canvas.scale(1.3, 0.8);
    canvas.translate(-64, -64);

    final squishY = frame * 0.5;

    // Tail flat
    Path flatTail = Path();
    flatTail.moveTo(20, 72);
    flatTail.quadraticBezierTo(12, 72, 8, 70);
    _drawStrokePath(canvas, flatTail, hairBase, width: 5);
    _drawStrokePath(canvas, flatTail, hairLight, width: 3);

    // Body wider and shorter
    Path squishBody = Path();
    squishBody.moveTo(30, 66 + squishY);
    squishBody.quadraticBezierTo(26, 76 + squishY, 30, 86 + squishY);
    squishBody.lineTo(98, 86 + squishY);
    squishBody.quadraticBezierTo(102, 76 + squishY, 98, 66 + squishY);
    squishBody.close();
    _drawGradientPath(canvas, squishBody, [clothLight, clothBase, clothDark],
        from: Offset(64, 66 + squishY), to: Offset(64, 86 + squishY));

    // Gold belt
    _drawLine(canvas, Offset(32, 76 + squishY), Offset(96, 76 + squishY), goldAccent, width: 1.0);

    // Arms spread out
    Path leftArmSpread = Path();
    leftArmSpread.moveTo(30, 72 + squishY);
    leftArmSpread.quadraticBezierTo(18, 72, 12, 72);
    _drawStrokePath(canvas, leftArmSpread, clothBase, width: 7);
    _drawStrokePath(canvas, leftArmSpread, clothLight, width: 4);
    _drawDot(canvas, Offset(11, 72), 3.5, skinBase);
    _drawDot(canvas, Offset(10, 71), 1.5, skinLight);

    Path rightArmSpread = Path();
    rightArmSpread.moveTo(98, 72 + squishY);
    rightArmSpread.quadraticBezierTo(110, 72, 116, 72);
    _drawStrokePath(canvas, rightArmSpread, clothBase, width: 7);
    _drawStrokePath(canvas, rightArmSpread, clothLight, width: 4);
    _drawDot(canvas, Offset(117, 72), 3.5, skinBase);
    _drawDot(canvas, Offset(118, 71), 1.5, skinLight);

    // Head wider
    _drawEllipse(canvas, Offset(64, 48), 34, 20, skinBase);
    _drawEllipse(canvas, Offset(64, 44), 26, 12, skinLight.withValues(alpha: 0.3));
    _drawEllipse(canvas, Offset(64, 60), 28, 5, skinShadow.withValues(alpha: 0.25));

    // Hair spread out
    Path spreadHair = Path();
    spreadHair.moveTo(26, 38);
    spreadHair.quadraticBezierTo(30, 28, 64, 26);
    spreadHair.quadraticBezierTo(98, 28, 102, 38);
    spreadHair.lineTo(102, 46);
    spreadHair.quadraticBezierTo(98, 50, 64, 48);
    spreadHair.quadraticBezierTo(30, 50, 26, 46);
    spreadHair.close();
    _drawGradientPath(canvas, spreadHair, [hairLight, hairBase, hairDark],
        from: Offset(64, 26), to: Offset(64, 50));

    // Cat ears flattened
    Path leftFlatEar = Path();
    leftFlatEar.moveTo(22, 36);
    leftFlatEar.quadraticBezierTo(18, 30, 24, 28);
    leftFlatEar.quadraticBezierTo(30, 30, 34, 36);
    leftFlatEar.close();
    _drawGradientPath(canvas, leftFlatEar, [hairBase, hairDark]);
    _drawEllipse(canvas, Offset(28, 32), 4, 2.5, earInner.withValues(alpha: 0.7));

    Path rightFlatEar = Path();
    rightFlatEar.moveTo(106, 36);
    rightFlatEar.quadraticBezierTo(110, 30, 104, 28);
    rightFlatEar.quadraticBezierTo(98, 30, 94, 36);
    rightFlatEar.close();
    _drawGradientPath(canvas, rightFlatEar, [hairBase, hairDark]);
    _drawEllipse(canvas, Offset(100, 32), 4, 2.5, earInner.withValues(alpha: 0.7));

    // X_X eyes
    _drawLine(canvas, Offset(48, 46), Offset(56, 52), eyeIris, width: 1.5);
    _drawLine(canvas, Offset(56, 46), Offset(48, 52), eyeIris, width: 1.5);
    _drawLine(canvas, Offset(72, 46), Offset(80, 52), eyeIris, width: 1.5);
    _drawLine(canvas, Offset(80, 46), Offset(72, 52), eyeIris, width: 1.5);

    // Wavy mouth
    _drawArcStroke(canvas, Offset(58, 56), 3, 2, math.pi * 1.2, -math.pi * 0.4, mouth, width: 1.0);
    _drawArcStroke(canvas, Offset(70, 56), 3, 2, math.pi * 1.2, -math.pi * 0.4, mouth, width: 1.0);

    // Blush
    _drawEllipse(canvas, Offset(42, 54), 5, 3, blush.withValues(alpha: 0.3));
    _drawEllipse(canvas, Offset(86, 54), 5, 3, blush.withValues(alpha: 0.3));

    // Legs spread
    _drawEllipse(canvas, Offset(44, 90 + squishY), 5, 4, skinBase);
    _drawEllipse(canvas, Offset(84, 90 + squishY), 5, 4, skinBase);

    canvas.restore();
  }

  // ============================================================
  // SHOCKED: Bigger eyes, O mouth, body shaking
  // ============================================================
  void _drawShocked(Canvas canvas) {
    final shake = [0.0, -1.0, 1.0, 0.0][frame];

    _drawTail(canvas, shake, 0);
    _drawLegs(canvas, shake, 0);
    _drawBody(canvas, shake, 0);

    // Arms up in shock
    Path leftArmShock = Path();
    leftArmShock.moveTo(45 + shake, 63);
    leftArmShock.quadraticBezierTo(30 + shake, 48, 26 + shake, 34);
    _drawStrokePath(canvas, leftArmShock, clothBase, width: 7);
    _drawStrokePath(canvas, leftArmShock, clothLight, width: 4);
    _drawDot(canvas, Offset(26 + shake, 33), 3.5, skinBase);
    _drawDot(canvas, Offset(25 + shake, 32), 1.5, skinLight);
    _drawArcStroke(canvas, Offset(36 + shake, 56), 6, 3, math.pi * 0.6, math.pi * 0.8, goldAccent, width: 1.0);

    Path rightArmShock = Path();
    rightArmShock.moveTo(83 + shake, 63);
    rightArmShock.quadraticBezierTo(98 + shake, 48, 102 + shake, 34);
    _drawStrokePath(canvas, rightArmShock, clothBase, width: 7);
    _drawStrokePath(canvas, rightArmShock, clothLight, width: 4);
    _drawDot(canvas, Offset(102 + shake, 33), 3.5, skinBase);
    _drawDot(canvas, Offset(103 + shake, 32), 1.5, skinLight);
    _drawArcStroke(canvas, Offset(92 + shake, 56), 6, 3, -math.pi * 0.4, math.pi * 0.8, goldAccent, width: 1.0);

    _drawFace(canvas, shake, 0, bigEyes: true, openMouth: true);
    _drawHair(canvas, shake, 0);
    _drawEars(canvas, shake, 0);

    // Sweat drops
    Path sweat1 = Path();
    sweat1.moveTo(96 + shake, 20);
    sweat1.quadraticBezierTo(100 + shake, 24, 98 + shake, 28);
    sweat1.quadraticBezierTo(94 + shake, 28, 96 + shake, 20);
    sweat1.close();
    _drawGradientPath(canvas, sweat1, [sweatTip, sweatBase]);
    _drawDot(canvas, Offset(96 + shake, 18), 1, sweatTip);

    Path sweat2 = Path();
    sweat2.moveTo(39 + shake, 20);
    sweat2.quadraticBezierTo(42 + shake, 23, 40 + shake, 26);
    sweat2.quadraticBezierTo(37 + shake, 26, 39 + shake, 20);
    sweat2.close();
    _drawGradientPath(canvas, sweat2, [sweatTip, sweatBase]);

    // Exclamation marks
    _drawLine(canvas, Offset(104, 8), Offset(104, 16), goldAccent, width: 1.5);
    _drawDot(canvas, Offset(104, 18), 1, goldAccent);
    _drawLine(canvas, Offset(110, 10), Offset(110, 18), goldAccent, width: 1.5);
    _drawDot(canvas, Offset(110, 20), 1, goldAccent);
  }

  // ============================================================
  // CELEBRATING: Hands up, star eyes, jumping
  // ============================================================
  void _drawCelebrating(Canvas canvas) {
    final jumpHeight = [0.0, -5.0, -8.0, -5.0, 0.0, -3.0][frame];
    final spin = frame < 3;

    // Tail wagging
    final tailWag = [0.0, 4.0, 0.0, -4.0, 0.0, 2.0][frame];
    _drawTail(canvas, 0, jumpHeight, wagX: tailWag);

    _drawLegs(canvas, 0, jumpHeight);
    _drawBody(canvas, 0, jumpHeight);

    // Arms alternating up
    if (spin) {
      // Left arm up high
      Path leftArmUp = Path();
      leftArmUp.moveTo(45, 63 + jumpHeight);
      leftArmUp.quadraticBezierTo(24, 46 + jumpHeight, 20, 28 + jumpHeight);
      _drawStrokePath(canvas, leftArmUp, clothBase, width: 7);
      _drawStrokePath(canvas, leftArmUp, clothLight, width: 4);
      _drawDot(canvas, Offset(20, 27 + jumpHeight), 3.5, skinBase);
      _drawDot(canvas, Offset(19, 26 + jumpHeight), 1.5, skinLight);
      _drawArcStroke(canvas, Offset(34, 56 + jumpHeight), 6, 3, math.pi * 0.6, math.pi * 0.8, goldAccent, width: 1.0);

      // Right arm out
      Path rightArmOut = Path();
      rightArmOut.moveTo(83, 63 + jumpHeight);
      rightArmOut.quadraticBezierTo(96, 72 + jumpHeight, 93, 82 + jumpHeight);
      _drawStrokePath(canvas, rightArmOut, clothBase, width: 7);
      _drawStrokePath(canvas, rightArmOut, clothLight, width: 4);
      _drawDot(canvas, Offset(93, 83 + jumpHeight), 3.5, skinBase);
      _drawArcStroke(canvas, Offset(90, 66 + jumpHeight), 5, 3, 0, math.pi * 0.5, goldAccent, width: 1.0);
    } else {
      // Right arm up high
      Path rightArmUp = Path();
      rightArmUp.moveTo(83, 63 + jumpHeight);
      rightArmUp.quadraticBezierTo(104, 46 + jumpHeight, 108, 28 + jumpHeight);
      _drawStrokePath(canvas, rightArmUp, clothBase, width: 7);
      _drawStrokePath(canvas, rightArmUp, clothLight, width: 4);
      _drawDot(canvas, Offset(108, 27 + jumpHeight), 3.5, skinBase);
      _drawDot(canvas, Offset(109, 26 + jumpHeight), 1.5, skinLight);
      _drawArcStroke(canvas, Offset(94, 56 + jumpHeight), 6, 3, -math.pi * 0.4, math.pi * 0.8, goldAccent, width: 1.0);

      // Left arm out
      Path leftArmOut = Path();
      leftArmOut.moveTo(45, 63 + jumpHeight);
      leftArmOut.quadraticBezierTo(32, 72 + jumpHeight, 35, 82 + jumpHeight);
      _drawStrokePath(canvas, leftArmOut, clothBase, width: 7);
      _drawStrokePath(canvas, leftArmOut, clothLight, width: 4);
      _drawDot(canvas, Offset(35, 83 + jumpHeight), 3.5, skinBase);
      _drawArcStroke(canvas, Offset(38, 66 + jumpHeight), 5, 3, math.pi * 0.5, math.pi, goldAccent, width: 1.0);
    }

    _drawFace(canvas, 0, jumpHeight, starEyes: true, bigSmile: true);
    _drawHair(canvas, 0, jumpHeight);
    _drawEars(canvas, 0, jumpHeight);

    // Sparkles around - alternating positions
    if (frame % 2 == 0) {
      _drawDot(canvas, Offset(14, 14 + jumpHeight), 1.5, goldLight);
      _drawDot(canvas, Offset(114, 18 + jumpHeight), 1.5, goldLight);
      _drawDot(canvas, Offset(9, 42 + jumpHeight), 1.2, goldAccent);
      _drawDot(canvas, Offset(119, 36 + jumpHeight), 1.2, goldAccent);
      Path spark1 = _starPath(Offset(16, 28 + jumpHeight), 3, 1.2);
      _drawFilledPath(canvas, spark1, goldLight.withValues(alpha: 0.8));
      Path spark2 = _starPath(Offset(112, 26 + jumpHeight), 3, 1.2);
      _drawFilledPath(canvas, spark2, goldLight.withValues(alpha: 0.8));
    } else {
      _drawDot(canvas, Offset(17, 25 + jumpHeight), 1.2, goldLight);
      _drawDot(canvas, Offset(111, 12 + jumpHeight), 1.2, goldLight);
      _drawDot(canvas, Offset(11, 52 + jumpHeight), 1.0, goldAccent);
      _drawDot(canvas, Offset(117, 46 + jumpHeight), 1.0, goldAccent);
      Path spark1 = _starPath(Offset(12, 36 + jumpHeight), 2.5, 1);
      _drawFilledPath(canvas, spark1, goldLight.withValues(alpha: 0.7));
      Path spark2 = _starPath(Offset(116, 32 + jumpHeight), 2.5, 1);
      _drawFilledPath(canvas, spark2, goldLight.withValues(alpha: 0.7));
    }
  }

  @override
  bool shouldRepaint(covariant CatGirlPainter oldDelegate) {
    return oldDelegate.state != state || oldDelegate.frame != frame;
  }
}
