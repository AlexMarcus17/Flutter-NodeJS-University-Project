import 'dart:io';

import 'package:coffee_shop_app_mpp/data/product.dart';
import 'package:coffee_shop_app_mpp/presentation/dataprovider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Product product;

  ProductFormScreen({required this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late bool isVegan;
  late bool hasCaffeine;
  late String imagePath;
  late bool imageIsAsset;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    isVegan = widget.product.isVegan;
    hasCaffeine = widget.product.hasCaffeine;
    imagePath = widget.product.image;
    imageIsAsset = widget.product.imageIsAsset;
  }

  Future<void> _pickImage() async {
    await Permission.photos.request();
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        imageIsAsset = false;
      });
    }
  }

  void _updateProduct() {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        imagePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You need to complete all the fields."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Provider.of<DataProvider>(context, listen: false).updateProduct(
      widget.product.id,
      _nameController.text,
      _descriptionController.text,
      double.parse(_priceController.text),
      imagePath,
      isVegan,
      hasCaffeine,
      imageIsAsset,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Product updated successfully!"),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  void _deleteProduct() {
    Provider.of<DataProvider>(context, listen: false)
        .deleteProduct(widget.product.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Product deleted successfully!"),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 201, 154),
      appBar: AppBar(
        title: Text("Edit Product"),
        backgroundColor: const Color.fromARGB(255, 237, 201, 154),
      ),
      body: Padding(
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
                    child: imageIsAsset
                        ? Image.network(imagePath, fit: BoxFit.cover)
                        : Image.file(File(imagePath), fit: BoxFit.cover),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Text("Update"),
                ),
                ElevatedButton(
                  onPressed: _deleteProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
