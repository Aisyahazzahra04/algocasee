import 'package:flutter/material.dart';

import '../main.dart';
import '../models/case_model.dart';
import '../logic/logic_checker.dart';
import 'problem_analysis_screen.dart';
import 'information_identification_screen.dart';
import 'input_output_rules_screen.dart';
import 'logic_builder_screen.dart';
import 'app_shell.dart';

class RunSimulationScreen extends StatefulWidget {
  final CaseModel caseData;
  final List<String> userLogic;

  const RunSimulationScreen({
    super.key,
    required this.caseData,
    required this.userLogic,
  });

  @override
  State<RunSimulationScreen> createState() =>
      _RunSimulationScreenState();
}

class _RunSimulationScreenState extends State<RunSimulationScreen> {
  late final LogicCheckResult result;

  @override
  void initState() {
    super.initState();

    result = LogicChecker.check(
      caseData: widget.caseData,
      userLogic: widget.userLogic,
    );
  }

  // ==================================================
  // HEADER
  // ==================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
            ),
            color: navy,
          ),
          Expanded(
            child: Column(
              children: [
                const Text(
                  'RUN SIMULATION',
                  textAlign: TextAlign.center,
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
                  style: const TextStyle(
                    fontSize: 9,
                    color: textGrey,
                  ),
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
            icon: const Icon(
              Icons.grid_view_rounded,
              size: 19,
            ),
            color: navy,
          ),
        ],
      ),
    );
  }

  // ==================================================
  // PROGRESS 5 TAHAP
  // ==================================================

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: Row(
        children: [
          _ProgressNumber(
            number: '1',
            active: false,
            enabled: true,
            onTap: () => _openStep(1),
          ),
          _progressLine(),
          _ProgressNumber(
            number: '2',
            active: false,
            enabled: true,
            onTap: () => _openStep(2),
          ),
          _progressLine(),
          _ProgressNumber(
            number: '3',
            active: false,
            enabled: true,
            onTap: () => _openStep(3),
          ),
          _progressLine(),
          const _ProgressNumber(
            number: '4',
            active: false,
            enabled: true,
          ),
          _progressLine(),
          const _ProgressNumber(
            number: '5',
            active: true,
            enabled: false,
          ),
        ],
      ),
    );
  }

  Widget _progressLine() {
    return const Expanded(
      child: SizedBox(
        height: 3,
        child: ColoredBox(color: navy),
      ),
    );
  }

  void _openStep(int step) {
    late final Widget screen;

    switch (step) {
      case 1:
        screen = ProblemAnalysisScreen(
          caseData: widget.caseData,
          maxReachedStep: 5,
        );
        break;
      case 2:
        screen = InformationIdentificationScreen(
          caseData: widget.caseData,
          maxReachedStep: 5,
        );
        break;
      default:
        screen = InputOutputRulesScreen(
          caseData: widget.caseData,
          maxReachedStep: 5,
        );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  // ==================================================
  // INTRODUCTION
  // ==================================================

  Widget _buildIntro() {
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
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: navy,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Periksa kembali susunan logika yang kamu buat dan lihat apakah langkah-langkahnya sudah sesuai dengan solusi yang diharapkan.',
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: textGrey,
          ),
        ),
        const SizedBox(height: 22),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: navy,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'UJI LOGIKA KAMU',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: Color(0xFFB9C7E5),
                ),
              ),
              const SizedBox(height: 9),
              Text(
                widget.caseData.title,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================================================
  // RESULT CARD
  // ==================================================

  Widget _buildResultCard({
    required bool isCorrect,
    required Color resultColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: resultColor.withValues(alpha: 0.55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: resultColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isCorrect
                      ? Icons.check_circle_rounded
                      : Icons.error_rounded,
                  color: resultColor,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect
                          ? 'Logika Sesuai'
                          : 'Logika Perlu Diperbaiki',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: resultColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isCorrect
                          ? 'Susunan logika sudah sesuai.'
                          : 'Periksa kembali langkah yang dibuat.',
                      style: const TextStyle(
                        fontSize: 10,
                        color: textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: borderGrey),
          const SizedBox(height: 14),
          const Text(
            'HASIL PEMERIKSAAN',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: navy,
            ),
          ),
          const SizedBox(height: 12),
          ...result.messages.map(
            (message) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.circle,
                    size: 6,
                    color: resultColor,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: textGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // LOGIC SUMMARY
  // ==================================================

  Widget _buildLogicSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SUSUNAN LOGIKA',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
            color: navy,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Langkah-langkah yang kamu susun di Logic Builder.',
          style: TextStyle(
            fontSize: 11,
            color: textGrey,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderGrey),
          ),
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

  Widget _buildLogicItem({
    required int index,
    required String text,
    required bool isLast,
  }) {
    final isTerminator = text == 'START' || text == 'END';
    final isDecision = text.startsWith('DECISION');
    final isBranch = text == 'TRUE:' || text == 'FALSE:';
    final isInput = text.startsWith('INPUT');
    final isOutput = text.startsWith('OUTPUT');

    final Color nodeColor;
    final IconData icon;

    if (isTerminator) {
      nodeColor = navy;
      icon = text == 'START'
          ? Icons.play_arrow_rounded
          : Icons.stop_rounded;
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
                decoration: BoxDecoration(
                  color: nodeColor,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isTerminator ? Colors.white : navy,
                ),
              ),
              if (!isLast)
                Container(
                  width: 1.5,
                  height: 14,
                  color: borderGrey,
                ),
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
                  fontWeight: isTerminator || isBranch
                      ? FontWeight.w800
                      : FontWeight.w500,
                  color: isTerminator ? navy : textDark,
                ),
              ),
            ),
          ),
          if (!isTerminator && !isBranch)
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 10,
                  color: textGrey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==================================================
  // BOTTOM BUTTON
  // ==================================================

  Widget _buildBottomButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => LogicBuilderScreen(
                caseData: widget.caseData,
                maxReachedStep: 5,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: teal,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back_rounded, size: 17),
            SizedBox(width: 8),
            Text(
              'KEMBALI KE LOGIC BUILDER',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: .3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // BUILD
  // ==================================================

  @override
  Widget build(BuildContext context) {
    final isCorrect = result.isCorrect;
    final resultColor = isCorrect ? success : error;

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
                    const SizedBox(height: 22),
                    _buildResultCard(
                      isCorrect: isCorrect,
                      resultColor: resultColor,
                    ),
                    const SizedBox(height: 22),
                    _buildLogicSection(),
                    const SizedBox(height: 26),
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

// ==================================================
// PROGRESS NUMBER
// ==================================================

class _ProgressNumber extends StatelessWidget {
  final String number;
  final bool active;
  final bool enabled;
  final VoidCallback? onTap;

  const _ProgressNumber({
    required this.number,
    required this.active,
    required this.enabled,
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
          border: Border.all(
            color: active || enabled ? navy : borderGrey,
          ),
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