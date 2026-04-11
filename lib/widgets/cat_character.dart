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

  // 帧数配置
  static const _frameCounts = {
    CatState.idle: 3,
    CatState.happy: 3,
    CatState.confused: 2,
    CatState.pushedAway: 2,
    CatState.sleeping: 2,
    CatState.squished: 2,
    CatState.shocked: 2,
    CatState.celebrating: 3,
  };

  // 帧间隔（毫秒）
  static const _frameDurations = {
    CatState.idle: 600,
    CatState.happy: 300,
    CatState.confused: 500,
    CatState.pushedAway: 250,
    CatState.sleeping: 1000,
    CatState.squished: 400,
    CatState.shocked: 200,
    CatState.celebrating: 250,
  };

  // 精灵图路径映射
  static const _spritePaths = {
    CatState.idle: [
      'assets/sprites/pixel_v2/idle_frame0.png',
      'assets/sprites/pixel_v2/idle_frame1.png',
      'assets/sprites/pixel_v2/idle_frame2.png',
    ],
    CatState.happy: [
      'assets/sprites/pixel_v2/happy_frame0.png',
      'assets/sprites/pixel_v2/happy_frame1.png',
      'assets/sprites/pixel_v2/happy_frame2.png',
    ],
    CatState.confused: [
      'assets/sprites/pixel_v2/confused_frame0.png',
      'assets/sprites/pixel_v2/confused_frame1.png',
    ],
    CatState.pushedAway: [
      'assets/sprites/pixel_v2/pushedAway_frame0.png',
      'assets/sprites/pixel_v2/pushedAway_frame1.png',
    ],
    CatState.sleeping: [
      'assets/sprites/pixel_v2/sleeping_frame0.png',
      'assets/sprites/pixel_v2/sleeping_frame1.png',
    ],
    CatState.squished: [
      'assets/sprites/pixel_v2/squished_frame0.png',
      'assets/sprites/pixel_v2/squished_frame1.png',
    ],
    CatState.shocked: [
      'assets/sprites/pixel_v2/shocked_frame0.png',
      'assets/sprites/pixel_v2/shocked_frame1.png',
    ],
    CatState.celebrating: [
      'assets/sprites/pixel_v2/celebrating_frame0.png',
      'assets/sprites/pixel_v2/celebrating_frame1.png',
      'assets/sprites/pixel_v2/celebrating_frame2.png',
    ],
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
    final frameCount = _frameCounts[widget.catState] ?? 2;
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
    final paths = _spritePaths[widget.catState] ?? [];
    if (paths.isEmpty || _currentFrame >= paths.length) {
      return const SizedBox(width: 160, height: 160);
    }

    return SizedBox(
      width: 160,
      height: 160,
      child: Image.asset(
        paths[_currentFrame],
        fit: BoxFit.contain,
        filterQuality: FilterQuality.none, // 保持像素锐利
        errorBuilder: (context, error, stackTrace) {
          // 加载失败时显示占位
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
