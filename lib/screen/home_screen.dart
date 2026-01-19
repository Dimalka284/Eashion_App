import 'package:eashion2/model/product_model.dart';
import 'package:eashion2/services/product_service.dart';
import 'package:eashion2/widgets/MainImageCard.dart';
import 'package:eashion2/widgets/SearchBar.dart';
import 'package:eashion2/widgets/SectionHeader.dart';
import 'package:eashion2/widgets/discount_products_card.dart';
import 'package:eashion2/widgets/new_collection_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late Future<List<Product>> _productsFuture;
    late Future<List<Product>> _discountproducts;
    _productsFuture = ProductService().fetchProducts();
    _discountproducts = ProductService().fetchDiscount();
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu, size: 35),
        title: const Center(
          child: Text(
            "EASHION",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'PlayfairDisplay',
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.shopping_cart, size: 35),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSearchBar(),
                  const SizedBox(height: 10),
                  MainImageCard(),
                  const SizedBox(height: 20),
                  SectionHeader(title: "Discount Products", isSeeAll: false),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            DiscountProducts(discountproducts: _discountproducts),
            SliverToBoxAdapter(
              child: SectionHeader(title: "NEW COLLECTION", isSeeAll: true),
            ),
            NewCollection(productsFuture: _productsFuture),
          ],
        ),
      ),
    );
  }
}
