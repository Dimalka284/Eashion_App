import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import '../widgets/guestview.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Load cart once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().loadCart();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'MY BAG',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!cart.isLoggedIn) {
            return const GuestView(
              title: 'PLEASE LOGIN',
              description:
                  'Login to view the items you have added to your cart.',
            );
          }

          // 🟡 LOGGED IN BUT CART EMPTY
          if (cart.items.isEmpty) {
            return const Center(
              child: Text(
                'YOUR BAG IS EMPTY',
                style: TextStyle(letterSpacing: 2, color: Colors.grey),
              ),
            );
          }

          // 🟢 CART HAS ITEMS
          return Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(
                  bottom: 180,
                  left: 20,
                  right: 20,
                  top: 10,
                ),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return _buildCartItem(context, item);
                },
              ),
              _buildCheckoutBottomBar(cart.total),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, item) {
    final cart = context.read<CartProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Image.network(
            item.product.imageUrl,
            width: 100,
            height: 130,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Qty: ${item.quantity}'),
                Text('Rs. ${item.product.price}'),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              cart.removeItem(item.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBottomBar(double total) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('TOTAL ESTIMATE'),
            Text(
              'Rs. ${total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
