import 'package:flutter/material.dart';
import '../controllers/calculator_controller.dart';
import 'calc_button.dart';

class ButtonGrid extends StatelessWidget {
  final CalculatorController controller;
  const ButtonGrid({super.key, required this.controller});

  static const _buttons = [
    ['C', '(', ')', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['0', '.', '⌫', '='],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: Column(
        children: _buttons.map((row) {
          return Expanded(
            child: Row(
              children: row.map((label) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: CalcButton(
                      label: label,
                      onPressed: () => _handlePress(label),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _handlePress(String label) {
    controller.wakeUp();
    switch (label) {
      case 'C':
        controller.onClearPressed();
        break;
      case '=':
        controller.onEqualsPressed();
        break;
      case '.':
        controller.onDecimalPressed();
        break;
      case '⌫':
        controller.onBackspacePressed();
        break;
      case '÷':
        controller.onOperatorPressed('/');
        break;
      case '×':
        controller.onOperatorPressed('*');
        break;
      case '+':
      case '-':
        controller.onOperatorPressed(label);
        break;
      case '(':
      case ')':
        controller.onNumberPressed(label);
        break;
      default:
        controller.onNumberPressed(label);
    }
  }
}
