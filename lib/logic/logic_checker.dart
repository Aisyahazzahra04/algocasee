import '../models/case_model.dart';

class LogicCheckResult {
  final bool isCorrect;
  final List<String> messages;
  final List<int> errorIndices;

  LogicCheckResult({
    required this.isCorrect,
    required this.messages,
    this.errorIndices = const [],
  });
}

class LogicChecker {
  static LogicCheckResult check({
    required CaseModel caseData,
    required List<String> userLogic,
  }) {
    final expected = caseData.logicBuilder.expectedLogic.map(_normalize).toList();
    final user = userLogic.map(_normalize).toList();
    final errors = <String>[];
    final indices = <int>{};

    if (user.length != expected.length) {
      errors.add('Jumlah blok logika belum sesuai.');
    }

    final count = user.length < expected.length ? user.length : expected.length;
    for (var i = 0; i < count; i++) {
      if (!_equivalent(user[i], expected[i])) indices.add(i);
    }
    for (var i = count; i < user.length; i++) { indices.add(i); }

    if (indices.isNotEmpty) errors.add('Susunan atau isi blok belum sesuai.');

    final declared = <String>{};
    final initialized = <String>{};
    for (var i = 0; i < user.length; i++) {
      final line = user[i];
      if (line.startsWith('declare ')) {
        final declaration = line.substring(8).trim();
        final match = RegExp(r'^(.+)\s*:\s*(integer|real|string|boolean)$').firstMatch(declaration);
        if (match == null) {
          errors.add('Format DECLARE pada blok ke-${i + 1} belum benar.');
          indices.add(i);
          continue;
        }
        final names = match.group(1)!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
        for (final name in names) {
          if (!RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(name) || declared.contains(name.toLowerCase())) {
            errors.add('Nama variabel tidak valid atau sudah dideklarasikan: $name.');
            indices.add(i);
          } else {
            declared.add(name.toLowerCase());
          }
        }
      } else if (line.startsWith('input ')) {
        final name = line.substring(6).trim().toLowerCase();
        if (!declared.contains(name)) {
          errors.add('Variabel INPUT "$name" harus dideklarasikan terlebih dahulu.');
          indices.add(i);
        } else {
          initialized.add(name);
        }
      } else if (line.startsWith('process ')) {
        final expression = line.substring(8);
        final assignment = expression.split('=');
        if (assignment.length != 2) {
          errors.add('Format PROCESS pada blok ke-${i + 1} belum benar.');
          indices.add(i);
        } else {
          final target = assignment.first.trim().toLowerCase();
          if (!declared.contains(target)) {
            errors.add('Variabel hasil "$target" belum dideklarasikan.');
            indices.add(i);
          }
          final identifiers = RegExp(r'[a-zA-Z_][a-zA-Z0-9_]*').allMatches(assignment.last)
              .map((m) => m.group(0)!.toLowerCase());
          for (final identifier in identifiers) {
            if (!declared.contains(identifier)) {
              errors.add('Variabel "$identifier" pada PROCESS belum dideklarasikan.');
              indices.add(i);
            } else if (!initialized.contains(identifier)) {
              errors.add('Variabel "$identifier" digunakan sebelum memiliki nilai.');
              indices.add(i);
            }
          }
          if (declared.contains(target)) initialized.add(target);
        }
      } else if (line.startsWith('output ')) {
        final name = line.substring(7).trim().toLowerCase();
        if (!declared.contains(name) || !initialized.contains(name)) {
          errors.add('OUTPUT harus menggunakan variabel yang sudah dideklarasikan dan memiliki nilai.');
          indices.add(i);
        }
      }
    }

    if (errors.isEmpty) {
      return LogicCheckResult(isCorrect: true, messages: [caseData.feedback.correct]);
    }
    errors.add(caseData.feedback.wrong);
    return LogicCheckResult(isCorrect: false, messages: errors, errorIndices: indices.toList()..sort());
  }

  static String _normalize(String value) => value.trim().toLowerCase()
      .replaceAll('×', '*').replaceAll('÷', '/')
      .replaceAll(RegExp(r'\s+'), ' ');

  static bool _equivalent(String user, String expected) {
    if (user == expected) return true;
    if (user.startsWith('process ') && expected.startsWith('process ')) {
      return _normalizeExpression(user.substring(8)) == _normalizeExpression(expected.substring(8));
    }
    if (user.startsWith('declare ') && expected.startsWith('declare ')) {
      return _normalize(user.substring(8)) == _normalize(expected.substring(8));
    }
    return false;
  }

  static String _normalizeExpression(String value) => _normalize(value)
      .replaceAll(' ', '').replaceAll('×', '*');
}
