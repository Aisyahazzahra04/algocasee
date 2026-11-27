import 'package:flutter/material.dart';

import '../main.dart';
import '../models/case_model.dart';
import '../services/case_service.dart';
import 'case_briefing_screen.dart';

class CasesScreen extends StatelessWidget {
  const CasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
  return Stack(
    children: [
      // BACKGROUND
      Positioned.fill(
        child: Image.asset(
          'assets/images/backgroundnav.png',
          fit: BoxFit.cover,
        ),
      ),

      // LAPISAN PUTIH TRANSPARAN
      Positioned.fill(
        child: Container(
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),

      // KONTEN HALAMAN CASES
      SafeArea(
        child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // JUDUL HALAMAN
            const Center(
              child: Text(
                'CASES',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: navy,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // PROGRESS CASE
            const Text(
              '0 of 10 Cases Completed',
              style: TextStyle(
                fontSize: 10,
                color: textGrey,
              ),
            ),

            const SizedBox(height: 8),

            // DAFTAR CASE
            Expanded(
              child: FutureBuilder<List<CaseModel>>(
                future: Future.wait([
                  CaseService.loadCase01(),
                  CaseService.loadCase02(),
                  CaseService.loadCase03(),
                  CaseService.loadCase04(),
                  CaseService.loadCase05(),
                  CaseService.loadCase06(),
                  CaseService.loadCase07(),
                  CaseService.loadCase08(),
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Gagal memuat case:\n${snapshot.error}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text(
                        'Data case tidak ditemukan.',
                        style: TextStyle(color: textGrey),
                      ),
                    );
                  }

                  final case01 = snapshot.data![0];
                  final case02 = snapshot.data![1];
                  final case03 = snapshot.data![2];
                  final case04 = snapshot.data![3];
                  final case05 = snapshot.data![4];
                  final case06 = snapshot.data![5];
                  final case07 = snapshot.data![6];
                  final case08 = snapshot.data![7];
                  return ListView(
                      padding: const EdgeInsets.only(
                        top: 0,
                        bottom: 16,
                      ),
                      physics: const BouncingScrollPhysics(),
                    children: [
                      CaseItem(
                        number: '01',
                        title: case01.title,
                        difficulty: case01.difficulty,
                        status: 'AVAILABLE',
                        locked: false,
                        imagePath: 'assets/images/foto_case01.jpg',
                      accentColor: const Color(0xFF22A06B),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CaseBriefingScreen(caseData: case01,),
                            ),
                          );
                        },
                      ),

                      CaseItem(
                        number: '02',
                        title: case02.title,
                        difficulty: case02.difficulty,
                        status: 'AVAILABLE',
                        locked: false,
                        accentColor: const Color(0xFFE5A323),
                        imagePath: 'assets/images/foto_case02.jpg',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CaseBriefingScreen(caseData: case02,), 
                            ),
                          );
                        },
                      ),

                      CaseItem(
                      number: '03',
                      title: case03.title,
                      difficulty: case03.difficulty,
                      status: 'AVAILABLE',
                      locked: false,
                      accentColor: const Color(0xFF8966C9),
                      imagePath: 'assets/images/foto_case03.jpg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CaseBriefingScreen(
                              caseData: case03,
                            ),
                          ),
                        );
                      },
                    ),

                      // CASE 04
                      CaseItem(
                      number: '04',
                      title: case04.title,
                      difficulty: case04.difficulty,
                      status: 'AVAILABLE',
                      locked: false,
                      accentColor: const Color(0xFF2585C5),
                      imagePath: 'assets/images/foto_case04.jpg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CaseBriefingScreen(
                              caseData: case04,
                            ),
                          ),
                        );
                      },
                    ),
                      // CASE 05
                      CaseItem(
                        number: '05',
                        title: case05.title,
                        difficulty: case05.difficulty,
                        status: 'AVAILABLE',
                        locked: false,
                        accentColor: const Color(0xFF14B8A6),
                        imagePath: 'assets/images/foto_case05.jpg',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CaseBriefingScreen(
                                caseData: case05,
                              ),
                            ),
                          );
                        },
                      ),
                      // CASE 06
                      CaseItem(
                        number: '06',
                        title: case06.title,
                        difficulty: case06.difficulty,
                        status: 'AVAILABLE',
                        locked: false,
                        accentColor: const Color(0xFF8966C9),
                        imagePath: 'assets/images/foto_case06.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CaseBriefingScreen(
                                caseData: case06,
                              ),
                            ),
                          );
                        },
                      ),
                      //CASE07
                      CaseItem(
                      number: '07',
                      title: case07.title,
                      difficulty: case07.difficulty,
                      status: 'AVAILABLE',
                      locked: false,
                      accentColor: const Color(0xFFB8874A),
                      imagePath: 'assets/images/foto_case07.jpg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CaseBriefingScreen(
                              caseData: case07,
                            ),
                          ),
                        );
                      },
                    ),
                    //CASE08
                    CaseItem(
                      number: '08',
                      title: case08.title,
                      difficulty: case07.difficulty,
                      status: 'AVAILABLE',
                      locked: false,
                      accentColor: const Color(0xFF2585C5),
                      imagePath: 'assets/images/foto_case08.jpg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CaseBriefingScreen(
                              caseData: case08,
                            ),
                          ),
                        );
                      },
                    ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      )
    ],
    );
  }
}

// ============================================================
// KOMPONEN CARD CASE
// ============================================================
  class CaseItem extends StatelessWidget {
    final String number;
    final String title;
    final String status;
    final String difficulty;
    final bool locked;
    final VoidCallback? onTap;
    final Color accentColor;
    final String imagePath;
    

    const CaseItem({
      super.key,
      required this.number,
      required this.title,
      required this.status,
      required this.locked,
      required this.imagePath,
      required this.accentColor,
      required this.difficulty,
      this.onTap,
    });

    @override
    Widget build(BuildContext context) {
      final Color backgroundColor =
          Color.lerp(accentColor, Colors.white, 0.88)!;

      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: locked ? const Color(0xFFF5F6F8) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.45),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: locked ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // ILUSTRASI CASE
                // GAMBAR ILUSTRASI CASE
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagePath,
                    width: 82,
                    height: 88,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 82,
                        height: 88,
                        color: backgroundColor,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: accentColor,
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // INFORMASI CASE
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'CASE $number',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: locked ? textGrey : accentColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: locked ? textGrey : textDark,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: locked
                              ? const Color(0xFFE6E8EC)
                              : const Color(0xFFE5F5EB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                           locked ? 'LOCKED' : difficulty.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: locked
                            ? textGrey
                            : difficulty.toLowerCase() == 'medium'
                                ? const Color(0xFFB7791F)
                                : difficulty.toLowerCase() == 'hard'
                                    ? const Color(0xFFD64545)
                                    : const Color(0xFF218653),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // STATUS CASE
                _buildStatus(),
              ],
            ),
          ),
        ),
      );
    }

    
    Widget _buildStatus() {
      final String currentStatus = locked
          ? 'LOCKED'
          : status.toUpperCase();

      late String statusText;
      late Color statusColor;
      late IconData statusIcon;

      switch (currentStatus) {
        case 'COMPLETED':
        case 'SELESAI':
          statusText = 'SELESAI';
          statusColor = const Color(0xFF22A06B);
          statusIcon = Icons.check_circle_rounded;
          break;

        case 'IN_PROGRESS':
        case 'PROSES':
          statusText = 'PROSES';
          statusColor = const Color(0xFFE5A323);
          statusIcon = Icons.pending_rounded;
          break;

        case 'LOCKED':
          statusText = 'LOCKED';
          statusColor = const Color(0xFF89909D);
          statusIcon = Icons.lock_rounded;
          break;

        default:
          statusText = 'MULAI';
          statusColor = const Color(0xFF1769C2);
          statusIcon = Icons.play_circle_fill_rounded;
      }

      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              statusIcon,
              color: Colors.white,
              size: 19,
            ),
            const SizedBox(height: 3),
            Text(
              statusText,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
  }