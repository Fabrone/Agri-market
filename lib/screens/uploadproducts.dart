import 'package:flutter/material.dart';
import 'package:agri_market/app_colors.dart'; // Import the AppColors class
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data'; // Import Uint8List
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:agri_market/firestore_helper.dart';
import 'package:agri_market/product_model.dart';

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
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      // Read the image file as bytes
      Uint8List imageBytes = await _imageFile!.readAsBytes();

      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('products/${_imageFile!.path.split('/').last}');
      await storageRef.putData(imageBytes); // Uploading Uint8List directly

      // Get the download URL
      final String downloadUrl = await storageRef.getDownloadURL();

      final product = Product(
        id: '', // Firestore will generate this
        category: _selectedCategory!,
        description: _description,
        price: _price,
        quantityType: _quantityType,
        imageUrl: downloadUrl, // Store the download URL
      );

      await FirestoreHelper().addProduct(product);
      
      // Check if the widget is still mounted before navigating
      if (!mounted) return;

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Products'),
        backgroundColor: AppColors.primaryGreen,
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Select Image from Gallery'),
              ),
              ElevatedButton(
                onPressed: _captureImage,
                child: const Text('Capture Image with Camera'),
              ),
              const SizedBox(height: 20),
              if (_imageFile != null) ...[
                Image.file(_imageFile!, height: 150),
                const SizedBox(height: 20),
              ],
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
}
