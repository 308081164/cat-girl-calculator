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
  static const hairMid = Color(0xFFC89838);     // mid tone (new)
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
  static const clothAccent = Color(0xFF8888A0); // accent (new)

  // Ribbon decoration
  static const ribbon = Color(0xFF333340);      // dark ribbon

  // Gold accents
  static const goldAccent = Color(0xFFE5C565);  // gold
  static const goldLight = Color(0xFFF5E5A5);   // light gold

  // Cat ears
  static const earInner = Color(0xFFFFD5D5);    // ear inner pink
  static const earFur = Color(0xFFF0C8C8);      // ear inner fur

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

  void _drawPixel(Canvas canvas, double x, double y, Color color) {
    final paint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(x, y, 1, 1), paint);
  }

  void _drawPixelRect(Canvas canvas, double x, double y, double w, double h, Color color) {
    final paint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(x, y, w, h), paint);
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

    // Left ear inner (pink, 4-5px wide, 5 rows)
    _drawPixelRect(canvas, 36 + offX, 6 + offY, 4, 1, earInner);
    _drawPixelRect(canvas, 35 + offX, 7 + offY, 6, 1, earInner);
    _drawPixelRect(canvas, 35 + offX, 8 + offY, 5, 1, earInner);
    _drawPixelRect(canvas, 35 + offX, 8 + offY, 2, 1, earFur);
    _drawPixelRect(canvas, 36 + offX, 9 + offY, 4, 1, earFur);
    _drawPixelRect(canvas, 37 + offX, 10 + offY, 2, 1, earFur);

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
      _drawPixelRect(canvas, 80 + offX, 11 + offY, 4, 1, earInner);
      _drawPixelRect(canvas, 82 + offX, 10 + offY, 2, 1, earFur);
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

      // Right ear inner (pink, 4-5px wide, 5 rows)
      _drawPixelRect(canvas, 88 + offX, 6 + offY, 4, 1, earInner);
      _drawPixelRect(canvas, 87 + offX, 7 + offY, 6, 1, earInner);
      _drawPixelRect(canvas, 88 + offX, 8 + offY, 5, 1, earInner);
      _drawPixelRect(canvas, 91 + offX, 8 + offY, 2, 1, earFur);
      _drawPixelRect(canvas, 88 + offX, 9 + offY, 4, 1, earFur);
      _drawPixelRect(canvas, 89 + offX, 10 + offY, 2, 1, earFur);
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

    // Highlight lines on bangs
    _drawPixelRect(canvas, 36 + offX, 14 + offY, 1, 2, hairLight);
    _drawPixelRect(canvas, 46 + offX, 14 + offY, 1, 2, hairLight);
    _drawPixelRect(canvas, 63 + offX, 14 + offY, 1, 2, hairLight);
    _drawPixelRect(canvas, 77 + offX, 14 + offY, 1, 2, hairLight);

    // Side hair - left (long flowing to y≈75)
    _drawPixelRect(canvas, 30 + offX, 14 + offY, 4, 28, hairBase);
    _drawPixelRect(canvas, 30 + offX, 14 + offY, 2, 8, hairLight);
    _drawPixelRect(canvas, 28 + offX, 22 + offY, 2, 20, hairBase);
    _drawPixelRect(canvas, 28 + offX, 22 + offY, 1, 6, hairDark);
    _drawPixelRect(canvas, 30 + offX, 34 + offY, 2, 8, hairDark);
    _drawPixelRect(canvas, 28 + offX, 38 + offY, 2, 6, hairShadow);
    _drawPixelRect(canvas, 30 + offX, 42 + offY, 2, 4, hairShadow);
    // Hair strand highlight
    _drawPixelRect(canvas, 31 + offX, 18 + offY, 1, 6, hairLight);
    _drawPixelRect(canvas, 29 + offX, 28 + offY, 1, 4, hairMid);

    // Side hair - right (long flowing to y≈75)
    _drawPixelRect(canvas, 94 + offX, 14 + offY, 4, 28, hairBase);
    _drawPixelRect(canvas, 96 + offX, 14 + offY, 2, 8, hairLight);
    _drawPixelRect(canvas, 98 + offX, 22 + offY, 2, 20, hairBase);
    _drawPixelRect(canvas, 99 + offX, 22 + offY, 1, 6, hairDark);
    _drawPixelRect(canvas, 96 + offX, 34 + offY, 2, 8, hairDark);
    _drawPixelRect(canvas, 98 + offX, 38 + offY, 2, 6, hairShadow);
    _drawPixelRect(canvas, 96 + offX, 42 + offY, 2, 4, hairShadow);
    // Hair strand highlight
    _drawPixelRect(canvas, 96 + offX, 18 + offY, 1, 6, hairLight);
    _drawPixelRect(canvas, 98 + offX, 28 + offY, 1, 4, hairMid);
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

    // Eyes
    if (xxEyes) {
      // X_X dizzy eyes (scaled up)
      // Left X
      _drawPixelRect(canvas, 46 + offX, 28 + offY, 2, 2, eyeIris);
      _drawPixelRect(canvas, 50 + offX, 28 + offY, 2, 2, eyeIris);
      _drawPixelRect(canvas, 48 + offX, 30 + offY, 2, 2, eyeIris);
      _drawPixelRect(canvas, 44 + offX, 30 + offY, 2, 2, eyeIris);
      // Right X
      _drawPixelRect(canvas, 74 + offX, 28 + offY, 2, 2, eyeIris);
      _drawPixelRect(canvas, 78 + offX, 28 + offY, 2, 2, eyeIris);
      _drawPixelRect(canvas, 76 + offX, 30 + offY, 2, 2, eyeIris);
      _drawPixelRect(canvas, 72 + offX, 30 + offY, 2, 2, eyeIris);
    } else if (blink) {
      // Blinking - 2 pixel high curved line
      _drawPixelRect(canvas, 44 + offX, 32 + offY, 10, 2, eyeIris);
      _drawPixelRect(canvas, 74 + offX, 32 + offY, 10, 2, eyeIris);
      // Eyelashes on blink
      _drawPixelRect(canvas, 43 + offX, 31 + offY, 2, 1, eyeIrisDark);
      _drawPixelRect(canvas, 83 + offX, 31 + offY, 2, 1, eyeIrisDark);
    } else if (starEyes) {
      // Star-shaped happy eyes (cross pattern, scaled up)
      // Left star eye
      _drawPixelRect(canvas, 46 + offX, 30 + offY, 6, 2, goldLight);
      _drawPixelRect(canvas, 48 + offX, 28 + offY, 2, 6, goldLight);
      _drawPixelRect(canvas, 48 + offX, 30 + offY, 2, 2, goldAccent);
      _drawPixelRect(canvas, 46 + offX, 28 + offY, 2, 2, goldAccent);
      _drawPixelRect(canvas, 50 + offX, 28 + offY, 2, 2, goldAccent);
      _drawPixelRect(canvas, 46 + offX, 32 + offY, 2, 2, goldAccent);
      _drawPixelRect(canvas, 50 + offX, 32 + offY, 2, 2, goldAccent);
      // Right star eye
      _drawPixelRect(canvas, 74 + offX, 30 + offY, 6, 2, goldLight);
      _drawPixelRect(canvas, 76 + offX, 28 + offY, 2, 6, goldLight);
      _drawPixelRect(canvas, 76 + offX, 30 + offY, 2, 2, goldAccent);
      _drawPixelRect(canvas, 74 + offX, 28 + offY, 2, 2, goldAccent);
      _drawPixelRect(canvas, 78 + offX, 28 + offY, 2, 2, goldAccent);
      _drawPixelRect(canvas, 74 + offX, 32 + offY, 2, 2, goldAccent);
      _drawPixelRect(canvas, 78 + offX, 32 + offY, 2, 2, goldAccent);
    } else if (bigEyes) {
      // Big round shocked eyes (12 wide, 10 tall)
      // Left eye
      _drawPixelRect(canvas, 42 + offX, 26 + offY, 14, 10, eyeWhite);
      _drawPixelRect(canvas, 44 + offX, 28 + offY, 10, 8, eyeIris);
      _drawPixelRect(canvas, 46 + offX, 30 + offY, 6, 4, eyeIrisDark);
      _drawPixelRect(canvas, 48 + offX, 31 + offY, 2, 2, eyePupil);
      _drawPixelRect(canvas, 44 + offX, 26 + offY, 4, 2, eyeHighlight);
      _drawPixelRect(canvas, 46 + offX, 34 + offY, 8, 2, eyeLower);
      // Upper eyelid line
      _drawPixelRect(canvas, 42 + offX, 25 + offY, 14, 1, eyeIrisDark);
      // Eyelashes
      _drawPixelRect(canvas, 41 + offX, 25 + offY, 2, 2, eyeIrisDark);
      _drawPixelRect(canvas, 55 + offX, 25 + offY, 2, 2, eyeIrisDark);
      // Right eye
      _drawPixelRect(canvas, 72 + offX, 26 + offY, 14, 10, eyeWhite);
      _drawPixelRect(canvas, 74 + offX, 28 + offY, 10, 8, eyeIris);
      _drawPixelRect(canvas, 76 + offX, 30 + offY, 6, 4, eyeIrisDark);
      _drawPixelRect(canvas, 78 + offX, 31 + offY, 2, 2, eyePupil);
      _drawPixelRect(canvas, 74 + offX, 26 + offY, 4, 2, eyeHighlight);
      _drawPixelRect(canvas, 76 + offX, 34 + offY, 8, 2, eyeLower);
      // Upper eyelid line
      _drawPixelRect(canvas, 72 + offX, 25 + offY, 14, 1, eyeIrisDark);
      // Eyelashes
      _drawPixelRect(canvas, 71 + offX, 25 + offY, 2, 2, eyeIrisDark);
      _drawPixelRect(canvas, 85 + offX, 25 + offY, 2, 2, eyeIrisDark);
    } else if (closedEyes) {
      // Peaceful closed eyes (curved arcs, scaled up)
      _drawPixelRect(canvas, 44 + offX, 32 + offY, 10, 2, eyeIris);
      _drawPixelRect(canvas, 46 + offX, 30 + offY, 6, 2, eyeIris);
      _drawPixelRect(canvas, 74 + offX, 32 + offY, 10, 2, eyeIris);
      _drawPixelRect(canvas, 76 + offX, 30 + offY, 6, 2, eyeIris);
    } else {
      // Normal big round purple eyes (10-12 wide, 8-10 tall, 6 layers)
      // Left eye
      // Layer 1: Eye white
      _drawPixelRect(canvas, 44 + offX, 28 + offY, 12, 10, eyeWhite);
      // Layer 2: Iris
      _drawPixelRect(canvas, 46 + offX, 30 + offY, 8, 6, eyeIris);
      // Layer 3: Dark iris
      _drawPixelRect(canvas, 48 + offX, 31 + offY, 4, 4, eyeIrisDark);
      // Layer 4: Pupil
      _drawPixelRect(canvas, 49 + offX, 32 + offY, 2, 2, eyePupil);
      // Layer 5: Highlight (top-left)
      _drawPixelRect(canvas, 46 + offX, 28 + offY, 4, 2, eyeHighlight);
      _drawPixelRect(canvas, 46 + offX, 28 + offY, 2, 1, eyeHighlight);
      // Layer 6: Lower eyelid (aegyo sal)
      _drawPixelRect(canvas, 46 + offX, 36 + offY, 8, 2, eyeLower);
      // Upper eyelid line
      _drawPixelRect(canvas, 44 + offX, 27 + offY, 12, 1, eyeIrisDark);
      // Eyelashes
      _drawPixelRect(canvas, 43 + offX, 27 + offY, 2, 2, eyeIrisDark);
      _drawPixelRect(canvas, 55 + offX, 27 + offY, 2, 2, eyeIrisDark);
      _drawPixelRect(canvas, 44 + offX, 26 + offY, 1, 1, eyeIrisDark);

      // Right eye
      // Layer 1: Eye white
      _drawPixelRect(canvas, 72 + offX, 28 + offY, 12, 10, eyeWhite);
      // Layer 2: Iris
      _drawPixelRect(canvas, 74 + offX, 30 + offY, 8, 6, eyeIris);
      // Layer 3: Dark iris
      _drawPixelRect(canvas, 76 + offX, 31 + offY, 4, 4, eyeIrisDark);
      // Layer 4: Pupil
      _drawPixelRect(canvas, 77 + offX, 32 + offY, 2, 2, eyePupil);
      // Layer 5: Highlight (top-left)
      _drawPixelRect(canvas, 74 + offX, 28 + offY, 4, 2, eyeHighlight);
      _drawPixelRect(canvas, 74 + offX, 28 + offY, 2, 1, eyeHighlight);
      // Layer 6: Lower eyelid (aegyo sal)
      _drawPixelRect(canvas, 74 + offX, 36 + offY, 8, 2, eyeLower);
      // Upper eyelid line
      _drawPixelRect(canvas, 72 + offX, 27 + offY, 12, 1, eyeIrisDark);
      // Eyelashes
      _drawPixelRect(canvas, 71 + offX, 27 + offY, 2, 2, eyeIrisDark);
      _drawPixelRect(canvas, 83 + offX, 27 + offY, 2, 2, eyeIrisDark);
      _drawPixelRect(canvas, 83 + offX, 26 + offY, 1, 1, eyeIrisDark);
    }

    // Nose - 2 pixels
    _drawPixelRect(canvas, 63 + offX, 38 + offY, 2, 2, skinShadow);

    // Blush - elliptical 8x4
    _drawPixelRect(canvas, 42 + offX, 36 + offY, 8, 4, blush);
    _drawPixelRect(canvas, 44 + offX, 35 + offY, 4, 1, blush);
    _drawPixelRect(canvas, 78 + offX, 36 + offY, 8, 4, blush);
    _drawPixelRect(canvas, 80 + offX, 35 + offY, 4, 1, blush);

    // Mouth
    if (openMouth) {
      // O-shaped open mouth (scaled up)
      _drawPixelRect(canvas, 58 + offX, 42 + offY, 8, 6, mouth);
      _drawPixelRect(canvas, 60 + offX, 40 + offY, 4, 2, mouth);
      _drawPixelRect(canvas, 60 + offX, 48 + offY, 4, 2, mouth);
      _drawPixelRect(canvas, 60 + offX, 42 + offY, 4, 4, skinDark);
      _drawPixelRect(canvas, 61 + offX, 43 + offY, 2, 2, skinDark);
    } else if (wavyMouth) {
      // Wavy confused mouth (scaled up)
      _drawPixelRect(canvas, 56 + offX, 42 + offY, 4, 2, mouth);
      _drawPixelRect(canvas, 62 + offX, 44 + offY, 4, 2, mouth);
      _drawPixelRect(canvas, 68 + offX, 42 + offY, 4, 2, mouth);
    } else if (bigSmile) {
      // Big arc smile (scaled up)
      _drawPixelRect(canvas, 54 + offX, 42 + offY, 16, 2, mouth);
      _drawPixelRect(canvas, 52 + offX, 40 + offY, 2, 2, mouth);
      _drawPixelRect(canvas, 70 + offX, 40 + offY, 2, 2, mouth);
      _drawPixelRect(canvas, 56 + offX, 44 + offY, 12, 2, mouth);
      _drawPixelRect(canvas, 58 + offX, 44 + offY, 8, 2, skinDark);
    } else {
      // Omega-shaped smile (5-6 pixels wide, scaled up)
      _drawPixelRect(canvas, 58 + offX, 42 + offY, 8, 2, mouth);
      _drawPixelRect(canvas, 56 + offX, 40 + offY, 2, 2, mouth);
      _drawPixelRect(canvas, 66 + offX, 40 + offY, 2, 2, mouth);
      _drawPixelRect(canvas, 60 + offX, 44 + offY, 4, 2, mouth);
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

    // Collar / neckline with white inner collar
    _drawPixelRect(canvas, 46 + offX, 48 + offY, 36, 4, clothLight);
    _drawPixelRect(canvas, 50 + offX, 48 + offY, 28, 2, skinBase);
    // White inner collar peek
    _drawPixelRect(canvas, 52 + offX, 49 + offY, 24, 2, skinLight);

    // Ribbon at collar (scaled up)
    _drawPixelRect(canvas, 58 + offX, 48 + offY, 8, 6, ribbon);
    _drawPixelRect(canvas, 56 + offX, 50 + offY, 2, 2, ribbon);
    _drawPixelRect(canvas, 66 + offX, 50 + offY, 2, 2, ribbon);
    _drawPixelRect(canvas, 60 + offX, 52 + offY, 4, 2, goldAccent);
    // Ribbon tails
    _drawPixelRect(canvas, 58 + offX, 54 + offY, 2, 4, ribbon);
    _drawPixelRect(canvas, 64 + offX, 54 + offY, 2, 4, ribbon);

    // Gold embroidery lines (scaled up)
    _drawPixelRect(canvas, 44 + offX, 54 + offY, 2, 12, goldAccent);
    _drawPixelRect(canvas, 82 + offX, 54 + offY, 2, 12, goldAccent);
    _drawPixelRect(canvas, 48 + offX, 64 + offY, 32, 2, goldAccent);
    // Additional gold detail
    _drawPixelRect(canvas, 50 + offX, 68 + offY, 28, 1, goldLight);

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

    // Gold armbands
    _drawPixelRect(canvas, 32 + offX, 54 + offY, 6, 2, goldAccent);
    _drawPixelRect(canvas, 90 + offX, 54 + offY, 6, 2, goldAccent);
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
    // Gold buckles
    _drawPixelRect(canvas, 48 + offX, 94 + offY, 4, 2, goldAccent);
    _drawPixelRect(canvas, 76 + offX, 94 + offY, 4, 2, goldAccent);
    // Shoe sole
    _drawPixelRect(canvas, 44 + offX, 98 + offY, 12, 2, hairDark);
    _drawPixelRect(canvas, 72 + offX, 98 + offY, 12, 2, hairDark);
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
    // Tail highlight
    _drawPixelRect(canvas, 8 + offX + wagX, 58 + offY, 2, 2, hairLight);
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
    // Gold armbands
    _drawPixelRect(canvas, 32, 34 + bounce, 6, 2, goldAccent);
    _drawPixelRect(canvas, 90, 34 + bounce, 6, 2, goldAccent);

    // Head / Face with star eyes and big smile
    _drawFace(canvas, 0, bounce, starEyes: true, bigSmile: true);

    // Hair
    _drawHair(canvas, 0, bounce);

    // Cat ears
    _drawEars(canvas, 0, bounce);

    // Sparkles
    if (frame % 2 == 0) {
      _drawPixelRect(canvas, 20, 16 + bounce, 2, 2, goldLight);
      _drawPixelRect(canvas, 104, 20 + bounce, 2, 2, goldLight);
      _drawPixelRect(canvas, 14, 36 + bounce, 2, 2, goldAccent);
      _drawPixelRect(canvas, 108, 32 + bounce, 2, 2, goldAccent);
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
    _drawPixelRect(canvas, 32, 54, 6, 2, goldAccent);
    _drawPixelRect(canvas, 90, 30, 6, 16, clothBase);
    _drawPixelRect(canvas, 94, 30, 2, 6, clothLight);
    _drawPixelRect(canvas, 90, 46, 6, 4, skinBase);
    _drawPixelRect(canvas, 90, 30, 6, 2, goldAccent);

    // Head / Face with wavy mouth
    _drawFace(canvas, tilt, 0, wavyMouth: true);

    // Hair
    _drawHair(canvas, tilt, 0);

    // Cat ears - right ear droopy
    _drawEars(canvas, tilt, 0, rightDroopy: true);

    // Question mark (scaled up)
    _drawPixelRect(canvas, 98, 10, 2, 2, goldAccent);
    _drawPixelRect(canvas, 100, 10, 2, 2, goldAccent);
    _drawPixelRect(canvas, 100, 12, 2, 2, goldAccent);
    _drawPixelRect(canvas, 100, 14, 2, 2, goldAccent);
    _drawPixelRect(canvas, 100, 16, 2, 2, goldAccent);
    _drawPixelRect(canvas, 98, 18, 2, 2, goldAccent);
    _drawPixelRect(canvas, 98, 20, 2, 2, goldAccent);
    _drawPixelRect(canvas, 100, 20, 2, 2, goldAccent);
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

    // Sweat drop (scaled up)
    _drawPixelRect(canvas, 94 - slideX, 24, 4, 6, Color(0xFF66CCFF));
    _drawPixelRect(canvas, 94 - slideX, 22, 2, 2, Color(0xFF88DDFF));
    _drawPixelRect(canvas, 96 - slideX, 20, 2, 2, Color(0xFFAAEEFF));

    // Motion lines
    for (int i = 0; i < 3; i++) {
      _drawPixelRect(canvas, 106 + i * 4 - slideX, 36 + i * 8, 2, 6, Color(0xFFFFFFFF).withValues(alpha: 0.5));
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
    _drawPixelRect(canvas, 10, 46 + breathe, 2, 2, earInner);
    _drawPixelRect(canvas, 10, 48 + breathe, 2, 2, earFur);

    // Closed eyes (peaceful arcs)
    _drawPixelRect(canvas, 14, 60 + breathe, 8, 2, eyeIris);
    _drawPixelRect(canvas, 16, 58 + breathe, 4, 2, eyeIris);

    // Peaceful mouth
    _drawPixelRect(canvas, 16, 64 + breathe, 6, 2, mouth);

    // Blush
    _drawPixelRect(canvas, 12, 62 + breathe, 6, 2, blush);
    _drawPixelRect(canvas, 24, 62 + breathe, 6, 2, blush);

    // Feet
    _drawPixelRect(canvas, 82, 68 + breathe, 8, 6, skinBase);
    _drawPixelRect(canvas, 82, 72 + breathe, 8, 2, skinShadow);

    // Zzz (floating, scaled up)
    _drawPixelRect(canvas, 36, 46 + breathe, 4, 4, goldLight);
    _drawPixelRect(canvas, 42, 40 + breathe, 4, 4, goldLight);
    _drawPixelRect(canvas, 48, 34 + breathe, 6, 4, goldLight);
    _drawPixelRect(canvas, 56, 28 + breathe, 6, 4, goldLight);
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

    // Hair (spread out)
    _drawPixelRect(canvas, 24, 34, 80, 12, hairBase);
    _drawPixelRect(canvas, 32, 34, 28, 4, hairLight);
    _drawPixelRect(canvas, 64, 36, 16, 2, hairMid);
    _drawPixelRect(canvas, 24, 42, 4, 16, hairBase);
    _drawPixelRect(canvas, 100, 42, 4, 16, hairBase);
    _drawPixelRect(canvas, 24, 42, 80, 2, hairDark);
    // Hair highlight lines
    _drawPixelRect(canvas, 36, 36, 2, 4, hairLight);
    _drawPixelRect(canvas, 68, 38, 2, 4, hairLight);

    // Cat ears (flattened)
    _drawPixelRect(canvas, 20, 30, 12, 6, hairBase);
    _drawPixelRect(canvas, 24, 30, 6, 4, earInner);
    _drawPixelRect(canvas, 24, 32, 4, 2, earFur);
    _drawPixelRect(canvas, 96, 30, 12, 6, hairBase);
    _drawPixelRect(canvas, 100, 30, 6, 4, earInner);
    _drawPixelRect(canvas, 100, 32, 4, 2, earFur);

    // X_X eyes (scaled up)
    _drawPixelRect(canvas, 42, 50, 2, 2, eyeIris);
    _drawPixelRect(canvas, 48, 50, 2, 2, eyeIris);
    _drawPixelRect(canvas, 45, 52, 2, 2, eyeIris);
    _drawPixelRect(canvas, 39, 52, 2, 2, eyeIris);
    _drawPixelRect(canvas, 82, 50, 2, 2, eyeIris);
    _drawPixelRect(canvas, 88, 50, 2, 2, eyeIris);
    _drawPixelRect(canvas, 85, 52, 2, 2, eyeIris);
    _drawPixelRect(canvas, 79, 52, 2, 2, eyeIris);

    // Wavy mouth
    _drawPixelRect(canvas, 54, 56, 6, 2, mouth);
    _drawPixelRect(canvas, 66, 56, 6, 2, mouth);

    // Blush (8x4)
    _drawPixelRect(canvas, 38, 54, 8, 4, blush);
    _drawPixelRect(canvas, 84, 54, 8, 4, blush);

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
    _drawPixelRect(canvas, 26 + shake, 38, 6, 2, goldAccent);
    _drawPixelRect(canvas, 96 + shake, 38, 6, 2, goldAccent);

    // Head / Face with big eyes and O mouth
    _drawFace(canvas, shake, 0, bigEyes: true, openMouth: true);

    // Hair
    _drawHair(canvas, shake, 0);

    // Cat ears (straight up, alert)
    _drawEars(canvas, shake, 0);

    // Sweat drops (scaled up)
    _drawPixelRect(canvas, 94 + shake, 20, 4, 6, Color(0xFF66CCFF));
    _drawPixelRect(canvas, 94 + shake, 18, 2, 2, Color(0xFF88DDFF));
    _drawPixelRect(canvas, 96 + shake, 16, 2, 2, Color(0xFFAAEEFF));
    _drawPixelRect(canvas, 38 + shake, 20, 2, 4, Color(0xFF66CCFF));
    _drawPixelRect(canvas, 38 + shake, 18, 2, 2, Color(0xFF88DDFF));

    // Exclamation marks (scaled up)
    _drawPixelRect(canvas, 102, 8, 2, 6, goldAccent);
    _drawPixelRect(canvas, 102, 16, 2, 2, goldAccent);
    _drawPixelRect(canvas, 108, 10, 2, 6, goldAccent);
    _drawPixelRect(canvas, 108, 18, 2, 2, goldAccent);
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
      _drawPixelRect(canvas, 26, 30 + jumpHeight, 6, 2, goldAccent);
      _drawPixelRect(canvas, 96, 54 + jumpHeight, 6, 16, clothBase);
      _drawPixelRect(canvas, 96, 70 + jumpHeight, 6, 4, skinBase);
      _drawPixelRect(canvas, 96, 54 + jumpHeight, 6, 2, goldAccent);
    } else {
      // Right arm up, left arm out
      _drawPixelRect(canvas, 96, 30 + jumpHeight, 6, 20, clothBase);
      _drawPixelRect(canvas, 100, 30 + jumpHeight, 2, 6, clothLight);
      _drawPixelRect(canvas, 100, 26 + jumpHeight, 6, 6, clothBase);
      _drawPixelRect(canvas, 100, 22 + jumpHeight, 6, 6, clothBase);
      _drawPixelRect(canvas, 100, 20 + jumpHeight, 6, 4, skinBase);
      _drawPixelRect(canvas, 104, 20 + jumpHeight, 2, 2, skinLight);
      _drawPixelRect(canvas, 96, 30 + jumpHeight, 6, 2, goldAccent);
      _drawPixelRect(canvas, 26, 54 + jumpHeight, 6, 16, clothBase);
      _drawPixelRect(canvas, 26, 70 + jumpHeight, 6, 4, skinBase);
      _drawPixelRect(canvas, 26, 54 + jumpHeight, 6, 2, goldAccent);
    }

    // Head / Face with star eyes and big smile
    _drawFace(canvas, 0, jumpHeight, starEyes: true, bigSmile: true);

    // Hair
    _drawHair(canvas, 0, jumpHeight);

    // Cat ears
    _drawEars(canvas, 0, jumpHeight);

    // Sparkles around (scaled up)
    if (frame % 2 == 0) {
      _drawPixelRect(canvas, 12, 12 + jumpHeight, 4, 4, goldLight);
      _drawPixelRect(canvas, 112, 16 + jumpHeight, 4, 4, goldLight);
      _drawPixelRect(canvas, 8, 38 + jumpHeight, 2, 2, goldAccent);
      _drawPixelRect(canvas, 116, 32 + jumpHeight, 2, 2, goldAccent);
    } else {
      _drawPixelRect(canvas, 16, 24 + jumpHeight, 2, 2, goldLight);
      _drawPixelRect(canvas, 108, 10 + jumpHeight, 2, 2, goldLight);
      _drawPixelRect(canvas, 10, 50 + jumpHeight, 2, 2, goldAccent);
      _drawPixelRect(canvas, 114, 44 + jumpHeight, 2, 2, goldAccent);
    }
  }

  @override
  bool shouldRepaint(covariant CatGirlPainter oldDelegate) {
    return oldDelegate.state != state || oldDelegate.frame != frame;
  }
}
