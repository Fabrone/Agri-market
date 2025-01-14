import 'package:flutter/material.dart';
import 'package:agri_market/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
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
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Add Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primaryGreen),
                title: const Text('Select from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primaryGreen),
                title: const Text('Capture with Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error selecting image: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null) {
        _showErrorSnackBar('Please select an image');
        return;
      }

      setState(() => _isLoading = true);

      try {
        // Generate unique filename
        String fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
        
        // Upload to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child('products/$fileName');
        await storageRef.putFile(_imageFile!);
        final String downloadUrl = await storageRef.getDownloadURL();

        final product = Product(
          id: DateTime.now().toString(),
          category: _selectedCategory!,
          description: _description,
          price: _price,
          quantityType: _quantityType,
          imageUrl: downloadUrl,
        );

        await FirestoreHelper().addProduct(product);

        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product uploaded successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        _showErrorSnackBar('Error uploading product: $e');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Product'),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Image Section
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add_photo_alternate,
                                    size: 50,
                                    color: AppColors.primaryGreen,
                                  ),
                                  onPressed: _showImageSourceDialog,
                                ),
                              ),
                      ),
                      const SizedBox(height: 24),

                      // Form Fields
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                items: ['Vegetables', 'Fruits', 'Grains', 'Herbs']
                                    .map((category) => DropdownMenuItem(
                                          value: category,
                                          child: Text(category),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() => _selectedCategory = value);
                                },
                                validator: (value) =>
                                    value == null ? 'Select a category' : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                onChanged: (value) => _description = value,
                                validator: (value) =>
                                    value!.isEmpty ? 'Enter product description' : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Price (KSH)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  _price = double.tryParse(value) ?? 0.0;
                                },
                                validator: (value) =>
                                    value!.isEmpty ? 'Enter product price' : null,
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Price Type',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                items: ['per kg', 'per item']
                                    .map((type) => DropdownMenuItem(
                                          value: type,
                                          child: Text(type),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() => _quantityType = value!);
                                },
                                validator: (value) =>
                                    value == null ? 'Select price type' : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Upload Button
                      ElevatedButton(
                        onPressed: _uploadProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Upload Product',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}