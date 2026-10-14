import 'dart:async';
import 'package:flutter/material.dart';

import '../services/database_service.dart';
import 'identity_screen.dart';
import 'app_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Splash tetap tampil selama 3 detik
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      checkUser();
    });
  }

  // ============================================================
  // CEK USER DI DATABASE
  // ============================================================

  Future<void> checkUser() async {
    final user = await DatabaseService.instance.getUser();

    if (!mounted) return;

    if (user != null) {
      // USER SUDAH ADA
      // Langsung masuk ke aplikasi
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AppShell(),
        ),
      );
    } else {
      // USER BELUM ADA
      // Masuk ke halaman identitas
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const UserIdentityScreen(),
        ),
      );
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // BACKGROUND GAMBAR
          Image.asset(
            'assets/images/splash_background.png',
            fit: BoxFit.cover,
          ),

          // LAPISAN PUTIH TRANSPARAN AGAR TEKS JELAS
          Container(
            color: Colors.white.withValues(alpha: 0.18),
          ),

          // KONTEN SPLASH SCREEN
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                  'assets/images/logo_algocase.png',
                  width: 320,
                  fit: BoxFit.contain,
                ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}