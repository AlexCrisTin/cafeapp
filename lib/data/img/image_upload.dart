import 'dart:io';
import 'package:flutter/material.dart';

class ImageHelper {
  static Widget buildImage(String? imagePath, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: Icon(Icons.image, color: Colors.grey),
      );
    }

    // Check if it's a local file path (starts with /)
    if (imagePath.startsWith('/')) {
      return Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      );
    } else {
      // It's an asset path
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      );
    }
  }

  static DecorationImage? buildDecorationImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    // Check if it's a local file path (starts with /)
    if (imagePath.startsWith('/')) {
      return DecorationImage(
        image: FileImage(File(imagePath)),
        fit: BoxFit.cover,
        onError: (exception, stackTrace) {
          // Handle error silently
        },
      );
    } else {
      // It's an asset path
      return DecorationImage(
        image: AssetImage(imagePath),
        fit: BoxFit.cover,
        onError: (exception, stackTrace) {
          // Handle error silently
        },
      );
    }
  }
}
