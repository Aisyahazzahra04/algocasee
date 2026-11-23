
import '../models/case_model.dart';
import 'logic_reader.dart';
import 'logic_checker.dart';
import 'logic_executor.dart';
import 'logic_test_result.dart';

class LogicEngine {
  static List<LogicTestResult> evaluate({
    required CaseModel caseData,
    required List<String> userLogic,
  }) {
    // 1. Periksa struktur algoritma.
    final check = LogicChecker.check(
      caseData: caseData,
      userLogic: userLogic,
    );

    // Jika struktur salah, hentikan pengujian.
    if (!check.isCorrect) {
      return [
        LogicTestResult(
          testNumber: 0,
          passed: false,
          expected: null,
          actual: null,
          message: check.messages.join('\n'),
        ),
      ];
    }

    // 2. Baca blok menjadi instruksi.
    final instructions = LogicReader.read(userLogic);

    // 3. Jalankan semua test case.
    return LogicExecutor.runAllTests(
      instructions: instructions,
      caseData: caseData,
    );
  }
}
