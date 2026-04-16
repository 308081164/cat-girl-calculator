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

      // 处理负数：将表达式开头的负号或运算符后的负号转换为 (0-...) 形式
      // 例如 "-5+3" -> "(0-5)+3"，"5+-3" -> "5+(0-3)"
      String processed = _handleNegativeNumbers(expression);

      // 大数精度保护：对于简单的 a+b 或 a-b，使用字符串运算
      final simpleAddSub = RegExp(r'^\(?(\d+)\)?\s*([+\-])\s*\(?(0-)?(\d+)\)?$');
      final match = simpleAddSub.firstMatch(processed);
      if (match != null) {
        final a = match[1]!;
        final op = match[2]!;
        final b = match[4]!;
        if (a.length > 15 || b.length > 15) {
          // 使用字符串大数运算
          String bigResult = _bigNumberOp(a, op, b);
          return ParseResult(
            value: bigResult,
            catState: _determineCatState(bigResult, double.tryParse(bigResult) ?? 0),
            hasError: false,
          );
        }
      }

      final parser = GrammarParser();
      final exp = parser.parse(processed);
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

  /// 处理表达式中的负数，将负号转换为 (0-...) 形式
  /// 使 math_expressions 解析器能正确解析负数
  String _handleNegativeNumbers(String expression) {
    // 处理表达式开头的负号："-5" -> "(0-5)"
    String result = expression.replaceFirstMapped(
      RegExp(r'^(-)(\d+\.?\d*)'),
      (m) => '(0${m[1]}${m[2]})',
    );

    // 处理运算符后的负号："5+-3" -> "5+(0-3)"，"5*-3" -> "5*(0-3)"
    result = result.replaceAllMapped(
      RegExp(r'([+\-*/])(-)(\d+\.?\d*)'),
      (m) => '${m[1]}(0${m[2]}${m[3]})',
    );

    return result;
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

  /// 字符串大数加法
  static String _bigNumberAdd(String a, String b) {
    // 对齐位数
    int maxLen = a.length > b.length ? a.length : b.length;
    a = a.padLeft(maxLen, '0');
    b = b.padLeft(maxLen, '0');

    String result = '';
    int carry = 0;
    for (int i = maxLen - 1; i >= 0; i--) {
      int sum = int.parse(a[i]) + int.parse(b[i]) + carry;
      carry = sum ~/ 10;
      result = (sum % 10).toString() + result;
    }
    if (carry > 0) result = carry.toString() + result;
    return result;
  }

  /// 字符串大数减法（假设 a >= b）
  static String _bigNumberSub(String a, String b) {
    a = a.padLeft(a.length, '0');
    b = b.padLeft(a.length, '0');

    String result = '';
    int borrow = 0;
    for (int i = a.length - 1; i >= 0; i--) {
      int diff = int.parse(a[i]) - int.parse(b[i]) - borrow;
      if (diff < 0) {
        diff += 10;
        borrow = 1;
      } else {
        borrow = 0;
      }
      result = diff.toString() + result;
    }
    // 去除前导零
    result = result.replaceFirst(RegExp(r'^0+'), '');
    return result.isEmpty ? '0' : result;
  }

  static String _bigNumberOp(String a, String op, String b) {
    if (op == '+') return _bigNumberAdd(a, b);
    // 判断哪个大
    if (a.length > b.length || (a.length == b.length && a.compareTo(b) >= 0)) {
      return _bigNumberSub(a, b);
    } else {
      return '-' + _bigNumberSub(b, a);
    }
  }
}
