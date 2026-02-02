
import 'package:flutter/material.dart';

class ShippingAddressCard extends StatelessWidget {
  const ShippingAddressCard({
    super.key,
    required TextEditingController masterAddressController,
    required this.colorScheme,
  }) : _masterAddressController = masterAddressController;

  final TextEditingController _masterAddressController;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DELIVERY TO:",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _masterAddressController.text.isEmpty
                ? "No address selected yet."
                : _masterAddressController.text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
