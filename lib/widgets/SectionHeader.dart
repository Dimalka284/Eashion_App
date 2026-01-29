
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool isSeeAll;
  const SectionHeader({
    super.key,
    required this.title,
    required this.isSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: "PlayfairDisplay",
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary
          ),
        ),
        isSeeAll ? Text("SEE ALL", style: TextStyle(color: Colors.blue)) : SizedBox(),
      ],
    );
  }
}
