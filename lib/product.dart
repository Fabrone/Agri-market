import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String imageUrl;
  final String location;
  final double price;

  Product({
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.price,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      name: data['name'],
      imageUrl: data['imageUrl'],
      location: data['location'],
      price: data['price'],
    );
  }
}
