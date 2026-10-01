import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

const Color navy = Color(0xFF1E2A44);
const Color blue = Color(0xFF3B82F6);
const Color teal = Color(0xFF14B8A6);
const Color success = Color(0xFF22A06B);
const Color error = Color(0xFFD64545);
const Color warning = Color(0xFFD99A00);

const Color textDark = Color(0xFF172033);
const Color textGrey = Color(0xFF667085);
const Color borderGrey = Color(0xFFD0D5DD);
const Color lightGrey = Color(0xFFF2F4F7);

void main() {
  runApp(const AlgoCaseApp());
}

class AlgoCaseApp extends StatelessWidget {
  const AlgoCaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AlgoCase',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: navy),
      ),
      home: const SplashScreen(),
    );
  }
}
