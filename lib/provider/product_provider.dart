import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  String? _selectedSize;

  String? get selectedSize => _selectedSize;

  void selectSize(String size) {
    _selectedSize = size;
    notifyListeners();
  }

  void clearSize() {
    _selectedSize = null;
    notifyListeners();
  }
}
