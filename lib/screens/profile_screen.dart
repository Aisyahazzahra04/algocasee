import 'package:flutter/material.dart';

import '../main.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import 'tutorial_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});


  // JUMLAH TOTAL CASE
  static const int totalCases = 5;


  // MENGAMBIL DATA USER DAN PROGRESS DARI SQLITE

  Future<Map<String, dynamic>?> getProfileData() async {
    final database = DatabaseService.instance;

    // Ambil user dari tabel users
    final UserModel? user = await database.getUser();

    if (user == null || user.id == null) {
      return null;
    }

    // Hitung case yang sudah selesai
    // dari tabel user_progress
    final int completedCases =
        await database.getCompletedCaseCount(user.id!);

    return {
      'user': user,
      'completedCases': completedCases,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: getProfileData(),

      builder: (context, snapshot) {
        // ========================================================
        // LOADING
        // ========================================================

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: blue,
            ),
          );
        }

        // ========================================================
        // ERROR
        // ========================================================

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Terjadi kesalahan saat mengambil data.',
              style: TextStyle(
                color: textGrey,
              ),
            ),
          );
        }

        // ========================================================
        // USER BELUM ADA
        // ========================================================

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text(
              'Data pengguna belum tersedia.',
              style: TextStyle(
                color: textGrey,
              ),
            ),
          );
        }

        // ========================================================
        // DATA DARI SQLITE
        // ========================================================

        final data = snapshot.data!;

        final UserModel user = data['user'] as UserModel;

        final int completedCases =
            data['completedCases'] as int;

        final int remainingCases =
            (totalCases - completedCases).clamp(0, totalCases);

        final double progress =
            (completedCases / totalCases).clamp(0.0, 1.0);

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ==================================================
                // HEADER PROFILE
                // ==================================================

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

                // ==================================================
                // CARD IDENTITAS PENGGUNA
                // ==================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: navy,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [

                      // ICON USER

                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.15,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // NAMA USER DARI SQLITE

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            const Text(
                              'Halo,',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 3),

                            const Text(
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

                // ==================================================
                // PROGRESS BELAJAR
                // ==================================================

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
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
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
                        borderRadius:
                            BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 9,
                          backgroundColor: lightGrey,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(
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

                // ==================================================
                // RINGKASAN CASE
                // ==================================================

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

                    // COMPLETED

                    Expanded(
                      child: _StatisticCard(
                        icon: Icons.check_circle_outline,
                        iconColor: success,
                        value: '$completedCases',
                        label: 'Completed',
                      ),
                    ),

                    const SizedBox(width: 12),

                    // REMAINING

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

                // ==================================================
                // INFORMASI APLIKASI
                // ==================================================

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

                      // VERSI

                      const _InfoRow(
                        icon: Icons.info_outline,
                        title: 'Versi Aplikasi',
                        value: '1.0.0',
                      ),

                      const Divider(
                        height: 24,
                        color: lightGrey,
                      ),

                      // TOTAL CASE

                      _InfoRow(
                        icon: Icons.grid_view_outlined,
                        title: 'Total Case',
                        value: '$totalCases Case',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ==================================================
                // TOMBOL TUTORIAL
                // ==================================================

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const TutorialWelcomeScreen(),
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
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),

          const SizedBox(height: 2),

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

        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius:
                BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 19,
            color: navy,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: textGrey,
            ),
          ),
        ),

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