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

  static const _totalFrames = 20;

  // 每帧间隔（毫秒）- 20帧 × 100ms = 2秒完整循环
  static const _frameDurations = {
    CatState.idle: 200,
    CatState.happy: 160,
    CatState.confused: 240,
    CatState.pushedAway: 160,
    CatState.sleeping: 300,
    CatState.squished: 200,
    CatState.shocked: 120,
    CatState.celebrating: 160,
  };

  static const _basePath = 'assets/sprites/pixel_v4';

  String _framePath(int frame) {
    return '$_basePath/${widget.catState.name}_frame${frame.toString().padLeft(2, '0')}.png';
  }

  @override
  void initState() {
    super.initState();
    _frameController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _frameDurations[widget.catState] ?? 100),
    )..repeat();
    _frameController.addListener(_onFrame);
  }

  void _onFrame() {
    final newFrame = (_frameController.value * _totalFrames).floor() % _totalFrames;
    if (newFrame != _currentFrame) {
      setState(() => _currentFrame = newFrame);
    }
  }

  @override
  void didUpdateWidget(CatCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.catState != widget.catState) {
      _currentFrame = 0;
      _frameController.duration = Duration(milliseconds: _frameDurations[widget.catState] ?? 100);
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
      child: Image.asset(
        _framePath(_currentFrame),
        fit: BoxFit.contain,
        filterQuality: FilterQuality.none,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 160,
            height: 160,
            color: Colors.grey[200],
            child: const Center(
              child: Text('?', style: TextStyle(fontSize: 48, color: Colors.grey)),
            ),
          );
        },
      ),
    );
  }
}
