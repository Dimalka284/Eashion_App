import 'package:flutter/material.dart';

class OrderTotalFooter extends StatelessWidget {
  final double totalAmount;
  final VoidCallback onConfirm;

  const OrderTotalFooter({
    super.key,
    required this.totalAmount,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.onSurface.withOpacity(0.1)),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "TOTAL",
                  style: TextStyle(
                    letterSpacing: 2,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  "Rs. ${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: onConfirm, // Uses the passed callback
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text(
                  "CONFIRM ORDER",
                  style: TextStyle(
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}