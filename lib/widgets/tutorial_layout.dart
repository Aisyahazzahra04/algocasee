import 'package:flutter/material.dart';
import '../main.dart';
import 'app_buttons.dart';
import 'page_indicator.dart';
import '../screens/app_shell.dart';

class TutorialLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final int page;
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final String nextText;

  const TutorialLayout({
    super.key,
    required this.title,
    required this.body,
    required this.page,
    this.onBack,
    required this.onNext,
    this.nextText = 'NEXT',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
          child: Column(
            children: [

           // TOMBOL SKIP
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AppShell(),
                  ),
                );
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: navy,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

              // SCREEN TITLE
              SizedBox(
                height: 34,
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: navy,
                    ),
                  ),
                ),
              ),

              // ISI UTAMA HALAMAN TUTORIAL
              Expanded(
                child: body,
              ),

              const SizedBox(height: 10),

              // INDIKATOR POSISI TUTORIAL
              PageIndicator(current: page),

              const SizedBox(height: 16),

              // TOMBOL NAVIGASI TUTORIAL
              Row(
                children: [
                  if (onBack != null) ...[
                    Expanded(
                      child: SecondaryButton(
                        text: 'BACK',
                        onPressed: onBack!,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],

                  Expanded(
                    child: PrimaryButton(
                      text: nextText,
                      onPressed: onNext,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
