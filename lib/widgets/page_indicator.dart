import 'package:flutter/material.dart';
import '../main.dart';

class PageIndicator extends StatelessWidget {
  final int current;

  const PageIndicator({
    super.key,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) {
          final active = index == current;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: active ? 7 : 6,
            height: active ? 7 : 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? navy : Colors.white,
              border: Border.all(
                color: navy,
                width: .8,
              ),
            ),
          );
        },
      ),
    );
  }
}
