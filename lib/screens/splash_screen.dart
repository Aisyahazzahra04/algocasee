import 'dart:async';
import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/app_logo.dart';
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
      backgroundColor: lightGrey,

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO APLIKASI
              const AppLogo(size: 64),

              const SizedBox(height: 20),

              // NAMA APLIKASI
              const Text(
                'ALGOCASE',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: navy,
                ),
              ),

              const SizedBox(height: 5),

              // TAGLINE APLIKASI
              const Text(
                'Think. Analyze. Solve.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  color: textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}