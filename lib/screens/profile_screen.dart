import 'package:flutter/material.dart';

import '../main.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import 'tutorial_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Jumlah case tetap mengikuti rancangan aplikasi.
  static const int totalCases = 10;

  // Mengambil data pengguna dan progress dari SQLite.
  Future<Map<String, dynamic>?> getProfileData() async {
    final database = DatabaseService.instance;
    final UserModel? user = await database.getUser();

    if (user == null || user.id == null) {
      return null;
    }

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
        // LOADING
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: blue),
          );
        }

        // ERROR
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Terjadi kesalahan saat mengambil data.',
              style: TextStyle(color: textGrey),
            ),
          );
        }

        // DATA PENGGUNA BELUM TERSEDIA
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text(
              'Data pengguna belum tersedia.',
              style: TextStyle(color: textGrey),
            ),
          );
        }

        // DATA DARI SQLITE
        final data = snapshot.data!;
        final UserModel user = data['user'] as UserModel;
        final int completedCases = data['completedCases'] as int;
        final int remainingCases =
            (totalCases - completedCases).clamp(0, totalCases);
        final double progress =
            (completedCases / totalCases).clamp(0.0, 1.0);

        return Stack(
          fit: StackFit.expand,
          children: [
            // Background aplikasi tetap menggunakan aset yang sama.
            Image.asset(
              'assets/images/backgroundnav.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const ColoredBox(
                  color: Color(0xFFF3F8FF),
                );
              },
            ),
            // Overlay lembut agar background tidak terlalu menyatu
            // dengan kartu putih dan teks di atasnya.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF173B70).withValues(alpha: 0.16),
                  ],
                  stops: const [0.0, 0.48, 1.0],
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ProfileHeader(),
                    const SizedBox(height: 22),

                    _IdentityCard(userName: user.name),
                    const SizedBox(height: 26),

                    const _SectionHeading(
                      title: 'Progress Belajar',
                      icon: Icons.bar_chart_rounded,
                    ),
                    const SizedBox(height: 12),
                    _ProgressCard(
                      completed: completedCases,
                      total: totalCases,
                      progress: progress,
                    ),
                    const SizedBox(height: 25),

                    const _SectionHeading(
                      title: 'Ringkasan Case',
                      icon: Icons.emoji_events_rounded,
                      iconColor: Color(0xFFFFD15C),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatisticCard(
                            icon: Icons.check_rounded,
                            iconColor: const Color(0xFF159B70),
                            backgroundColor: const Color(0xFFE7F8F0),
                            value: '$completedCases',
                            label: 'Completed',
                            description: 'Case selesai',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatisticCard(
                            icon: Icons.hourglass_bottom_rounded,
                            iconColor: const Color(0xFFE39A21),
                            backgroundColor: const Color(0xFFFFF4DF),
                            value: '$remainingCases',
                            label: 'Remaining',
                            description: 'Belum selesai',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    const _SectionHeading(
                      title: 'Informasi Aplikasi',
                      icon: Icons.info_rounded,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 5,
                      ),
                      decoration: _profileCardDecoration(),
                      child: const Column(
                        children: [
                          _InfoRow(
                            icon: Icons.info_outline_rounded,
                            iconColor: Color(0xFF7658C8),
                            iconBackground: Color(0xFFF0ECFF),
                            title: 'Versi Aplikasi',
                            value: '1.0.0',
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xFFE8EDF5),
                            indent: 51,
                          ),
                          _InfoRow(
                            icon: Icons.grid_view_rounded,
                            iconColor: Color(0xFF2876D8),
                            iconBackground: Color(0xFFEAF3FF),
                            title: 'Total Case',
                            value: '$totalCases Case',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Fungsi navigasi tutorial tetap sama.
                    SizedBox(
                      width: double.infinity,
                      height: 52,
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
                          Icons.menu_book_rounded,
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
                          foregroundColor: const Color(0xFF2457A7),
                          backgroundColor:
                              Colors.white.withValues(alpha: 0.88),
                          side: const BorderSide(
                            color: Color(0xFF9CBCEB),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// HEADER
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  color: Color(0xFF172F5B),
                  fontSize: 29,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Lihat informasi dan perkembangan belajarmu.',
                style: TextStyle(
                  color: const Color(0xFF526887).withValues(alpha: 0.96),
                  fontSize: 13.5,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD86B).withValues(alpha: 0.28),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.75),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.lightbulb_rounded,
            color: Color(0xFFFFB928),
            size: 40,
          ),
        ),
      ],
    );
  }
}

// KARTU IDENTITAS PENGGUNA
class _IdentityCard extends StatelessWidget {
  final String userName;

  const _IdentityCard({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF18366D),
            Color(0xFF2459A9),
            Color(0xFF17366F),
          ],
        ),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.75),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2459A9).withValues(alpha: 0.20),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 39,
                ),
              ),
              Positioned(
                right: -3,
                bottom: -1,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color(0xFF43B8F5),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Halo,',
                  style: TextStyle(
                    color: Color(0xFFDCE8FF),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Tetap semangat belajar!',
                  style: TextStyle(
                    color: Color(0xFFD5E2FA),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.auto_awesome_rounded,
            color: Color(0xFFFFD76A),
            size: 25,
          ),
        ],
      ),
    );
  }
}

// JUDUL SETIAP BAGIAN
class _SectionHeading extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;

  const _SectionHeading({
    required this.title,
    required this.icon,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFF2E6BC2),
            borderRadius: BorderRadius.circular(11),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E6BC2).withValues(alpha: 0.18),
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1C3152),
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

// KARTU PROGRESS BELAJAR
class _ProgressCard extends StatelessWidget {
  final int completed;
  final int total;
  final double progress;

  const _ProgressCard({
    required this.completed,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _profileCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  'Perkembangan case',
                  style: TextStyle(
                    color: Color(0xFF263B60),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$completed / $total',
                style: const TextStyle(
                  color: Color(0xFF2467C8),
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFE7EDF7),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF3984EA),
              ),
            ),
          ),
          const SizedBox(height: 11),
          Text(
            '$completed dari $total case sudah diselesaikan.',
            style: const TextStyle(
              color: Color(0xFF687B99),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// KARTU STATISTIK CASE
class _StatisticCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String value;
  final String label;
  final String description;

  const _StatisticCard({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.value,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 145),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.18),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: iconColor, size: 23),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1D365F),
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF263B60),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF71809A),
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}

// INFORMASI APLIKASI
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF536783),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF243957),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// DEKORASI KARTU YANG DIGUNAKAN BERSAMA
BoxDecoration _profileCardDecoration() {
  return BoxDecoration(
    color: Colors.white.withValues(alpha: 0.94),
    borderRadius: BorderRadius.circular(19),
    border: Border.all(
      color: const Color(0xFFDCE7F5),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF315D98).withValues(alpha: 0.09),
        blurRadius: 13,
        offset: const Offset(0, 5),
      ),
    ],
  );
}
