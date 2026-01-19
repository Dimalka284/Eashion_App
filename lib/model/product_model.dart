class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double discount;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price']),
      discount:double.parse(json['discount']),
      imageUrl: json['image_path'],
    );
  }
}
