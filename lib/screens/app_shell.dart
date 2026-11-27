
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'cases_screen.dart';
import 'profile_screen.dart';

class AppShell extends StatefulWidget {
  final int initialIndex;

  const AppShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int currentIndex;

  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color darkBlue = Color(0xFF1E2A44);
  static const Color inactiveColor = Color(0xFF9298A5);
  static const Color navBackground = Color(0xFFF0F1F8);

  final List<Widget> pages = const [
    HomeScreen(),
    CasesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _changePage(int index) {
    if (currentIndex == index) return;

    setState(() {
      currentIndex = index;
    });
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.extension_rounded;
      case 2:
        return Icons.person_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Cases';
      case 2:
        return 'Profile';
      default:
        return '';
    }
  }

  Widget _buildSideItem(int index) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _changePage(index),
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 58,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  _getIcon(index),
                  size: 24,
                  color: isSelected
                      ? primaryBlue
                      : inactiveColor,
                ),
              ),
              const SizedBox(height: 5),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: isSelected
                      ? darkBlue
                      : inactiveColor,
                ),
                child: Text(_getLabel(index)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCasesButton() {
    final bool isSelected = currentIndex == 1;

    return GestureDetector(
      onTap: () => _changePage(1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: isSelected ? 72 : 66,
        height: isSelected ? 72 : 66,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2456A4),
              Color(0xFF3B82F6),
            ],
          ),
          border: Border.all(
            color: Colors.white,
            width: 5,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withValues(
                alpha: isSelected ? 0.30 : 0.18,
              ),
              blurRadius: isSelected ? 16 : 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          Icons.extension_rounded,
          color: Colors.white,
          size: 29,
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 104,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // Background dengan cekungan di tengah.
                Positioned(
                  left: 16,
                  right: 16,
                  top: 28,
                  bottom: 5,
                  child: CustomPaint(
                    painter: _NavigationBarPainter(
                      color: navBackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 13,
                        bottom: 2,
                      ),
                      child: Row(
                        children: [
                          _buildSideItem(0),

                          const Expanded(
                            child: SizedBox(),
                          ),

                          _buildSideItem(2),
                        ],
                      ),
                    ),
                  ),
                ),

                // Tombol Cases selalu berada di tengah.
                Positioned(
                  top: 0,
                  child: _buildCasesButton(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}

// =====================================================
// CUSTOM NAVIGATION BAR SHAPE
// =====================================================

class _NavigationBarPainter extends CustomPainter {
  final Color color;

  _NavigationBarPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double center = width / 2;

    final Path path = Path();

    path.moveTo(0, 22);

    // Sudut kiri atas.
    path.quadraticBezierTo(0, 0, 22, 0);

    // Bagian kiri menuju cekungan.
    path.lineTo(center - 66, 0);

    // Cekungan tengah.
    path.cubicTo(
      center - 43, 0,
      center - 46, 39,
      center, 39,
    );

    path.cubicTo(
      center + 46, 39,
      center + 43, 0,
      center + 66, 0,
    );

    // Bagian kanan.
    path.lineTo(width - 22, 0);
    path.quadraticBezierTo(width, 0, width, 22);

    // Bagian bawah.
    path.lineTo(width, height - 22);
    path.quadraticBezierTo(
      width, height,
      width - 22, height,
    );

    path.lineTo(22, height);
    path.quadraticBezierTo(
      0, height,
      0, height - 22,
    );

    path.close();

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Shadow navigation bar.
    canvas.drawShadow(
      path,
      Colors.black.withValues(alpha: 0.07),
      8,
      false,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(
    covariant _NavigationBarPainter oldDelegate,
  ) {
    return oldDelegate.color != color;
  }
}
