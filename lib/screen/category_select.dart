import 'package:eashion2/screen/category_products_screen.dart';
import 'package:eashion2/widgets/category_card.dart';
import 'package:eashion2/widgets/category_promo_banner.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorScheme.secondary,
        body: SingleChildScrollView(
          child: Column(
            children: [
              CategoryPromoBanner(),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryProductsScreen(
                        categoryId: 1,
                        categoryName: "Men",
                      ),
                    ),
                  );
                },
                child: CategoryCard(
                  title: "Men",
                  imageUrl: "assets/images/categoryM.png",
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryProductsScreen(
                        categoryId: 2,
                        categoryName: "Women",
                      ),
                    ),
                  );
                },
                child: CategoryCard(
                  title: "Women",
                  imageUrl: "assets/images/categoryW.png",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
