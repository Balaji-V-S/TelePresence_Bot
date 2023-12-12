// ignore: file_names
import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({Key? key, required this.imgpath}) : super(key: key);

  final File imgpath;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> with WidgetsBindingObserver {
  bool isLocked = false;
  String correctPassword = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        correctPassword = prefs.getString('password')!;
      });
    });
  }

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
              _showPasswordDialog(context);
            } else {
              setState(() {
                isLocked = !isLocked;
              });
              Fluttertoast.showToast(
                msg: "Screen Locked",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color.fromARGB(144, 255, 255, 255),
                textColor: Colors.black,
                fontSize: 16.0,
              );
            }
          },
          child: isLocked
              ? const Icon(
                  Icons.lock_outline,
                  color: Colors.black,
                  size: 40,
                )
              : const Icon(
                  Icons.lock_open,
                  color: Colors.black,
                  size: 40,
                ),
        ),
      ),
    );
  }

  Future<void> _showPasswordDialog(BuildContext context) {
    String enteredPassword = "";
    bool isPasswordCorrect = false;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(150, 13, 13, 13),
          title: const Text(
            'Enter Password',
            style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
          ),
          content: TextField(
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey[400]),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: 'Password',
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              enteredPassword = value;
            },
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
              ),
            ),
            TextButton(
              onPressed: () {
                isPasswordCorrect = enteredPassword == correctPassword;

                if (isPasswordCorrect) {
                  // Unlock the page and close the dialog
                  Navigator.of(context).pop(true);
                  setState(() {
                    isLocked = false;
                  });
                  Fluttertoast.showToast(
                      msg: "Screen Unlocked",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color.fromARGB(144, 255, 255, 255),
                      textColor: Colors.black,
                      fontSize: 16.0);
                } else {
                  // Show error message for wrong password
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: const Color.fromARGB(150, 13, 13, 13),
                        title: const Text(
                          'Wrong Password',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Roboto'),
                        ),
                        content: const Text(
                          'Please try again.',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Roboto'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text(
                'Unlock',
                style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
              ),
            ),
          ],
        );
      },
    );
  }
}
