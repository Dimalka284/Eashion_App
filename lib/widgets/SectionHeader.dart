
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: "PlayfairDisplay",
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        isSeeAll ? Text("SEE ALL", style: TextStyle(color: Colors.blue)) : SizedBox(),
      ],
    );
  }
}
