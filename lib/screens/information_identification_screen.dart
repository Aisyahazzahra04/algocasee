import 'dart:convert';

import 'package:flutter/material.dart';

import '../main.dart';
import '../models/case_model.dart';
import '../services/database_service.dart';
import 'input_output_rules_screen.dart';
import 'cases_screen.dart';
import 'problem_analysis_screen.dart';

class InformationIdentificationScreen
    extends StatefulWidget {
  final CaseModel caseData;
  final int maxReachedStep;

  const InformationIdentificationScreen({
    super.key,
    required this.caseData,
    this.maxReachedStep = 2,
  });

  @override
  State<InformationIdentificationScreen> createState() =>
      _InformationIdentificationScreenState();
}

class _InformationIdentificationScreenState
    extends State<InformationIdentificationScreen> {
  final Set<int> selectedItems = {};

  bool submitted = false;
  @override
  void initState() {
    super.initState();
    _loadSavedAnswer();
  }

  Future<void> _loadSavedAnswer() async {
    final user = await DatabaseService.instance.getUser();
    final userId = user?.id;

    if (userId == null) return;

    final saved = await DatabaseService.instance.getAnswer(
      userId: userId,
      caseId: '01',
      stepId: 'information_identification',
    );

    if (saved == null) return;

    try {
      final data = jsonDecode(saved) as Map<String, dynamic>;
      final savedItems = data['selectedItems'] as List<dynamic>? ?? [];

      if (!mounted) return;

      setState(() {
        selectedItems
          ..clear()
          ..addAll(
            savedItems.whereType<num>().map((item) => item.toInt()),
          );

        submitted = data['submitted'] as bool? ?? false;
      });
    } catch (e) {
      debugPrint('Gagal membaca jawaban Step 2: $e');
    }
  }
  
  Future<void> _saveCurrentAnswer() async {
    final user = await DatabaseService.instance.getUser();
    final userId = user?.id;

    if (userId == null) return;

    final answerData = {
      'selectedItems': selectedItems.toList(),
      'submitted': submitted,
    };

    await DatabaseService.instance.saveAnswer(
      userId: userId,
      caseId: '01',
      stepId: 'information_identification',
      answer: jsonEncode(answerData),
    );
  }
  bool get isCorrect {
    final information =
        widget.caseData.informationIdentification.information;

    final correctIndexes = <int>{};

    for (int i = 0; i < information.length; i++) {
      if (information[i].relevant) {
        correctIndexes.add(i);
      }
    }

    return selectedItems.length == correctIndexes.length &&
        selectedItems.containsAll(correctIndexes);
  }

  
  Future<void> checkAnswer() async {
    setState(() {
      submitted = true;
    });

    await _saveCurrentAnswer();
  }

  Future<void> tryAgain() async {
    setState(() {
      selectedItems.clear();
      submitted = false;
    });

    await _saveCurrentAnswer();
  }

  void continueToNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InputOutputRulesScreen(
        caseData: widget.caseData,
        maxReachedStep:
            widget.maxReachedStep < 3
                ? 3
                : widget.maxReachedStep,
      ),
      ),
    );
  }

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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProblemAnalysisScreen(
                  caseData: widget.caseData,
                  maxReachedStep: widget.maxReachedStep,
                ),
              ),
            );
          },
        ),

        Expanded(
          child: Container(
            height: 3,
            color: navy,
          ),
        ),

        _ProgressNumber(
          number: '2',
          active: true,
          enabled: false,
          onTap: null,
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
          onTap: widget.maxReachedStep >= 3
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InputOutputRulesScreen(
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
    final data =
        widget.caseData.informationIdentification;

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
                          'INFORMATION IDENTIFICATION',
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
                          textAlign: TextAlign.center,
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
            // PROGRESS
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
                    // ==================================================
                    // TITLE
                    // ==================================================
                    const Text(
                      'TAHAP 2',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: teal,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Pilih Informasi yang Relevan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: navy,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      data.question,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: textGrey,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // INSTRUCTION
                    // ==================================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF4FF),
                        borderRadius:
                            BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFC9D8F5),
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.touch_app_outlined,
                            size: 20,
                            color: Color(0xFF3B82F6),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Pilih semua informasi yang menurutmu dibutuhkan untuk menyelesaikan case ini.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.45,
                                color: textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ==================================================
                    // INFORMATION LIST
                    // ==================================================
                    ...List.generate(
                      data.information.length,
                      (index) {
                        final item =
                            data.information[index];

                        final selected =
                            selectedItems.contains(index);

                        final showCorrect =
                            submitted && item.relevant;

                        final showWrong =
                            submitted &&
                            selected &&
                            !item.relevant;

                        return _InformationCard(
                          number:
                              String.fromCharCode(
                            65 + index,
                          ),
                          text: item.text,
                          selected: selected,
                          correct: showCorrect,
                          wrong: showWrong,
                          enabled: !submitted,
                          
                          onTap: () async {
                            if (submitted) return;

                            setState(() {
                              if (selected) {
                                selectedItems.remove(index);
                              } else {
                                selectedItems.add(index);
                              }
                            });

                            await _saveCurrentAnswer();
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    // ==================================================
                    // FEEDBACK
                    // ==================================================
                    if (submitted)
                      Container(
                        width: double.infinity,
                        margin:
                            const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(16),
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
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Icon(
                              isCorrect
                                  ? Icons.check_circle_outline
                                  : Icons.info_outline,
                              color: isCorrect
                                  ? success
                                  : error,
                              size: 21,
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                isCorrect
                                    ? 'Benar! Kamu sudah memilih informasi yang diperlukan untuk menyelesaikan masalah.'
                                    : 'Masih ada informasi yang belum tepat. Perhatikan kembali data yang benar-benar dibutuhkan untuk menghitung luas taman.',
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1.5,
                                  color: textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // ==================================================
                    // BUTTON
                    // ==================================================
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: selectedItems.isEmpty
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
                          foregroundColor: Colors.white,
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
                              : 'CEK PILIHAN',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
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
// INFORMATION CARD
// ============================================================

class _InformationCard extends StatelessWidget {
  final String number;
  final String text;
  final bool selected;
  final bool correct;
  final bool wrong;
  final bool enabled;
  final VoidCallback onTap;

  const _InformationCard({
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
    Color numberBackground =
        const Color(0xFFF2F4F7);
    Color numberColor = textGrey;

    if (selected && enabled) {
      background = const Color(0xFFEFF7F5);
      border = teal;
      numberBackground = teal;
      numberColor = Colors.white;
    }

    if (correct) {
      background = const Color(0xFFEAF7F0);
      border = success;
      numberBackground = success;
      numberColor = Colors.white;
    }

    if (wrong) {
      background = const Color(0xFFFFF0F0);
      border = error;
      numberBackground = error;
      numberColor = Colors.white;
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
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: numberBackground,
                borderRadius:
                    BorderRadius.circular(9),
              ),
              child: Center(
                child: Text(
                  number,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: numberColor,
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
