import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const EmptyMessage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 90, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
