import 'package:flutter/material.dart';

import '../main.dart';
import '../models/case_model.dart';
import '../logic/logic_checker.dart';
import 'problem_analysis_screen.dart';
import 'information_identification_screen.dart';
import 'input_output_rules_screen.dart';
import 'logic_builder_screen.dart';
import 'app_shell.dart';
import '../services/database_service.dart';
import '../logic/logic_reader.dart';
import '../logic/logic_executor.dart';
import '../logic/logic_engine.dart';
import '../logic/logic_test_result.dart';

class RunSimulationScreen extends StatefulWidget {
  final CaseModel caseData;
  final List<String> userLogic;

  const RunSimulationScreen({
    super.key,
    required this.caseData,
    required this.userLogic,
  });

  @override
  State<RunSimulationScreen> createState() => _RunSimulationScreenState();
}

class _RunSimulationScreenState extends State<RunSimulationScreen> {
  final Map<String, TextEditingController> _inputControllers = {};
  bool _hasPassed = false;
  TestCase get _testCase => widget.caseData.testCases.first;

  @override
  void initState() {
    super.initState();
    for (final entry in _testCase.input.entries) {
      _inputControllers[entry.key] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in _inputControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // HEADER
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            color: navy,
          ),
          Expanded(
            child: Column(
              children: [
                const Text(
                  'RUN SIMULATION',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .8,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.caseData.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 9, color: textGrey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const AppShell(initialIndex: 1),
                ),
                (route) => route.isFirst,
              );
            },
            icon: const Icon(Icons.grid_view_rounded, size: 19),
            color: navy,
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          _ProgressNumber(number: '1', enabled: true, onTap: () => _openStep(1)),
          _progressLine(),
          _ProgressNumber(number: '2', enabled: true, onTap: () => _openStep(2)),
          _progressLine(),
          _ProgressNumber(number: '3', enabled: true, onTap: () => _openStep(3)),
          _progressLine(),
          const _ProgressNumber(number: '4', enabled: true),
          _progressLine(),
          const _ProgressNumber(number: '5', active: true, enabled: false),
        ],
      ),
    );
  }

  Widget _progressLine() => const Expanded(
        child: SizedBox(height: 3, child: ColoredBox(color: navy)),
      );

  void _openStep(int step) {
    late final Widget screen;
    switch (step) {
      case 1:
        screen = ProblemAnalysisScreen(caseData: widget.caseData, maxReachedStep: 5);
        break;
      case 2:
        screen = InformationIdentificationScreen(
          caseData: widget.caseData,
          maxReachedStep: 5,
        );
        break;
      default:
        screen = InputOutputRulesScreen(caseData: widget.caseData, maxReachedStep: 5);
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  // TEST CASE CARD
  Widget _buildIntro() {
    final inputEntries = _testCase.input.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TAHAP 5',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: teal,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Run Simulation',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: navy),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sekarang saatnya menguji logika yang sudah kamu susun. Gunakan data pada test case berikut.',
          style: TextStyle(fontSize: 13, height: 1.5, color: textGrey),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E2A44), Color(0xFF304B78)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.science_rounded, color: Colors.white70, size: 17),
                  const SizedBox(width: 7),
                  const Text(
                    'TEST CASE 01',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.caseData.difficulty,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Text(
                widget.caseData.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'DATA INPUT',
                style: TextStyle(
                  color: Color(0xFFB9C7E5),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .8,
                ),
              ),
              const SizedBox(height: 8),
              ...inputEntries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _prettyName(entry.key),
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                      Text(
                        '${entry.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF8F0),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFC8EBD7)),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFD2F0DF),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(Icons.flag_rounded, color: Color(0xFF18794E)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EXPECTED RESULT',
                      style: TextStyle(
                        color: Color(0xFF18794E),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .7,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_testCase.expectedResult}',
                      style: const TextStyle(
                        color: Color(0xFF145C3D),
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.check_circle_rounded, color: Color(0xFF32A66A), size: 23),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 53,
          child: ElevatedButton.icon(
            onPressed: _hasPassed ? null : _showInputDialog,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(_hasPassed ? 'CASE SELESAI' : 'UJI LOGIKAMU'),
            style: ElevatedButton.styleFrom(
              backgroundColor: teal,
              disabledBackgroundColor: const Color(0xFFB8D9CE),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: .4),
            ),
          ),
        ),
      ],
    );
  }

  String _prettyName(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  // INPUT OVERLAY
  void _showInputDialog() {
    for (final entry in _testCase.input.entries) {
      _inputControllers[entry.key]!.clear();
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(21),
          child: StatefulBuilder(
            builder: (context, setDialogState) => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF0FF),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Icon(Icons.keyboard_alt_rounded, color: navy),
                      ),
                      const SizedBox(width: 11),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Masukkan Nilai', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: navy)),
                            SizedBox(height: 3),
                            Text('Isi data untuk menguji logikamu.', style: TextStyle(fontSize: 11, color: textGrey)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        icon: const Icon(Icons.close_rounded, color: textGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ..._inputControllers.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _prettyName(entry.key),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: navy),
                          ),
                          const SizedBox(height: 7),
                          TextField(
                            controller: entry.value,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintText: 'Masukkan ${entry.key}...',
                              filled: true,
                              fillColor: const Color(0xFFF7F9FC),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: borderGrey)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: borderGrey)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: navy, width: 1.5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    height: 49,
                    child: ElevatedButton.icon(
                      onPressed: () => _runSimulation(dialogContext),
                      icon: const Icon(Icons.bolt_rounded),
                      label: const Text('JALANKAN LOGIKA'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: navy,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

    void _runSimulation(BuildContext dialogContext) {
    final manualInputValues = <dynamic>[];

    // Ambil nilai input sesuai urutan input yang digunakan oleh case.
    for (final entry in _inputControllers.entries) {
      final raw = entry.value.text.trim().replaceAll(',', '.');
      final parsed = num.tryParse(raw);

      if (parsed == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Masukkan nilai ${entry.key} dengan benar.'),
          ),
        );
        return;
      }

      manualInputValues.add(parsed);
    }

    final check = LogicChecker.check(
      caseData: widget.caseData,
      userLogic: widget.userLogic,
    );

    if (!check.isCorrect) {
      Navigator.pop(dialogContext);
      _showResultDialog(
        isCorrect: false,
        actualResult: null,
        message: check.messages.join('\n'),
      );
      return;
    }

    try {
      final instructions = LogicReader.read(widget.userLogic);

      // Simulasi manual hanya menjalankan input yang dimasukkan pengguna.
      // Hasilnya tidak dibandingkan dengan expected result Test Case 01,
      // karena nilai input manual dapat berbeda dari data contoh.
      final output = LogicExecutor.execute(
        instructions: instructions,
        caseData: widget.caseData,
        testCase: _testCase,
        manualInputValues: manualInputValues,
      );

      Navigator.pop(dialogContext);

      _showResultDialog(
        isCorrect: true,
        actualResult: output,
        message:
            'Simulasi berhasil dijalankan. Selanjutnya, periksa seluruh test case untuk menyelesaikan case ini.',
      );
    } catch (e) {
      Navigator.pop(dialogContext);

      _showResultDialog(
        isCorrect: false,
        actualResult: null,
        message: 'Logika belum dapat dijalankan. $e',
      );
    }
  }

  // VALIDASI SELURUH TEST CASE
  Future<void> _validateAllTestCases() async {
    final results = LogicEngine.evaluate(
      caseData: widget.caseData,
      userLogic: widget.userLogic,
    );

    final allPassed =
        results.isNotEmpty && results.every((result) => result.passed);

    _showAllTestResults(results, allPassed);
  }

  void _showAllTestResults(
    List<LogicTestResult> results,
    bool allPassed,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'HASIL VALIDASI',
          style: TextStyle(
            color: navy,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  allPassed
                      ? 'Semua test case berhasil!'
                      : 'Masih ada test case yang belum berhasil.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                ...results.map(
                  (result) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: result.passed
                            ? const Color(0xFFEAF8F0)
                            : const Color(0xFFFFEEEE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            result.passed
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            color: result.passed ? success : error,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  result.testNumber == 0
                                      ? 'Struktur Logika'
                                      : 'Test Case ${result.testNumber}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: navy,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  result.message,
                                  style: const TextStyle(
                                    color: textGrey,
                                    fontSize: 10,
                                  ),
                                ),
                                if (result.testNumber != 0) ...[
                                  Text(
                                    'Expected: ${result.expected}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: textGrey,
                                    ),
                                  ),
                                  Text(
                                    'Actual: ${result.actual}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: textGrey,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                if (!allPassed) return;

                setState(() => _hasPassed = true);

                try {
                  await _saveCaseProgress();

                  if (!mounted) return;
                  _showFinishDialog();
                } catch (e) {
                  if (!mounted) return;

                  setState(() => _hasPassed = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menyimpan progres: $e'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: allPassed ? teal : navy,
                foregroundColor: Colors.white,
              ),
              child: Text(
                allPassed ? 'FINISH' : 'PERIKSA LOGIKA LAGI',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SIMPAN PROGRESS
    int get _currentCaseNumber {
    final match = RegExp(r'(\d+)$').firstMatch(widget.caseData.id);

    if (match == null) {
      throw FormatException('ID Case tidak valid: ${widget.caseData.id}');
    }

    return int.parse(match.group(1)!);
  }

  Future<void> _saveCaseProgress() async {
    final database = DatabaseService.instance;
    final user = await database.getUser();

    if (user == null || user.id == null) {
      throw Exception('Data pengguna tidak ditemukan.');
    }

    final currentCaseNumber = _currentCaseNumber;
    final currentCaseId = currentCaseNumber.toString().padLeft(2, '0');
    final nextCaseNumber = currentCaseNumber + 1;

    await database.saveProgress(
      userId: user.id!,
      caseId: currentCaseId,
      status: 'Completed',
      currentStep: '5',
      tanggalSelesai: DateTime.now().toIso8601String(),
    );

    if (nextCaseNumber <= 5) {
      await database.saveProgress(
        userId: user.id!,
        caseId: nextCaseNumber.toString().padLeft(2, '0'),
        status: 'Available',
        currentStep: '1',
      );
    }
  }


  // RESULT OVERLAY
  void _showResultDialog({
    required bool isCorrect,
    required dynamic actualResult,
    required String message,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: (isCorrect ? success : error).withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect ? Icons.emoji_events_rounded : Icons.refresh_rounded,
                  color: isCorrect ? success : error,
                  size: 35,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                isCorrect ? 'Excellent!' : 'Belum Berhasil',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: isCorrect ? success : error),
              ),
              const SizedBox(height: 7),
              Text(
                isCorrect
                    ? 'Logikamu berhasil dijalankan. Lanjutkan validasi seluruh test case.'
                    : 'Masih ada bagian yang perlu kamu periksa.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, height: 1.5, color: textGrey),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _resultRow(
                      'Hasil simulasi',
                      actualResult == null ? '-' : '$actualResult',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, height: 1.5, color: textGrey),
              ),
              const SizedBox(height: 21),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                onPressed: () {
                Navigator.pop(dialogContext);

                if (isCorrect) {
                  _validateAllTestCases();
                } else {
                  _showInputDialog();
                }
              },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCorrect ? teal : navy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isCorrect ? 'VALIDASI SEMUA TEST CASE' : 'COBA LAGI',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: .5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: textGrey)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: navy)),
        ],
      );

    void _showFinishDialog() {
    final currentCaseNumber = _currentCaseNumber;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CaseCompletionScreen(
          completedCaseNumber: currentCaseNumber,
          nextCaseNumber:
              currentCaseNumber < 5 ? currentCaseNumber + 1 : null,
        ),
      ),
    );
  }

  // LOGIC SUMMARY
  Widget _buildLogicSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('SUSUNAN LOGIKA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: .3, color: navy)),
        const SizedBox(height: 5),
        const Text('Logika yang akan dijalankan pada simulasi.', style: TextStyle(fontSize: 11, color: textGrey)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderGrey)),
          child: Column(
            children: List.generate(
              widget.userLogic.length,
              (index) => _buildLogicItem(
                index: index,
                text: widget.userLogic[index],
                isLast: index == widget.userLogic.length - 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogicItem({required int index, required String text, required bool isLast}) {
    final isTerminator = text == 'START' || text == 'END';
    final isDecision = text.startsWith('DECISION');
    final isBranch = text == 'TRUE:' || text == 'FALSE:';
    final isInput = text.startsWith('INPUT');
    final isOutput = text.startsWith('OUTPUT');
    final Color nodeColor;
    final IconData icon;

    if (isTerminator) {
      nodeColor = navy;
      icon = text == 'START' ? Icons.play_arrow_rounded : Icons.stop_rounded;
    } else if (isDecision) {
      nodeColor = const Color(0xFFF7D5D5);
      icon = Icons.alt_route_rounded;
    } else if (isInput) {
      nodeColor = const Color(0xFFDDEAFF);
      icon = Icons.input_rounded;
    } else if (isOutput) {
      nodeColor = const Color(0xFFD8F7D8);
      icon = Icons.output_rounded;
    } else if (isBranch) {
      nodeColor = const Color(0xFFE9E5FF);
      icon = Icons.subdirectory_arrow_right_rounded;
    } else {
      nodeColor = const Color(0xFFFFF0B8);
      icon = Icons.settings_rounded;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(color: nodeColor, borderRadius: BorderRadius.circular(9)),
                child: Icon(icon, size: 18, color: isTerminator ? Colors.white : navy),
              ),
              if (!isLast) Container(width: 1.5, height: 14, color: borderGrey),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  fontWeight: isTerminator || isBranch ? FontWeight.w800 : FontWeight.w500,
                  color: isTerminator ? navy : textDark,
                ),
              ),
            ),
          ),
          if (!isTerminator && !isBranch)
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Text('${index + 1}', style: const TextStyle(fontSize: 10, color: textGrey)),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => LogicBuilderScreen(caseData: widget.caseData, maxReachedStep: 5),
            ),
          );
        },
        icon: const Icon(Icons.arrow_back_rounded, size: 17),
        label: const Text('KEMBALI KE LOGIC BUILDER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: .3)),
        style: OutlinedButton.styleFrom(
          foregroundColor: navy,
          side: const BorderSide(color: borderGrey),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgress(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIntro(),
                    const SizedBox(height: 23),
                    _buildLogicSection(),
                    const SizedBox(height: 24),
                    _buildBottomButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// COMPLETE
class CaseCompletionScreen extends StatelessWidget {
  final int completedCaseNumber;
  final int? nextCaseNumber;

  const CaseCompletionScreen({
    super.key,
    required this.completedCaseNumber,
    required this.nextCaseNumber,
  });

  void _goToCases(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const AppShell(initialIndex: 1),
      ),
      (route) => false,
    );
  }

  void _goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const AppShell(initialIndex: 0),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedId = completedCaseNumber.toString().padLeft(2, '0');
    final nextId = nextCaseNumber?.toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(
                  Icons.emoji_events_rounded,
                  color: success,
                  size: 75,
                ),
                const SizedBox(height: 20),
                const Text(
                  'CASE COMPLETED!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kamu berhasil menyelesaikan Case $completedId!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: textGrey,
                  ),
                ),
                const SizedBox(height: 30),

                // CASE SELESAI
                _statusCard(
                  title: 'CASE $completedId',
                  subtitle: 'Berhasil diselesaikan',
                  status: 'COMPLETED',
                  icon: Icons.check_circle_rounded,
                  color: success,
                  background: const Color(0xFFEAF8F0),
                ),

                if (nextId != null) ...[
                  const SizedBox(height: 13),

                  // CASE BERIKUTNYA
                  _statusCard(
                    title: 'CASE $nextId',
                    subtitle: 'Case berikutnya sudah terbuka',
                    status: 'UNLOCKED',
                    icon: Icons.lock_open_rounded,
                    color: const Color(0xFF2878D0),
                    background: const Color(0xFFEAF2FF),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => _goToCases(context),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('NEXT CASE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: teal,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 20),
                  const Text(
                    'Selamat! Kamu telah menyelesaikan seluruh Case di AlgoCase.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: textGrey,
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => _goToHome(context),
                    icon: const Icon(Icons.home_rounded),
                    label: const Text('BACK TO HOME'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: navy,
                      side: const BorderSide(color: borderGrey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusCard({
    required String title,
    required String subtitle,
    required String status,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: .2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressNumber extends StatelessWidget {
  final String number;
  final bool active;
  final bool enabled;
  final VoidCallback? onTap;

  const _ProgressNumber({
    required this.number,
    required this.enabled,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: active || enabled ? navy : Colors.white,
          border: Border.all(color: active || enabled ? navy : borderGrey),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              color: active || enabled ? Colors.white : textGrey,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

