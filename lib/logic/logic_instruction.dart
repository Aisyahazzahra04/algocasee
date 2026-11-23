
enum LogicInstructionType {
  declare,
  input,
  process,
  decision,
  output,
}

class LogicInstruction {
  final LogicInstructionType type;
  final String? content;

  // Instruksi yang dijalankan jika kondisi benar.
  final List<LogicInstruction> trueBranch;

  // Instruksi yang dijalankan jika kondisi salah.
  final List<LogicInstruction> falseBranch;

  const LogicInstruction({
    required this.type,
    this.content,
    this.trueBranch = const [],
    this.falseBranch = const [],
  });
}