import 'package:flutter/material.dart';
import '../main.dart';
import 'app_card.dart';

class SmallCaseCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final String status;
  final Color color;
  final IconData icon;

  const SmallCaseCard({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    required this.status,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // NOMOR CASE
          Container(
            height: 48,
            width: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              number,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // INFORMASI CASE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // JUDUL CASE
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 3),

                // DESKRIPSI CASE
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
