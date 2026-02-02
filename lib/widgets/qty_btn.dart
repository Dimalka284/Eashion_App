
import 'package:flutter/material.dart';

class QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colorScheme.onSurface),
        ),
        child: Icon(icon, size: 18, color: colorScheme.onSurface),
      ),
    );
  }
}