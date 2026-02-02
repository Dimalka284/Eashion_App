
import 'package:flutter/material.dart';

class StepSectionHeader extends StatelessWidget {
  const StepSectionHeader({
    super.key,
    required this.context,
    required this.num,
    required this.title,
  });

  final BuildContext context;
  final String num;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          num,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}