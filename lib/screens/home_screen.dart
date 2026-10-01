import 'package:flutter/material.dart';

import '../main.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../widgets/app_card.dart';
import '../widgets/app_buttons.dart';
import '../widgets/small_case_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ============================================================
  // MENGAMBIL USER
  // ============================================================

  Future<UserModel?> getUser() async {
    return await DatabaseService.instance.getUser();
  }

  // ============================================================
  // MENGAMBIL PROGRESS USER
  // ============================================================

  Future<Map<String, dynamic>?> getProgress(int userId) async {
    return await DatabaseService.instance.getProgress(
      userId: userId,
      caseId: '01',
    );
  }

  // ============================================================
  // MENGAMBIL JUMLAH CASE SELESAI
  // ============================================================

  Future<int> getCompletedCases(int userId) async {
    return await DatabaseService.instance.getCompletedCaseCount(
      userId,
    );
  }

  // ============================================================
  // NAMA CASE
  // ============================================================

  String getCaseName(String caseId) {
    switch (caseId) {
      case '01':
        return 'Penataan Taman Sekolah';

      case '02':
        return 'Diskon Belanja';

      case '03':
        return 'Tarif Listrik';

      default:
        return 'Penataan Taman Sekolah';
    }
  }

  // ============================================================
  // DESKRIPSI CASE
  // ============================================================

  String getCaseDescription(String caseId) {
    switch (caseId) {
      case '01':
        return 'Tentukan informasi dan aturan yang diperlukan untuk menata taman sekolah.';

      case '02':
        return 'Tentukan harga setelah mendapatkan diskon.';

      case '03':
        return 'Hitung biaya penggunaan listrik.';

      default:
        return 'Tentukan informasi dan aturan yang diperlukan untuk menata taman sekolah.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: getUser(),

      builder: (context, userSnapshot) {
        // ========================================================
        // LOADING USER
        // ========================================================

        if (userSnapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: blue,
            ),
          );
        }

        // ========================================================
        // USER TIDAK DITEMUKAN
        // ========================================================

        if (!userSnapshot.hasData ||
            userSnapshot.data == null) {
          return const Center(
            child: Text(
              'Data pengguna belum tersedia.',
              style: TextStyle(
                color: textGrey,
              ),
            ),
          );
        }

        final user = userSnapshot.data!;
        final userId = user.id!;

        // ========================================================
        // AMBIL PROGRESS DAN JUMLAH CASE SELESAI
        // ========================================================

        return FutureBuilder<List<dynamic>>(
          future: Future.wait([
            getProgress(userId),
            getCompletedCases(userId),
          ]),

          builder: (context, dataSnapshot) {
            // ====================================================
            // LOADING DATA
            // ====================================================

            if (dataSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: blue,
                ),
              );
            }

            // ====================================================
            // ERROR / DATA TIDAK ADA
            // ====================================================

            if (!dataSnapshot.hasData) {
              return const Center(
                child: Text(
                  'Data progress belum tersedia.',
                  style: TextStyle(
                    color: textGrey,
                  ),
                ),
              );
            }

            // ====================================================
            // DATA DARI SQLITE
            // ====================================================

            final progressData =
                dataSnapshot.data![0]
                    as Map<String, dynamic>?;

            final completedCases =
                dataSnapshot.data![1] as int;

            // ====================================================
            // DEFAULT PROGRESS
            // ====================================================

            final String currentCase =
                progressData?['id_case']?.toString() ?? '01';

            final String status =
                progressData?['status']?.toString() ??
                    'Available';

            final int currentStep =
                int.tryParse(
                      progressData?['current_step']
                              ?.toString() ??
                          '1',
                    ) ??
                    1;

            // ====================================================
            // TOTAL CASE
            // ====================================================

            const int totalCases = 5;

            final double progress =
                (completedCases / totalCases)
                    .clamp(0.0, 1.0);

            // ====================================================
            // HOME
            // ====================================================

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  24,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // ==================================================
                    // SAPAAN
                    // ==================================================

                    Text(
                      'Hi, ${user.name}',
                      style: const TextStyle(
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

                    // ==================================================
                    // PROGRESS BELAJAR
                    // ==================================================

                    AppCard(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [

                              Container(
                                padding:
                                    const EdgeInsets.all(10),
                                decoration:
                                    BoxDecoration(
                                  color: blue.withValues(
                                    alpha: .10,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(
                                    12,
                                  ),
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
                                    fontWeight:
                                        FontWeight.w600,
                                    color: textDark,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(10),
                            child:
                                LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor:
                                  const Color(
                                0xFFE9EDF3,
                              ),
                              valueColor:
                                  const AlwaysStoppedAnimation<
                                      Color>(
                                blue,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '$completedCases dari $totalCases case selesai',
                            style: const TextStyle(
                              fontSize: 11,
                              color: textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ==================================================
                    // LANJUTKAN BELAJAR
                    // ==================================================

                    const Text(
                      'Lanjutkan Belajar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ==================================================
                    // CURRENT CASE
                    // ==================================================

                    AppCard(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [

                              const Spacer(),

                              Text(
                                'Step $currentStep of 5',
                                style: const TextStyle(
                                  color: textGrey,
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Text(
                            'Case $currentCase',
                            style: const TextStyle(
                              color: blue,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            getCaseName(currentCase),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                              color: textDark,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            getCaseDescription(
                              currentCase,
                            ),
                            style: const TextStyle(
                              color: textGrey,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // STATUS
                          Text(
                            'Status: $status',
                            style: TextStyle(
                              color: status == 'Completed'
                                  ? success
                                  : blue,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 18),

                          PrimaryButton(
                            text: 'Lanjutkan',
                            icon: Icons.arrow_forward,
                            onPressed: () {
                              // Nanti disambungkan ke
                              // halaman Case 01 sesuai
                              // currentStep.
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ==================================================
                    // JELAJAHI CASE
                    // ==================================================

                    Row(
                      children: [

                        const Expanded(
                          child: Text(
                            'Jelajahi Case',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w700,
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

                    // ==================================================
                    // CASE 01
                    // ==================================================

                    const SmallCaseCard(
                      number: '01',
                      title:
                          'Penataan Taman Sekolah',
                      description:
                          'Tentukan kebutuhan penataan taman.',
                      status: 'Available',
                      color: blue,
                      icon: Icons.arrow_forward,
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // CASE 02
                    // ==================================================

                    const SmallCaseCard(
                      number: '02',
                      title: 'Diskon Belanja',
                      description:
                          'Tentukan harga setelah diskon.',
                      status: 'Locked',
                      color: textGrey,
                      icon: Icons.lock_outline,
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // CASE 03
                    // ==================================================

                    const SmallCaseCard(
                      number: '03',
                      title: 'Tarif Listrik',
                      description:
                          'Hitung biaya penggunaan listrik.',
                      status: 'Locked',
                      color: textGrey,
                      icon: Icons.lock_outline,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

