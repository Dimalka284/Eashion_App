import 'dart:convert';
import 'package:eashion2/model/cart_model.dart';
import 'package:eashion2/services/api_service.dart';
import 'package:http/http.dart' as http;

class CartService {
  Future<List<CartItem>> getCart(String token) async {
    final response = await http.get(
      ApiService.getUri('cart'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List cartItems = data['cart_items'];

      return cartItems
          .map((item) => CartItem.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load cart');
    }
  }
}
