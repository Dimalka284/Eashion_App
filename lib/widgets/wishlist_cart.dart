
import 'package:eashion2/model/product_model.dart';
import 'package:eashion2/provider/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistCard extends StatelessWidget {
  const WishlistCard({
    super.key,
    required this.context,
    required this.product,
  });

  final BuildContext context;
  final Product product;

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:colorScheme.secondary ,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          if (wishlist.isSelectMode)
            GestureDetector(
              onTap: () => wishlist.toggleSelection(product.id),
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 4),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                    color: wishlist.isSelected(product.id)
                        ? Colors.blue
                        : Colors.white,
                  ),
                  child: wishlist.isSelected(product.id)
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
            ),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.imageUrl,
              width: 90,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "Rs. ${(product.price - (product.price * product.discount / 100)).toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Rs. ${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                if (product.discount > 0)
                  Text(
                    "-${product.discount}% OFF",
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}