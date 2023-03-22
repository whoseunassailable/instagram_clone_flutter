import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// To pick an image file from the gallery
pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  XFile? _file = await _picker.pickImage(source: source);
  if (_file != null) {
    return _file.readAsBytes();
  }
  print('No image selected');
}

// to show bottom toast message
showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
