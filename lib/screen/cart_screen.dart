import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/cart_model.dart';
import '../provider/cart_provider.dart';
import '../screen/checkout_screen.dart';
import '../widgets/guestview.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Map<int, bool> _selectedItems = {};

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().loadCart();
    });

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: colorScheme.onPrimary,
        title: Text(
          'MY BAG',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: colorScheme.primary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }
          if (!cart.isLoggedIn) {
            return GuestView(
              title: 'PLEASE LOGIN',
              description:
                  'Login to view the items you have added to your cart.',
            );
          }
          if (cart.items.isEmpty) {
            return Center(
              child: Text(
                'YOUR BAG IS EMPTY',
                style: TextStyle(
                  letterSpacing: 2,
                  color: colorScheme.onBackground.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

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
                  final isSelected = _selectedItems[item.id] ?? true;
                  return _buildCartItem(
                    context,
                    item,
                    isSelected,
                    cart,
                    colorScheme,
                  );
                },
              ),
              _buildCheckoutBottomBar(cart, colorScheme),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartItem item,
    bool isSelected,
    CartProvider cart,
    ColorScheme colorScheme,
  ) {
    final price =
        item.product.price - (item.product.price * item.product.discount / 100);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: colorScheme.shadow.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            activeColor: colorScheme.primary,
            checkColor: colorScheme.onPrimary,
            onChanged: (val) {
              setState(() {
                _selectedItems[item.id] = val ?? false;
              });
            },
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.product.imageUrl,
              width: 80,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 100,
                color: colorScheme.surfaceVariant,
                child: Icon(
                  Icons.image_not_supported,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Rs.${price.toStringAsFixed(2)}',
                      style: TextStyle(color: colorScheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => cart.decreaseQty(item.id),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colorScheme.onSurface),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 18,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => cart.increaseQty(item.id),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colorScheme.onSurface),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 18,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: colorScheme.onSurface),
            onPressed: () => cart.removeItem(item.id),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBottomBar(CartProvider cart, ColorScheme colorScheme) {
    final selectedItems = cart.items
        .where((item) => _selectedItems[item.id] ?? true)
        .toList();

    final total = selectedItems.fold<double>(
      0,
      (sum, item) =>
          sum +
          (item.product.price -
                  (item.product.price * item.product.discount / 100)) *
              item.quantity,
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TOTAL: Rs.${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            ElevatedButton(
              onPressed: selectedItems.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CheckoutScreen(selectedItems: selectedItems),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                'CHECKOUT',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
