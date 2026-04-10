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

  // Colors
  static const hairColor = Color(0xFFFF69B4); // Hot pink
  static const skinColor = Color(0xFFFFDAB9); // Peach
  static const eyeColor = Color(0xFF00FFFF);  // Cyan eyes
  static const dressColor = Color(0xFF6A0DAD); // Purple dress
  static const earInnerColor = Color(0xFFFFB6C1); // Light pink
  static const tailColor = Color(0xFFFF69B4);
  static const mouthColor = Color(0xFFFF6B6B);
  static const blushColor = Color(0xFFFF9999);

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

  // === IDLE: Standing with breathing animation ===
  void _drawIdle(Canvas canvas) {
    final breathOffset = frame == 1 ? -0.5 : (frame == 3 ? 0.5 : 0.0);
    final blink = frame == 2;

    // Tail
    _drawPixelRect(canvas, 2, 18 + breathOffset, 2, 1, tailColor);
    _drawPixelRect(canvas, 1, 17 + breathOffset, 2, 1, tailColor);
    _drawPixelRect(canvas, 1, 16 + breathOffset, 1, 1, tailColor);

    // Body / Dress
    _drawPixelRect(canvas, 11, 16 + breathOffset, 10, 8, dressColor);
    _drawPixelRect(canvas, 12, 15 + breathOffset, 8, 1, dressColor);

    // Arms
    _drawPixelRect(canvas, 10, 17 + breathOffset, 1, 4, skinColor);
    _drawPixelRect(canvas, 21, 17 + breathOffset, 1, 4, skinColor);

    // Head
    _drawPixelRect(canvas, 11, 8 + breathOffset, 10, 8, skinColor);

    // Hair
    _drawPixelRect(canvas, 10, 6 + breathOffset, 12, 4, hairColor);
    _drawPixelRect(canvas, 10, 8 + breathOffset, 1, 6, hairColor);
    _drawPixelRect(canvas, 21, 8 + breathOffset, 1, 6, hairColor);
    _drawPixelRect(canvas, 12, 5 + breathOffset, 8, 2, hairColor);

    // Cat ears
    _drawPixelRect(canvas, 10, 4 + breathOffset, 3, 3, hairColor);
    _drawPixelRect(canvas, 11, 5 + breathOffset, 1, 1, earInnerColor);
    _drawPixelRect(canvas, 19, 4 + breathOffset, 3, 3, hairColor);
    _drawPixelRect(canvas, 20, 5 + breathOffset, 1, 1, earInnerColor);

    // Eyes
    if (blink) {
      _drawPixelRect(canvas, 13, 11 + breathOffset, 2, 1, eyeColor);
      _drawPixelRect(canvas, 17, 11 + breathOffset, 2, 1, eyeColor);
    } else {
      _drawPixelRect(canvas, 13, 10 + breathOffset, 2, 2, eyeColor);
      _drawPixelRect(canvas, 13, 10 + breathOffset, 1, 1, Colors.white);
      _drawPixelRect(canvas, 17, 10 + breathOffset, 2, 2, eyeColor);
      _drawPixelRect(canvas, 17, 10 + breathOffset, 1, 1, Colors.white);
    }

    // Blush
    _drawPixelRect(canvas, 12, 12 + breathOffset, 1, 1, blushColor);
    _drawPixelRect(canvas, 19, 12 + breathOffset, 1, 1, blushColor);

    // Mouth
    _drawPixelRect(canvas, 15, 13 + breathOffset, 2, 1, mouthColor);

    // Legs
    _drawPixelRect(canvas, 12, 24 + breathOffset, 2, 3, skinColor);
    _drawPixelRect(canvas, 18, 24 + breathOffset, 2, 3, skinColor);

    // Shoes
    _drawPixelRect(canvas, 11, 27 + breathOffset, 3, 1, Color(0xFF333366));
    _drawPixelRect(canvas, 18, 27 + breathOffset, 3, 1, Color(0xFF333366));
  }

  // === HAPPY: Arms up, bouncing ===
  void _drawHappy(Canvas canvas) {
    final bounce = [0.0, -1.5, 0.0, -1.0][frame];

    // Tail (wagging)
    final tailWag = [0.0, 1.0, 0.0, -1.0][frame];
    _drawPixelRect(canvas, 2 + tailWag, 18 + bounce, 2, 1, tailColor);
    _drawPixelRect(canvas, 1 + tailWag, 17 + bounce, 2, 1, tailColor);

    // Body
    _drawPixelRect(canvas, 11, 16 + bounce, 10, 8, dressColor);
    _drawPixelRect(canvas, 12, 15 + bounce, 8, 1, dressColor);

    // Arms UP
    _drawPixelRect(canvas, 10, 12 + bounce, 1, 4, skinColor);
    _drawPixelRect(canvas, 9, 11 + bounce, 2, 1, skinColor);
    _drawPixelRect(canvas, 21, 12 + bounce, 1, 4, skinColor);
    _drawPixelRect(canvas, 21, 11 + bounce, 2, 1, skinColor);

    // Head
    _drawPixelRect(canvas, 11, 8 + bounce, 10, 8, skinColor);

    // Hair
    _drawPixelRect(canvas, 10, 6 + bounce, 12, 4, hairColor);
    _drawPixelRect(canvas, 10, 8 + bounce, 1, 6, hairColor);
    _drawPixelRect(canvas, 21, 8 + bounce, 1, 6, hairColor);
    _drawPixelRect(canvas, 12, 5 + bounce, 8, 2, hairColor);

    // Cat ears
    _drawPixelRect(canvas, 10, 4 + bounce, 3, 3, hairColor);
    _drawPixelRect(canvas, 11, 5 + bounce, 1, 1, earInnerColor);
    _drawPixelRect(canvas, 19, 4 + bounce, 3, 3, hairColor);
    _drawPixelRect(canvas, 20, 5 + bounce, 1, 1, earInnerColor);

    // Star eyes (happy)
    _drawPixelRect(canvas, 13, 10 + bounce, 2, 2, Color(0xFFFFFF00));
    _drawPixelRect(canvas, 17, 10 + bounce, 2, 2, Color(0xFFFFFF00));

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
    _drawPixelRect(canvas, 11, 27 + bounce, 3, 1, Color(0xFF333366));
    _drawPixelRect(canvas, 18, 27 + bounce, 3, 1, Color(0xFF333366));
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
    _drawPixelRect(canvas, 12, 15, 8, 1, dressColor);

    // Arms (one scratching head)
    _drawPixelRect(canvas, 10, 17, 1, 4, skinColor);
    _drawPixelRect(canvas, 21, 14, 1, 3, skinColor);

    // Head
    _drawPixelRect(canvas, 11, 8, 10, 8, skinColor);

    // Hair
    _drawPixelRect(canvas, 10, 6, 12, 4, hairColor);
    _drawPixelRect(canvas, 10, 8, 1, 6, hairColor);
    _drawPixelRect(canvas, 21, 8, 1, 6, hairColor);
    _drawPixelRect(canvas, 12, 5, 8, 2, hairColor);

    // Cat ears (one droopy)
    _drawPixelRect(canvas, 10, 4, 3, 3, hairColor);
    _drawPixelRect(canvas, 11, 5, 1, 1, earInnerColor);
    _drawPixelRect(canvas, 19, 5, 3, 2, hairColor); // droopy ear

    // Eyes (one normal, one squinting)
    _drawPixelRect(canvas, 13, 10, 2, 2, eyeColor);
    _drawPixelRect(canvas, 17, 11, 2, 1, eyeColor); // squinting

    // Wavy mouth
    _drawPixelRect(canvas, 14, 13, 1, 1, mouthColor);
    _drawPixelRect(canvas, 16, 13, 1, 1, mouthColor);

    // Question mark above head
    _drawPixelRect(canvas, 23, 3, 1, 1, Color(0xFFFFFF00));
    _drawPixelRect(canvas, 23, 4, 1, 1, Color(0xFFFFFF00));
    _drawPixelRect(canvas, 24, 4, 1, 1, Color(0xFFFFFF00));
    _drawPixelRect(canvas, 24, 5, 1, 1, Color(0xFFFFFF00));
    _drawPixelRect(canvas, 23, 6, 1, 1, Color(0xFFFFFF00));

    // Legs
    _drawPixelRect(canvas, 12, 24, 2, 3, skinColor);
    _drawPixelRect(canvas, 18, 24, 2, 3, skinColor);
    _drawPixelRect(canvas, 11, 27, 3, 1, Color(0xFF333366));
    _drawPixelRect(canvas, 18, 27, 3, 1, Color(0xFF333366));
  }

  // === PUSHED AWAY: Sliding left, hands pushing ===
  void _drawPushedAway(Canvas canvas) {
    // ignore: unused_local_variable
    final slideX = frame * 2.0;

    // Body
    _drawPixelRect(canvas, 11, 16, 10, 8, dressColor);
    _drawPixelRect(canvas, 12, 15, 8, 1, dressColor);

    // Arms pushing forward (to the right)
    _drawPixelRect(canvas, 21, 16, 3, 1, skinColor);
    _drawPixelRect(canvas, 24, 15, 1, 3, skinColor);
    _drawPixelRect(canvas, 10, 17, 1, 4, skinColor);

    // Head
    _drawPixelRect(canvas, 11, 8, 10, 8, skinColor);

    // Hair
    _drawPixelRect(canvas, 10, 6, 12, 4, hairColor);
    _drawPixelRect(canvas, 10, 8, 1, 6, hairColor);
    _drawPixelRect(canvas, 21, 8, 1, 6, hairColor);
    _drawPixelRect(canvas, 12, 5, 8, 2, hairColor);

    // Cat ears
    _drawPixelRect(canvas, 10, 4, 3, 3, hairColor);
    _drawPixelRect(canvas, 11, 5, 1, 1, earInnerColor);
    _drawPixelRect(canvas, 19, 4, 3, 3, hairColor);
    _drawPixelRect(canvas, 20, 5, 1, 1, earInnerColor);

    // Eyes (struggling)
    _drawPixelRect(canvas, 13, 10, 2, 2, eyeColor);
    _drawPixelRect(canvas, 17, 10, 2, 2, eyeColor);
    // Sweat drop
    _drawPixelRect(canvas, 22, 9, 1, 1, Color(0xFF66CCFF));

    // Open mouth
    _drawPixelRect(canvas, 14, 13, 4, 1, mouthColor);

    // Motion lines
    for (int i = 0; i < 3; i++) {
      _drawPixelRect(canvas, 25 + i * 2, 10 + i * 3, 1, 2, Color(0xFFFFFFFF).withValues(alpha: 0.5));
    }

    // Legs (running pose)
    _drawPixelRect(canvas, 12, 24, 2, 3, skinColor);
    _drawPixelRect(canvas, 18, 24, 2, 3, skinColor);
    _drawPixelRect(canvas, 11, 27, 3, 1, Color(0xFF333366));
    _drawPixelRect(canvas, 18, 27, 3, 1, Color(0xFF333366));
  }

  // === SLEEPING: Lying down, eyes closed ===
  void _drawSleeping(Canvas canvas) {
    final breathe = frame == 0 ? 0.0 : 0.3;

    // Tail curled
    _drawPixelRect(canvas, 2, 20, 3, 1, tailColor);
    _drawPixelRect(canvas, 1, 19, 2, 1, tailColor);
    _drawPixelRect(canvas, 1, 18, 1, 1, tailColor);

    // Body (lying down, wider)
    _drawPixelRect(canvas, 6, 20 + breathe, 16, 4, dressColor);
    _drawPixelRect(canvas, 8, 19 + breathe, 12, 1, dressColor);

    // Head (resting on side)
    _drawPixelRect(canvas, 4, 18 + breathe, 6, 5, skinColor);

    // Hair
    _drawPixelRect(canvas, 3, 16 + breathe, 8, 3, hairColor);
    _drawPixelRect(canvas, 4, 18 + breathe, 1, 4, hairColor);
    _drawPixelRect(canvas, 3, 17 + breathe, 1, 1, earInnerColor); // ear

    // Closed eyes (lines)
    _drawPixelRect(canvas, 5, 20 + breathe, 2, 1, eyeColor);
    _drawPixelRect(canvas, 8, 20 + breathe, 2, 1, eyeColor);

    // Peaceful mouth
    _drawPixelRect(canvas, 6, 21 + breathe, 2, 1, mouthColor);

    // Blush
    _drawPixelRect(canvas, 5, 21 + breathe, 1, 1, blushColor);
    _drawPixelRect(canvas, 9, 21 + breathe, 1, 1, blushColor);

    // Feet
    _drawPixelRect(canvas, 20, 21 + breathe, 2, 2, skinColor);
    _drawPixelRect(canvas, 22, 22 + breathe, 2, 1, Color(0xFF333366));
  }

  // === SQUISHED: Flat/wide ===
  void _drawSquished(Canvas canvas) {
    // ignore: unused_local_variable
    final squish = [0.0, 0.5, 1.0][frame];

    // Body (wider, shorter)
    _drawPixelRect(canvas, 6, 20, 20, 4, dressColor);

    // Arms (spread out)
    _drawPixelRect(canvas, 4, 21, 2, 1, skinColor);
    _drawPixelRect(canvas, 26, 21, 2, 1, skinColor);

    // Head (wider)
    _drawPixelRect(canvas, 8, 14, 16, 6, skinColor);

    // Hair
    _drawPixelRect(canvas, 7, 12, 18, 3, hairColor);
    _drawPixelRect(canvas, 7, 14, 1, 5, hairColor);
    _drawPixelRect(canvas, 24, 14, 1, 5, hairColor);

    // Cat ears (flattened)
    _drawPixelRect(canvas, 7, 11, 4, 2, hairColor);
    _drawPixelRect(canvas, 21, 11, 4, 2, hairColor);

    // Eyes (X_X or dizzy)
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

    // Legs (spread)
    _drawPixelRect(canvas, 8, 24, 2, 2, skinColor);
    _drawPixelRect(canvas, 22, 24, 2, 2, skinColor);
  }

  // === SHOCKED: Big eyes, sweat drops ===
  void _drawShocked(Canvas canvas) {
    final shake = [0.0, -0.5, 0.5, 0.0][frame];

    // Body
    _drawPixelRect(canvas, 11 + shake, 16, 10, 8, dressColor);
    _drawPixelRect(canvas, 12 + shake, 15, 8, 1, dressColor);

    // Arms (up in shock)
    _drawPixelRect(canvas, 9 + shake, 14, 2, 1, skinColor);
    _drawPixelRect(canvas, 10 + shake, 15, 1, 3, skinColor);
    _drawPixelRect(canvas, 22 + shake, 14, 2, 1, skinColor);
    _drawPixelRect(canvas, 21 + shake, 15, 1, 3, skinColor);

    // Head
    _drawPixelRect(canvas, 11 + shake, 8, 10, 8, skinColor);

    // Hair
    _drawPixelRect(canvas, 10 + shake, 6, 12, 4, hairColor);
    _drawPixelRect(canvas, 10 + shake, 8, 1, 6, hairColor);
    _drawPixelRect(canvas, 21 + shake, 8, 1, 6, hairColor);
    _drawPixelRect(canvas, 12 + shake, 5, 8, 2, hairColor);

    // Cat ears (straight up, alert)
    _drawPixelRect(canvas, 10 + shake, 3, 3, 3, hairColor);
    _drawPixelRect(canvas, 11 + shake, 4, 1, 1, earInnerColor);
    _drawPixelRect(canvas, 19 + shake, 3, 3, 3, hairColor);
    _drawPixelRect(canvas, 20 + shake, 4, 1, 1, earInnerColor);

    // Big round eyes
    _drawPixelRect(canvas, 12 + shake, 9, 3, 3, Colors.white);
    _drawPixelRect(canvas, 13 + shake, 10, 1, 1, eyeColor);
    _drawPixelRect(canvas, 17 + shake, 9, 3, 3, Colors.white);
    _drawPixelRect(canvas, 18 + shake, 10, 1, 1, eyeColor);

    // O mouth
    _drawPixelRect(canvas, 15 + shake, 13, 2, 2, mouthColor);

    // Sweat drops
    _drawPixelRect(canvas, 22 + shake, 8, 1, 2, Color(0xFF66CCFF));
    _drawPixelRect(canvas, 9 + shake, 14, 1, 1, Color(0xFF66CCFF));

    // Legs
    _drawPixelRect(canvas, 12 + shake, 24, 2, 3, skinColor);
    _drawPixelRect(canvas, 18 + shake, 24, 2, 3, skinColor);
    _drawPixelRect(canvas, 11 + shake, 27, 3, 1, Color(0xFF333366));
    _drawPixelRect(canvas, 18 + shake, 27, 3, 1, Color(0xFF333366));

    // Exclamation marks
    _drawPixelRect(canvas, 24, 4, 1, 2, Color(0xFFFF0000));
    _drawPixelRect(canvas, 24, 7, 1, 1, Color(0xFFFF0000));
  }

  // === CELEBRATING: Jumping, spinning ===
  void _drawCelebrating(Canvas canvas) {
    final jumpHeight = [0.0, -2.0, -3.0, -2.0, 0.0, -1.5][frame];
    final spin = frame < 3;

    // Body
    _drawPixelRect(canvas, 11, 16 + jumpHeight, 10, 8, dressColor);
    _drawPixelRect(canvas, 12, 15 + jumpHeight, 8, 1, dressColor);

    // Arms (alternating up)
    if (spin) {
      _drawPixelRect(canvas, 9, 10 + jumpHeight, 2, 1, skinColor);
      _drawPixelRect(canvas, 10, 11 + jumpHeight, 1, 5, skinColor);
      _drawPixelRect(canvas, 21, 13 + jumpHeight, 2, 1, skinColor);
      _drawPixelRect(canvas, 21, 14 + jumpHeight, 1, 3, skinColor);
    } else {
      _drawPixelRect(canvas, 21, 10 + jumpHeight, 2, 1, skinColor);
      _drawPixelRect(canvas, 21, 11 + jumpHeight, 1, 5, skinColor);
      _drawPixelRect(canvas, 9, 13 + jumpHeight, 2, 1, skinColor);
      _drawPixelRect(canvas, 10, 14 + jumpHeight, 1, 3, skinColor);
    }

    // Head
    _drawPixelRect(canvas, 11, 8 + jumpHeight, 10, 8, skinColor);

    // Hair
    _drawPixelRect(canvas, 10, 6 + jumpHeight, 12, 4, hairColor);
    _drawPixelRect(canvas, 10, 8 + jumpHeight, 1, 6, hairColor);
    _drawPixelRect(canvas, 21, 8 + jumpHeight, 1, 6, hairColor);
    _drawPixelRect(canvas, 12, 5 + jumpHeight, 8, 2, hairColor);

    // Cat ears
    _drawPixelRect(canvas, 10, 4 + jumpHeight, 3, 3, hairColor);
    _drawPixelRect(canvas, 11, 5 + jumpHeight, 1, 1, earInnerColor);
    _drawPixelRect(canvas, 19, 4 + jumpHeight, 3, 3, hairColor);
    _drawPixelRect(canvas, 20, 5 + jumpHeight, 1, 1, earInnerColor);

    // Happy eyes (closed, smiling)
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
    _drawPixelRect(canvas, 11, 27 + jumpHeight, 3, 1, Color(0xFF333366));
    _drawPixelRect(canvas, 18, 27 + jumpHeight, 3, 1, Color(0xFF333366));

    // Sparkles
    if (frame % 2 == 0) {
      _drawPixelRect(canvas, 5, 5 + jumpHeight, 1, 1, Color(0xFFFFFF00));
      _drawPixelRect(canvas, 26, 8 + jumpHeight, 1, 1, Color(0xFFFFFF00));
      _drawPixelRect(canvas, 3, 14 + jumpHeight, 1, 1, Color(0xFFFF00FF));
    }
  }

  @override
  bool shouldRepaint(covariant CatGirlPainter oldDelegate) {
    return oldDelegate.state != state || oldDelegate.frame != frame;
  }
}
