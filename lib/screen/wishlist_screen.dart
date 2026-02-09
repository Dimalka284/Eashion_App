import 'package:eashion2/provider/wishlist_provider.dart';
import 'package:eashion2/widgets/empty_message.dart';
import 'package:eashion2/widgets/wishlist_cart.dart';
import 'package:eashion2/widgets/wishlist_edit_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Future.microtask(() {
      final provider = Provider.of<WishlistProvider>(context, listen: false);
      if (provider.wishlistProducts.isEmpty) {
        provider.loadWishlist();
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
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
              onPressed: wishlist.toggleSelectMode,
              child: Text(
                wishlist.isSelectMode ? 'Cancel' : 'Select',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlist, _) {
          if (wishlist.wishlistProducts.isEmpty) {
            return const EmptyMessage(
              title: "Your wishlist is empty",
              subtitle: "Save items you love for later",
              icon: Icons.favorite_border,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: wishlist.wishlistProducts.length,
            itemBuilder: (context, index) {
              final product = wishlist.wishlistProducts[index];
              return WishlistCard(context: context, product: product);
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<WishlistProvider>(
        builder: (context, wishlist, _) {
          if (!wishlist.isSelectMode || wishlist.selectedIds.isEmpty) {
            return const SizedBox.shrink();
          }
          return const WishlistBottomEditBar();
        },
      ),
    );
  }
}
