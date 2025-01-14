import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_market/product_model.dart';

class FirestoreHelper {
  final CollectionReference _productsCollection = 
      FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(Product product) async {
    try {
      await _productsCollection.doc(product.id).set(product.toMap());
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      QuerySnapshot querySnapshot = await _productsCollection
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
}