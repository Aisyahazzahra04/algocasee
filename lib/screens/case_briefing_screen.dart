import 'package:flutter/material.dart';

import '../main.dart';
import '../models/case_model.dart';
import 'problem_analysis_screen.dart';

class CaseBriefingScreen extends StatelessWidget {
  final CaseModel caseData;

  const CaseBriefingScreen({
    super.key,
    required this.caseData,
  });

  IconData _getFactIcon(String label) {
    final text = label.toLowerCase();

    if (text.contains('panjang')) {
      return Icons.straighten_outlined;
    }

    if (text.contains('lebar')) {
      return Icons.height_outlined;
    }

    if (text.contains('bentuk')) {
      return Icons.crop_square_outlined;
    }

    return Icons.info_outline;
  }

  @override
  Widget build(BuildContext context) {
    final briefing = caseData.briefing;

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
                    child: Center(
                      child: Text(
                        'CASE ${caseData.id.replaceAll('case_', '').toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: navy,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
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
                  8,
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
                    Text(
                      caseData.title,
                      style: const TextStyle(
                        fontSize: 27,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        color: navy,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // DIFFICULTY
                    // ==================================================
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F7F4),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        caseData.difficulty.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: teal,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // CERITANYA
                    // ==================================================
                    const _SectionTitle(
                      icon: Icons.menu_book_outlined,
                      title: 'CERITANYA',
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(16),
                        border: Border.all(
                          color: borderGrey,
                        ),
                      ),
                      child: Text(
                        briefing.description,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.65,
                          color: textDark,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // AREA / ILUSTRASI
                    // ==================================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(
                        18,
                        16,
                        18,
                        18,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF7F5),
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'INFORMASI VISUAL',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                                color: navy,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Container(
                            height: 105,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: teal,
                                width: 2,
                              ),
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                const Center(
                                  child: Icon(
                                    Icons.grass_outlined,
                                    size: 38,
                                    color: teal,
                                  ),
                                ),

                                // LABEL ATAS
                                if (briefing.facts.isNotEmpty)
                                  Positioned(
                                    top: 8,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: _VisualLabel(
                                        text: briefing
                                            .facts
                                            .first
                                            .value,
                                      ),
                                    ),
                                  ),

                                // LABEL SAMPING
                                if (briefing.facts.length > 1)
                                  Positioned(
                                    right: 8,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: RotatedBox(
                                        quarterTurns: 1,
                                        child: _VisualLabel(
                                          text: briefing
                                              .facts[1]
                                              .value,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // MISSION
                    // ==================================================
                    const _SectionTitle(
                      icon: Icons.flag_outlined,
                      title: 'MISIMU',
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: navy,
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withValues(alpha: .12),
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.flag_outlined,
                              size: 19,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              briefing.mission,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // INFORMASI YANG KAMU PUNYA
                    // ==================================================
                    const _SectionTitle(
                      icon:
                          Icons.lightbulb_outline_rounded,
                      title: 'INFORMASI YANG KAMU PUNYA',
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(16),
                        border: Border.all(
                          color: borderGrey,
                        ),
                      ),
                      child: Column(
                        children: List.generate(
                          briefing.facts.length,
                          (index) {
                            final fact =
                                briefing.facts[index];

                            return Column(
                              children: [
                                _InfoRow(
                                  icon: _getFactIcon(
                                    fact.label,
                                  ),
                                  label: fact.label,
                                  value: fact.value,
                                ),

                                if (index <
                                    briefing.facts.length - 1)
                                  const Divider(
                                    height: 20,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ==================================================
                    // RULES
                    // ==================================================
                    if (briefing.rules.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFFFF8E8),
                          borderRadius:
                              BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                const Color(0xFFF0D99A),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.rule_outlined,
                                  size: 19,
                                  color:
                                      Color(0xFFD99A00),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'ATURAN AWAL',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight:
                                        FontWeight.w800,
                                    letterSpacing: .8,
                                    color:
                                        Color(0xFFD99A00),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            ...briefing.rules.map(
                              (rule) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(
                                    bottom: 6,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      const Text(
                                        '• ',
                                        style: TextStyle(
                                          fontWeight:
                                              FontWeight.w800,
                                          color:
                                              textDark,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          rule,
                                          style:
                                              const TextStyle(
                                            fontSize: 12,
                                            height: 1.45,
                                            color:
                                                textDark,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 16),

                    // ==================================================
                    // HINT
                    // ==================================================
                    Container(
                      padding:
                          const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFFEFF4FF),
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              const Color(0xFFC9D8F5),
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.tips_and_updates_outlined,
                            size: 19,
                            color:
                                Color(0xFF3B82F6),
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              'Jangan langsung menghitung. Pahami dulu masalahnya dan tentukan informasi yang benar-benar kamu butuhkan.',
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

                    const SizedBox(height: 26),

                    // ==================================================
                    // START BUTTON
                    // ==================================================
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProblemAnalysisScreen(
                                caseData: caseData,
                              ),
                            ),
                          );
                        },
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor: teal,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              'MULAI CASE',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight:
                                    FontWeight.w800,
                                letterSpacing: .5,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 19,
                            ),
                          ],
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
// VISUAL LABEL
// ============================================================

class _VisualLabel extends StatelessWidget {
  final String text;

  const _VisualLabel({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 3,
      ),
      color: const Color(0xFFEFF7F5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: navy,
        ),
      ),
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: navy,
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: .8,
            color: navy,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// INFORMATION ROW
// ============================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF7F5),
            borderRadius:
                BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            size: 17,
            color: teal,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: textGrey,
            ),
          ),
        ),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
          ),
        ),
      ],
    );
  }
}

