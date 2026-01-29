import 'package:eashion2/model/product_model.dart';
import 'package:eashion2/provider/wishlist_provider.dart';
import 'package:eashion2/screen/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscountProducts extends StatelessWidget {
  const DiscountProducts({
    super.key,
    required Future<List<Product>> discountproducts,
  }) : _discountproducts = discountproducts;

  final Future<List<Product>> _discountproducts;

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(
      viewportFraction: 0.89,
      initialPage: 0,
    );
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<List<Product>>(
      future: _discountproducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
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
                "ERROR : ${snapshot.error}",
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(child: Text('No Product Found')),
          );
        }

        final items = snapshot.data!;

        return SliverToBoxAdapter(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),
              SizedBox(
                height: 400,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: items.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final product = items[index];
                    final discountedPrice =
                        product.price * (1 - product.discount / 100);

                    return AnimatedBuilder(
                      animation: pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (pageController.position.haveDimensions) {
                          value = pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                        }

                        return Center(
                          child: SizedBox(
                            height: Curves.easeInOut.transform(value) * 400,
                            child: child,
                          ),
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsScreen(productId: product.id),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 25,
                                offset: Offset(0, 12),
                                spreadRadius: -5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Hero(
                                    tag: 'product_${product.id}',
                                    child: Image.network(
                                      product.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.grey[300]!,
                                                    Colors.grey[200]!,
                                                  ],
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 60,
                                                color: Colors.grey[400],
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.2),
                                          Colors.black.withOpacity(0.85),
                                        ],
                                        stops: [0.4, 0.65, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 20,
                                  right: 20,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF6B6B),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(
                                            0xFFFF6B6B,
                                          ).withOpacity(0.4),
                                          blurRadius: 12,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.local_fire_department,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          '${product.discount.toInt()}% OFF',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(24),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          product.name.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                            height: 1.2,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          product.description,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.85,
                                            ),
                                            fontSize: 12,
                                            height: 1.4,
                                            letterSpacing: 0.2,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Text(
                                              'Rs.${discountedPrice.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.3,
                                                fontFamily: 'Roboto'
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              'Rs.${product.price.toString()}',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.5,
                                                ),
                                                fontSize: 14,
                                                fontFamily: 'RobotoR',
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationColor: Colors.white
                                                    .withOpacity(0.5),
                                                decorationThickness: 2,
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              width:50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(0.4),
                                                    blurRadius: 10,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Consumer<WishlistProvider>(
                                                builder: (context, wishlist, _) {
                                                  final isWishlisted = wishlist
                                                      .isWishlisted(product.id);
                                                  return IconButton(
                                                    icon: Icon(
                                                      isWishlisted
                                                          ? Icons.favorite
                                                          : Icons
                                                                .favorite_border,
                                                      color: isWishlisted
                                                          ? Colors.red
                                                          : Colors.black87,
                                                      size: 24,
                                                    ),
                                                    onPressed: () async {
                                                      await wishlist
                                                          .toggleWishlist(
                                                            product,
                                                          );

                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          backgroundColor:colorScheme.primary ,
                                                          content: Text(
                                                            isWishlisted
                                                                ? 'Removed from wishlist'
                                                                : 'Added to wishlist',
                                                          ),
                                                          duration:
                                                              const Duration(
                                                                seconds: 1,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
