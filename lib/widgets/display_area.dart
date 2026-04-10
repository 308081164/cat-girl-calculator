import 'package:flutter/material.dart';
import '../controllers/calculator_controller.dart';
import '../models/calculator_state.dart';
import '../models/cat_state.dart';
import '../theme/app_colors.dart';
import '../theme/pixel_text_styles.dart';
import 'cat_character.dart';
import 'scanline_overlay.dart';
import 'zzz_effect.dart';

class DisplayArea extends StatelessWidget {
  final CalculatorController controller;
  const DisplayArea({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final state = controller.state;
        final screenWidth = MediaQuery.of(context).size.width;

        return Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.displayBg,
            border: Border.all(color: AppColors.cyan.withValues(alpha: 0.6), width: 3),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.15),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Stack(
              children: [
                // Scanline overlay
                const Positioned.fill(
                  child: ScanlineOverlay(),
                ),
                // Expression text (top)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Text(
                    state.expression,
                    style: PixelTextStyles.expression,
                  ),
                ),
                // Result text (bottom right)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Text(
                    state.resultText,
                    style: PixelTextStyles.result.copyWith(
                      fontSize: _getResultFontSize(state.resultText),
                      color: state.hasError ? AppColors.red : AppColors.textPrimary,
                    ),
                  ),
                ),
                // Cat character
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  left: _getCatLeft(state, screenWidth),
                  bottom: _getCatBottom(state),
                  child: CatCharacter(catState: state.catState),
                ),
                // Zzz effect when sleeping
                if (state.catState == CatState.sleeping)
                  Positioned(
                    top: 30,
                    right: screenWidth * 0.3,
                    child: const ZzzEffect(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _getResultFontSize(String text) {
    if (text.length > 14) return 16;
    if (text.length > 10) return 20;
    if (text.length > 7) return 24;
    return 28;
  }

  double _getCatLeft(CalculatorState state, double screenWidth) {
    switch (state.catState) {
      case CatState.pushedAway:
        return -60;
      case CatState.squished:
        return 10;
      case CatState.shocked:
        return screenWidth * 0.5 + 20;
      default:
        return screenWidth * 0.05;
    }
  }

  double _getCatBottom(CalculatorState state) {
    switch (state.catState) {
      case CatState.sleeping:
        return 8;
      case CatState.squished:
        return 0;
      case CatState.pushedAway:
        return 30;
      default:
        return 20;
    }
  }
}
