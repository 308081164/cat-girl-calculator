import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/pixel_text_styles.dart';

class CalcButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const CalcButton({super.key, required this.label, required this.onPressed});

  @override
  State<CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton> {
  bool _isPressed = false;

  Color _getBackgroundColor() {
    if (widget.label == '=') return AppColors.buttonSpecialBg;
    if ('÷×+-'.contains(widget.label)) return AppColors.buttonOpBg;
    if (widget.label == 'C') return AppColors.buttonBg;
    if (widget.label == '⌫') return AppColors.buttonOpBg;
    return AppColors.panel;
  }

  Color _getPressedBackgroundColor() {
    if (widget.label == '=') return const Color(0xFF006CBE);
    if ('÷×+-'.contains(widget.label)) return const Color(0xFFD8D8D8);
    if (widget.label == 'C') return const Color(0xFFE0E0E0);
    if (widget.label == '⌫') return const Color(0xFFD8D8D8);
    return const Color(0xFFE8E8E8);
  }

  Color _getBorderColor() {
    return AppColors.border;
  }

  TextStyle _getTextStyle() {
    if (widget.label == '=') return PixelTextStyles.buttonSpecial;
    if ('÷×+-'.contains(widget.label)) return PixelTextStyles.buttonOp;
    if (widget.label == 'C') {
      return PixelTextStyles.button.copyWith(color: AppColors.red);
    }
    return PixelTextStyles.button;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        decoration: BoxDecoration(
          color: _isPressed
              ? _getPressedBackgroundColor()
              : _getBackgroundColor(),
          border: Border.all(color: _getBorderColor(), width: 1),
          borderRadius: BorderRadius.circular(8),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            widget.label,
            style: _getTextStyle(),
          ),
        ),
      ),
    );
  }
}
