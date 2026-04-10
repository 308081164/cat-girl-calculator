import 'cat_state.dart';

class CalculatorState {
  final String expression;
  final String resultText;
  final CatState catState;
  final bool hasError;

  const CalculatorState({
    this.expression = '',
    this.resultText = '0',
    this.catState = CatState.idle,
    this.hasError = false,
  });

  CalculatorState copyWith({
    String? expression,
    String? resultText,
    CatState? catState,
    bool? hasError,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      resultText: resultText ?? this.resultText,
      catState: catState ?? this.catState,
      hasError: hasError ?? this.hasError,
    );
  }
}
