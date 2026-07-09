import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageScaleScreen extends StatefulWidget {
  const ImageScaleScreen({super.key});

  @override
  State<ImageScaleScreen> createState() => _ImageScaleScreenState();
}

class _ImageScaleScreenState extends State<ImageScaleScreen> {
  final String _imageUrl = "https://i.imgur.com/IvW6Buj.png";
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Scale")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: PhotoView(
                imageProvider: _selectedImage != null
                    ? FileImage(_selectedImage!) as ImageProvider
                    : NetworkImage(_imageUrl),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text("Upload Image"),
          ),
        ],
      ),
    );
  }
}
