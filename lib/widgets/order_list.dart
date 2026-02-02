
import 'package:eashion2/screen/checkout_screen.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  const OrderList({
    super.key,
    required this.widget,
    required this.colorScheme,
  });

  final CheckoutScreen widget;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.selectedItems.map((item) {
        final price =
            item.product.price -
            (item.product.price * item.product.discount / 100);
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              Container(
                height: 70,
                width: 60,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  image: DecorationImage(
                    image: NetworkImage(item.product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      "Quantity: ${item.quantity}",
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Rs. ${price.toStringAsFixed(0)}",
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}