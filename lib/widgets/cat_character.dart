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
      width: 160,
      height: 160,
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

  // === Kawaii Cat Girl Color Palette ===

  // Hair - golden/light brown, 4 layers
  static const hairLight = Color(0xFFF5D585);   // golden highlight
  static const hairBase = Color(0xFFD4A040);    // golden base
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

  // Clothing - dark coat, 3 layers
  static const clothBase = Color(0xFF555565);   // dark gray-blue base
  static const clothLight = Color(0xFF707080);  // light highlight
  static const clothDark = Color(0xFF404050);   // dark shadow

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
    canvas.scale(size.width / 64, size.height / 64);

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
  // Helper: Draw cat ears (hoodie style, large and prominent)
  // ============================================================
  void _drawEars(Canvas canvas, double offX, double offY, {bool rightDroopy = false}) {
    // Left ear - tall triangle, 5 rows high
    _drawPixelRect(canvas, 18 + offX, 6 + offY, 1, 1, hairBase);
    _drawPixelRect(canvas, 17 + offX, 6 + offY, 1, 1, hairLight);
    _drawPixelRect(canvas, 17 + offX, 7 + offY, 4, 1, hairBase);
    _drawPixelRect(canvas, 17 + offX, 8 + offY, 5, 1, hairBase);
    _drawPixelRect(canvas, 18 + offX, 9 + offY, 3, 1, hairBase);
    _drawPixelRect(canvas, 19 + offX, 10 + offY, 1, 1, hairBase);
    // Left ear inner
    _drawPixelRect(canvas, 18 + offX, 7 + offY, 2, 1, earInner);
    _drawPixelRect(canvas, 18 + offX, 8 + offY, 3, 1, earInner);
    _drawPixelRect(canvas, 19 + offX, 8 + offY, 1, 1, earFur);
    _drawPixelRect(canvas, 18 + offX, 9 + offY, 2, 1, earFur);

    // Right ear
    if (rightDroopy) {
      // Droopy right ear - tilted to the side
      _drawPixelRect(canvas, 39 + offX, 10 + offY, 4, 1, hairBase);
      _drawPixelRect(canvas, 40 + offX, 9 + offY, 3, 1, hairBase);
      _drawPixelRect(canvas, 41 + offX, 8 + offY, 2, 1, hairBase);
      _drawPixelRect(canvas, 40 + offX, 10 + offY, 2, 1, earInner);
      _drawPixelRect(canvas, 41 + offX, 9 + offY, 1, 1, earFur);
    } else {
      // Normal right ear - tall triangle, 5 rows high
      _drawPixelRect(canvas, 42 + offX, 6 + offY, 1, 1, hairLight);
      _drawPixelRect(canvas, 43 + offX, 6 + offY, 1, 1, hairBase);
      _drawPixelRect(canvas, 43 + offX, 7 + offY, 4, 1, hairBase);
      _drawPixelRect(canvas, 42 + offX, 8 + offY, 5, 1, hairBase);
      _drawPixelRect(canvas, 43 + offX, 9 + offY, 3, 1, hairBase);
      _drawPixelRect(canvas, 44 + offX, 10 + offY, 1, 1, hairBase);
      // Right ear inner
      _drawPixelRect(canvas, 44 + offX, 7 + offY, 2, 1, earInner);
      _drawPixelRect(canvas, 43 + offX, 8 + offY, 3, 1, earInner);
      _drawPixelRect(canvas, 44 + offX, 8 + offY, 1, 1, earFur);
      _drawPixelRect(canvas, 44 + offX, 9 + offY, 2, 1, earFur);
    }
  }

  // ============================================================
  // Helper: Draw hair (golden, layered, with bangs and side hair)
  // ============================================================
  void _drawHair(Canvas canvas, double offX, double offY) {
    // Top hair volume - back layer (darkest)
    _drawPixelRect(canvas, 18 + offX, 8 + offY, 28, 2, hairShadow);

    // Top hair volume - main layer
    _drawPixelRect(canvas, 17 + offX, 8 + offY, 30, 3, hairBase);
    // Top highlight
    _drawPixelRect(canvas, 22 + offX, 8 + offY, 8, 1, hairLight);
    _drawPixelRect(canvas, 30 + offX, 9 + offY, 4, 1, hairLight);

    // Bangs - layered strands
    // Left bangs
    _drawPixelRect(canvas, 17 + offX, 11 + offY, 4, 2, hairBase);
    _drawPixelRect(canvas, 17 + offX, 11 + offY, 2, 1, hairLight);
    _drawPixelRect(canvas, 21 + offX, 11 + offY, 3, 3, hairBase);
    _drawPixelRect(canvas, 21 + offX, 11 + offY, 1, 1, hairLight);
    _drawPixelRect(canvas, 24 + offX, 11 + offY, 3, 2, hairDark);
    _drawPixelRect(canvas, 24 + offX, 11 + offY, 1, 1, hairBase);
    // Center bangs
    _drawPixelRect(canvas, 27 + offX, 11 + offY, 4, 2, hairBase);
    _drawPixelRect(canvas, 28 + offX, 11 + offY, 2, 1, hairLight);
    _drawPixelRect(canvas, 31 + offX, 11 + offY, 3, 3, hairBase);
    _drawPixelRect(canvas, 31 + offX, 11 + offY, 1, 1, hairLight);
    // Right bangs
    _drawPixelRect(canvas, 34 + offX, 11 + offY, 4, 2, hairBase);
    _drawPixelRect(canvas, 34 + offX, 11 + offY, 1, 1, hairLight);
    _drawPixelRect(canvas, 38 + offX, 11 + offY, 3, 2, hairDark);
    _drawPixelRect(canvas, 41 + offX, 11 + offY, 4, 2, hairBase);
    _drawPixelRect(canvas, 43 + offX, 11 + offY, 2, 1, hairLight);

    // Side hair - left (long flowing)
    _drawPixelRect(canvas, 16 + offX, 12 + offY, 2, 12, hairBase);
    _drawPixelRect(canvas, 16 + offX, 12 + offY, 1, 4, hairLight);
    _drawPixelRect(canvas, 15 + offX, 16 + offY, 1, 8, hairBase);
    _drawPixelRect(canvas, 15 + offX, 16 + offY, 1, 3, hairDark);
    _drawPixelRect(canvas, 16 + offX, 20 + offY, 1, 4, hairDark);
    _drawPixelRect(canvas, 15 + offX, 22 + offY, 1, 2, hairShadow);

    // Side hair - right (long flowing)
    _drawPixelRect(canvas, 46 + offX, 12 + offY, 2, 12, hairBase);
    _drawPixelRect(canvas, 47 + offX, 12 + offY, 1, 4, hairLight);
    _drawPixelRect(canvas, 48 + offX, 16 + offY, 1, 8, hairBase);
    _drawPixelRect(canvas, 48 + offX, 16 + offY, 1, 3, hairDark);
    _drawPixelRect(canvas, 47 + offX, 20 + offY, 1, 4, hairDark);
    _drawPixelRect(canvas, 48 + offX, 22 + offY, 1, 2, hairShadow);
  }

  // ============================================================
  // Helper: Draw face with detailed eyes, blush, nose, mouth
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
    _drawPixelRect(canvas, 20 + offX, 13 + offY, 24, 14, skinBase);
    // Face highlight (forehead and cheeks)
    _drawPixelRect(canvas, 22 + offX, 13 + offY, 10, 2, skinLight);
    _drawPixelRect(canvas, 24 + offX, 14 + offY, 6, 1, skinLight);
    // Face shadow (sides and chin)
    _drawPixelRect(canvas, 20 + offX, 13 + offY, 2, 10, skinShadow);
    _drawPixelRect(canvas, 42 + offX, 13 + offY, 2, 10, skinShadow);
    _drawPixelRect(canvas, 22 + offX, 25 + offY, 20, 2, skinShadow);
    _drawPixelRect(canvas, 24 + offX, 26 + offY, 16, 1, skinDark);

    // Eyes
    if (xxEyes) {
      // X_X dizzy eyes
      _drawPixelRect(canvas, 24 + offX, 17 + offY, 1, 1, eyeIris);
      _drawPixelRect(canvas, 26 + offX, 17 + offY, 1, 1, eyeIris);
      _drawPixelRect(canvas, 25 + offX, 18 + offY, 1, 1, eyeIris);
      _drawPixelRect(canvas, 23 + offX, 18 + offY, 1, 1, eyeIris);
      _drawPixelRect(canvas, 36 + offX, 17 + offY, 1, 1, eyeIris);
      _drawPixelRect(canvas, 38 + offX, 17 + offY, 1, 1, eyeIris);
      _drawPixelRect(canvas, 37 + offX, 18 + offY, 1, 1, eyeIris);
      _drawPixelRect(canvas, 35 + offX, 18 + offY, 1, 1, eyeIris);
    } else if (blink) {
      // Blinking - 1 pixel high line
      _drawPixelRect(canvas, 23 + offX, 18 + offY, 5, 1, eyeIris);
      _drawPixelRect(canvas, 35 + offX, 18 + offY, 5, 1, eyeIris);
    } else if (starEyes) {
      // Star-shaped happy eyes (cross pattern)
      // Left star eye
      _drawPixelRect(canvas, 24 + offX, 17 + offY, 3, 1, goldLight);
      _drawPixelRect(canvas, 25 + offX, 16 + offY, 1, 1, goldLight);
      _drawPixelRect(canvas, 25 + offX, 18 + offY, 1, 1, goldLight);
      _drawPixelRect(canvas, 25 + offX, 17 + offY, 1, 1, goldAccent);
      _drawPixelRect(canvas, 24 + offX, 16 + offY, 1, 1, goldAccent);
      _drawPixelRect(canvas, 26 + offX, 16 + offY, 1, 1, goldAccent);
      _drawPixelRect(canvas, 24 + offX, 18 + offY, 1, 1, goldAccent);
      _drawPixelRect(canvas, 26 + offX, 18 + offY, 1, 1, goldAccent);
      // Right star eye
      _drawPixelRect(canvas, 36 + offX, 17 + offY, 3, 1, goldLight);
      _drawPixelRect(canvas, 37 + offX, 16 + offY, 1, 1, goldLight);
      _drawPixelRect(canvas, 37 + offX, 18 + offY, 1, 1, goldLight);
      _drawPixelRect(canvas, 37 + offX, 17 + offY, 1, 1, goldAccent);
      _drawPixelRect(canvas, 36 + offX, 16 + offY, 1, 1, goldAccent);
      _drawPixelRect(canvas, 38 + offX, 16 + offY, 1, 1, goldAccent);
      _drawPixelRect(canvas, 36 + offX, 18 + offY, 1, 1, goldAccent);
      _drawPixelRect(canvas, 38 + offX, 18 + offY, 1, 1, goldAccent);
    } else if (bigEyes) {
      // Big round shocked eyes (6 wide, 5 tall)
      // Left eye
      _drawPixelRect(canvas, 22 + offX, 15 + offY, 7, 6, eyeWhite);
      _drawPixelRect(canvas, 23 + offX, 16 + offY, 5, 4, eyeIris);
      _drawPixelRect(canvas, 24 + offX, 17 + offY, 3, 2, eyeIrisDark);
      _drawPixelRect(canvas, 25 + offX, 17 + offY, 1, 2, eyePupil);
      _drawPixelRect(canvas, 23 + offX, 15 + offY, 2, 1, eyeHighlight);
      _drawPixelRect(canvas, 24 + offX, 20 + offY, 4, 1, eyeLower);
      // Right eye
      _drawPixelRect(canvas, 34 + offX, 15 + offY, 7, 6, eyeWhite);
      _drawPixelRect(canvas, 35 + offX, 16 + offY, 5, 4, eyeIris);
      _drawPixelRect(canvas, 36 + offX, 17 + offY, 3, 2, eyeIrisDark);
      _drawPixelRect(canvas, 37 + offX, 17 + offY, 1, 2, eyePupil);
      _drawPixelRect(canvas, 35 + offX, 15 + offY, 2, 1, eyeHighlight);
      _drawPixelRect(canvas, 36 + offX, 20 + offY, 4, 1, eyeLower);
    } else if (closedEyes) {
      // Peaceful closed eyes (curved arcs)
      _drawPixelRect(canvas, 23 + offX, 18 + offY, 5, 1, eyeIris);
      _drawPixelRect(canvas, 24 + offX, 17 + offY, 3, 1, eyeIris);
      _drawPixelRect(canvas, 35 + offX, 18 + offY, 5, 1, eyeIris);
      _drawPixelRect(canvas, 36 + offX, 17 + offY, 3, 1, eyeIris);
    } else {
      // Normal big round purple eyes (5 wide, 4 tall)
      // Left eye
      _drawPixelRect(canvas, 23 + offX, 16 + offY, 5, 4, eyeWhite);
      _drawPixelRect(canvas, 24 + offX, 17 + offY, 3, 2, eyeIris);
      _drawPixelRect(canvas, 25 + offX, 17 + offY, 1, 2, eyeIrisDark);
      _drawPixelRect(canvas, 25 + offX, 18 + offY, 1, 1, eyePupil);
      _drawPixelRect(canvas, 24 + offX, 16 + offY, 2, 1, eyeHighlight);
      _drawPixelRect(canvas, 24 + offX, 19 + offY, 3, 1, eyeLower);
      // Right eye
      _drawPixelRect(canvas, 35 + offX, 16 + offY, 5, 4, eyeWhite);
      _drawPixelRect(canvas, 36 + offX, 17 + offY, 3, 2, eyeIris);
      _drawPixelRect(canvas, 37 + offX, 17 + offY, 1, 2, eyeIrisDark);
      _drawPixelRect(canvas, 37 + offX, 18 + offY, 1, 1, eyePupil);
      _drawPixelRect(canvas, 36 + offX, 16 + offY, 2, 1, eyeHighlight);
      _drawPixelRect(canvas, 36 + offX, 19 + offY, 3, 1, eyeLower);
    }

    // Nose - 1 pixel
    _drawPixel(canvas, 31 + offX, 21 + offY, skinShadow);

    // Blush - elliptical 4x2
    _drawPixelRect(canvas, 22 + offX, 20 + offY, 4, 2, blush);
    _drawPixelRect(canvas, 37 + offX, 20 + offY, 4, 2, blush);

    // Mouth
    if (openMouth) {
      // O-shaped open mouth
      _drawPixelRect(canvas, 29 + offX, 23 + offY, 4, 3, mouth);
      _drawPixelRect(canvas, 30 + offX, 22 + offY, 2, 1, mouth);
      _drawPixelRect(canvas, 30 + offX, 25 + offY, 2, 1, mouth);
      _drawPixelRect(canvas, 30 + offX, 23 + offY, 2, 2, skinDark);
    } else if (wavyMouth) {
      // Wavy confused mouth
      _drawPixelRect(canvas, 28 + offX, 23 + offY, 2, 1, mouth);
      _drawPixelRect(canvas, 31 + offX, 23 + offY, 2, 1, mouth);
      _drawPixelRect(canvas, 34 + offX, 23 + offY, 2, 1, mouth);
    } else if (bigSmile) {
      // Big arc smile
      _drawPixelRect(canvas, 27 + offX, 23 + offY, 8, 1, mouth);
      _drawPixelRect(canvas, 26 + offX, 22 + offY, 1, 1, mouth);
      _drawPixelRect(canvas, 35 + offX, 22 + offY, 1, 1, mouth);
      _drawPixelRect(canvas, 28 + offX, 24 + offY, 6, 1, mouth);
      _drawPixelRect(canvas, 29 + offX, 24 + offY, 4, 1, skinDark);
    } else {
      // Omega-shaped smile (3 pixels wide)
      _drawPixelRect(canvas, 29 + offX, 23 + offY, 4, 1, mouth);
      _drawPixelRect(canvas, 28 + offX, 22 + offY, 1, 1, mouth);
      _drawPixelRect(canvas, 33 + offX, 22 + offY, 1, 1, mouth);
      _drawPixelRect(canvas, 30 + offX, 24 + offY, 2, 1, mouth);
    }
  }

  // ============================================================
  // Helper: Draw body with dark coat, ribbon, gold embroidery
  // ============================================================
  void _drawBody(Canvas canvas, double offX, double offY) {
    // Coat body - main
    _drawPixelRect(canvas, 20 + offX, 28 + offY, 24, 16, clothBase);
    // Coat highlight (center chest)
    _drawPixelRect(canvas, 26 + offX, 28 + offY, 8, 3, clothLight);
    _drawPixelRect(canvas, 28 + offX, 31 + offY, 4, 2, clothLight);
    // Coat shadow (sides)
    _drawPixelRect(canvas, 20 + offX, 28 + offY, 3, 14, clothDark);
    _drawPixelRect(canvas, 41 + offX, 28 + offY, 3, 14, clothDark);
    // Coat bottom shadow
    _drawPixelRect(canvas, 22 + offX, 42 + offY, 20, 2, clothDark);

    // Collar / neckline
    _drawPixelRect(canvas, 24 + offX, 27 + offY, 16, 2, clothLight);
    _drawPixelRect(canvas, 26 + offX, 27 + offY, 12, 1, skinBase);

    // Ribbon at collar (3-4 pixels)
    _drawPixelRect(canvas, 30 + offX, 27 + offY, 4, 3, ribbon);
    _drawPixelRect(canvas, 29 + offX, 28 + offY, 1, 1, ribbon);
    _drawPixelRect(canvas, 34 + offX, 28 + offY, 1, 1, ribbon);
    _drawPixelRect(canvas, 31 + offX, 29 + offY, 2, 1, goldAccent);
    // Ribbon tails
    _drawPixelRect(canvas, 30 + offX, 30 + offY, 1, 2, ribbon);
    _drawPixelRect(canvas, 33 + offX, 30 + offY, 1, 2, ribbon);

    // Gold embroidery lines
    _drawPixelRect(canvas, 23 + offX, 30 + offY, 1, 6, goldAccent);
    _drawPixelRect(canvas, 40 + offX, 30 + offY, 1, 6, goldAccent);
    _drawPixelRect(canvas, 25 + offX, 35 + offY, 14, 1, goldAccent);

    // Arms
    _drawPixelRect(canvas, 17 + offX, 30 + offY, 3, 10, clothBase);
    _drawPixelRect(canvas, 17 + offX, 30 + offY, 1, 4, clothLight);
    _drawPixelRect(canvas, 44 + offX, 30 + offY, 3, 10, clothBase);
    _drawPixelRect(canvas, 46 + offX, 30 + offY, 1, 4, clothLight);
    // Hands (skin)
    _drawPixelRect(canvas, 17 + offX, 40 + offY, 3, 2, skinBase);
    _drawPixelRect(canvas, 44 + offX, 40 + offY, 3, 2, skinBase);

    // Gold armbands
    _drawPixelRect(canvas, 17 + offX, 30 + offY, 3, 1, goldAccent);
    _drawPixelRect(canvas, 44 + offX, 30 + offY, 3, 1, goldAccent);
  }

  // ============================================================
  // Helper: Draw legs and shoes
  // ============================================================
  void _drawLegs(Canvas canvas, double offX, double offY) {
    // Legs
    _drawPixelRect(canvas, 24 + offX, 44 + offY, 4, 6, skinBase);
    _drawPixelRect(canvas, 36 + offX, 44 + offY, 4, 6, skinBase);
    // Leg shadow
    _drawPixelRect(canvas, 24 + offX, 48 + offY, 4, 2, skinShadow);
    _drawPixelRect(canvas, 36 + offX, 48 + offY, 4, 2, skinShadow);
    // Shoes
    _drawPixelRect(canvas, 23 + offX, 50 + offY, 6, 2, clothDark);
    _drawPixelRect(canvas, 35 + offX, 50 + offY, 6, 2, clothDark);
    // Shoe highlight
    _drawPixelRect(canvas, 24 + offX, 50 + offY, 4, 1, clothBase);
    _drawPixelRect(canvas, 36 + offX, 50 + offY, 4, 1, clothBase);
    // Gold buckles
    _drawPixelRect(canvas, 25 + offX, 50 + offY, 2, 1, goldAccent);
    _drawPixelRect(canvas, 37 + offX, 50 + offY, 2, 1, goldAccent);
  }

  // ============================================================
  // Helper: Draw tail
  // ============================================================
  void _drawTail(Canvas canvas, double offX, double offY, {double wagX = 0}) {
    _drawPixelRect(canvas, 6 + offX + wagX, 34 + offY, 3, 1, hairBase);
    _drawPixelRect(canvas, 5 + offX + wagX, 33 + offY, 2, 1, hairBase);
    _drawPixelRect(canvas, 4 + offX + wagX, 32 + offY, 2, 1, hairBase);
    _drawPixelRect(canvas, 4 + offX + wagX, 31 + offY, 2, 1, hairLight);
    // Tail tip
    _drawPixelRect(canvas, 3 + offX + wagX, 30 + offY, 2, 1, hairLight);
  }

  // ============================================================
  // IDLE: Standing with breathing animation
  // ============================================================
  void _drawIdle(Canvas canvas) {
    // Breathing: frame 0,2 body down 0.5; frame 1,3 body up 0.5
    final breathOffset = (frame == 1 || frame == 3) ? -0.5 : 0.5;
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
    final bounce = [0.0, -2.0, 0.0, -1.0][frame];

    // Tail (wagging)
    final tailWag = [0.0, 1.5, 0.0, -1.5][frame];
    _drawTail(canvas, 0, bounce, wagX: tailWag);

    // Legs
    _drawLegs(canvas, 0, bounce);

    // Body
    _drawBody(canvas, 0, bounce);

    // Arms UP (happy pose)
    _drawPixelRect(canvas, 17, 20 + bounce, 3, 8, clothBase);
    _drawPixelRect(canvas, 17, 20 + bounce, 1, 3, clothLight);
    _drawPixelRect(canvas, 15, 18 + bounce, 3, 2, clothBase);
    _drawPixelRect(canvas, 44, 20 + bounce, 3, 8, clothBase);
    _drawPixelRect(canvas, 46, 20 + bounce, 1, 3, clothLight);
    _drawPixelRect(canvas, 46, 18 + bounce, 3, 2, clothBase);
    // Hands
    _drawPixelRect(canvas, 15, 17 + bounce, 3, 2, skinBase);
    _drawPixelRect(canvas, 46, 17 + bounce, 3, 2, skinBase);
    // Gold armbands
    _drawPixelRect(canvas, 17, 20 + bounce, 3, 1, goldAccent);
    _drawPixelRect(canvas, 44, 20 + bounce, 3, 1, goldAccent);

    // Head / Face with star eyes and big smile
    _drawFace(canvas, 0, bounce, starEyes: true, bigSmile: true);

    // Hair
    _drawHair(canvas, 0, bounce);

    // Cat ears
    _drawEars(canvas, 0, bounce);

    // Sparkles
    if (frame % 2 == 0) {
      _drawPixelRect(canvas, 12, 10 + bounce, 1, 1, goldLight);
      _drawPixelRect(canvas, 50, 12 + bounce, 1, 1, goldLight);
      _drawPixelRect(canvas, 8, 20 + bounce, 1, 1, goldAccent);
    }
  }

  // ============================================================
  // CONFUSED: One ear droopy, wavy mouth, head tilt
  // ============================================================
  void _drawConfused(Canvas canvas) {
    final tilt = frame == 1 ? 1.0 : 0.0;

    // Tail (droopy)
    _drawPixelRect(canvas, 6, 36, 3, 1, hairBase);
    _drawPixelRect(canvas, 5, 37, 2, 1, hairDark);

    // Legs
    _drawLegs(canvas, 0, 0);

    // Body
    _drawBody(canvas, 0, 0);

    // Arms - one scratching head
    _drawPixelRect(canvas, 17, 30, 3, 10, clothBase);
    _drawPixelRect(canvas, 44, 18, 3, 8, clothBase);
    _drawPixelRect(canvas, 44, 18, 1, 3, clothLight);
    _drawPixelRect(canvas, 44, 26, 3, 2, skinBase);
    _drawPixelRect(canvas, 17, 30, 3, 1, goldAccent);
    _drawPixelRect(canvas, 44, 18, 3, 1, goldAccent);

    // Head / Face with wavy mouth
    _drawFace(canvas, tilt, 0, wavyMouth: true);

    // Hair
    _drawHair(canvas, tilt, 0);

    // Cat ears - right ear droopy
    _drawEars(canvas, tilt, 0, rightDroopy: true);

    // Question mark
    _drawPixelRect(canvas, 48, 6, 1, 1, goldAccent);
    _drawPixelRect(canvas, 49, 6, 1, 1, goldAccent);
    _drawPixelRect(canvas, 49, 7, 1, 1, goldAccent);
    _drawPixelRect(canvas, 49, 8, 1, 1, goldAccent);
    _drawPixelRect(canvas, 48, 9, 1, 1, goldAccent);
    _drawPixelRect(canvas, 48, 10, 1, 1, goldAccent);
  }

  // ============================================================
  // PUSHED AWAY: Body leaning back, arms pushing forward, sweat
  // ============================================================
  void _drawPushedAway(Canvas canvas) {
    final slideX = frame * 1.5;

    // Tail
    _drawTail(canvas, -slideX, 0);

    // Legs (running pose - spread)
    _drawPixelRect(canvas, 22 - slideX, 44, 4, 6, skinBase);
    _drawPixelRect(canvas, 38 - slideX, 44, 4, 6, skinBase);
    _drawPixelRect(canvas, 22 - slideX, 48, 4, 2, skinShadow);
    _drawPixelRect(canvas, 38 - slideX, 48, 4, 2, skinShadow);
    _drawPixelRect(canvas, 21 - slideX, 50, 6, 2, clothDark);
    _drawPixelRect(canvas, 37 - slideX, 50, 6, 2, clothDark);

    // Body (leaning back)
    _drawBody(canvas, -slideX, 0);

    // Arms pushing forward
    _drawPixelRect(canvas, 44 - slideX, 28, 6, 2, skinBase);
    _drawPixelRect(canvas, 49 - slideX, 27, 2, 4, skinBase);
    _drawPixelRect(canvas, 17 - slideX, 30, 3, 10, clothBase);
    _drawPixelRect(canvas, 17 - slideX, 40, 3, 2, skinBase);

    // Head / Face
    _drawFace(canvas, -slideX, 0, openMouth: true);

    // Hair
    _drawHair(canvas, -slideX, 0);

    // Cat ears (alert)
    _drawEars(canvas, -slideX, 0);

    // Sweat drop
    _drawPixelRect(canvas, 46 - slideX, 14, 2, 3, Color(0xFF66CCFF));
    _drawPixelRect(canvas, 46 - slideX, 13, 1, 1, Color(0xFF88DDFF));

    // Motion lines
    for (int i = 0; i < 3; i++) {
      _drawPixelRect(canvas, 52 + i * 2, 20 + i * 4, 1, 3, Color(0xFFFFFFFF).withValues(alpha: 0.5));
    }
  }

  // ============================================================
  // SLEEPING: Eyes closed, body lying down, Zzz
  // ============================================================
  void _drawSleeping(Canvas canvas) {
    final breathe = frame == 0 ? 0.0 : 0.5;

    // Tail curled
    _drawPixelRect(canvas, 4, 36, 4, 1, hairBase);
    _drawPixelRect(canvas, 3, 35, 2, 1, hairBase);
    _drawPixelRect(canvas, 3, 34, 2, 1, hairLight);

    // Body (lying down, wider)
    _drawPixelRect(canvas, 10, 36 + breathe, 32, 6, clothBase);
    _drawPixelRect(canvas, 12, 35 + breathe, 28, 2, clothLight);
    _drawPixelRect(canvas, 14, 36 + breathe, 24, 1, goldAccent);
    // Body shadow
    _drawPixelRect(canvas, 10, 40 + breathe, 32, 2, clothDark);

    // Head (resting on side)
    _drawPixelRect(canvas, 6, 30 + breathe, 12, 8, skinBase);
    _drawPixelRect(canvas, 8, 30 + breathe, 6, 2, skinLight);
    _drawPixelRect(canvas, 6, 36 + breathe, 12, 2, skinShadow);

    // Hair (flowing while lying down)
    _drawPixelRect(canvas, 4, 28 + breathe, 16, 4, hairBase);
    _drawPixelRect(canvas, 6, 28 + breathe, 8, 1, hairLight);
    _drawPixelRect(canvas, 4, 32 + breathe, 2, 6, hairBase);
    _drawPixelRect(canvas, 4, 32 + breathe, 1, 3, hairLight);
    _drawPixelRect(canvas, 4, 36 + breathe, 2, 2, hairDark);

    // Cat ear (one visible)
    _drawPixelRect(canvas, 6, 26 + breathe, 3, 2, hairBase);
    _drawPixelRect(canvas, 7, 26 + breathe, 1, 1, earInner);

    // Closed eyes (peaceful arcs)
    _drawPixelRect(canvas, 9, 33 + breathe, 4, 1, eyeIris);
    _drawPixelRect(canvas, 10, 32 + breathe, 2, 1, eyeIris);

    // Peaceful mouth
    _drawPixelRect(canvas, 10, 35 + breathe, 3, 1, mouth);

    // Blush
    _drawPixelRect(canvas, 8, 34 + breathe, 3, 1, blush);
    _drawPixelRect(canvas, 14, 34 + breathe, 3, 1, blush);

    // Feet
    _drawPixelRect(canvas, 40, 37 + breathe, 4, 3, skinBase);
    _drawPixelRect(canvas, 40, 39 + breathe, 4, 1, skinShadow);

    // Zzz (floating)
    _drawPixelRect(canvas, 20, 26 + breathe, 2, 2, goldLight);
    _drawPixelRect(canvas, 23, 23 + breathe, 2, 2, goldLight);
    _drawPixelRect(canvas, 26, 20 + breathe, 3, 2, goldLight);
  }

  // ============================================================
  // SQUISHED: Body horizontally compressed, X_X eyes
  // ============================================================
  void _drawSquished(Canvas canvas) {
    // Body (wider +4, shorter -2)
    _drawPixelRect(canvas, 14, 36, 36, 10, clothBase);
    _drawPixelRect(canvas, 18, 36, 28, 3, clothLight);
    _drawPixelRect(canvas, 14, 36, 4, 8, clothDark);
    _drawPixelRect(canvas, 46, 36, 4, 8, clothDark);
    _drawPixelRect(canvas, 16, 44, 32, 2, clothDark);
    // Gold belt
    _drawPixelRect(canvas, 18, 38, 28, 1, goldAccent);

    // Arms (spread out)
    _drawPixelRect(canvas, 8, 38, 6, 2, clothBase);
    _drawPixelRect(canvas, 8, 38, 2, 2, skinBase);
    _drawPixelRect(canvas, 50, 38, 6, 2, clothBase);
    _drawPixelRect(canvas, 54, 38, 2, 2, skinBase);

    // Head (wider)
    _drawPixelRect(canvas, 16, 24, 32, 12, skinBase);
    _drawPixelRect(canvas, 20, 24, 16, 3, skinLight);
    _drawPixelRect(canvas, 16, 24, 4, 8, skinShadow);
    _drawPixelRect(canvas, 44, 24, 4, 8, skinShadow);
    _drawPixelRect(canvas, 20, 34, 24, 2, skinShadow);

    // Hair (spread out)
    _drawPixelRect(canvas, 14, 20, 36, 6, hairBase);
    _drawPixelRect(canvas, 18, 20, 12, 2, hairLight);
    _drawPixelRect(canvas, 14, 24, 2, 8, hairBase);
    _drawPixelRect(canvas, 48, 24, 2, 8, hairBase);
    _drawPixelRect(canvas, 14, 24, 36, 1, hairDark);

    // Cat ears (flattened)
    _drawPixelRect(canvas, 12, 18, 6, 3, hairBase);
    _drawPixelRect(canvas, 14, 18, 3, 2, earInner);
    _drawPixelRect(canvas, 46, 18, 6, 3, hairBase);
    _drawPixelRect(canvas, 48, 18, 3, 2, earInner);

    // X_X eyes
    _drawPixelRect(canvas, 22, 28, 1, 1, eyeIris);
    _drawPixelRect(canvas, 24, 28, 1, 1, eyeIris);
    _drawPixelRect(canvas, 23, 29, 1, 1, eyeIris);
    _drawPixelRect(canvas, 21, 29, 1, 1, eyeIris);
    _drawPixelRect(canvas, 40, 28, 1, 1, eyeIris);
    _drawPixelRect(canvas, 42, 28, 1, 1, eyeIris);
    _drawPixelRect(canvas, 41, 29, 1, 1, eyeIris);
    _drawPixelRect(canvas, 39, 29, 1, 1, eyeIris);

    // Wavy mouth
    _drawPixelRect(canvas, 28, 32, 3, 1, mouth);
    _drawPixelRect(canvas, 33, 32, 3, 1, mouth);

    // Blush
    _drawPixelRect(canvas, 20, 31, 4, 2, blush);
    _drawPixelRect(canvas, 40, 31, 4, 2, blush);

    // Legs (spread)
    _drawPixelRect(canvas, 18, 46, 4, 3, skinBase);
    _drawPixelRect(canvas, 42, 46, 4, 3, skinBase);
  }

  // ============================================================
  // SHOCKED: Bigger eyes, O mouth, body shaking
  // ============================================================
  void _drawShocked(Canvas canvas) {
    final shake = [0.0, -0.5, 0.5, 0.0][frame];

    // Tail
    _drawTail(canvas, shake, 0);

    // Legs
    _drawLegs(canvas, shake, 0);

    // Body
    _drawBody(canvas, shake, 0);

    // Arms (up in shock)
    _drawPixelRect(canvas, 14 + shake, 22, 3, 6, clothBase);
    _drawPixelRect(canvas, 13 + shake, 20, 2, 2, clothBase);
    _drawPixelRect(canvas, 13 + shake, 19, 2, 2, skinBase);
    _drawPixelRect(canvas, 47 + shake, 22, 3, 6, clothBase);
    _drawPixelRect(canvas, 49 + shake, 20, 2, 2, clothBase);
    _drawPixelRect(canvas, 49 + shake, 19, 2, 2, skinBase);
    _drawPixelRect(canvas, 14 + shake, 22, 3, 1, goldAccent);
    _drawPixelRect(canvas, 47 + shake, 22, 3, 1, goldAccent);

    // Head / Face with big eyes and O mouth
    _drawFace(canvas, shake, 0, bigEyes: true, openMouth: true);

    // Hair
    _drawHair(canvas, shake, 0);

    // Cat ears (straight up, alert)
    _drawEars(canvas, shake, 0);

    // Sweat drops
    _drawPixelRect(canvas, 46 + shake, 12, 2, 3, Color(0xFF66CCFF));
    _drawPixelRect(canvas, 46 + shake, 11, 1, 1, Color(0xFF88DDFF));
    _drawPixelRect(canvas, 20 + shake, 12, 1, 2, Color(0xFF66CCFF));

    // Exclamation marks
    _drawPixelRect(canvas, 50, 6, 1, 3, goldAccent);
    _drawPixelRect(canvas, 50, 10, 1, 1, goldAccent);
  }

  // ============================================================
  // CELEBRATING: Hands up, star eyes, jumping
  // ============================================================
  void _drawCelebrating(Canvas canvas) {
    final jumpHeight = [0.0, -3.0, -4.0, -3.0, 0.0, -2.0][frame];
    final spin = frame < 3;

    // Tail (wagging)
    final tailWag = [0.0, 2.0, 0.0, -2.0, 0.0, 1.0][frame];
    _drawTail(canvas, 0, jumpHeight, wagX: tailWag);

    // Legs (slightly apart when jumping)
    _drawPixelRect(canvas, 22, 44 + jumpHeight, 4, 6, skinBase);
    _drawPixelRect(canvas, 38, 44 + jumpHeight, 4, 6, skinBase);
    _drawPixelRect(canvas, 22, 48 + jumpHeight, 4, 2, skinShadow);
    _drawPixelRect(canvas, 38, 48 + jumpHeight, 4, 2, skinShadow);
    _drawPixelRect(canvas, 21, 50 + jumpHeight, 6, 2, clothDark);
    _drawPixelRect(canvas, 35, 50 + jumpHeight, 6, 2, clothDark);
    _drawPixelRect(canvas, 22, 50 + jumpHeight, 4, 1, clothBase);
    _drawPixelRect(canvas, 36, 50 + jumpHeight, 4, 1, clothBase);

    // Body
    _drawBody(canvas, 0, jumpHeight);

    // Arms (alternating up)
    if (spin) {
      // Left arm up, right arm out
      _drawPixelRect(canvas, 14, 18 + jumpHeight, 3, 10, clothBase);
      _drawPixelRect(canvas, 14, 18 + jumpHeight, 1, 3, clothLight);
      _drawPixelRect(canvas, 12, 16 + jumpHeight, 3, 3, clothBase);
      _drawPixelRect(canvas, 12, 15 + jumpHeight, 3, 2, skinBase);
      _drawPixelRect(canvas, 14, 18 + jumpHeight, 3, 1, goldAccent);
      _drawPixelRect(canvas, 47, 30 + jumpHeight, 3, 8, clothBase);
      _drawPixelRect(canvas, 47, 38 + jumpHeight, 3, 2, skinBase);
      _drawPixelRect(canvas, 47, 30 + jumpHeight, 3, 1, goldAccent);
    } else {
      // Right arm up, left arm out
      _drawPixelRect(canvas, 47, 18 + jumpHeight, 3, 10, clothBase);
      _drawPixelRect(canvas, 49, 18 + jumpHeight, 1, 3, clothLight);
      _drawPixelRect(canvas, 49, 16 + jumpHeight, 3, 3, clothBase);
      _drawPixelRect(canvas, 49, 15 + jumpHeight, 3, 2, skinBase);
      _drawPixelRect(canvas, 47, 18 + jumpHeight, 3, 1, goldAccent);
      _drawPixelRect(canvas, 14, 30 + jumpHeight, 3, 8, clothBase);
      _drawPixelRect(canvas, 14, 38 + jumpHeight, 3, 2, skinBase);
      _drawPixelRect(canvas, 14, 30 + jumpHeight, 3, 1, goldAccent);
    }

    // Head / Face with star eyes and big smile
    _drawFace(canvas, 0, jumpHeight, starEyes: true, bigSmile: true);

    // Hair
    _drawHair(canvas, 0, jumpHeight);

    // Cat ears
    _drawEars(canvas, 0, jumpHeight);

    // Sparkles around
    if (frame % 2 == 0) {
      _drawPixelRect(canvas, 8, 8 + jumpHeight, 2, 2, goldLight);
      _drawPixelRect(canvas, 54, 10 + jumpHeight, 2, 2, goldLight);
      _drawPixelRect(canvas, 6, 22 + jumpHeight, 1, 1, goldAccent);
      _drawPixelRect(canvas, 56, 18 + jumpHeight, 1, 1, goldAccent);
    } else {
      _drawPixelRect(canvas, 10, 14 + jumpHeight, 1, 1, goldLight);
      _drawPixelRect(canvas, 52, 6 + jumpHeight, 1, 1, goldLight);
    }
  }

  @override
  bool shouldRepaint(covariant CatGirlPainter oldDelegate) {
    return oldDelegate.state != state || oldDelegate.frame != frame;
  }
}
