import 'package:eashion2/model/product_model.dart';
import 'package:eashion2/screen/product_details_screen.dart';
import 'package:eashion2/widgets/ProductCard.dart';
import 'package:flutter/material.dart';

class NewCollection extends StatelessWidget {
  const NewCollection({
    super.key,
    required Future<List<Product>> productsFuture,
  }) : _productsFuture = productsFuture;

  final Future<List<Product>> _productsFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(color: Colors.black),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(child: Text("No products found")),
          );
        }
        final items = snapshot.data!;
        return SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          sliver: SliverGrid(
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsScreen(productId: product.id),
                    ),
                  );
                },
                child: ProductCard(product: product),
              );
            }, childCount: items.length),
          ),
        );
      },
    );
  }
}
