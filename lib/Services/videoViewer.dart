import 'package:flutter/material.dart';

class VideoViewer extends StatelessWidget {
  const VideoViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: ElevatedButton(onPressed: () {}, child: Text('Select the Video')),
      ),
    );
  }
}
