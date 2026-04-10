import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/pixel_text_styles.dart';

class ZzzEffect extends StatefulWidget {
  const ZzzEffect({super.key});

  @override
  State<ZzzEffect> createState() => _ZzzEffectState();
}

class _ZzzEffectState extends State<ZzzEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            children: [
              // First Z
              Transform.translate(
                offset: Offset(
                  math.sin(t * 2 * math.pi) * 8,
                  -t * 40,
                ),
                child: Opacity(
                  opacity: math.max(0, 1.0 - t),
                  child: Text('Z', style: PixelTextStyles.zzz),
                ),
              ),
              // Second Z (delayed)
              if (t > 0.3)
                Transform.translate(
                  offset: Offset(
                    math.sin((t - 0.3) * 2 * math.pi) * 8,
                    -(t - 0.3) * 40,
                  ),
                  child: Opacity(
                    opacity: math.max(0, 1.3 - t),
                    child: Text('Z', style: PixelTextStyles.zzzSmall),
                  ),
                ),
              // Third Z (more delayed)
              if (t > 0.6)
                Transform.translate(
                  offset: Offset(
                    math.sin((t - 0.6) * 2 * math.pi) * 8,
                    -(t - 0.6) * 40,
                  ),
                  child: Opacity(
                    opacity: math.max(0, 1.6 - t),
                    child: Text('z', style: PixelTextStyles.zzzSmall.copyWith(fontSize: 10)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
