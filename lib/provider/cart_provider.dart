import 'package:flutter/material.dart';
import '../model/cart_model.dart';
import '../services/cart_service.dart';
import '../services/user_session_service.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _token;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  double get total => _items.fold(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    _token = await UserSessionService().getToken();

    if (_token == null || _token!.isEmpty) {
      _isLoggedIn = false;
      _items = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoggedIn = true;
    _items = await CartService().getCart(_token!);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeItem(int cartItemId) async {
    if (_token == null) return;

    await CartService().deleteProductFromCart(
      token: _token!,
      cartItemId: cartItemId,
    );

    _items.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }
}
