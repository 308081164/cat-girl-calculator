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
    if (widget.label == '=') return AppColors.magenta.withValues(alpha: 0.3);
    if ('÷×+-'.contains(widget.label)) return AppColors.buttonOpBg;
    if (widget.label == 'C') return AppColors.red.withValues(alpha: 0.2);
    if (widget.label == '⌫') return AppColors.buttonSpecialBg;
    return AppColors.buttonBg;
  }

  Color _getBorderColor() {
    if (widget.label == '=') return AppColors.magenta;
    if ('÷×+-'.contains(widget.label)) return AppColors.cyan.withValues(alpha: 0.6);
    if (widget.label == 'C') return AppColors.red.withValues(alpha: 0.6);
    return AppColors.cyan.withValues(alpha: 0.2);
  }

  TextStyle _getTextStyle() {
    if (widget.label == '=') return PixelTextStyles.buttonSpecial;
    if ('÷×+-'.contains(widget.label)) return PixelTextStyles.buttonOp;
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
              ? _getBackgroundColor().withValues(alpha: 0.5)
              : _getBackgroundColor(),
          border: Border.all(color: _getBorderColor(), width: 2),
          borderRadius: BorderRadius.circular(4),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(2, 2),
                  ),
                ],
        ),
        transform: _isPressed
            ? (Matrix4.identity()..translate(0.0, 1.0))
            : Matrix4.identity(), // ignore: deprecated_member_use
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
