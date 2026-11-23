import 'logic_instruction.dart';

class LogicReader {
  static List<LogicInstruction> read(List<String> lines) {
    final index = _LineIndex(lines);

    // Lewati baris kosong di awal.
    index.skipEmptyLines();

    if (index.isFinished || index.currentLine.toUpperCase() != 'START') {
      throw const FormatException('Algoritma harus diawali dengan blok START.');
    }

    index.position++;

    final instructions = _readSequence(index, stopAt: {'END'});

    index.skipEmptyLines();

    if (index.isFinished || index.currentLine.toUpperCase() != 'END') {
      throw const FormatException('Algoritma harus diakhiri dengan blok END.');
    }

    index.position++;
    index.skipEmptyLines();

    if (!index.isFinished) {
      throw FormatException(
        'Ada instruksi setelah blok END pada baris ${index.position + 1}.',
      );
    }

    return instructions;
  }

  // Membaca instruksi sampai menemukan salah satu penanda berhenti.
  static List<LogicInstruction> _readSequence(
    _LineIndex index, {
    Set<String> stopAt = const {},
  }) {
    final instructions = <LogicInstruction>[];

    while (!index.isFinished) {
      index.skipEmptyLines();

      if (index.isFinished) break;

      final line = index.currentLine;
      final upperLine = line.toUpperCase();

      if (stopAt.contains(upperLine)) {
        break;
      }

      if (upperLine == 'START' || upperLine == 'END') {
        throw FormatException(
          'Penanda "$line" tidak berada pada posisi yang benar '
          '(baris ${index.position + 1}).',
        );
      }

      if (upperLine == 'TRUE:' ||
          upperLine == 'FALSE:' ||
          upperLine == 'END_DECISION') {
        throw FormatException(
          'Penanda "$line" tidak berada di dalam blok DECISION '
          '(baris ${index.position + 1}).',
        );
      }

      if (upperLine.startsWith('DECISION ')) {
        instructions.add(_readDecision(index));
        continue;
      }

      final instruction = _readSimpleInstruction(line);

      if (instruction == null) {
        throw FormatException(
          'Instruksi "$line" tidak dikenali pada baris '
          '${index.position + 1}.',
        );
      }

      instructions.add(instruction);
      index.position++;
    }

    return instructions;
  }

  // Membaca DECISION beserta cabang TRUE dan FALSE.
  static LogicInstruction _readDecision(_LineIndex index) {
    final lineNumber = index.position + 1;
    final line = index.currentLine;

    final condition = line.substring('DECISION '.length).trim();

    if (condition.isEmpty) {
      throw FormatException(
        'Kondisi DECISION tidak boleh kosong (baris $lineNumber).',
      );
    }

    index.position++;
    index.skipEmptyLines();

    // Pastikan cabang TRUE tersedia.
    if (index.isFinished || index.currentLine.toUpperCase() != 'TRUE:') {
      throw FormatException(
        'DECISION "$condition" harus memiliki penanda TRUE:.',
      );
    }

    index.position++;

    final trueBranch = _readSequence(index, stopAt: {'FALSE:', 'END_DECISION'});

    // Setelah TRUE harus ada FALSE.
    if (index.isFinished || index.currentLine.toUpperCase() != 'FALSE:') {
      throw FormatException(
        'DECISION "$condition" harus memiliki penanda FALSE:.',
      );
    }

    index.position++;

    final falseBranch = _readSequence(index, stopAt: {'END_DECISION'});

    // Pastikan DECISION ditutup.
    if (index.isFinished || index.currentLine.toUpperCase() != 'END_DECISION') {
      throw FormatException(
        'DECISION "$condition" belum ditutup dengan END_DECISION.',
      );
    }

    index.position++;

    return LogicInstruction(
      type: LogicInstructionType.decision,
      content: condition,
      trueBranch: trueBranch,
      falseBranch: falseBranch,
    );
  }

  // Membaca instruksi sederhana.
  static LogicInstruction? _readSimpleInstruction(String line) {
    final upperLine = line.toUpperCase();

    if (upperLine.startsWith('DECLARE ')) {
      return LogicInstruction(
        type: LogicInstructionType.declare,
        content: line.substring(8).trim(),
      );
    }

    if (upperLine.startsWith('INPUT ')) {
      return LogicInstruction(
        type: LogicInstructionType.input,
        content: line.substring(6).trim(),
      );
    }

    if (upperLine.startsWith('PROCESS ')) {
      return LogicInstruction(
        type: LogicInstructionType.process,
        content: line.substring(8).trim(),
      );
    }

    if (upperLine.startsWith('OUTPUT ')) {
      return LogicInstruction(
        type: LogicInstructionType.output,
        content: line.substring(7).trim(),
      );
    }

    return null;
  }
}

// Membantu melacak posisi baris.
class _LineIndex {
  final List<String> lines;
  int position = 0;

  _LineIndex(this.lines);

  bool get isFinished => position >= lines.length;

  String get currentLine => lines[position].trim();

  void skipEmptyLines() {
    while (!isFinished && currentLine.isEmpty) {
      position++;
    }
  }
}
