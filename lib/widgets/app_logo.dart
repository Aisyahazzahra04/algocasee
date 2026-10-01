import 'package:flutter/material.dart';
import '../main.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({
    super.key,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderGrey,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.extension_outlined,
        size: size * .45,
        color:teal,
      ),
    );
  }
}
