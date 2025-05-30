import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String userId; // New field added
  final String category;
  final String description;
  final double price;
  final String quantityType;
  final String imageUrl;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.userId, // New parameter added
    required this.category,
    required this.description,
    required this.price,
    required this.quantityType,
    required this.imageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId, // New field added to map
      'category': category,
      'description': description,
      'price': price,
      'quantityType': quantityType,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '', // New field retrieved from map
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantityType: map['quantityType'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
