import 'dart:io' show File;
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({Key? key, required this.imgpath}) : super(key: key);

  final File imgpath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // Set it to false
          // boundaryMargin: EdgeInsets.all(100),
          minScale: 0.5,
          maxScale: 5,
          child: Image.file(
            imgpath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
