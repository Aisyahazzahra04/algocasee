import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/app_card.dart';
import '../widgets/app_buttons.dart';
import '../widgets/small_case_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================================
            // SAPAAN PENGGUNA
            // ============================================================

            const Text(
              'Hi, Aisyah ',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Lanjutkan belajar algoritma hari ini.',
              style: TextStyle(
                color: textGrey,
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // CARD PROGRESS BELAJAR
            // ============================================================

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: blue.withValues(alpha: .10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.trending_up,
                          color: blue,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          'Progress Belajar',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: textDark,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Progress sementara
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 0.2,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFE9EDF3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    '1 dari 5 case selesai',
                    style: TextStyle(
                      fontSize: 11,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // LANJUTKAN BELAJAR
            // ============================================================

            const Text(
              'Lanjutkan Belajar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),

            const SizedBox(height: 12),

            // ============================================================
            // CARD CASE YANG SEDANG DIKERJAKAN
            // ============================================================

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Spacer(),

                      const Text(
                        'Step 1 of 5',
                        style: TextStyle(
                          color: textGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Case 01',
                    style: TextStyle(
                      color: blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Penataan Taman Sekolah',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Tentukan informasi dan aturan yang diperlukan untuk menata taman sekolah.',
                    style: TextStyle(
                      color: textGrey,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 18),

                  PrimaryButton(
                    text: 'Mulai Case',
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      // Nanti kita sambungkan ke CaseDetailScreen
                      // atau halaman tahap pertama case.
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // JELAJAHI CASE
            // ============================================================

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Jelajahi Case',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Lihat semua',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // ============================================================
            // CASE 01
            // ============================================================

            const SmallCaseCard(
              number: '01',
              title: 'Penataan Taman Sekolah',
              description: 'Tentukan kebutuhan penataan taman.',
              status: 'Available',
              color: blue,
              icon: Icons.arrow_forward,
            ),

            const SizedBox(height: 10),

            // ============================================================
            // CASE 02
            // ============================================================

            const SmallCaseCard(
              number: '02',
              title: 'Diskon Belanja',
              description: 'Tentukan harga setelah diskon.',
              status: 'Locked',
              color: textGrey,
              icon: Icons.lock_outline,
            ),

            const SizedBox(height: 10),

            // ============================================================
            // CASE 03
            // ============================================================

            const SmallCaseCard(
              number: '03',
              title: 'Tarif Listrik',
              description: 'Hitung biaya penggunaan listrik.',
              status: 'Locked',
              color: textGrey,
              icon: Icons.lock_outline,
            ),
          ],
        ),
      ),
    );
  }
}

