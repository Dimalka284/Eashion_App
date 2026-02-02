import 'package:eashion2/model/cart_model.dart';
import 'package:eashion2/provider/cart_provider.dart';
import 'package:eashion2/widgets/qty_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final bool isSelected;
  final Function(bool?) onSelectedChanged;

  const CartItemTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onSelectedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cart = Provider.of<CartProvider>(context, listen: false);
    final price =
        item.product.price - (item.product.price * item.product.discount / 100);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: colorScheme.shadow.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            activeColor: colorScheme.primary,
            checkColor: colorScheme.onPrimary,
            onChanged: onSelectedChanged,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.product.imageUrl,
              width: 80,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs.${price.toStringAsFixed(2)}',
                  style: TextStyle(color: colorScheme.primary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    QtyButton(
                      icon: Icons.remove,
                      onTap: () => cart.decreaseQty(item.id),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    QtyButton(
                      icon: Icons.add,
                      onTap: () => cart.increaseQty(item.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: colorScheme.onSurface),
            onPressed: () => cart.removeItem(item.id),
          ),
        ],
      ),
    );
  }
}
