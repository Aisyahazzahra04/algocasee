import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/tutorial_layout.dart';
import 'app_shell.dart';

class TutorialWelcomeScreen extends StatelessWidget {
  const TutorialWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TutorialLayout(
      title: 'TUTORIAL 1 / 5',
      page: 0,
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TutorialFlowScreen(),
          ),
        );
      },
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 105,
              decoration: BoxDecoration(
                border: Border.all(
                  color: borderGrey,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(
                  Icons.extension_outlined,
                  color: teal,
                  size: 40,
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Welcome to AlgoCase',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: navy,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Kamu akan belajar menyelesaikan masalah secara\n'
              'bertahap, selangkah demi selangkah.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TutorialFlowScreen extends StatelessWidget {
  const TutorialFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TutorialLayout(
      title: 'TUTORIAL 2 / 5',
      page: 1,
      onBack: () => Navigator.pop(context),
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TutorialStagesScreen(),
          ),
        );
      },
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Alur Utama Aplikasi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: navy,
                ),
              ),

              const SizedBox(height: 32),

              _FlowItem(
                icon: Icons.menu_book_outlined,
                text: 'READ THE CASE',
              ),

              _FlowArrow(),

              _FlowItem(
                icon: Icons.search,
                text: 'ANALYZE THE PROBLEM',
              ),

              _FlowArrow(),

              _FlowItem(
                icon: Icons.account_tree_outlined,
                text: 'BUILD THE LOGIC',
              ),

              _FlowArrow(),

              _FlowItem(
                icon: Icons.play_circle_outline,
                text: 'TEST YOUR SOLUTION',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlowItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FlowItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(
          color: navy,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: navy,
          ),
          const SizedBox(width: 9),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: navy,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowArrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 28,
      child: Center(
        child: Icon(
          Icons.arrow_downward,
          size: 17,
          color: textGrey,
        ),
      ),
    );
  }
}

class TutorialStagesScreen extends StatelessWidget {
  const TutorialStagesScreen({super.key});

  final List<String> stages = const [
    'Understand the Problem',
    'Analyze Information',
    'Identify Input, Output & Rules',
    'Build Logic',
    'Test Solution',
  ];

  @override
  Widget build(BuildContext context) {
    return TutorialLayout(
      title: 'TUTORIAL 3 / 5',
      page: 2,
      onBack: () => Navigator.pop(context),
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TutorialCaseScreen(),
          ),
        );
      },
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Setiap Case Punya 5 Tahap',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: navy,
                ),
              ),

              const SizedBox(height: 28),

              ...List.generate(
                stages.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _StageCard(
                      number: index + 1,
                      text: stages[index],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  final int number;
  final String text;

  const _StageCard({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        border: Border.all(
          color: navy,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 19,
            height: 19,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: navy,
              ),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: navy,
                ),
              ),
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: navy,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialCaseScreen extends StatelessWidget {
  const TutorialCaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TutorialLayout(
      title: 'TUTORIAL 4 / 5',
      page: 3,
      onBack: () => Navigator.pop(context),
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TutorialReadyScreen(),
          ),
        );
      },
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),

            const Text(
              'Contoh Mini Case',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: navy,
              ),
            ),

            const SizedBox(height: 24),

            _InfoBox(
              text:
                  '"Sebuah sistem ingin menghitung jumlah dari dua angka."',
            ),

            const SizedBox(height: 12),

            _InfoBox(
              title: 'INPUT',
              text: 'Angka 1 dan Angka 2',
            ),

            const SizedBox(height: 12),

            _InfoBox(
              title: 'PROCESS',
              text: 'Menjumlahkan kedua angka',
            ),

            const SizedBox(height: 12),

            _InfoBox(
              title: 'OUTPUT',
              text: 'Hasil Penjumlahan',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String? title;
  final String text;

  const _InfoBox({
    this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: navy,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 5),
          ],

          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: navy,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialReadyScreen extends StatelessWidget {
  const TutorialReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TutorialLayout(
      title: 'TUTORIAL 5 / 5',
      page: 4,
      nextText: 'START LEARNING',
      onBack: () => Navigator.pop(context),
      onNext: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AppShell(),
          ),
        );
      },
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                border: Border.all(
                  color: borderGrey,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.fact_check_outlined,
                size: 40,
                color: teal,
              ),
            ),

            const SizedBox(height: 26),

            const Text(
              "YOU'RE READY!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: navy,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Kamu sudah siap untuk menyelesaikan case.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

