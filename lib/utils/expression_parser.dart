import 'package:math_expressions/math_expressions.dart';
import '../models/cat_state.dart';

class ParseResult {
  final String value;
  final CatState catState;
  final bool hasError;
  ParseResult({
    required this.value,
    required this.catState,
    required this.hasError,
  });
}

class ExpressionParser {
  final ContextModel _context = ContextModel();

  ParseResult evaluate(String expression) {
    try {
      if (expression.isEmpty) {
        return ParseResult(value: '0', catState: CatState.idle, hasError: false);
      }

      // Check for divide by zero
      if (RegExp(r'/\s*0(?!\.)').hasMatch(expression)) {
        return ParseResult(value: 'Error!', catState: CatState.shocked, hasError: true);
      }

      final parser = GrammarParser();
      final exp = parser.parse(expression);
      final result = exp.evaluate(EvaluationType.REAL, _context);

      if (result.isInfinite || result.isNaN) {
        return ParseResult(value: 'Error!', catState: CatState.shocked, hasError: true);
      }

      String formatted;
      if (result == result.roundToDouble()) {
        formatted = result.toInt().toString();
      } else {
        formatted = result.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      }

      return ParseResult(
        value: formatted,
        catState: _determineCatState(formatted, result),
        hasError: false,
      );
    } catch (e) {
      return ParseResult(value: 'Error!', catState: CatState.confused, hasError: true);
    }
  }

  CatState _determineCatState(String formatted, double result) {
    // Round numbers like 100, 1000, etc.
    if (result == result.roundToDouble() && result != 0) {
      final intResult = result.toInt();
      if (intResult >= 100 && intResult % 100 == 0) {
        return CatState.celebrating;
      }
      // Nice numbers: 42, 69, 100, 256, 360, 512, 1024, etc.
      final niceNumbers = {42, 69, 100, 256, 360, 512, 666, 777, 888, 999, 1024, 2048, 4096};
      if (niceNumbers.contains(intResult)) {
        return CatState.happy;
      }
    }

    // Very long result
    if (formatted.length > 12) {
      return CatState.squished;
    }

    return CatState.happy;
  }
}
