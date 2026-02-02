import 'package:eashion2/widgets/cart_item_tile.dart';
import 'package:eashion2/widgets/cart_total_bottom_panel.dart';
import 'package:eashion2/widgets/empty_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
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
            return EmptyMessage(
              title: "YOUR BAG IS EMPTY",
              subtitle: "Time to start a new fashion haul!",
              icon: Icons.shopping_bag_outlined,
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
                  return CartItemTile(
                    item: item,
                    isSelected: isSelected,
                    onSelectedChanged: (value) {
                      setState(() {
                        _selectedItems[item.id] = value ?? false;
                      });
                    },
                  );
                },
              ),
              CartTotalBottomPanel(selectedItems: _selectedItems, context: context, cart: cart, colorScheme: colorScheme),
            ],
          );
        },
      ),
    );
  }
}

