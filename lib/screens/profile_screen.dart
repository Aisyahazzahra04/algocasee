import 'package:flutter/material.dart';

import '../main.dart';
import 'tutorial_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // DATA SEMENTARA
    // Nanti data ini  diganti dengan data dari database
    // ============================================================

    const String userName = 'Aisyah';

    const int completedCases = 0;
    const int totalCases = 5;
    const int remainingCases = totalCases - completedCases;

    const double progress = completedCases / totalCases;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ========================================================
            // HEADER PROFILE
            // ========================================================

            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Lihat informasi dan perkembangan belajarmu.',
              style: TextStyle(
                fontSize: 14,
                color: textGrey,
              ),
            ),

            const SizedBox(height: 24),

            // ========================================================
            // CARD IDENTITAS PENGGUNA
            // ========================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [

                  // FOTO / ICON USER
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // NAMA PENGGUNA
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo,',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),

                        SizedBox(height: 3),

                        Text(
                          userName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        SizedBox(height: 3),

                        Text(
                          'Tetap semangat belajar!',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ========================================================
            // PROGRESS BELAJAR
            // ========================================================

            const Text(
              'Progress Belajar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: borderGrey,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TEKS PROGRESS
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Perkembangan case',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textDark,
                          ),
                        ),
                      ),

                      Text(
                        '$completedCases / $totalCases',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // PROGRESS BAR
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 9,
                      backgroundColor: lightGrey,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '$completedCases dari $totalCases case sudah diselesaikan.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ========================================================
            // RINGKASAN CASE
            // ========================================================

            const Text(
              'Ringkasan Case',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [

                // CASE SELESAI
                Expanded(
                  child: _StatisticCard(
                    icon: Icons.check_circle_outline,
                    iconColor: success,
                    value: '$completedCases',
                    label: 'Completed',
                  ),
                ),

                const SizedBox(width: 12),

                // CASE TERSISA
                Expanded(
                  child: _StatisticCard(
                    icon: Icons.pending_actions_outlined,
                    iconColor: warning,
                    value: '$remainingCases',
                    label: 'Remaining',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ========================================================
            // INFORMASI APLIKASI
            // ========================================================

            const Text(
              'Informasi Aplikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: borderGrey,
                ),
              ),
              child: Column(
                children: [

                  // VERSI APLIKASI
                  _InfoRow(
                    icon: Icons.info_outline,
                    title: 'Versi Aplikasi',
                    value: '1.0.0',
                  ),

                  const Divider(
                    height: 24,
                    color: lightGrey,
                  ),

                  // JUMLAH CASE
                  _InfoRow(
                    icon: Icons.grid_view_outlined,
                    title: 'Total Case',
                    value: '$totalCases Case',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ========================================================
            // TOMBOL LIHAT TUTORIAL LAGI
            // ========================================================

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TutorialWelcomeScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.menu_book_outlined,
                  size: 19,
                ),
                label: const Text(
                  'Lihat Tutorial Lagi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: navy,
                  side: const BorderSide(
                    color: borderGrey,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// WIDGET STATISTIK
// ================================================================

class _StatisticCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatisticCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderGrey,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ICON
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),

          const SizedBox(height: 14),

          // ANGKA
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),

          const SizedBox(height: 2),

          // LABEL
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: textGrey,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// WIDGET INFO ROW
// ================================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        // ICON
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 19,
            color: navy,
          ),
        ),

        const SizedBox(width: 12),

        // JUDUL
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: textGrey,
            ),
          ),
        ),

        // NILAI
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
      ],
    );
  }
}