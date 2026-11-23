
import '../models/case_model.dart';
import 'logic_instruction.dart';
import 'logic_test_result.dart';

class LogicExecutor {
  // ============================================================
  // MENJALANKAN SATU TEST CASE
  // ============================================================

    static dynamic execute({
    required List<LogicInstruction> instructions,
    required CaseModel caseData,
    required TestCase testCase,
    List<dynamic>? manualInputValues,
    }) {
    final variables = <String, dynamic>{};
    final declared = <String>{};

    // Mengambil urutan data input dari JSON.
    final inputValues = manualInputValues ??
    caseData.logicBuilder.inputOrder.map((key) {
      if (!testCase.input.containsKey(key)) {
        throw FormatException(
          'Data input "$key" tidak ditemukan pada test case.',
        );
      }
      return testCase.input[key];
    }).toList();

    var inputIndex = 0;
    dynamic output;

    void executeInstructions(List<LogicInstruction> items) {
      for (final instruction in items) {
        final content = instruction.content?.trim() ?? '';

        switch (instruction.type) {
          case LogicInstructionType.declare:
            final match = RegExp(
              r'^(.+)\s*:\s*(integer|real|string|boolean)$',
              caseSensitive: false,
            ).firstMatch(content);

            if (match == null) {
              throw const FormatException(
                'Format DECLARE tidak valid.',
              );
            }

            final names = match.group(1)!
                .split(',')
                .map((name) => name.trim().toLowerCase())
                .toList();

            for (final name in names) {
              if (!RegExp(
                r'^[a-zA-Z_][a-zA-Z0-9_]*$',
              ).hasMatch(name)) {
                throw FormatException(
                  'Nama variabel "$name" tidak valid.',
                );
              }

              if (!declared.add(name)) {
                throw FormatException(
                  'Variabel "$name" sudah dideklarasikan.',
                );
              }
            }
            break;

          case LogicInstructionType.input:
            final name = content.toLowerCase();

            if (!declared.contains(name)) {
              throw FormatException(
                'Variabel "$name" belum dideklarasikan.',
              );
            }

            if (inputIndex >= inputValues.length) {
              throw const FormatException(
                'Jumlah blok INPUT melebihi data masukan.',
              );
            }

            final value = inputValues[inputIndex];

            if (value == null) {
              throw FormatException(
                'Data input untuk "$name" kosong.',
              );
            }

            variables[name] = value;
            inputIndex++;
            break;

          case LogicInstructionType.process:
            final separator = content.indexOf('=');

            if (separator < 1) {
              throw const FormatException(
                'Format PROCESS tidak valid. Gunakan variabel = rumus.',
              );
            }

            final target = content
                .substring(0, separator)
                .trim()
                .toLowerCase();

            final expression = content
                .substring(separator + 1)
                .trim();

            if (!declared.contains(target)) {
              throw FormatException(
                'Variabel hasil "$target" belum dideklarasikan.',
              );
            }

            if (expression.isEmpty) {
              throw const FormatException(
                'Rumus PROCESS tidak boleh kosong.',
              );
            }

            // Mendukung nilai teks, misalnya status = "Lulus".
            final stringMatch = RegExp(
              r"""^(['"])(.*)\1$""",
            ).firstMatch(expression);

            if (stringMatch != null) {
              variables[target] = stringMatch.group(2)!;
            } else {
              variables[target] = _calculate(
                expression,
                variables,
              );
            }
            break;

          case LogicInstructionType.decision:
            final condition = _evaluateCondition(
              content,
              variables,
            );

            if (condition) {
              executeInstructions(instruction.trueBranch);
            } else {
              executeInstructions(instruction.falseBranch);
            }
            break;

          case LogicInstructionType.output:
            final name = content.toLowerCase();

            if (!declared.contains(name)) {
              throw FormatException(
                'Variabel OUTPUT "$name" belum dideklarasikan.',
              );
            }

            if (!variables.containsKey(name)) {
              throw FormatException(
                'Variabel OUTPUT "$name" belum memiliki nilai.',
              );
            }

            output = variables[name];
            break;
        }
      }
    }

    executeInstructions(instructions);

    if (inputIndex != inputValues.length) {
      throw FormatException(
        'Jumlah blok INPUT belum sesuai. '
        'Dibutuhkan ${inputValues.length}, digunakan $inputIndex.',
      );
    }

    if (output == null) {
      throw const FormatException(
        'Algoritma belum menghasilkan OUTPUT.',
      );
    }

    return output;
  }

  // ============================================================
  // MENJALANKAN SEMUA TEST CASE
  // ============================================================

  static List<LogicTestResult> runAllTests({
    required List<LogicInstruction> instructions,
    required CaseModel caseData,
  }) {
    final results = <LogicTestResult>[];

    for (var i = 0; i < caseData.testCases.length; i++) {
      final testCase = caseData.testCases[i];

      try {
        final actual = execute(
          instructions: instructions,
          caseData: caseData,
          testCase: testCase,
        );

        final expected = testCase.expectedResult;
        final passed = _isSameResult(actual, expected);

        results.add(
          LogicTestResult(
            testNumber: i + 1,
            passed: passed,
            expected: expected,
            actual: actual,
            message: passed
                ? 'Test case ${i + 1} berhasil.'
                : 'Hasil belum sesuai pada test case ${i + 1}.',
          ),
        );
      } catch (error) {
        results.add(
          LogicTestResult(
            testNumber: i + 1,
            passed: false,
            expected: testCase.expectedResult,
            actual: null,
            message: 'Test case ${i + 1} gagal: $error',
          ),
        );
      }
    }

    return results;
  }

  // ============================================================
  // MEMBANDINGKAN HASIL
  // ============================================================

  static bool _isSameResult(dynamic actual, dynamic expected) {
    if (actual is num && expected is num) {
      return (actual - expected).abs() < 0.000001;
    }

    if (actual is String && expected is String) {
      return actual.trim().toLowerCase() ==
          expected.trim().toLowerCase();
    }

    return actual == expected;
  }

  // ============================================================
  // MEMERIKSA KONDISI DECISION
  // ============================================================

  static bool _evaluateCondition(
    String condition,
    Map<String, dynamic> variables,
  ) {
    final match = RegExp(
      r'^(.+?)\s*(>=|<=|==|!=|>|<)\s*(.+)$',
    ).firstMatch(condition);

    if (match == null) {
      throw FormatException(
        'Kondisi DECISION "$condition" belum valid.',
      );
    }

    final leftText = match.group(1)!.trim();
    final operator = match.group(2)!;
    final rightText = match.group(3)!.trim();

    final left = _readConditionValue(leftText, variables);
    final right = _readConditionValue(rightText, variables);

    if (left is num && right is num) {
      switch (operator) {
        case '>':
          return left > right;
        case '<':
          return left < right;
        case '>=':
          return left >= right;
        case '<=':
          return left <= right;
        case '==':
          return left == right;
        case '!=':
          return left != right;
      }
    }

    if (left is String && right is String) {
      final comparison = left.compareTo(right);

      switch (operator) {
        case '==':
          return comparison == 0;
        case '!=':
          return comparison != 0;
        case '>':
          return comparison > 0;
        case '<':
          return comparison < 0;
        case '>=':
          return comparison >= 0;
        case '<=':
          return comparison <= 0;
      }
    }

    throw const FormatException(
      'Tipe data pada kondisi DECISION tidak sesuai.',
    );
  }

  static dynamic _readConditionValue(
    String expression,
    Map<String, dynamic> variables,
  ) {
    final textMatch = RegExp(
      r"""^(['"])(.*)\1$""",
    ).firstMatch(expression);

    if (textMatch != null) {
      return textMatch.group(2)!;
    }

    final number = num.tryParse(expression);
    if (number != null) return number;

    final key = expression.toLowerCase();

    if (variables.containsKey(key)) {
      return variables[key];
    }

    throw FormatException(
      'Nilai "$expression" tidak ditemukan.',
    );
  }

  // ============================================================
  // KALKULASI MATEMATIKA
  // ============================================================

  static num _calculate(
    String expression,
    Map<String, dynamic> variables,
  ) {
    final normalized = expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll(',', '.');

    final tokens = <String>[];

    final pattern = RegExp(
      r'\d+(?:\.\d+)?|[a-zA-Z_][a-zA-Z0-9_]*|[()+\-*/]',
    );

    var lastEnd = 0;

    for (final match in pattern.allMatches(normalized)) {
      final skipped = normalized.substring(lastEnd, match.start);

      if (skipped.trim().isNotEmpty) {
        throw FormatException(
          'Karakter "$skipped" tidak dikenali pada rumus.',
        );
      }

      tokens.add(match.group(0)!);
      lastEnd = match.end;
    }

    final remaining = normalized.substring(lastEnd);

    if (remaining.trim().isNotEmpty || tokens.isEmpty) {
      throw FormatException(
        'Ekspresi "$expression" tidak valid.',
      );
    }

    return _ExpressionParser(tokens, variables).parse();
  }
}

// ============================================================
// PARSER EKSPRESI MATEMATIKA
// ============================================================

class _ExpressionParser {
  final List<String> tokens;
  final Map<String, dynamic> variables;

  int position = 0;

  _ExpressionParser(this.tokens, this.variables);

  num parse() {
    final result = _expression();

    if (position != tokens.length) {
      throw const FormatException(
        'Ekspresi matematika tidak valid.',
      );
    }

    return result;
  }

  num _expression() {
    var value = _term();

    while (position < tokens.length &&
        (tokens[position] == '+' ||
            tokens[position] == '-')) {
      final operator = tokens[position++];
      final right = _term();

      value = operator == '+'
          ? value + right
          : value - right;
    }

    return value;
  }

  num _term() {
    var value = _factor();

    while (position < tokens.length &&
        (tokens[position] == '*' ||
            tokens[position] == '/')) {
      final operator = tokens[position++];
      final right = _factor();

      if (operator == '/' && right == 0) {
        throw const FormatException(
          'Tidak bisa membagi dengan nol.',
        );
      }

      value = operator == '*'
          ? value * right
          : value / right;
    }

    return value;
  }

  num _factor() {
    if (position >= tokens.length) {
      throw const FormatException(
        'Ekspresi belum lengkap.',
      );
    }

    final token = tokens[position++];

    if (token == '+') {
      return _factor();
    }

    if (token == '-') {
      return -_factor();
    }

    if (token == '(') {
      final value = _expression();

      if (position >= tokens.length ||
          tokens[position] != ')') {
        throw const FormatException(
          'Kurung tidak berpasangan.',
        );
      }

      position++;
      return value;
    }

    final number = num.tryParse(token);
    if (number != null) return number;

    final key = token.toLowerCase();

    if (!variables.containsKey(key)) {
      throw FormatException(
        'Variabel "$key" belum memiliki nilai.',
      );
    }

    final value = variables[key];

    if (value is num) return value;

    throw FormatException(
      'Variabel "$key" bukan angka.',
    );
  }
}