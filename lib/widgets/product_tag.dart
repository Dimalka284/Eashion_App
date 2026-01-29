import 'package:flutter/material.dart';

class ProductTag extends StatelessWidget {
  final String tagname;
  const ProductTag({super.key, required this.tagname});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(tagname, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
