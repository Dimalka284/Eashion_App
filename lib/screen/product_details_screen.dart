import 'package:eashion2/model/product_model.dart';
import 'package:eashion2/provider/product_provider.dart';
import 'package:eashion2/provider/wishlist_provider.dart';
import 'package:eashion2/services/product_service.dart';
import 'package:eashion2/widgets/product_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;
  ProductDetailsScreen({super.key, required this.productId});
  final List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: isDark ? colorScheme.surface : colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: FutureBuilder<Product>(
          future: ProductService().fetchProductDetails(productId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            return Text(
              snapshot.data!.name.toUpperCase(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            );
          },
        ),
        actions: [
          Consumer<WishlistProvider>(
            builder: (context, wishlist, _) {
              final isWishlisted = wishlist.isWishlisted(productId);
              return IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted
                      ? Colors.redAccent
                      : colorScheme.onSurface,
                ),
                onPressed: () async {
                  final product = await ProductService().fetchProductDetails(
                    productId,
                  );
                  wishlist.toggleWishlist(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isWishlisted
                            ? 'Removed from wishlist'
                            : 'Added to wishlist',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Product>(
        future: ProductService().fetchProductDetails(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('ERROR: ${snapshot.error}'));
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
            child: ProductDetailSheet(
              product: product,
              isDark: isDark,
              colorScheme: colorScheme,
              productProvider: productProvider,
              sizes: sizes,
            ),
          );
        },
      ),
    );
  }
}
