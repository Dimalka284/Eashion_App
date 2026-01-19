import 'package:eashion2/provider/navigation_provider.dart';
import 'package:eashion2/screen/auth_screen.dart';
import 'package:eashion2/screen/cart_screen.dart';
import 'package:eashion2/screen/category_select.dart';
import 'package:eashion2/screen/home_screen.dart';
import 'package:eashion2/screen/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  Wrapper({super.key});

  final List<Widget> _screens = [
    HomeScreen(),
    CategoryScreen(),
    WishlistScreen(),
    CartScreen(),
    AuthScreen()
  ];
  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      body: _screens[navProvider.currentIndex],
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: navProvider.currentIndex,
        onDestinationSelected: (index) {
          context.read<NavigationProvider>().setIndex(index);
        },
        backgroundColor: Colors.grey[200],
        indicatorColor: Colors.black.withOpacity(0.1),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.manage_search_outlined),
            selectedIcon: Icon(Icons.manage_search),
            label: 'Category',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite, color: Colors.red),
            label: 'Wishlist',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.login_outlined),
            selectedIcon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
      ),
    );
  }
}
