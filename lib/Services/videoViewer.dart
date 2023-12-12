import 'dart:io';
import 'package:flutter/material.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttertoast/fluttertoast.dart';

class VideoViewer extends StatefulWidget {
  const VideoViewer({Key? key, required this.vdoPath}) : super(key: key);
  final File vdoPath;

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> with WidgetsBindingObserver {
  late CustomVideoPlayerController _customVideoPlayerController;

  late bool isLoading = true;
  bool isLocked = false;
  String correctPassword = "";

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        correctPassword = prefs.getString('password')!;
      });
    });
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isLocked;
      },
      child: Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomVideoPlayer(
                    customVideoPlayerController: _customVideoPlayerController,
                  ),
                ],
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

  void initializeVideoPlayer() {
    setState(() {
      isLoading = true;
    });
    VideoPlayerController videoPlayerController =
        VideoPlayerController.file(widget.vdoPath)
          ..initialize().then((value) {
            setState(() {
              isLoading = false;
            });
          });

    _customVideoPlayerController = CustomVideoPlayerController(
        context: context, videoPlayerController: videoPlayerController);
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
