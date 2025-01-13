class Product {
  String id;
  String category;
  String description;
  double price;
  String quantityType;
  String imageUrl;

  Product({
    required this.id,
    required this.category,
    required this.description,
    required this.price,
    required this.quantityType,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'description': description,
      'price': price,
      'quantityType': quantityType,
      'imageUrl': imageUrl,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      category: map['category'],
      description: map['description'],
      price: map['price'],
      quantityType: map['quantityType'],
      imageUrl: map['imageUrl'],
    );
  }
}
