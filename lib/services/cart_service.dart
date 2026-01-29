import 'dart:convert';
import 'package:eashion2/model/cart_model.dart';
import 'package:eashion2/services/api_service.dart';
import 'package:http/http.dart' as http;

class CartService {
  //Get Cart Items
  Future<List<CartItem>> getCart(String token) async {
    final response = await http.get(
      ApiService.getUri('cart'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List cartItems = data['cart_items'];

      return cartItems.map((item) => CartItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load cart');
    }
  }

  //Add to cart
  Future<bool> addtoCart({
    required String? token,
    required int productId,
    int quantity = 1,
  }) async {
    final response = await http.post(
      ApiService.getUri('cart/add'),
       headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'product_id': productId,
        'quantity': quantity,
      }),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Add to cart failed: ${response.body}');
      return false;
    }
  }

  //Delete a product for a cart
  Future<bool> deleteProductFromCart({
    required String? token,
    required int cartItemId,
  }) async {
    final response = await http.delete(
      ApiService.getUri('cart/$cartItemId'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Delete from cart failed: ${response.body}');
      return false;
    }
  }  

  //Update qty
  // Update quantity of a cart item
Future<bool> updateCartQuantity({
  required String token,
  required int cartItemId,
  required int quantity,
}) async {
  final response = await http.put(
    ApiService.getUri('cart/$cartItemId'), 
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'quantity': quantity,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    print('Update cart quantity failed: ${response.body}');
    return false;
  }
}


}
