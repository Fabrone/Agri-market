import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_market/app_colors.dart'; // Import AppColors

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = []; // List to hold cart items
  String _sortOption = 'Alphabetical'; // Default sort option

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    // Fetch cart items from Firestore
    final snapshot = await FirebaseFirestore.instance.collection('cart').get();
    setState(() {
      cartItems = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  void _deleteItem(String itemId) async {
    // Delete item from Firestore
    await FirebaseFirestore.instance.collection('cart').doc(itemId).delete();
    _fetchCartItems(); // Refresh the cart items
  }

  void _sortItems() {
    switch (_sortOption) {
      case 'Alphabetical':
        cartItems.sort((a, b) => a['description'].compareTo(b['description']));
        break;
      case 'Latest':
        cartItems.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
        break;
      case 'Price':
        cartItems.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'Category':
        cartItems.sort((a, b) => a['category'].compareTo(b['category']));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _sortItems(); // Sort items based on the selected option

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: AppColors.primaryGreen, // Use AppColors
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _sortOption,
              items: [
                'Alphabetical',
                'Latest',
                'Price',
                'Category',
              ].map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _sortOption = value!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(item['image'], width: 50),
                    title: Text(item['description']),
                    subtitle: Text('Price: Kshs ${item['price']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteItem(item['id']), // Use the document ID for deletion
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'delete',
            onPressed: () {
              // Implement delete all functionality if needed
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.delete),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'purchase',
            onPressed: () {
              // Implement purchase functionality when ready
            },
            backgroundColor: AppColors.primaryGreen,
            child: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
