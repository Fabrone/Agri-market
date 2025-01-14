import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'product_model.dart';
import 'category_model.dart';

class FirestoreHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _logger = Logger('FirestoreHelper');

  // Initialize this in your app's main.dart
  static void initializeLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      // In development, you might want to see the logs in the console
      // In production, you might want to send them to a logging service
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  Future<void> addProduct(Product product) async {
    try {
      // Add timestamp to the product data
      final productData = {
        ...product.toMap(),
        'timestamp': FieldValue.serverTimestamp(),
      };

      DocumentReference docRef = await _firestore.collection('products').add(productData);
      
      // Update the product with the generated ID
      await docRef.update({'id': docRef.id});
      
      _logger.info('Product added successfully with ID: ${docRef.id}');
    } catch (e) {
      _logger.severe('Error adding product', e);
      throw Exception('Failed to add product: $e');
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .orderBy('timestamp', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Ensure ID is included
        return Product.fromMap(data);
      }).toList();
    } catch (e) {
      _logger.severe('Error getting products', e);
      throw Exception('Failed to get products: $e');
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('categories')
          .orderBy('name')
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Category.fromMap(data);
      }).toList();
    } catch (e) {
      _logger.severe('Error getting categories', e);
      throw Exception('Failed to get categories: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      _logger.info('Product deleted successfully: $productId');
    } catch (e) {
      _logger.severe('Error deleting product: $productId', e);
      throw Exception('Failed to delete product: $e');
    }
  }

  Future<void> updateProduct(String productId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('products').doc(productId).update(updates);
      _logger.info('Product updated successfully: $productId');
    } catch (e) {
      _logger.severe('Error updating product: $productId', e);
      throw Exception('Failed to update product: $e');
    }
  }
}