import 'package:eashion2/model/product_model.dart';
import 'package:eashion2/provider/product_provider.dart';
import 'package:eashion2/screen/auth_screen.dart';
import 'package:eashion2/screen/cart_screen.dart';
import 'package:eashion2/services/cart_service.dart';
import 'package:eashion2/services/user_session_service.dart';
import 'package:eashion2/widgets/product_tag.dart';
import 'package:flutter/material.dart';

class ProductDetailSheet extends StatelessWidget {
  const ProductDetailSheet({
    super.key,
    required this.product,
    required this.isDark,
    required this.colorScheme,
    required this.productProvider,
    required this.sizes,
  });

  final Product product;
  final bool isDark;
  final ColorScheme colorScheme;
  final ProductProvider productProvider;
  final List<String> sizes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            product.imageUrl,
            width: double.infinity,
            height: 420,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey.shade500,
                size: 50,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Rs.${(product.price - (product.price * product.discount / 100)).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
                fontFamily: 'Roboto',
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Rs.${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: 10),
            if (product.discount > 0)
              Text(
                '-${product.discount.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          product.name.toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            ProductTag(tagname: 'NEW'),
            SizedBox(width: 10),
            ProductTag(tagname: 'Regular'),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          product.description,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: productProvider.selectedSize,
          hint: const Text('Select Size'),
          items: sizes
              .map((size) => DropdownMenuItem(value: size, child: Text(size)))
              .toList(),
          onChanged: (value) {
            productProvider.selectSize(value!);
          },
          dropdownColor: colorScheme.onPrimary,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
        const SizedBox(height: 25),
        SizedBox(
          height: 55,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              if (productProvider.selectedSize == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a size')),
                );
                return;
              }

              final token = await UserSessionService().getToken();
              if (token == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                );
                return;
              }

              final success = await CartService().addtoCart(
                token: token,
                productId: product.id,
              );

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to shopping bag')),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              }
            },
            child: const Text(
              'ADD TO SHOPPING BAG',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
