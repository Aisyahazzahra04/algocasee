import '../models/case_model.dart';
import 'logic_check_result.dart';
import 'logic_instruction.dart';
import 'logic_reader.dart';

class LogicChecker {
  static LogicCheckResult check({
    required CaseModel caseData,
    required List<String> userLogic,
  }) {
    final errors = <String>[];
    final errorIndices = <int>{};

    final declared = <String, String>{};
    final initialized = <String>{};
    final inputVariables = <String>[];

    final counts = <String, int>{'process': 0, 'output': 0};

    void addError(String message, [int index = -1]) {
      errors.add(message);
      if (index >= 0) {
        errorIndices.add(index);
      }
    }

    int findLine(String prefix, String? content) {
      final target = '$prefix ${content ?? ''}'.trim().toLowerCase();

      return userLogic.indexWhere(
        (line) => line.trim().toLowerCase() == target,
      );
    }

    // Pastikan penanda utama tersedia.
    if (userLogic.isEmpty || userLogic.first.trim().toUpperCase() != 'START') {
      addError('Blok START harus berada di awal algoritma.', 0);
    }

    if (userLogic.isEmpty || userLogic.last.trim().toUpperCase() != 'END') {
      addError('Blok END harus berada di akhir algoritma.');
    }

    // Baca susunan blok menjadi instruksi.
    List<LogicInstruction> instructions;

    try {
      instructions = LogicReader.read(userLogic);
    } catch (error) {
      return LogicCheckResult.failure(
        messages: [
          'Susunan blok logika belum valid.',
          error.toString(),
          caseData.feedback.wrong,
        ],
      );
    }

    // Memeriksa instruksi, termasuk instruksi di dalam cabang DECISION.
    void validateInstructions(
      List<LogicInstruction> items,
      Set<String> currentInitialized,
    ) {
      for (final instruction in items) {
        final content = instruction.content?.trim() ?? '';

        switch (instruction.type) {
          case LogicInstructionType.declare:
            final index = findLine('DECLARE', content);

            final match = RegExp(
              r'^(.+?)\s*:\s*(integer|real|string|boolean)$',
              caseSensitive: false,
            ).firstMatch(content);

            if (match == null) {
              addError(
                'Format DECLARE belum benar. Contoh: panjang, lebar : Integer.',
                index,
              );
              continue;
            }

            final names = match.group(1)!.split(',');
            final type = match.group(2)!.toLowerCase();

            for (final rawName in names) {
              final name = rawName.trim();
              final key = name.toLowerCase();

              if (!RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(name)) {
                addError('Nama variabel "$name" tidak valid.', index);
                continue;
              }

              if (declared.containsKey(key)) {
                addError(
                  'Variabel "$name" sudah pernah dideklarasikan.',
                  index,
                );
                continue;
              }

              declared[key] = type;
            }
            break;

          case LogicInstructionType.input:
            final name = content.toLowerCase();
            final index = findLine('INPUT', content);

            if (!RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(content)) {
              addError('Format INPUT "$content" belum benar.', index);
              continue;
            }

            if (!declared.containsKey(name)) {
              addError(
                'Variabel INPUT "$content" harus dideklarasikan terlebih dahulu.',
                index,
              );
              continue;
            }

            if (inputVariables.contains(name)) {
              addError(
                'Variabel "$content" tidak boleh di-input berulang kali.',
                index,
              );
              continue;
            }

            inputVariables.add(name);
            currentInitialized.add(name);
            break;

          case LogicInstructionType.process:
            counts['process'] = counts['process']! + 1;

            final index = findLine('PROCESS', content);
            final separator = content.indexOf('=');

            if (separator < 1) {
              addError(
                'Format PROCESS belum benar. Gunakan bentuk variabel = rumus.',
                index,
              );
              continue;
            }

            final target = content.substring(0, separator).trim().toLowerCase();

            final expression = content.substring(separator + 1).trim();

            if (expression.isEmpty) {
              addError('Rumus PROCESS tidak boleh kosong.', index);
              continue;
            }

            if (!declared.containsKey(target)) {
              addError('Variabel hasil "$target" belum dideklarasikan.', index);
            }

            // Abaikan teks di dalam tanda kutip karena bukan nama variabel.
            final expressionWithoutText = expression.replaceAll(
              RegExp(r"""(['"])[^'"]*\1"""),
              '',
            );
            
            final identifiers = RegExp(r'[a-zA-Z_][a-zA-Z0-9_]*')
                .allMatches(expressionWithoutText);

            for (final match in identifiers) {
              final identifier = match.group(0)!.toLowerCase();

              if (!declared.containsKey(identifier)) {
                addError(
                  'Variabel "$identifier" pada PROCESS belum dideklarasikan.',
                  index,
                );
              } else if (!currentInitialized.contains(identifier)) {
                addError(
                  'Variabel "$identifier" digunakan sebelum memiliki nilai.',
                  index,
                );
              }
            }

            if (declared.containsKey(target)) {
              currentInitialized.add(target);
            }
            break;

          case LogicInstructionType.output:
            counts['output'] = counts['output']! + 1;

            final name = content.toLowerCase();
            final index = findLine('OUTPUT', content);

            if (!declared.containsKey(name)) {
              addError(
                'Variabel OUTPUT "$content" belum dideklarasikan.',
                index,
              );
            } else if (!currentInitialized.contains(name)) {
              addError(
                'Variabel OUTPUT "$content" belum memiliki nilai.',
                index,
              );
            }
            break;

          case LogicInstructionType.decision:
            final index = findLine('DECISION', content);

            if (content.isEmpty) {
              addError('Kondisi DECISION tidak boleh kosong.', index);
              continue;
            }

            // Variabel dalam kondisi harus sudah dideklarasikan
            // dan memiliki nilai.
            final identifiers = RegExp(r'[a-zA-Z_][a-zA-Z0-9_]*')
                .allMatches(content);

            for (final match in identifiers) {
              final identifier = match.group(0)!.toLowerCase();

              if (!declared.containsKey(identifier)) {
                addError(
                  'Variabel "$identifier" pada DECISION belum dideklarasikan.',
                  index,
                );
              } else if (!currentInitialized.contains(identifier)) {
                addError(
                  'Variabel "$identifier" pada DECISION belum memiliki nilai.',
                  index,
                );
              }
            }

            // Periksa kedua cabang secara terpisah.
            final trueInitialized = Set<String>.from(currentInitialized);
            final falseInitialized = Set<String>.from(currentInitialized);

            validateInstructions(instruction.trueBranch, trueInitialized);

            validateInstructions(instruction.falseBranch, falseInitialized);

            // Setelah DECISION, hanya variabel yang tersedia
            // di kedua cabang yang dianggap sudah pasti memiliki nilai.
            currentInitialized
              ..clear()
              ..addAll(trueInitialized.intersection(falseInitialized));
            break;
        }
      }
    }

    validateInstructions(instructions, initialized);

    // Jumlah INPUT harus sesuai kebutuhan kasus.
    final requiredInputCount = caseData.logicBuilder.inputOrder.length;

    if (inputVariables.length != requiredInputCount) {
      addError(
        'Jumlah INPUT belum sesuai. Kasus ini membutuhkan '
        '$requiredInputCount input, tetapi algoritmamu memiliki '
        '${inputVariables.length} input.',
      );
    }

    if (counts['process'] == 0) {
      addError('Tambahkan blok PROCESS untuk mengolah data.');
    }

    if (counts['output'] == 0) {
      addError('Tambahkan blok OUTPUT untuk menampilkan hasil.');
    }

    if (errors.isNotEmpty) {
      errors.add(caseData.feedback.wrong);

      return LogicCheckResult.failure(
        messages: errors,
        errorIndices: errorIndices.toList()..sort(),
      );
    }

    return LogicCheckResult(
      isCorrect: true,
      messages: [caseData.feedback.correct],
    );
  }
}
