
import 'package:flutter/material.dart';

class MainImageCard extends StatelessWidget {
  const MainImageCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage('assets/images/primaryImage.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}