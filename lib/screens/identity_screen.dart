import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/app_buttons.dart';
import 'tutorial_screen.dart';

class UserIdentityScreen extends StatefulWidget {
  const UserIdentityScreen({super.key});

  @override
  State<UserIdentityScreen> createState() => _UserIdentityScreenState();
}

class _UserIdentityScreenState extends State<UserIdentityScreen> {
  // Controller untuk mengambil isi nama dari TextField
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void start() {
    // Setelah mengisi nama → masuk ke tutorial
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const TutorialWelcomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: lightGrey,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),

            // ICON USER
            Center(
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // JUDUL
            const Center(
              child: Text(
                'Siap menjelajahi case?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // DESKRIPSI
            const Center(
              child: Text(
                'Masukkan nama kamu untuk memulai.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textGrey,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // INPUT NAMA
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Nama kamu',
                prefixIcon: const Icon(
                  Icons.person_outline,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: borderGrey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: borderGrey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: blue,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // BUTTON UNTUK MEMULAI
            PrimaryButton(
              text: 'Mulai Belajar',
              icon: Icons.arrow_forward,
              onPressed: start,
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
