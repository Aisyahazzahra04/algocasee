
class LogicCheckResult {
  final bool isCorrect;
  final List<String> messages;
  final List<int> errorIndices;

  const LogicCheckResult({
    required this.isCorrect,
    this.messages = const [],
    this.errorIndices = const [],
  });

  factory LogicCheckResult.success() {
    return const LogicCheckResult(
      isCorrect: true,
      messages: ['Logika berhasil diperiksa!'],
    );
  }

  factory LogicCheckResult.failure({
    required List<String> messages,
    List<int> errorIndices = const [],
  }) {
    return LogicCheckResult(
      isCorrect: false,
      messages: messages,
      errorIndices: errorIndices,
    );
  }
}
