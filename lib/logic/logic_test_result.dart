class LogicTestResult {
  final int testNumber;
  final bool passed;
  final dynamic expected;
  final dynamic actual;
  final String message;

  const LogicTestResult({
    required this.testNumber,
    required this.passed,
    required this.expected,
    required this.actual,
    required this.message,
  });
}
