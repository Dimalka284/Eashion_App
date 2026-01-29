import 'package:eashion2/services/cart_service.dart';
import 'package:flutter/material.dart';
import '../model/product_model.dart';
import '../services/wishlist_service.dart';

class WishlistProvider extends ChangeNotifier {
  WishlistProvider() {
    loadWishlist();
  }

  /// Wishlist products
  List<Product> _wishlistProducts = [];

  /// Selection mode
  bool _isSelectMode = false;

  /// Selected product IDs
  final Set<int> _selectedIds = {};
  List<Product> get wishlistProducts => _wishlistProducts;

  bool get isSelectMode => _isSelectMode;

  Set<int> get selectedIds => _selectedIds;

  bool isSelected(int productId) => _selectedIds.contains(productId);

  bool isWishlisted(int productId) =>
      _wishlistProducts.any((p) => p.id == productId);

  Future<void> loadWishlist() async {
    final data = await WishlistService().getWishlist();

    _wishlistProducts = data.map<Product>((e) {
      return Product(
        id: e['product_id'],
        name: e['name'],
        price: e['price'],
        imageUrl: e['image_url'],
        discount: e['discount'],
        description: '',
      );
    }).toList();

    notifyListeners();
  }

  Future<void> toggleWishlist(Product product) async {
    final exists = isWishlisted(product.id);

    if (exists) {
      await WishlistService().removeFromWishlist(product.id);
      _wishlistProducts.removeWhere((p) => p.id == product.id);
      _selectedIds.remove(product.id);
    } else {
      await WishlistService().addToWishlist({
        'product_id': product.id,
        'name': product.name,
        'price': product.price,
        'image_url': product.imageUrl,
        'discount': product.discount,
      });
      _wishlistProducts.add(product);
    }

    notifyListeners();
  }

  void toggleSelectMode() {
    _isSelectMode = !_isSelectMode;
    _selectedIds.clear();
    notifyListeners();
  }

  void toggleSelection(int productId) {
    if (_selectedIds.contains(productId)) {
      _selectedIds.remove(productId);
    } else {
      _selectedIds.add(productId);
    }
    notifyListeners();
  }

  Future<void> deleteSelected() async {
    for (final id in _selectedIds) {
      await WishlistService().removeFromWishlist(id);
    }

    _wishlistProducts.removeWhere(
      (product) => _selectedIds.contains(product.id),
    );

    _selectedIds.clear();
    _isSelectMode = false;

    notifyListeners();
  }

  void clearSelection() {
    _selectedIds.clear();
    notifyListeners();
  }

  Future<void> moveSelectedToCart(String token) async {
    final cartService = CartService();

    final selectedProducts =
        _wishlistProducts.where((p) => _selectedIds.contains(p.id)).toList();

    for (final product in selectedProducts) {
      await cartService.addtoCart(
        token: token,
        productId: product.id,
        quantity: 1,
      );

      await WishlistService().removeFromWishlist(product.id);
    }
    
    _wishlistProducts.removeWhere((p) => _selectedIds.contains(p.id));
    _selectedIds.clear();
    _isSelectMode = false;

    notifyListeners();
  }

}
