import 'package:flutter/material.dart';

import '../main.dart';
import '../models/case_model.dart';
import '../services/case_service.dart';
import 'case_briefing_screen.dart';

class CasesScreen extends StatelessWidget {
  const CasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              '0 of 5 Cases Completed',
              style: TextStyle(
                fontSize: 10,
                color: textGrey,
              ),
            ),

            const SizedBox(height: 8),

            // DAFTAR CASE
            Expanded(
              child: FutureBuilder<CaseModel>(
                future: CaseService.loadCase01(),
                builder: (context, snapshot) {
                  // SAAT DATA SEDANG DIMUAT
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Gagal memuat case.',
                      style: TextStyle(
                        color: textGrey,
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      'Data case tidak ditemukan.',
                      style: TextStyle(
                        color: textGrey,
                      ),
                    ),
                  );
                }

                  // DATA CASE DARI JSON
                  final caseData = snapshot.data!;

                  return ListView(
                    children: [
                      // CASE 01 - DATA DARI JSON
                      CaseItem(
                        number: '01',
                        title: caseData.title,
                        status: 'AVAILABLE',
                        locked: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CaseBriefingScreen(
                                caseData: caseData,
                              ),
                            ),
                          );
                        },
                      ),
                      // CASE 02
                      const CaseItem(
                        number: '02',
                        title: 'Student Discount',
                        status: 'LOCKED',
                        locked: true,
                      ),

                      // CASE 03
                      const CaseItem(
                        number: '03',
                        title: 'Library Fine',
                        status: 'LOCKED',
                        locked: true,
                      ),

                      // CASE 04
                      const CaseItem(
                        number: '04',
                        title: 'Electricity Bill',
                        status: 'LOCKED',
                        locked: true,
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