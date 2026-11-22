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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                  return ListView(
                    children: [
                      CaseItem(
                        number: '01',
                        title: case01.title,
                        status: 'AVAILABLE',
                        locked: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CaseBriefingScreen(
                                caseData: case01,
                              ),
                            ),
                          );
                        },
                      ),

                      CaseItem(
                        number: '02',
                        title: case02.title,
                        status: 'AVAILABLE',
                        locked: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CaseBriefingScreen(
                                caseData: case02,
                              ),
                            ),
                          );
                        },
                      ),

                      CaseItem(
                      number: '03',
                      title: case03.title,
                      status: 'AVAILABLE',
                      locked: false,
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
                      status: 'AVAILABLE',
                      locked: false,
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
                      const CaseItem(
                        number: '05',
                        title: 'Final Case',
                        status: 'LOCKED',
                        locked: true,
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
  final bool locked;
  final VoidCallback? onTap;

  const CaseItem({
    super.key,
    required this.number,
    required this.title,
    required this.status,
    required this.locked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: locked ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 90,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: locked ? borderGrey : navy,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // INFORMASI CASE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CASE $number',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: locked ? textGrey : navy,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: locked ? textGrey : textDark,
                    ),
                  ),
                ],
              ),
            ),

            // STATUS CASE
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: locked ? textGrey : navy,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    locked
                        ? Icons.lock_outline
                        : Icons.play_arrow_outlined,
                    size: 12,
                    color: locked ? textGrey : navy,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: locked ? textGrey : navy,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}