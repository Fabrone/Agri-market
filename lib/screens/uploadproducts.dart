import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_market/app_colors.dart'; // Import the AppColors class

class UploadProductsPage extends StatefulWidget {
  const UploadProductsPage({super.key});

  @override
  UploadProductsPageState createState() => UploadProductsPageState();
}

class UploadProductsPageState extends State<UploadProductsPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  String _description = '';
  double _price = 0.0;
  String _quantityType = 'per kg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Products'),
        backgroundColor: AppColors.primaryGreen, // Use AppColors
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: ['Vegetables', 'Fruits', 'Grains', 'Herbs']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) => value == null ? 'Select a category' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _description = value;
                },
                validator: (value) => value!.isEmpty ? 'Enter product description' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _price = double.tryParse(value) ?? 0.0;
                },
                validator: (value) => value!.isEmpty ? 'Enter product price' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Price Type',
                  border: OutlineInputBorder(),
                ),
                items: ['per kg', 'per item']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _quantityType = value!;
                  });
                },
                validator: (value) => value == null ? 'Select price type' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _uploadProduct();
                  }
                },
                child: const Text('Upload Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadProduct() async {
    await FirebaseFirestore.instance.collection('products').add({
      'category': _selectedCategory,
      'description': _description,
      'price': _price,
      'quantityType': _quantityType,
      // You may want to add an image URL as well
    });

    // Check if the widget is still mounted before navigating
    if (!mounted) return;

    // Optionally, navigate back or show a success message
    Navigator.pop(context);
  }
}
