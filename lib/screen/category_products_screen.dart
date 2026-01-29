import 'package:eashion2/model/product_model.dart';
import 'package:eashion2/screen/product_details_screen.dart';
import 'package:eashion2/services/product_service.dart';
import 'package:eashion2/widgets/ProductCard.dart';
import 'package:flutter/material.dart';

class CategoryProductsScreen extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: ProductService().fetchProductsByCategory(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final items = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailsScreen(productId: product.id),
                    ),
                  );
                },
                child: ProductCard(product: product),
              );
            },
          );
        },
      ),
    );
  }
}
