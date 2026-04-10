import 'package:flutter/material.dart';
import '../controllers/calculator_controller.dart';
import '../theme/app_colors.dart';
import 'display_area.dart';
import 'button_grid.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorController _controller = CalculatorController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _controller.wakeUp,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Title bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.cyan.withValues(alpha: 0.3), width: 2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '🐱 猫猫计算器 🐱',
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        fontSize: 12,
                        color: AppColors.cyan,
                        shadows: const [
                          Shadow(color: AppColors.cyan, blurRadius: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Display area
              Expanded(
                flex: 3,
                child: DisplayArea(controller: _controller),
              ),
              // Separator
              Container(height: 2, color: AppColors.cyan.withValues(alpha: 0.5)),
              // Button grid
              Expanded(
                flex: 7,
                child: ButtonGrid(controller: _controller),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
