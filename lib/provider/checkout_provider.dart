import 'package:eashion2/model/cart_model.dart';
import 'package:eashion2/services/cart_service.dart';
import 'package:flutter/material.dart';

class CheckoutProvider extends ChangeNotifier {
  Future<bool> placeOrderAndClearCart({
    required String token,
    required List<CartItem> itemsToClear,
    required List<CartItem> allCartItems, 
  }) async {
    bool allDeleted = true;

    for (var item in itemsToClear) {
      try {
        await CartService().deleteProductFromCart(
          token: token,
          cartItemId: item.id,
        );
      } catch (e) {
        debugPrint("Failed to remove item ${item.id} from server: $e");
        allDeleted = false;
      }
    }


    final idsToRemove = itemsToClear.map((e) => e.id).toSet();
    allCartItems.removeWhere((item) => idsToRemove.contains(item.id));
    
    notifyListeners();
    return allDeleted;
  }
}