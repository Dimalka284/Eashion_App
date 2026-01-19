import 'dart:convert';
import 'package:eashion2/model/product_model.dart';
import 'package:eashion2/services/api_service.dart';
import 'package:http/http.dart' as http;

class ProductService {
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(ApiService.getUri('products'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List products = jsonData['data'];

      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Products');
    }
  }

  Future<List<Product>> fetchDiscount() async {
    final response = await http.get(ApiService.getUri('discount'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List products = jsonData['data'];

      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Discount Products');
    }
  }

  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final response = await http.get(
      ApiService.getUri('categoryproducts?category_id=$categoryId'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List products = jsonData['data'];

      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Products');
    }
  }

  Future<Product> fetchProductDetails(int id) async {
    final response = await http.get(ApiService.getUri('products/${id}'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Product.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load Product Details');
    }
  }
}
