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
      width: 96,
      height: 96,
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

  // === Pepe-style color palette: Egyptian/desert theme ===
  static const hairColor = Color(0xFFD4A017);     // Golden hair
  static const skinColor = Color(0xFFF5DEB3);     // Wheat skin
  static const eyeColor = Color(0xFF1E90FF);      // Blue eyes
  static const dressColor = Color(0xFF2C3E50);    // Dark blue-gray dress
  static const earInnerColor = Color(0xFFFFDAB9); // Light skin ear inner
  static const tailColor = Color(0xFFD4A017);     // Golden tail
  static const mouthColor = Color(0xFFE8836B);    // Coral mouth
  static const blushColor = Color(0xFFFFAA88);    // Warm blush
  static const goldAccent = Color(0xFFFFD700);    // Gold decoration (new)

  // Darker shade for hair shading
  static const hairDark = Color(0xFFB8860B);
  // Dress accent / collar
  static const dressAccent = Color(0xFF34495E);
  // Sandal color
  static const sandalColor = Color(0xFF8B7355);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 32, size.height / 32);

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

  // ignore: unused_element
  void _drawPixel(Canvas canvas, double x, double y, Color color) {
    final paint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(x, y, 1, 1), paint);
  }

  void _drawPixelRect(Canvas canvas, double x, double y, double w, double h, Color color) {
    final paint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(x, y, w, h), paint);
  }

  /// Helper: draw larger prominent cat ears (Pepe style - tall and upright)
  void _drawEars(Canvas canvas, double offX, double offY) {
    // Left ear - tall triangle shape (4px tall instead of 3)
    _drawPixelRect(canvas, 9 + offX, 2 + offY, 1, 1, hairColor);
    _drawPixelRect(canvas, 10 + offX, 2 + offY, 3, 1, hairColor);
    _drawPixelRect(canvas, 9 + offX, 3 + offY, 4, 1, hairColor);
    _drawPixelRect(canvas, 9 + offX, 4 + offY, 4, 1, hairColor);
    _drawPixelRect(canvas, 10 + offX, 5 + offY, 2, 1, hairColor);
    // Left ear inner
    _drawPixelRect(canvas, 10 + offX, 3 + offY, 2, 1, earInnerColor);
    _drawPixelRect(canvas, 10 + offX, 4 + offY, 2, 1, earInnerColor);

    // Right ear - tall triangle shape
    _drawPixelRect(canvas, 18 + offX, 2 + offY, 3, 1, hairColor);
    _drawPixelRect(canvas, 18 + offX, 2 + offY, 1, 1, hairColor);
    _drawPixelRect(canvas, 19 + offX, 2 + offY, 3, 1, hairColor);
    _drawPixelRect(canvas, 19 + offX, 3 + offY, 4, 1, hairColor);
    _drawPixelRect(canvas, 19 + offX, 4 + offY, 4, 1, hairColor);
    _drawPixelRect(canvas, 20 + offX, 5 + offY, 2, 1, hairColor);
    // Right ear inner
    _drawPixelRect(canvas, 20 + offX, 3 + offY, 2, 1, earInnerColor);
    _drawPixelRect(canvas, 20 + offX, 4 + offY, 2, 1, earInnerColor);
  }

  /// Helper: draw golden Egyptian headpiece / uraeus-style ornament
  void _drawGoldHeadpiece(Canvas canvas, double offX, double offY) {
    // Golden band across forehead
    _drawPixelRect(canvas, 11 + offX, 7 + offY, 10, 1, goldAccent);
    // Center jewel
    _drawPixelRect(canvas, 15 + offX, 6 + offY, 2, 1, goldAccent);
    _drawPixelRect(canvas, 15 + offX, 7 + offY, 2, 1, eyeColor); // sapphire gem
    // Side ornaments
    _drawPixelRect(canvas, 10 + offX, 7 + offY, 1, 2, goldAccent);
    _drawPixelRect(canvas, 21 + offX, 7 + offY, 1, 2, goldAccent);
    // Small dangling gold pieces
    _drawPixelRect(canvas, 10 + offX, 9 + offY, 1, 1, goldAccent);
    _drawPixelRect(canvas, 21 + offX, 9 + offY, 1, 1, goldAccent);
  }

  /// Helper: draw standard Pepe-style hair (golden, flowing)
  void _drawHair(Canvas canvas, double offX, double offY) {
    // Top hair volume
    _drawPixelRect(canvas, 10 + offX, 5 + offY, 12, 3, hairColor);
    // Hair shading (darker layer)
    _drawPixelRect(canvas, 10 + offX, 7 + offY, 12, 1, hairDark);
    // Side hair left
    _drawPixelRect(canvas, 10 + offX, 8 + offY, 1, 7, hairColor);
    _drawPixelRect(canvas, 9 + offX, 10 + offY, 1, 4, hairColor);
    // Side hair right
    _drawPixelRect(canvas, 21 + offX, 8 + offY, 1, 7, hairColor);
    _drawPixelRect(canvas, 22 + offX, 10 + offY, 1, 4, hairColor);
    // Back hair strands
    _drawPixelRect(canvas, 11 + offX, 4 + offY, 10, 2, hairColor);
  }

  /// Helper: draw standard Pepe-style face features
  void _drawFace(Canvas canvas, double offX, double offY, {bool blink = false, bool starEyes = false, bool bigEyes = false, bool closedEyes = false}) {
    if (blink) {
      // Blinking eyes - horizontal lines
      _drawPixelRect(canvas, 13 + offX, 11 + offY, 2, 1, eyeColor);
      _drawPixelRect(canvas, 17 + offX, 11 + offY, 2, 1, eyeColor);
    } else if (starEyes) {
      // Star-shaped happy eyes
      _drawPixelRect(canvas, 13 + offX, 10 + offY, 2, 2, goldAccent);
      _drawPixelRect(canvas, 17 + offX, 10 + offY, 2, 2, goldAccent);
    } else if (bigEyes) {
      // Big round shocked eyes
      _drawPixelRect(canvas, 12 + offX, 9 + offY, 3, 3, Colors.white);
      _drawPixelRect(canvas, 13 + offX, 10 + offY, 1, 1, eyeColor);
      _drawPixelRect(canvas, 17 + offX, 9 + offY, 3, 3, Colors.white);
      _drawPixelRect(canvas, 18 + offX, 10 + offY, 1, 1, eyeColor);
    } else if (closedEyes) {
      // Peaceful closed eyes (sleeping)
      _drawPixelRect(canvas, 13 + offX, 11 + offY, 2, 1, eyeColor);
      _drawPixelRect(canvas, 17 + offX, 11 + offY, 2, 1, eyeColor);
    } else {
      // Normal blue eyes with white highlight
      _drawPixelRect(canvas, 13 + offX, 10 + offY, 2, 2, eyeColor);
      _drawPixelRect(canvas, 13 + offX, 10 + offY, 1, 1, Colors.white);
      _drawPixelRect(canvas, 17 + offX, 10 + offY, 2, 2, eyeColor);
      _drawPixelRect(canvas, 17 + offX, 10 + offY, 1, 1, Colors.white);
    }

    // Warm blush
    _drawPixelRect(canvas, 12 + offX, 12 + offY, 1, 1, blushColor);
    _drawPixelRect(canvas, 19 + offX, 12 + offY, 1, 1, blushColor);

    // Coral mouth
    _drawPixelRect(canvas, 15 + offX, 13 + offY, 2, 1, mouthColor);
  }

  /// Helper: draw standard body with dress
  void _drawBody(Canvas canvas, double offX, double offY) {
    // Dress body
    _drawPixelRect(canvas, 11 + offX, 16 + offY, 10, 8, dressColor);
    // Dress collar / neckline
    _drawPixelRect(canvas, 12 + offX, 15 + offY, 8, 1, dressAccent);
    // Gold collar detail
    _drawPixelRect(canvas, 14 + offX, 15 + offY, 4, 1, goldAccent);
    // Arms
    _drawPixelRect(canvas, 10 + offX, 17 + offY, 1, 4, skinColor);
    _drawPixelRect(canvas, 21 + offX, 17 + offY, 1, 4, skinColor);
    // Gold armbands
    _drawPixelRect(canvas, 10 + offX, 17 + offY, 1, 1, goldAccent);
    _drawPixelRect(canvas, 21 + offX, 17 + offY, 1, 1, goldAccent);
    // Legs
    _drawPixelRect(canvas, 12 + offX, 24 + offY, 2, 3, skinColor);
    _drawPixelRect(canvas, 18 + offX, 24 + offY, 2, 3, skinColor);
    // Sandals
    _drawPixelRect(canvas, 11 + offX, 27 + offY, 3, 1, sandalColor);
    _drawPixelRect(canvas, 18 + offX, 27 + offY, 3, 1, sandalColor);
    // Gold sandal straps
    _drawPixelRect(canvas, 12 + offX, 26 + offY, 2, 1, goldAccent);
    _drawPixelRect(canvas, 19 + offX, 26 + offY, 2, 1, goldAccent);
  }

  /// Helper: draw golden tail
  void _drawTail(Canvas canvas, double offX, double offY, {double wagX = 0}) {
    _drawPixelRect(canvas, 2 + offX + wagX, 18 + offY, 2, 1, tailColor);
    _drawPixelRect(canvas, 1 + offX + wagX, 17 + offY, 2, 1, tailColor);
    _drawPixelRect(canvas, 1 + offX + wagX, 16 + offY, 1, 1, tailColor);
    // Tail tip highlight
    _drawPixelRect(canvas, 1 + offX + wagX, 16 + offY, 1, 1, goldAccent);
  }

  // === IDLE: Standing with breathing animation, gold headpiece ===
  void _drawIdle(Canvas canvas) {
    final breathOffset = frame == 1 ? -0.5 : (frame == 3 ? 0.5 : 0.0);
    final blink = frame == 2;

    // Tail
    _drawTail(canvas, 0, breathOffset);

    // Body
    _drawBody(canvas, 0, breathOffset);

    // Head
    _drawPixelRect(canvas, 11, 8 + breathOffset, 10, 8, skinColor);

    // Hair
    _drawHair(canvas, 0, breathOffset);

    // Large prominent cat ears
    _drawEars(canvas, 0, breathOffset);

    // Golden Egyptian headpiece
    _drawGoldHeadpiece(canvas, 0, breathOffset);

    // Face
    _drawFace(canvas, 0, breathOffset, blink: blink);
  }

  // === HAPPY: Arms up, bouncing, golden sparkles ===
  void _drawHappy(Canvas canvas) {
    final bounce = [0.0, -1.5, 0.0, -1.0][frame];

    // Tail (wagging)
    final tailWag = [0.0, 1.0, 0.0, -1.0][frame];
    _drawTail(canvas, 0, bounce, wagX: tailWag);

    // Body
    _drawPixelRect(canvas, 11, 16 + bounce, 10, 8, dressColor);
    _drawPixelRect(canvas, 12, 15 + bounce, 8, 1, dressAccent);
    _drawPixelRect(canvas, 14, 15 + bounce, 4, 1, goldAccent);

    // Arms UP
    _drawPixelRect(canvas, 10, 12 + bounce, 1, 4, skinColor);
    _drawPixelRect(canvas, 9, 11 + bounce, 2, 1, skinColor);
    _drawPixelRect(canvas, 21, 12 + bounce, 1, 4, skinColor);
    _drawPixelRect(canvas, 21, 11 + bounce, 2, 1, skinColor);
    // Gold armbands
    _drawPixelRect(canvas, 10, 12 + bounce, 1, 1, goldAccent);
    _drawPixelRect(canvas, 21, 12 + bounce, 1, 1, goldAccent);

    // Head
    _drawPixelRect(canvas, 11, 8 + bounce, 10, 8, skinColor);

    // Hair
    _drawHair(canvas, 0, bounce);

    // Cat ears
    _drawEars(canvas, 0, bounce);

    // Golden headpiece
    _drawGoldHeadpiece(canvas, 0, bounce);

    // Star eyes (golden, happy)
    _drawPixelRect(canvas, 13, 10 + bounce, 2, 2, goldAccent);
    _drawPixelRect(canvas, 17, 10 + bounce, 2, 2, goldAccent);

    // Big smile
    _drawPixelRect(canvas, 14, 13 + bounce, 4, 1, mouthColor);
    _drawPixelRect(canvas, 13, 13 + bounce, 1, 1, mouthColor);
    _drawPixelRect(canvas, 18, 13 + bounce, 1, 1, mouthColor);

    // Blush
    _drawPixelRect(canvas, 12, 12 + bounce, 1, 1, blushColor);
    _drawPixelRect(canvas, 19, 12 + bounce, 1, 1, blushColor);

    // Legs
    _drawPixelRect(canvas, 12, 24 + bounce, 2, 3, skinColor);
    _drawPixelRect(canvas, 18, 24 + bounce, 2, 3, skinColor);
    _drawPixelRect(canvas, 11, 27 + bounce, 3, 1, sandalColor);
    _drawPixelRect(canvas, 18, 27 + bounce, 3, 1, sandalColor);
    _drawPixelRect(canvas, 12, 26 + bounce, 2, 1, goldAccent);
    _drawPixelRect(canvas, 19, 26 + bounce, 2, 1, goldAccent);
  }

  // === CONFUSED: Tilted head, question mark ===
  void _drawConfused(Canvas canvas) {
    // ignore: unused_local_variable
    final tilt = frame == 1 ? 1.0 : 0.0;

    // Tail (droopy)
    _drawPixelRect(canvas, 2, 19, 2, 1, tailColor);
    _drawPixelRect(canvas, 1, 20, 2, 1, tailColor);

    // Body
    _drawPixelRect(canvas, 11, 16, 10, 8, dressColor);
    _drawPixelRect(canvas, 12, 15, 8, 1, dressAccent);
    _drawPixelRect(canvas, 14, 15, 4, 1, goldAccent);

    // Arms (one scratching head)
    _drawPixelRect(canvas, 10, 17, 1, 4, skinColor);
    _drawPixelRect(canvas, 21, 14, 1, 3, skinColor);
    _drawPixelRect(canvas, 10, 17, 1, 1, goldAccent);

    // Head
    _drawPixelRect(canvas, 11, 8, 10, 8, skinColor);

    // Hair
    _drawHair(canvas, 0, 0);

    // Cat ears (one droopy - right ear tilted)
    // Left ear normal
    _drawPixelRect(canvas, 9, 2, 1, 1, hairColor);
    _drawPixelRect(canvas, 10, 2, 3, 1, hairColor);
    _drawPixelRect(canvas, 9, 3, 4, 1, hairColor);
    _drawPixelRect(canvas, 9, 4, 4, 1, hairColor);
    _drawPixelRect(canvas, 10, 5, 2, 1, hairColor);
    _drawPixelRect(canvas, 10, 3, 2, 1, earInnerColor);
    _drawPixelRect(canvas, 10, 4, 2, 1, earInnerColor);
    // Right ear droopy
    _drawPixelRect(canvas, 19, 5, 4, 1, hairColor);
    _drawPixelRect(canvas, 20, 4, 3, 1, hairColor);
    _drawPixelRect(canvas, 21, 3, 2, 1, hairColor);
    _drawPixelRect(canvas, 20, 5, 2, 1, earInnerColor);

    // Golden headpiece
    _drawGoldHeadpiece(canvas, 0, 0);

    // Eyes (one normal, one squinting)
    _drawPixelRect(canvas, 13, 10, 2, 2, eyeColor);
    _drawPixelRect(canvas, 13, 10, 1, 1, Colors.white);
    _drawPixelRect(canvas, 17, 11, 2, 1, eyeColor); // squinting

    // Wavy mouth
    _drawPixelRect(canvas, 14, 13, 1, 1, mouthColor);
    _drawPixelRect(canvas, 16, 13, 1, 1, mouthColor);

    // Blush
    _drawPixelRect(canvas, 12, 12, 1, 1, blushColor);
    _drawPixelRect(canvas, 19, 12, 1, 1, blushColor);

    // Question mark above head (gold colored)
    _drawPixelRect(canvas, 23, 3, 1, 1, goldAccent);
    _drawPixelRect(canvas, 23, 4, 1, 1, goldAccent);
    _drawPixelRect(canvas, 24, 4, 1, 1, goldAccent);
    _drawPixelRect(canvas, 24, 5, 1, 1, goldAccent);
    _drawPixelRect(canvas, 23, 6, 1, 1, goldAccent);

    // Legs
    _drawPixelRect(canvas, 12, 24, 2, 3, skinColor);
    _drawPixelRect(canvas, 18, 24, 2, 3, skinColor);
    _drawPixelRect(canvas, 11, 27, 3, 1, sandalColor);
    _drawPixelRect(canvas, 18, 27, 3, 1, sandalColor);
    _drawPixelRect(canvas, 12, 26, 2, 1, goldAccent);
    _drawPixelRect(canvas, 19, 26, 2, 1, goldAccent);
  }

  // === PUSHED AWAY: Sliding left, hands pushing ===
  void _drawPushedAway(Canvas canvas) {
    // ignore: unused_local_variable
    final slideX = frame * 2.0;

    // Body
    _drawPixelRect(canvas, 11, 16, 10, 8, dressColor);
    _drawPixelRect(canvas, 12, 15, 8, 1, dressAccent);
    _drawPixelRect(canvas, 14, 15, 4, 1, goldAccent);

    // Arms pushing forward (to the right)
    _drawPixelRect(canvas, 21, 16, 3, 1, skinColor);
    _drawPixelRect(canvas, 24, 15, 1, 3, skinColor);
    _drawPixelRect(canvas, 10, 17, 1, 4, skinColor);
    _drawPixelRect(canvas, 21, 16, 1, 1, goldAccent);

    // Head
    _drawPixelRect(canvas, 11, 8, 10, 8, skinColor);

    // Hair
    _drawHair(canvas, 0, 0);

    // Cat ears (alert, pushed back slightly)
    _drawPixelRect(canvas, 9, 2, 1, 1, hairColor);
    _drawPixelRect(canvas, 10, 2, 3, 1, hairColor);
    _drawPixelRect(canvas, 9, 3, 4, 1, hairColor);
    _drawPixelRect(canvas, 9, 4, 4, 1, hairColor);
    _drawPixelRect(canvas, 10, 5, 2, 1, hairColor);
    _drawPixelRect(canvas, 10, 3, 2, 1, earInnerColor);
    _drawPixelRect(canvas, 10, 4, 2, 1, earInnerColor);

    _drawPixelRect(canvas, 19, 2, 3, 1, hairColor);
    _drawPixelRect(canvas, 19, 3, 4, 1, hairColor);
    _drawPixelRect(canvas, 19, 4, 4, 1, hairColor);
    _drawPixelRect(canvas, 20, 5, 2, 1, hairColor);
    _drawPixelRect(canvas, 20, 3, 2, 1, earInnerColor);
    _drawPixelRect(canvas, 20, 4, 2, 1, earInnerColor);

    // Golden headpiece
    _drawGoldHeadpiece(canvas, 0, 0);

    // Eyes (struggling)
    _drawPixelRect(canvas, 13, 10, 2, 2, eyeColor);
    _drawPixelRect(canvas, 13, 10, 1, 1, Colors.white);
    _drawPixelRect(canvas, 17, 10, 2, 2, eyeColor);
    _drawPixelRect(canvas, 17, 10, 1, 1, Colors.white);
    // Sweat drop
    _drawPixelRect(canvas, 22, 9, 1, 1, Color(0xFF66CCFF));

    // Open mouth
    _drawPixelRect(canvas, 14, 13, 4, 1, mouthColor);

    // Blush
    _drawPixelRect(canvas, 12, 12, 1, 1, blushColor);
    _drawPixelRect(canvas, 19, 12, 1, 1, blushColor);

    // Motion lines
    for (int i = 0; i < 3; i++) {
      _drawPixelRect(canvas, 25 + i * 2, 10 + i * 3, 1, 2, Color(0xFFFFFFFF).withValues(alpha: 0.5));
    }

    // Legs (running pose)
    _drawPixelRect(canvas, 12, 24, 2, 3, skinColor);
    _drawPixelRect(canvas, 18, 24, 2, 3, skinColor);
    _drawPixelRect(canvas, 11, 27, 3, 1, sandalColor);
    _drawPixelRect(canvas, 18, 27, 3, 1, sandalColor);
    _drawPixelRect(canvas, 12, 26, 2, 1, goldAccent);
    _drawPixelRect(canvas, 19, 26, 2, 1, goldAccent);
  }

  // === SLEEPING: Lying down, eyes closed ===
  void _drawSleeping(Canvas canvas) {
    final breathe = frame == 0 ? 0.0 : 0.3;

    // Tail curled
    _drawPixelRect(canvas, 2, 20, 3, 1, tailColor);
    _drawPixelRect(canvas, 1, 19, 2, 1, tailColor);
    _drawPixelRect(canvas, 1, 18, 1, 1, goldAccent);

    // Body (lying down, wider)
    _drawPixelRect(canvas, 6, 20 + breathe, 16, 4, dressColor);
    _drawPixelRect(canvas, 8, 19 + breathe, 12, 1, dressAccent);
    // Gold belt detail
    _drawPixelRect(canvas, 10, 20 + breathe, 8, 1, goldAccent);

    // Head (resting on side)
    _drawPixelRect(canvas, 4, 18 + breathe, 6, 5, skinColor);

    // Hair (flowing)
    _drawPixelRect(canvas, 3, 16 + breathe, 8, 3, hairColor);
    _drawPixelRect(canvas, 4, 18 + breathe, 1, 4, hairColor);
    _drawPixelRect(canvas, 3, 17 + breathe, 1, 1, earInnerColor); // ear
    // Hair shading
    _drawPixelRect(canvas, 3, 18 + breathe, 1, 1, hairDark);

    // Closed eyes (peaceful lines)
    _drawPixelRect(canvas, 5, 20 + breathe, 2, 1, eyeColor);
    _drawPixelRect(canvas, 8, 20 + breathe, 2, 1, eyeColor);

    // Peaceful mouth
    _drawPixelRect(canvas, 6, 21 + breathe, 2, 1, mouthColor);

    // Blush
    _drawPixelRect(canvas, 5, 21 + breathe, 1, 1, blushColor);
    _drawPixelRect(canvas, 9, 21 + breathe, 1, 1, blushColor);

    // Feet
    _drawPixelRect(canvas, 20, 21 + breathe, 2, 2, skinColor);
    _drawPixelRect(canvas, 22, 22 + breathe, 2, 1, sandalColor);

    // Zzz (gold colored)
    _drawPixelRect(canvas, 10, 15 + breathe, 1, 1, goldAccent);
    _drawPixelRect(canvas, 11, 14 + breathe, 1, 1, goldAccent);
    _drawPixelRect(canvas, 12, 13 + breathe, 1, 1, goldAccent);
  }

  // === SQUISHED: Flat/wide ===
  void _drawSquished(Canvas canvas) {
    // ignore: unused_local_variable
    final squish = [0.0, 0.5, 1.0][frame];

    // Body (wider, shorter)
    _drawPixelRect(canvas, 6, 20, 20, 4, dressColor);
    // Gold belt
    _drawPixelRect(canvas, 8, 20, 16, 1, goldAccent);

    // Arms (spread out)
    _drawPixelRect(canvas, 4, 21, 2, 1, skinColor);
    _drawPixelRect(canvas, 26, 21, 2, 1, skinColor);

    // Head (wider)
    _drawPixelRect(canvas, 8, 14, 16, 6, skinColor);

    // Hair (spread out)
    _drawPixelRect(canvas, 7, 12, 18, 3, hairColor);
    _drawPixelRect(canvas, 7, 14, 1, 5, hairColor);
    _drawPixelRect(canvas, 24, 14, 1, 5, hairColor);
    // Hair shading
    _drawPixelRect(canvas, 7, 14, 18, 1, hairDark);

    // Cat ears (flattened but still prominent)
    _drawPixelRect(canvas, 6, 10, 5, 2, hairColor);
    _drawPixelRect(canvas, 7, 10, 3, 1, earInnerColor);
    _drawPixelRect(canvas, 21, 10, 5, 2, hairColor);
    _drawPixelRect(canvas, 22, 10, 3, 1, earInnerColor);

    // Eyes (X_X dizzy)
    _drawPixelRect(canvas, 11, 16, 1, 1, eyeColor);
    _drawPixelRect(canvas, 13, 16, 1, 1, eyeColor);
    _drawPixelRect(canvas, 12, 17, 1, 1, eyeColor);
    _drawPixelRect(canvas, 10, 17, 1, 1, eyeColor);

    _drawPixelRect(canvas, 19, 16, 1, 1, eyeColor);
    _drawPixelRect(canvas, 21, 16, 1, 1, eyeColor);
    _drawPixelRect(canvas, 20, 17, 1, 1, eyeColor);
    _drawPixelRect(canvas, 18, 17, 1, 1, eyeColor);

    // Wavy mouth
    _drawPixelRect(canvas, 14, 18, 4, 1, mouthColor);

    // Blush
    _drawPixelRect(canvas, 10, 18, 1, 1, blushColor);
    _drawPixelRect(canvas, 21, 18, 1, 1, blushColor);

    // Legs (spread)
    _drawPixelRect(canvas, 8, 24, 2, 2, skinColor);
    _drawPixelRect(canvas, 22, 24, 2, 2, skinColor);
  }

  // === SHOCKED: Big eyes, sweat drops ===
  void _drawShocked(Canvas canvas) {
    final shake = [0.0, -0.5, 0.5, 0.0][frame];

    // Body
    _drawPixelRect(canvas, 11 + shake, 16, 10, 8, dressColor);
    _drawPixelRect(canvas, 12 + shake, 15, 8, 1, dressAccent);
    _drawPixelRect(canvas, 14 + shake, 15, 4, 1, goldAccent);

    // Arms (up in shock)
    _drawPixelRect(canvas, 9 + shake, 14, 2, 1, skinColor);
    _drawPixelRect(canvas, 10 + shake, 15, 1, 3, skinColor);
    _drawPixelRect(canvas, 22 + shake, 14, 2, 1, skinColor);
    _drawPixelRect(canvas, 21 + shake, 15, 1, 3, skinColor);
    // Gold armbands
    _drawPixelRect(canvas, 9 + shake, 14, 1, 1, goldAccent);
    _drawPixelRect(canvas, 22 + shake, 14, 1, 1, goldAccent);

    // Head
    _drawPixelRect(canvas, 11 + shake, 8, 10, 8, skinColor);

    // Hair
    _drawHair(canvas, shake, 0);

    // Cat ears (straight up, alert - extra tall)
    _drawPixelRect(canvas, 9 + shake, 1, 1, 1, hairColor);
    _drawPixelRect(canvas, 10 + shake, 1, 3, 1, hairColor);
    _drawPixelRect(canvas, 9 + shake, 2, 4, 1, hairColor);
    _drawPixelRect(canvas, 9 + shake, 3, 4, 1, hairColor);
    _drawPixelRect(canvas, 10 + shake, 4, 2, 1, hairColor);
    _drawPixelRect(canvas, 10 + shake, 2, 2, 1, earInnerColor);
    _drawPixelRect(canvas, 10 + shake, 3, 2, 1, earInnerColor);

    _drawPixelRect(canvas, 18 + shake, 1, 3, 1, hairColor);
    _drawPixelRect(canvas, 19 + shake, 2, 4, 1, hairColor);
    _drawPixelRect(canvas, 19 + shake, 3, 4, 1, hairColor);
    _drawPixelRect(canvas, 20 + shake, 4, 2, 1, hairColor);
    _drawPixelRect(canvas, 20 + shake, 2, 2, 1, earInnerColor);
    _drawPixelRect(canvas, 20 + shake, 3, 2, 1, earInnerColor);

    // Golden headpiece
    _drawGoldHeadpiece(canvas, shake, 0);

    // Big round eyes
    _drawPixelRect(canvas, 12 + shake, 9, 3, 3, Colors.white);
    _drawPixelRect(canvas, 13 + shake, 10, 1, 1, eyeColor);
    _drawPixelRect(canvas, 17 + shake, 9, 3, 3, Colors.white);
    _drawPixelRect(canvas, 18 + shake, 10, 1, 1, eyeColor);

    // O mouth
    _drawPixelRect(canvas, 15 + shake, 13, 2, 2, mouthColor);

    // Blush
    _drawPixelRect(canvas, 12 + shake, 12, 1, 1, blushColor);
    _drawPixelRect(canvas, 19 + shake, 12, 1, 1, blushColor);

    // Sweat drops
    _drawPixelRect(canvas, 22 + shake, 8, 1, 2, Color(0xFF66CCFF));
    _drawPixelRect(canvas, 9 + shake, 14, 1, 1, Color(0xFF66CCFF));

    // Legs
    _drawPixelRect(canvas, 12 + shake, 24, 2, 3, skinColor);
    _drawPixelRect(canvas, 18 + shake, 24, 2, 3, skinColor);
    _drawPixelRect(canvas, 11 + shake, 27, 3, 1, sandalColor);
    _drawPixelRect(canvas, 18 + shake, 27, 3, 1, sandalColor);
    _drawPixelRect(canvas, 12 + shake, 26, 2, 1, goldAccent);
    _drawPixelRect(canvas, 19 + shake, 26, 2, 1, goldAccent);

    // Exclamation marks (gold)
    _drawPixelRect(canvas, 24, 4, 1, 2, goldAccent);
    _drawPixelRect(canvas, 24, 7, 1, 1, goldAccent);
  }

  // === CELEBRATING: Jumping, spinning ===
  void _drawCelebrating(Canvas canvas) {
    final jumpHeight = [0.0, -2.0, -3.0, -2.0, 0.0, -1.5][frame];
    final spin = frame < 3;

    // Body
    _drawPixelRect(canvas, 11, 16 + jumpHeight, 10, 8, dressColor);
    _drawPixelRect(canvas, 12, 15 + jumpHeight, 8, 1, dressAccent);
    _drawPixelRect(canvas, 14, 15 + jumpHeight, 4, 1, goldAccent);

    // Arms (alternating up)
    if (spin) {
      _drawPixelRect(canvas, 9, 10 + jumpHeight, 2, 1, skinColor);
      _drawPixelRect(canvas, 10, 11 + jumpHeight, 1, 5, skinColor);
      _drawPixelRect(canvas, 9, 10 + jumpHeight, 1, 1, goldAccent);
      _drawPixelRect(canvas, 21, 13 + jumpHeight, 2, 1, skinColor);
      _drawPixelRect(canvas, 21, 14 + jumpHeight, 1, 3, skinColor);
      _drawPixelRect(canvas, 21, 13 + jumpHeight, 1, 1, goldAccent);
    } else {
      _drawPixelRect(canvas, 21, 10 + jumpHeight, 2, 1, skinColor);
      _drawPixelRect(canvas, 21, 11 + jumpHeight, 1, 5, skinColor);
      _drawPixelRect(canvas, 21, 10 + jumpHeight, 1, 1, goldAccent);
      _drawPixelRect(canvas, 9, 13 + jumpHeight, 2, 1, skinColor);
      _drawPixelRect(canvas, 10, 14 + jumpHeight, 1, 3, skinColor);
      _drawPixelRect(canvas, 9, 13 + jumpHeight, 1, 1, goldAccent);
    }

    // Head
    _drawPixelRect(canvas, 11, 8 + jumpHeight, 10, 8, skinColor);

    // Hair
    _drawHair(canvas, 0, jumpHeight);

    // Cat ears
    _drawEars(canvas, 0, jumpHeight);

    // Golden headpiece
    _drawGoldHeadpiece(canvas, 0, jumpHeight);

    // Happy eyes (closed, smiling - blue arcs)
    _drawPixelRect(canvas, 13, 10 + jumpHeight, 2, 1, eyeColor);
    _drawPixelRect(canvas, 17, 10 + jumpHeight, 2, 1, eyeColor);

    // Big grin
    _drawPixelRect(canvas, 13, 13 + jumpHeight, 6, 1, mouthColor);
    _drawPixelRect(canvas, 14, 12 + jumpHeight, 4, 1, mouthColor);

    // Blush
    _drawPixelRect(canvas, 12, 12 + jumpHeight, 1, 1, blushColor);
    _drawPixelRect(canvas, 19, 12 + jumpHeight, 1, 1, blushColor);

    // Legs
    _drawPixelRect(canvas, 12, 24 + jumpHeight, 2, 3, skinColor);
    _drawPixelRect(canvas, 18, 24 + jumpHeight, 2, 3, skinColor);
    _drawPixelRect(canvas, 11, 27 + jumpHeight, 3, 1, sandalColor);
    _drawPixelRect(canvas, 18, 27 + jumpHeight, 3, 1, sandalColor);
    _drawPixelRect(canvas, 12, 26 + jumpHeight, 2, 1, goldAccent);
    _drawPixelRect(canvas, 19, 26 + jumpHeight, 2, 1, goldAccent);

    // Golden sparkles
    if (frame % 2 == 0) {
      _drawPixelRect(canvas, 5, 5 + jumpHeight, 1, 1, goldAccent);
      _drawPixelRect(canvas, 26, 8 + jumpHeight, 1, 1, goldAccent);
      _drawPixelRect(canvas, 3, 14 + jumpHeight, 1, 1, goldAccent);
    }
  }

  @override
  bool shouldRepaint(covariant CatGirlPainter oldDelegate) {
    return oldDelegate.state != state || oldDelegate.frame != frame;
  }
}
