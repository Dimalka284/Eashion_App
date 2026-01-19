import 'package:eashion2/provider/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/product_model.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'SELECT ITEMS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Consumer<WishlistProvider>(
            builder: (context, wishlist, _) => TextButton(
              onPressed: () {
                wishlist.toggleSelectMode();
              },
              child: Text(
                wishlist.isSelectMode ? 'Cancel' : 'Select',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),

      body: Consumer<WishlistProvider>(
        builder: (context, wishlist, _) {
          if (wishlist.wishlistProducts.isEmpty) {
            return _emptyWishlist();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: wishlist.wishlistProducts.length,
            itemBuilder: (context, index) {
              final product = wishlist.wishlistProducts[index];
              return _wishlistItem(context, product);
            },
          );
        },
      ),

      bottomNavigationBar: Consumer<WishlistProvider>(
        builder: (context, wishlist, _) {
          if (!wishlist.isSelectMode || wishlist.selectedIds.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            height: 60,
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      wishlist.deleteSelected();
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontFamily: 'RExtraBoldItalic',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Later: move to cart logic
                    },
                    child: const Text(
                      'Move to Bag',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontFamily: 'RExtraBoldItalic',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _wishlistItem(BuildContext context, Product product) {
    final wishlist = context.watch<WishlistProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          if (wishlist.isSelectMode)
            GestureDetector(
              onTap: () {
                wishlist.toggleSelection(product.id);
              },
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
                    SizedBox(width: 10),
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

  // ===================== EMPTY UI =====================

  Widget _emptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.favorite_border, size: 90, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "Your wishlist is empty",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Save items you love for later",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
