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

    if (text.contains('buku')) {
      return Icons.menu_book_outlined;
    }

    if (text.contains('harga')) {
      return Icons.sell_outlined;
    }

    if (text.contains('nilai')) {
      return Icons.grade_outlined;
    }
    if (text.contains('hari')) {
      return Icons.calendar_month_outlined;
    }

    if (text.contains('tiket')) {
      return Icons.confirmation_number_outlined;
    }

    return Icons.info_outline;
  }


  Widget _buildVisualInformation(CaseBriefing briefing) {
    Widget visual;

    switch (briefing.visualType) {
    case 'garden':
      visual = Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFDDF3D8),
          border: Border.all(
            color: const Color(0xFF398A52),
            width: 4,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            // UKURAN PANJANG TAMAN
            if (briefing.facts.isNotEmpty)
              Positioned(
                top: 7,
                left: 0,
                right: 0,
                child: Center(
                  child: _VisualLabel(
                    text: briefing.facts[0].value,
                  ),
                ),
              ),

            // UKURAN LEBAR TAMAN
            if (briefing.facts.length > 1)
              Positioned(
                right: 5,
                top: 0,
                bottom: 0,
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: _VisualLabel(
                      text: briefing.facts[1].value,
                    ),
                  ),
                ),
              ),

            // ILUSTRASI TANAMAN
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.local_florist_rounded,
                    color: Color(0xFFE69A45),
                    size: 30,
                  ),
                  SizedBox(width: 12),
                  Icon(
                    Icons.grass_rounded,
                    color: Color(0xFF398A52),
                    size: 43,
                  ),
                  SizedBox(width: 12),
                  Icon(
                    Icons.park_rounded,
                    color: Color(0xFF398A52),
                    size: 38,
                  ),
                  SizedBox(width: 12),
                  Icon(
                    Icons.local_florist_rounded,
                    color: Color(0xFFE69A45),
                    size: 30,
                  ),
                ],
              ),
            ),

            // KETERANGAN
            const Positioned(
              bottom: 7,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'TAMAN SEKOLAH',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: Color(0xFF286A3D),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      break;

      case 'rectangle':
        visual = Container(
          height: 105,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: teal,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
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

              if (briefing.facts.isNotEmpty)
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _VisualLabel(
                      text: briefing.facts[0].value,
                    ),
                  ),
                ),

              if (briefing.facts.length > 1)
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: _VisualLabel(
                        text: briefing.facts[1].value,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
        break;

      case 'money':
        visual = Row(
          children: [
            Expanded(
              child: _MoneyItem(
                icon: Icons.account_balance_wallet_outlined,
                label: briefing.facts.isNotEmpty
                    ? briefing.facts[0].label
                    : 'Uang awal',
                value: briefing.facts.isNotEmpty
                    ? briefing.facts[0].value
                    : '-',
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.remove_rounded,
                color: navy,
                size: 24,
              ),
            ),

            Expanded(
              child: _MoneyItem(
                icon: Icons.shopping_bag_outlined,
                label: briefing.facts.length > 1
                    ? briefing.facts[1].label
                    : 'Uang digunakan',
                value: briefing.facts.length > 1
                    ? briefing.facts[1].value
                    : '-',
              ),
            ),
          ],
        );
        break;

        case 'stationery':
        visual = Row(
          children: [
            Expanded(
              child: _MoneyItem(
                icon: Icons.menu_book_rounded,
                label: briefing.facts.isNotEmpty
                    ? briefing.facts[0].label
                    : 'Jumlah buku',
                value: briefing.facts.isNotEmpty
                    ? briefing.facts[0].value
                    : '-',
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.close_rounded,
                color: teal,
                size: 24,
              ),
            ),

            Expanded(
              child: _MoneyItem(
                icon: Icons.sell_outlined,
                label: briefing.facts.length > 1
                    ? briefing.facts[1].label
                    : 'Harga satu buku',
                value: briefing.facts.length > 1
                    ? briefing.facts[1].value
                    : '-',
              ),
            ),
          ],
        );
        break;

              case 'books':
              visual = Container(
                width: double.infinity,
                height: 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.auto_stories_rounded,
                      color: teal,
                      size: 38,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _BookCount(
                          label: 'Buku awal',
                          value: briefing.facts.isNotEmpty
                              ? briefing.facts[0].value
                              : '-',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.add,
                            color: teal,
                            size: 18,
                          ),
                        ),
                        _BookCount(
                          label: 'Ditambahkan',
                          value: briefing.facts.length > 1
                              ? briefing.facts[1].value
                              : '-',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.remove,
                            color: teal,
                            size: 18,
                          ),
                        ),
                        _BookCount(
                          label: 'Dipinjam',
                          value: briefing.facts.length > 2
                              ? briefing.facts[2].value
                              : '-',
                        ),
                      ],
                    ),
                  ],
                ),
              );
              break;

            case 'late_fee':
              visual = _LateFeeVisual(
                daysLate: briefing.facts.length > 1
                    ? briefing.facts[1].value
                    : '0 hari',
                finePerDay: briefing.facts.isNotEmpty
                    ? briefing.facts[0].value
                    : 'Rp0',
              );
              break;

                case 'school':
          visual = Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFB9D0F5),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.school_rounded,
                  size: 42,
                  color: Color(0xFF3B82F6),
                ),

                const SizedBox(height: 8),

                const Text(
                  'PENENTUAN KELULUSAN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: navy,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _ScoreCard(
                        label: 'Nilai Ujian',
                        value: briefing.facts.isNotEmpty
                            ? briefing.facts[0].value
                            : '-',
                        color: const Color(0xFF3B82F6),
                        icon: Icons.assignment_rounded,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: _ScoreCard(
                        label: 'Nilai Minimum',
                        value: briefing.facts.length > 1
                            ? briefing.facts[1].value
                            : '-',
                        color: const Color(0xFF14B8A6),
                        icon: Icons.flag_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.compare_arrows_rounded,
                        color: navy,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Bandingkan nilai ujian dengan batas kelulusan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: navy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
          break;
        
          case 'ticket':
            visual = Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFC9D8F5),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.movie_creation_rounded,
                    size: 38,
                    color: Color(0xFF3B82F6),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'HARGA TIKET BIOSKOP',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Harga berbeda berdasarkan jenis hari',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: textGrey,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _MoneyItem(
                          icon: Icons.confirmation_number_outlined,
                          label: briefing.facts.isNotEmpty
                              ? briefing.facts[0].label
                              : 'Hari biasa',
                          value: briefing.facts.isNotEmpty
                              ? briefing.facts[0].value
                              : '-',
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _MoneyItem(
                          icon: Icons.weekend_rounded,
                          label: briefing.facts.length > 1
                              ? briefing.facts[1].label
                              : 'Akhir pekan',
                          value: briefing.facts.length > 1
                              ? briefing.facts[1].value
                              : '-',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          size: 17,
                          color: Color(0xFF3B82F6),
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            briefing.facts.length > 2
                                ? '${briefing.facts[2].label}: ${briefing.facts[2].value}'
                                : 'Pilih jenis hari',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: navy,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
            break;


      default:
        visual = Container(
          height: 105,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderGrey),
          ),
          child: const Icon(
            Icons.info_outline,
            size: 36,
            color: teal,
          ),
        );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'INFORMASI VISUAL',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: navy,
            ),
          ),
          const SizedBox(height: 16),
          visual,
        ],
      ),
    );
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
                      title: 'PAHAMI DAN BACA SECARA SEKSAMA STUDI KASUS DIBAWAH',
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
                    _buildVisualInformation(briefing), 
                    const SizedBox(height: 22),

                    // ==================================================
                    // MISSION
                    // ==================================================
                    const _SectionTitle(
                      icon: Icons.flag_outlined,
                      title: 'MISI',
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

  // VISUALTAMPILAN ILUSTRASI
  class _MoneyItem extends StatelessWidget {
    final IconData icon;
    final String label;
    final String value;

    const _MoneyItem({
      required this.icon,
      required this.label,
      required this.value,
    });

    @override
    Widget build(BuildContext context) {
      return Container(
        constraints: const BoxConstraints(
          minHeight: 105,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: teal,
              size: 25,
            ),
            const SizedBox(height: 7),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: textGrey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
          ],
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

  class _BookCount extends StatelessWidget {
    final String label;
    final String value;

    const _BookCount({
      required this.label,
      required this.value,
    });

    @override
    Widget build(BuildContext context) {
      return Expanded(
        child: Column(
          children: [
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 9,
                color: textGrey,
              ),
            ),
          ],
        ),
      );
    }
  }
  // ============================================================
  // SCORE CARD - CASE 06
  // ============================================================

  class _ScoreCard extends StatelessWidget {
    final String label;
    final String value;
    final Color color;
    final IconData icon;

    const _ScoreCard({
      required this.label,
      required this.value,
      required this.color,
      required this.icon,
    });

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 25,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: textGrey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      );
    }
  }


class _LateFeeVisual extends StatelessWidget {
  final String daysLate;
  final String finePerDay;

  const _LateFeeVisual({
    required this.daysLate,
    required this.finePerDay,
  });

  int _getNumber(String value) {
    return int.tryParse(
          value.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    final days = _getNumber(daysLate);
    final fine = _getNumber(finePerDay);
    final total = days * fine;

    final totalText =
        'Rp${total.toString().replaceAllMapped(
              RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
              (match) => '${match[1]}.',
            )}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDDD2F1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2D8F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF8061B5),
                  size: 24,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PENGEMBALIAN BUKU',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .8,
                        color: Color(0xFF69518F),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Perhitungan denda perpustakaan',
                      style: TextStyle(
                        fontSize: 11,
                        color: textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _LateFeeItem(
                  icon: Icons.calendar_month_rounded,
                  label: 'Hari terlambat',
                  value: daysLate,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _LateFeeItem(
                  icon: Icons.payments_outlined,
                  label: 'Denda per hari',
                  value: finePerDay,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF8061B5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'TOTAL DENDA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  totalText,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$days × Rp${fine.toString()}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LateFeeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _LateFeeItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 23,
            color: const Color(0xFF8061B5),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: textGrey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: navy,
            ),
          ),
        ],
      ),
    );
  }
}

