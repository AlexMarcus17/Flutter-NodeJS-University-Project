import 'dart:io';

import 'package:coffee_shop_app_mpp/presentation/dataprovider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool isVegan = false;
  bool hasCaffeine = false;
  File? _image;

  void _validateAndSubmit() {
    if (_nameController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You need to complete all the fields."),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      Provider.of<DataProvider>(context, listen: false).addProduct(
        _nameController.text,
        _descriptionController.text,
        double.parse(_priceController.text),
        _image!.path,
        isVegan,
        hasCaffeine,
      );

      setState(() {
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _image = null;
        isVegan = false;
        hasCaffeine = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product added successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    await Permission.photos.request();
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Product Name"),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(hintText: "Product Description"),
          ),
          SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.grey[200],
                  ),
                  child: _image == null
                      ? Icon(Icons.image, size: 50, color: Colors.grey)
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
                TextButton(
                  onPressed: _pickImage,
                  child: Text("Choose image"),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(hintText: "Price"),
          ),
          SizedBox(height: 10),
          SwitchListTile(
            title: Text("The product is vegan"),
            value: isVegan,
            onChanged: (value) {
              setState(() {
                isVegan = value;
              });
            },
          ),
          SwitchListTile(
            title: Text("The product has caffeine"),
            value: hasCaffeine,
            onChanged: (value) {
              setState(() {
                hasCaffeine = value;
              });
            },
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _validateAndSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text("Add Product"),
            ),
          ),
        ],
      ),
    );
  }
}
