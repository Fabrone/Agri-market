import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_model.dart';
import 'category_model.dart';

class FirestoreHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(Product product) async {
    await _firestore.collection('products').add(product.toMap());
  }

  Future<List<Product>> getProducts() async {
    QuerySnapshot snapshot = await _firestore.collection('products').get();
    return snapshot.docs.map((doc) {
      return Product.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<Category>> getCategories() async {
    QuerySnapshot snapshot = await _firestore.collection('categories').get();
    return snapshot.docs.map((doc) {
      return Category.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
