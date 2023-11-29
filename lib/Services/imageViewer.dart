import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Viewer'),
      ),
      body: Center(
        child: ElevatedButton(onPressed: () {}, child: Text('Select the Image')),
      ),
    );
  }
}