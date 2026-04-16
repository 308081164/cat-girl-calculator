import 'dart:async';
import 'package:flutter/material.dart';
import '../models/calculator_state.dart';
import '../models/cat_state.dart';
import '../utils/expression_parser.dart';

class CalculatorController extends ChangeNotifier {
  CalculatorState _state = const CalculatorState();
  CalculatorState get state => _state;

  final ExpressionParser _parser = ExpressionParser();
  Timer? _idleTimer;
  static const _idleThreshold = Duration(seconds: 10);
  String _currentInput = '';
  String _pendingExpression = '';
  bool _justCalculated = false;

  CalculatorController() {
    _resetIdleTimer();
  }

  void onNumberPressed(String digit) {
    _resetIdleTimer();
    if (_justCalculated) {
      _currentInput = '';
      _pendingExpression = '';
      _justCalculated = false;
    }
    // 限制最大输入15位（double安全整数范围内）
    if (_currentInput.replaceFirst('-', '').length >= 15) return;
    if (_currentInput == '0' && digit != '.') {
      _currentInput = digit;
    } else {
      _currentInput += digit;
    }
    _updateDisplay();
    _checkPushAway();
  }

  void onOperatorPressed(String op) {
    _resetIdleTimer();
    _justCalculated = false;
    if (_currentInput.isNotEmpty) {
      _pendingExpression += _currentInput + op;
      _currentInput = '';
    } else if (_pendingExpression.isNotEmpty) {
      _pendingExpression = _pendingExpression.replaceAll(RegExp(r'[+\-*/]$'), '') + op;
    }
    _updateDisplay();
  }

  void onEqualsPressed() {
    _resetIdleTimer();
    if (_currentInput.isEmpty && _pendingExpression.isEmpty) return;

    final fullExpression = _pendingExpression + _currentInput;
    final result = _parser.evaluate(fullExpression);

    _state = _state.copyWith(
      expression: fullExpression,
      resultText: result.value,
      catState: result.catState,
      hasError: result.hasError,
    );

    _currentInput = '';
    _pendingExpression = '';
    _justCalculated = true;

    // Auto return to idle after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (_state.catState != CatState.sleeping && _state.catState != CatState.idle) {
        _state = _state.copyWith(catState: CatState.idle);
        notifyListeners();
      }
    });

    notifyListeners();
  }

  void onClearPressed() {
    _resetIdleTimer();
    _currentInput = '';
    _pendingExpression = '';
    _justCalculated = false;
    _state = _state.copyWith(
      expression: '',
      resultText: '0',
      catState: CatState.confused,
      hasError: false,
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (_state.catState == CatState.confused) {
        _state = _state.copyWith(catState: CatState.idle);
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void onBackspacePressed() {
    _resetIdleTimer();
    if (_currentInput.isNotEmpty) {
      _currentInput = _currentInput.substring(0, _currentInput.length - 1);
    }
    _updateDisplay();
  }

  void onDecimalPressed() {
    _resetIdleTimer();
    if (_justCalculated) {
      _currentInput = '0';
      _pendingExpression = '';
      _justCalculated = false;
    }
    if (!_currentInput.contains('.')) {
      _currentInput += '.';
    }
    _updateDisplay();
  }

  /// CE - 清除当前输入的数字，保留表达式
  void clearEntry() {
    _resetIdleTimer();
    _currentInput = '';
    _updateDisplay();
  }

  /// +/- - 切换当前数字的正负号
  void toggleSign() {
    _resetIdleTimer();
    if (_currentInput.isEmpty) return;
    if (_currentInput.startsWith('-')) {
      _currentInput = _currentInput.substring(1);
    } else {
      _currentInput = '-$_currentInput';
    }
    _updateDisplay();
  }

  /// % - 百分比计算，将当前数字除以100
  void percentage() {
    _resetIdleTimer();
    if (_currentInput.isEmpty) return;
    final num value = num.parse(_currentInput);
    final result = value / 100;
    _currentInput = _formatNumber(result);
    _updateDisplay();
  }

  /// 1/x - 倒数计算
  void reciprocal() {
    _resetIdleTimer();
    if (_currentInput.isEmpty) return;
    final num value = num.parse(_currentInput);
    if (value == 0) {
      _state = _state.copyWith(
        resultText: 'Error!',
        catState: CatState.shocked,
        hasError: true,
      );
      notifyListeners();
      return;
    }
    final result = 1 / value;
    _currentInput = _formatNumber(result);
    _updateDisplay();
  }

  /// x² - 平方计算
  void square() {
    _resetIdleTimer();
    if (_currentInput.isEmpty) return;
    final num value = num.parse(_currentInput);
    final result = value * value;
    _currentInput = _formatNumber(result);
    _updateDisplay();
  }

  /// ²√x - 平方根计算
  void squareRoot() {
    _resetIdleTimer();
    if (_currentInput.isEmpty) return;
    final num value = num.parse(_currentInput);
    if (value < 0) {
      _state = _state.copyWith(
        resultText: 'Error!',
        catState: CatState.shocked,
        hasError: true,
      );
      notifyListeners();
      return;
    }
    final result = _sqrt(value.toDouble());
    _currentInput = _formatNumber(result);
    _updateDisplay();
  }

  /// 格式化数字，去除不必要的尾零
  String _formatNumber(num value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    String formatted = value.toStringAsFixed(8)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
    return formatted;
  }

  /// 计算平方根（使用 dart:math）
  double _sqrt(double value) {
    // 使用简单的牛顿迭代法，避免引入 dart:math
    if (value < 0) return double.nan;
    if (value == 0) return 0;
    double x = value;
    double y = (x + 1) / 2;
    while (y < x) {
      x = y;
      y = (x + value / x) / 2;
    }
    return x;
  }

  void _updateDisplay() {
    final displayText = _currentInput.isEmpty ? '0' : _currentInput;
    _state = _state.copyWith(
      expression: _pendingExpression,
      resultText: displayText,
      catState: CatState.idle,
    );
    notifyListeners();
  }

  void _checkPushAway() {
    if (_currentInput.length > 8) {
      _state = _state.copyWith(catState: CatState.pushedAway);
      notifyListeners();
    }
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(_idleThreshold, () {
      _state = _state.copyWith(catState: CatState.sleeping);
      notifyListeners();
    });
  }

  void wakeUp() {
    _resetIdleTimer();
    if (_state.catState == CatState.sleeping) {
      _state = _state.copyWith(catState: CatState.idle);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    super.dispose();
  }
}
