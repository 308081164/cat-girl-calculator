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
