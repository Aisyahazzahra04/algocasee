import '../models/case_model.dart';

class LogicCheckResult {
  final bool isCorrect;
  final List<String> messages;

  LogicCheckResult({
    required this.isCorrect,
    required this.messages,
  });
}

class LogicChecker {
  static LogicCheckResult check({
    required CaseModel caseData,
    required List<String> userLogic,
  }) {
    final expectedLogic =
        caseData.logicBuilder.expectedLogic;

    final user = userLogic
        .map(_normalize)
        .toList();

    final expected = expectedLogic
        .map(_normalize)
        .toList();

    final errors = <String>[];

    // ============================================================
    // 1. CEK JUMLAH BLOK
    // ============================================================

    if (user.length != expected.length) {
      errors.add(
        'Jumlah blok logika belum sesuai.',
      );
    }

    // ============================================================
    // 2. CEK START
    // ============================================================

    if (user.isEmpty || user.first != 'start') {
      errors.add(
        'Alur logika harus dimulai dengan START.',
      );
    }

    // ============================================================
    // 3. CEK END
    // ============================================================

    if (user.isEmpty || user.last != 'end') {
      errors.add(
        'Alur logika harus diakhiri dengan END.',
      );
    }

    // ============================================================
    // 4. CEK URUTAN BLOK
    // ============================================================

    final maxLength =
        user.length < expected.length
            ? user.length
            : expected.length;

    for (int i = 0; i < maxLength; i++) {
      final userBlock = user[i];
      final expectedBlock = expected[i];

      if (!_isEquivalent(
        userBlock,
        expectedBlock,
      )) {
        errors.add(
          'Blok ke-${i + 1} belum sesuai.',
        );
      }
    }

    // ============================================================
    // 5. CEK INPUT
    // ============================================================

    final inputError = _checkInputOrder(
      user,
      expected,
    );

    if (inputError != null) {
      errors.add(inputError);
    }

    // ============================================================
    // 6. CEK PROCESS
    // ============================================================

    final processError = _checkProcess(
      user,
      expected,
    );

    if (processError != null) {
      errors.add(processError);
    }

    // ============================================================
    // 7. CEK OUTPUT
    // ============================================================

    final outputError = _checkOutput(
      user,
      expected,
    );

    if (outputError != null) {
      errors.add(outputError);
    }

    // ============================================================
    // HASIL
    // ============================================================

    if (errors.isEmpty) {
      return LogicCheckResult(
        isCorrect: true,
        messages: [
          caseData.feedback.correct,
        ],
      );
    }

    errors.add(
      caseData.feedback.wrong,
    );

    return LogicCheckResult(
      isCorrect: false,
      messages: errors,
    );
  }

  // ============================================================
  // CEK KESETARAAN BLOK
  // ============================================================

  static bool _isEquivalent(
    String user,
    String expected,
  ) {
    // Sama persis
    if (user == expected) {
      return true;
    }

    // ----------------------------------------------------------
    // PROCESS
    // ----------------------------------------------------------

    if (user.startsWith('process ') &&
        expected.startsWith('process ')) {
      final userProcess =
          user.substring(8).trim();

      final expectedProcess =
          expected.substring(8).trim();

      return _normalizeProcess(userProcess) ==
          _normalizeProcess(expectedProcess);
    }

    // ----------------------------------------------------------
    // OUTPUT
    // ----------------------------------------------------------

    if (user.startsWith('output ') &&
        expected.startsWith('output ')) {
      final userOutput =
          user.substring(7).trim();

      final expectedOutput =
          expected.substring(7).trim();

      return _sameOutput(
        userOutput,
        expectedOutput,
      );
    }

    return false;
  }

  // ============================================================
  // INPUT
  // ============================================================

  static String? _checkInputOrder(
    List<String> user,
    List<String> expected,
  ) {
    final expectedInputs = expected
        .where(
          (value) => value.startsWith('input '),
        )
        .toList();

    final userInputs = user
        .where(
          (value) => value.startsWith('input '),
        )
        .toList();

    if (userInputs.length != expectedInputs.length) {
      return 'Jumlah INPUT belum sesuai.';
    }

    for (int i = 0; i < expectedInputs.length; i++) {
      if (userInputs[i] != expectedInputs[i]) {
        return 'Urutan INPUT belum sesuai.';
      }
    }

    return null;
  }

  // ============================================================
  // PROCESS
  // ============================================================

  static String? _checkProcess(
    List<String> user,
    List<String> expected,
  ) {
    final expectedProcesses = expected
        .where(
          (value) => value.startsWith('process '),
        )
        .toList();

    final userProcesses = user
        .where(
          (value) => value.startsWith('process '),
        )
        .toList();

    if (userProcesses.length !=
        expectedProcesses.length) {
      return 'Jumlah PROCESS belum sesuai.';
    }

    for (int i = 0;
        i < expectedProcesses.length;
        i++) {
      final userProcess =
          userProcesses[i].substring(8);

      final expectedProcess =
          expectedProcesses[i].substring(8);

      if (_normalizeProcess(userProcess) !=
          _normalizeProcess(expectedProcess)) {
        return 'PROCESS belum sesuai dengan aturan perhitungan.';
      }
    }

    return null;
  }

  // ============================================================
  // OUTPUT
  // ============================================================

  static String? _checkOutput(
    List<String> user,
    List<String> expected,
  ) {
    final expectedOutputs = expected
        .where(
          (value) => value.startsWith('output '),
        )
        .toList();

    final userOutputs = user
        .where(
          (value) => value.startsWith('output '),
        )
        .toList();

    if (userOutputs.length !=
        expectedOutputs.length) {
      return 'Jumlah OUTPUT belum sesuai.';
    }

    for (int i = 0;
        i < expectedOutputs.length;
        i++) {
      final userOutput =
          userOutputs[i].substring(7).trim();

      final expectedOutput =
          expectedOutputs[i].substring(7).trim();

      if (!_sameOutput(
        userOutput,
        expectedOutput,
      )) {
        return 'OUTPUT belum sesuai dengan hasil yang diharapkan.';
      }
    }

    return null;
  }

  // ============================================================
  // NORMALIZE TEXT
  // ============================================================

  static String _normalize(String text) {
    return text
        .trim()
        .toLowerCase()
        .replaceAll('×', 'x',)
        .replaceAll('÷', '/')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  // ============================================================
  // NORMALIZE PROCESS
  // ============================================================

  static String _normalizeProcess(
    String text,
  ) {
    var value = _normalize(text);

    value = value
        .replaceAll(' x ', '*')
        .replaceAll('x', '*')
        .replaceAll(' = ', '=')
        .replaceAll(' ', '');

    return value;
  }

  // ============================================================
  // OUTPUT
  // ============================================================

  static bool _sameOutput(
    String user,
    String expected,
  ) {
    user = _normalize(user);
    expected = _normalize(expected);

    // Contoh:
    // luas == luas
    if (user == expected) {
      return true;
    }

    // Contoh:
    // "luas taman" dianggap mengacu pada "luas"
    if (user.startsWith('$expected ')) {
      return true;
    }

    if (expected.startsWith('$user ')) {
      return true;
    }

    return false;
  }
}