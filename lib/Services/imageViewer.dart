import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({Key? key, required this.imgpath}) : super(key: key);

  final File imgpath;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> with WidgetsBindingObserver {
  bool isLocked = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isLocked;
      },
      child: Scaffold(
        body: Center(
          child: InteractiveViewer(
            panEnabled: true, // Set it to false
            // boundaryMargin: EdgeInsets.all(100),
            minScale: 0.5,
            maxScale: 5,
            child: Image.file(
              widget.imgpath,
              fit: BoxFit.fill,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.large(
            backgroundColor: Colors.white,
            elevation: 50,
            onPressed: () {
              if (isLocked) {
                Fluttertoast.showToast(
                    msg: "Screen Locked",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: const Color.fromARGB(144, 255, 255, 255),
                    textColor: Colors.black,
                    fontSize: 16.0);
              } else {
                
                Fluttertoast.showToast(
                  msg: "Screen Unlocked",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color.fromARGB(144, 255, 255, 255),
                  textColor: Colors.black,
                  fontSize: 16.0,
                );
              }
              setState(() {
                isLocked = !isLocked;
              });
            },
            child: isLocked
                ? const Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                    size:40
                  )
                : const Icon(
                    Icons.lock_open,
                    color: Colors.black,
                    size:40,
                  ),
          ),
      ),
    );
  }
}
