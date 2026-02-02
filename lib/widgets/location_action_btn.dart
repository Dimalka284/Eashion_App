
import 'package:flutter/material.dart';

class LocationActionButton extends StatelessWidget {
  const LocationActionButton({
    super.key,
    required this.context,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isPrimary,
  });

  final BuildContext context;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 45,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: isPrimary
              ? colorScheme.onPrimary
              : colorScheme.primary,
          backgroundColor: isPrimary ? colorScheme.primary : Colors.transparent,
          side: BorderSide(color: colorScheme.primary),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    );
  }
}