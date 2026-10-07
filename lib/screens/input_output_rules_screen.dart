import 'package:flutter/material.dart';

import '../main.dart';
import '../models/case_model.dart';
import 'logic_builder_screen.dart';

class InputOutputRulesScreen extends StatefulWidget {
  final CaseModel caseData;

  const InputOutputRulesScreen({
    super.key,
    required this.caseData,
  });

  @override
  State<InputOutputRulesScreen> createState() =>
      _InputOutputRulesScreenState();
}

class _InputOutputRulesScreenState
    extends State<InputOutputRulesScreen> {
  int? selectedInput;
  int? selectedOutput;

  final Set<int> selectedRules = {};

  // ============================================================
  // FEEDBACK INPUT
  // ============================================================

  bool get inputAnswered => selectedInput != null;

  bool get inputCorrect =>
      selectedInput == widget.caseData.inputOutputRules.inputAnswer;

  // ============================================================
  // FEEDBACK OUTPUT
  // ============================================================

  bool get outputAnswered => selectedOutput != null;

  bool get outputCorrect =>
      selectedOutput == widget.caseData.inputOutputRules.outputAnswer;

  // ============================================================
  // FEEDBACK RULES
  // ============================================================

  bool get rulesAnswered => selectedRules.isNotEmpty;

  bool get rulesCorrect {
    final options =
        widget.caseData.inputOutputRules.rules.options;

    final correctIndexes = <int>{};

    for (int i = 0; i < options.length; i++) {
      if (options[i].correct) {
        correctIndexes.add(i);
      }
    }

    return selectedRules.length == correctIndexes.length &&
        selectedRules.containsAll(correctIndexes);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.caseData.inputOutputRules;

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
                20,
                14,
                20,
                0,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 19,
                        ),
                        color: navy,
                      ),

                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'INPUT, OUTPUT & RULES',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                                color: navy,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              widget.caseData.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                                color: textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 32),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ==================================================
                  // PROGRESS 5 TAHAP
                  // ==================================================
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        _ProgressNumber(
                          number: '1',
                          active: true,
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
                        ),

                        Expanded(
                          child: Container(
                            height: 3,
                            color: navy,
                          ),
                        ),

                        _ProgressNumber(
                          number: '3',
                          active: true,
                        ),

                        Expanded(
                          child: Container(
                            height: 3,
                            color: borderGrey,
                          ),
                        ),

                        _ProgressNumber(
                          number: '4',
                          active: false,
                        ),

                        Expanded(
                          child: Container(
                            height: 3,
                            color: borderGrey,
                          ),
                        ),

                        _ProgressNumber(
                          number: '5',
                          active: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // CONTENT
            // ==================================================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  22,
                  20,
                  28,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // STEP LABEL
                    // ==================================================

                    const Text(
                      'TAHAP 3',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: teal,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Identifikasi Input,\nOutput & Rules',
                      style: TextStyle(
                        fontSize: 24,
                        height: 1.08,
                        fontWeight: FontWeight.w800,
                        color: navy,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Tentukan data yang menjadi input, hasil yang ingin diperoleh, dan aturan yang digunakan.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: textGrey,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ==================================================
                    // INPUT
                    // ==================================================

                    const _SectionTitle(
                      title: 'INPUT',
                      number: '01',
                    ),

                    const SizedBox(height: 8),

                    Text(
                      data.inputQuestion,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: textGrey,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...List.generate(
                      data.inputOptions.length,
                      (index) {
                        return _OptionCard(
                          text: data.inputOptions[index],
                          selected:
                              selectedInput == index,
                          onTap: () {
                            setState(() {
                              selectedInput = index;
                            });
                          },
                        );
                      },
                    ),

                    // ==================================================
                    // INPUT FEEDBACK
                    // ==================================================

                    if (inputAnswered)
                      _FeedbackBox(
                        correct: inputCorrect,
                        text: inputCorrect
                            ? 'Benar! Input yang dibutuhkan adalah panjang dan lebar taman.'
                            : 'Belum tepat. Perhatikan kembali data yang diperlukan untuk menghitung luas taman.',
                      ),

                    const SizedBox(height: 18),

                    const _Divider(),

                    const SizedBox(height: 22),

                    // ==================================================
                    // OUTPUT
                    // ==================================================

                    const _SectionTitle(
                      title: 'OUTPUT',
                      number: '02',
                    ),

                    const SizedBox(height: 8),

                    Text(
                      data.outputQuestion,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: textGrey,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...List.generate(
                      data.outputOptions.length,
                      (index) {
                        return _OptionCard(
                          text: data.outputOptions[index],
                          selected:
                              selectedOutput == index,
                          onTap: () {
                            setState(() {
                              selectedOutput = index;
                            });
                          },
                        );
                      },
                    ),

                    // ==================================================
                    // OUTPUT FEEDBACK
                    // ==================================================

                    if (outputAnswered)
                      _FeedbackBox(
                        correct: outputCorrect,
                        text: outputCorrect
                            ? 'Benar! Output yang dihasilkan adalah luas taman.'
                            : 'Belum tepat. Perhatikan kembali hasil yang ingin diperoleh dari proses penyelesaian.',
                      ),

                    const SizedBox(height: 18),

                    const _Divider(),

                    const SizedBox(height: 22),

                    // ==================================================
                    // RULES
                    // ==================================================

                    const _SectionTitle(
                      title: 'RULES',
                      number: '03',
                    ),

                    const SizedBox(height: 8),

                    Text(
                      data.rulesQuestion,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: textGrey,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...List.generate(
                      data.rules.options.length,
                      (index) {
                        final selected =
                            selectedRules.contains(index);

                        return _RuleCard(
                          text:
                              data.rules.options[index].text,
                          selected: selected,
                          onTap: () {
                            setState(() {
                              if (selected) {
                                selectedRules.remove(index);
                              } else {
                                selectedRules.add(index);
                              }
                            });
                          },
                        );
                      },
                    ),

                    // ==================================================
                    // RULES FEEDBACK
                    // ==================================================

                    if (rulesAnswered)
                      _FeedbackBox(
                        correct: rulesCorrect,
                        text: rulesCorrect
                            ? 'Benar! Semua aturan yang diperlukan sudah dipilih.'
                            : 'Belum tepat. Pilih aturan yang benar dan hilangkan aturan yang tidak digunakan.',
                      ),

                    const SizedBox(height: 24),

                    // ==================================================
                    // BUTTONS
                    // ==================================================

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style:
                                  OutlinedButton.styleFrom(
                                foregroundColor: navy,
                                side: const BorderSide(
                                  color: navy,
                                  width: 1.2,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'BACK',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                                  selectedInput != null &&
                                          selectedOutput !=
                                              null &&
                                          selectedRules
                                              .isNotEmpty
                                      ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => LogicBuilderScreen(
                                                  caseData: widget.caseData,
                                                ),
                                              ),
                                            );
                                          }
                                      : null,
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor: navy,
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
                                      BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'NEXT',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  const _ProgressNumber({
    required this.number,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: active ? navy : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: active ? navy : borderGrey,
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        number,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: active ? Colors.white : textGrey,
        ),
      ),
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final String number;

  const _SectionTitle({
    required this.title,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: navy,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(width: 9),

        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
            color: navy,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// OPTION CARD
// ============================================================

class _OptionCard extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF0F4FA)
              : Colors.white,
          border: Border.all(
            color: selected ? navy : borderGrey,
            width: selected ? 1.4 : 1,
          ),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? navy : textGrey,
                  width: 1.4,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration:
                            const BoxDecoration(
                          shape: BoxShape.circle,
                          color: navy,
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.35,
                  color: textDark,
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
// RULE CARD
// ============================================================

class _RuleCard extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _RuleCard({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF0F4FA)
              : Colors.white,
          border: Border.all(
            color: selected ? navy : borderGrey,
            width: selected ? 1.4 : 1,
          ),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color:
                    selected ? navy : Colors.white,
                border: Border.all(
                  color: selected ? navy : textGrey,
                  width: 1.2,
                ),
                borderRadius:
                    BorderRadius.circular(4),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: Colors.white,
                    )
                  : null,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.35,
                  color: textDark,
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
// FEEDBACK BOX
// ============================================================

class _FeedbackBox extends StatelessWidget {
  final bool correct;
  final String text;

  const _FeedbackBox({
    required this.correct,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: correct
            ? const Color(0xFFEAF7F0)
            : const Color(0xFFFDEEEE),
        border: Border.all(
          color: correct
              ? const Color(0xFFB7DFC8)
              : const Color(0xFFE8BABA),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            correct
                ? Icons.check_circle_outline_rounded
                : Icons.info_outline_rounded,
            size: 17,
            color: correct
                ? success
                : error,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: correct
                    ? success
                    : error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DIVIDER
// ============================================================

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: borderGrey,
    );
  }
}