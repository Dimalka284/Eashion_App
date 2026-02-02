
import 'package:eashion2/provider/cart_provider.dart';
import 'package:eashion2/screen/checkout_screen.dart';
import 'package:flutter/material.dart';

class CartTotalBottomPanel extends StatelessWidget {
  const CartTotalBottomPanel({
    super.key,
    required Map<int, bool> selectedItems,
    required this.context,
    required this.cart,
    required this.colorScheme,
  }) : _selectedItems = selectedItems;

  final Map<int, bool> _selectedItems;
  final BuildContext context;
  final CartProvider cart;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final selectedItems = cart.items
        .where((item) => _selectedItems[item.id] ?? true)
        .toList();

    final total = selectedItems.fold<double>(
      0,
      (sum, item) =>
          sum +
          (item.product.price -
                  (item.product.price * item.product.discount / 100)) *
              item.quantity,
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TOTAL: Rs.${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            ElevatedButton(
              onPressed: selectedItems.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CheckoutScreen(selectedItems: selectedItems),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                'CHECKOUT',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}