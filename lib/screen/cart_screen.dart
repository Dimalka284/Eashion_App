import 'package:eashion2/model/cart_model.dart';
import 'package:eashion2/services/cart_service.dart';
import 'package:eashion2/services/user_session_service.dart';
import 'package:eashion2/widgets/guestview.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'MY BAG', // Fashion apps usually use 'Bag' or 'Selection'
          style: TextStyle(
            letterSpacing: 4,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<String?>(
        future: UserSessionService().getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 1,
              ),
            );
          }

          final token = snapshot.data;
          final isLoggedOut = token == null || token.isEmpty;

          if (isLoggedOut) {
            return const GuestView(
              title: 'YOUR BAG IS EMPTY',
              description:
                  'Please login to see the items you added to your cart.',
            );
          }

          return FutureBuilder<List<CartItem>>(
            future: CartService().getCart(token),
            builder: (context, cartSnapshot) {
              if (cartSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 1,
                  ),
                );
              }
              if (cartSnapshot.hasError) {
                return Center(child: Text('Error: ${cartSnapshot.error}'));
              }

              final cartItems = cartSnapshot.data ?? [];

              if (cartItems.isEmpty) {
                return _buildEmptyState();
              }

              // Calculate Total Price
              double total = cartItems.fold(
                0,
                (sum, item) => sum + (item.product.price * item.quantity),
              );

              return Stack(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 180,
                      left: 20,
                      right: 20,
                      top: 10,
                    ),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _buildCartItem(item);
                    },
                  ),
                  _buildCheckoutBottomBar(total),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // Individual Cart Item Widget
  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image (Tall Aspect Ratio for Fashion)
          Container(
            width: 100,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              image: DecorationImage(
                image: NetworkImage(item.product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 15),
                Text(
                  'Rs. ${item.product.price}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Remove Button
          IconButton(
            onPressed: () {}, // Implement delete logic here
            icon: const Icon(Icons.close, color: Colors.black, size: 20),
          ),
        ],
      ),
    );
  }

  // Sticky Bottom Bar for Checkout
  Widget _buildCheckoutBottomBar(double total) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL ESTIMATE',
                  style: TextStyle(letterSpacing: 1, color: Colors.grey),
                ),
                Text(
                  'Rs. ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'PROCEED TO CHECKOUT',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[200]),
          const SizedBox(height: 20),
          const Text(
            'YOUR BAG IS EMPTY',
            style: TextStyle(letterSpacing: 2, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
