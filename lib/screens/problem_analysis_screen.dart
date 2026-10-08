import 'package:flutter/material.dart';

import '../main.dart';
import '../models/case_model.dart';
import 'information_identification_screen.dart';
import 'cases_screen.dart';

class ProblemAnalysisScreen extends StatefulWidget {
  final CaseModel caseData;
  final int maxReachedStep;

  const ProblemAnalysisScreen({
    super.key,
    required this.caseData,
    this.maxReachedStep = 1,
  });

  @override
  State<ProblemAnalysisScreen> createState() =>
      _ProblemAnalysisScreenState();
}

class _ProblemAnalysisScreenState
    extends State<ProblemAnalysisScreen> {
  int? selectedAnswer;
  bool submitted = false;

  bool get isCorrect =>
      selectedAnswer ==
      widget.caseData.problemAnalysis.correctAnswer;

  void checkAnswer() {
    if (selectedAnswer == null) return;

    setState(() {
      submitted = true;
    });
  }

  void tryAgain() {
    setState(() {
      selectedAnswer = null;
      submitted = false;
    });
  }

  void continueToNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            InformationIdentificationScreen(
          caseData: widget.caseData,
          maxReachedStep:
              widget.maxReachedStep < 2
                  ? 2
                  : widget.maxReachedStep,
        ),
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
          active: true,
          enabled: false,
          onTap: null,
        ),

        Expanded(
          child: Container(
            height: 3,
            color: widget.maxReachedStep >= 2
                ? navy
                : borderGrey,
          ),
        ),

        _ProgressNumber(
          number: '2',
          active: false,
          enabled: widget.maxReachedStep >= 2,
          onTap: widget.maxReachedStep >= 2
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          InformationIdentificationScreen(
                        caseData: widget.caseData,
                        maxReachedStep:
                            widget.maxReachedStep,
                      ),
                    ),
                  );
                }
              : null,
        ),

        Expanded(
          child: Container(
            height: 3,
            color: widget.maxReachedStep >= 3
                ? navy
                : borderGrey,
          ),
        ),

        _ProgressNumber(
          number: '3',
          active: false,
          enabled: widget.maxReachedStep >= 3,
          onTap: null,
        ),

        Expanded(
          child: Container(
            height: 3,
            color: widget.maxReachedStep >= 4
                ? navy
                : borderGrey,
          ),
        ),

        _ProgressNumber(
          number: '4',
          active: false,
          enabled: widget.maxReachedStep >= 4,
          onTap: null,
        ),

        Expanded(
          child: Container(
            height: 3,
            color: widget.maxReachedStep >= 5
                ? navy
                : borderGrey,
          ),
        ),

        _ProgressNumber(
          number: '5',
          active: false,
          enabled: widget.maxReachedStep >= 5,
          onTap: null,
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final data = widget.caseData.problemAnalysis;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // HEADER
            // ==================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(
                14,
                10,
                14,
                4,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
                          'PROBLEM ANALYSIS',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Scaffold(
                            body: CasesScreen(),
                          ),
                        ),
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
            ),

            // ==================================================
            // PROGRESS 5 TAHAP
            // ==================================================
            _buildProgress(),

            // ==================================================
            // CONTENT
            // ==================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  4,
                  20,
                  28,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TAHAP 1',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: teal,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Problem Analysis',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: navy,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Pahami terlebih dahulu masalah yang harus diselesaikan sebelum menentukan langkah penyelesaiannya.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: textGrey,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // QUESTION CARD
                    // ==================================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: navy,
                        borderRadius:
                            BorderRadius.circular(17),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PERTANYAAN',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                              color: Color(0xFFB9C7E5),
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            data.question,
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

                    const SizedBox(height: 18),

                    // ==================================================
                    // OPTIONS
                    // ==================================================
                    ...List.generate(
                      data.options.length,
                      (index) {
                        final selected =
                            selectedAnswer == index;

                        final correct =
                            submitted &&
                            index ==
                                data.correctAnswer;

                        final wrong =
                            submitted &&
                            selected &&
                            !correct;

                        return _AnswerCard(
                          number:
                              String.fromCharCode(
                            65 + index,
                          ),
                          text: data.options[index],
                          selected: selected,
                          correct: correct,
                          wrong: wrong,
                          enabled: !submitted,
                          onTap: () {
                            if (submitted) return;

                            setState(() {
                              selectedAnswer =
                                  index;
                            });
                          },
                        );
                      },
                    ),

                    // ==================================================
                    // FEEDBACK
                    // ==================================================
                    if (submitted) ...[
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? const Color(0xFFEAF7F0)
                              : const Color(0xFFFFF0F0),
                          borderRadius:
                              BorderRadius.circular(14),
                          border: Border.all(
                            color: isCorrect
                                ? const Color(0xFFB8DFC8)
                                : const Color(0xFFF0C1C1),
                          ),
                        ),
                        child: Text(
                          isCorrect
                              ? data.feedbackCorrect
                              : data.feedbackWrong,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: textDark,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 22),

                    // ==================================================
                    // BUTTON
                    // ==================================================
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: selectedAnswer == null
                            ? null
                            : submitted
                                ? isCorrect
                                    ? continueToNext
                                    : tryAgain
                                : checkAnswer,
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor: teal,
                          disabledBackgroundColor:
                              borderGrey,
                          foregroundColor:
                              Colors.white,
                          disabledForegroundColor:
                              textGrey,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          submitted
                              ? isCorrect
                                  ? 'LANJUT'
                                  : 'COBA LAGI'
                              : 'CEK JAWABAN',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w800,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ),
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

// ============================================================
// PROGRESS NUMBER
// ============================================================

class _ProgressNumber extends StatelessWidget {
  final String number;
  final bool active;
  final bool enabled;
  final VoidCallback? onTap;

  const _ProgressNumber({
    required this.number,
    required this.active,
    required this.enabled,
    required this.onTap,
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
          color: active || enabled
              ? navy
              : Colors.white,
          border: Border.all(
            color: active || enabled
                ? navy
                : borderGrey,
          ),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              color: active || enabled
                  ? Colors.white
                  : textGrey,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ANSWER CARD
// ============================================================

class _AnswerCard extends StatelessWidget {
  final String number;
  final String text;
  final bool selected;
  final bool correct;
  final bool wrong;
  final bool enabled;
  final VoidCallback onTap;

  const _AnswerCard({
    required this.number,
    required this.text,
    required this.selected,
    required this.correct,
    required this.wrong,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color background = Colors.white;
    Color border = borderGrey;
    Color badgeBackground =
        const Color(0xFFF2F4F7);
    Color badgeColor = textGrey;

    if (selected && enabled) {
      background = const Color(0xFFEFF7F5);
      border = teal;
      badgeBackground = teal;
      badgeColor = Colors.white;
    }

    if (correct) {
      background = const Color(0xFFEAF7F0);
      border = success;
      badgeBackground = success;
      badgeColor = Colors.white;
    }

    if (wrong) {
      background = const Color(0xFFFFF0F0);
      border = error;
      badgeBackground = error;
      badgeColor = Colors.white;
    }

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        margin:
            const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            color: border,
            width:
                selected || correct || wrong
                    ? 1.5
                    : 1,
          ),
          borderRadius:
              BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: badgeBackground,
                borderRadius:
                    BorderRadius.circular(9),
              ),
              child: Center(
                child: Text(
                  number,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w800,
                    color: badgeColor,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: textDark,
                ),
              ),
            ),

            if (correct)
              const Icon(
                Icons.check_circle,
                color: success,
                size: 20,
              ),

            if (wrong)
              const Icon(
                Icons.cancel_outlined,
                color: error,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

