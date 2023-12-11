// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../Services/ImageViewer.dart';
import '../Services/PdfViewer.dart';
import '../Services/VideoViewer.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdBuilder extends StatefulWidget {
  const AdBuilder({super.key});

  @override
  State<AdBuilder> createState() => _AdBuilderState();
}

class _AdBuilderState extends State<AdBuilder> with WidgetsBindingObserver {
  bool isLocked = false;
  late File adFile;
  late File selectedImg;
  late File vdoPath;
  final String correctPassword = "12345678";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(1, 13, 13, 13),
          body: Center(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 255, 255, 0.5),
                          Color.fromRGBO(255, 255, 255, 1),
                          Color.fromRGBO(255, 255, 255, 0),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'Create Your Advertisement              ',
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(21,21,21,100),
                          Color.fromRGBO(21,21,21,50),
                          Color.fromRGBO(21,21,21,0),
                        ]),
                      ),
                      child: const Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Add Images',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 40,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Make a visual impact: \nCreate powerful image ads with our robot.',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Container(
                      decoration:const BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(21,21,21,100),
                          Color.fromRGBO(21,21,21,50),
                          Color.fromRGBO(21,21,21,0),
                        ]),
                      ),
                      child: const Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Add Videos',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 40,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Say it with video:\nCreate video ads that connect with your audience.',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  width: 300,
                  decoration:const BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(21,21,21,100),
                          Color.fromRGBO(21,21,21,50),
                          Color.fromRGBO(21,21,21,0),
                        ]),
                      ),
                  child: const Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Add PDF',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 40,
                          ),
                        ],
                      ),
                      Text(
                        'Go beyond the surface:\n Create in-depth PDF ads that tell the whole story.',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final returnedImg = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      setState(() {
                        selectedImg = File(returnedImg!.path);
                      });
                      // Handle tap for the first container
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ImageViewer(imgpath: selectedImg)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 40, right: 40, bottom: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(203, 158, 158, 158),
                              offset: Offset(0.0, 0.0),
                              blurRadius: 2.8,
                              spreadRadius: 4,
                            ),
                          ],
                          // color: Color.
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 231, 231, 232),
                              Color.fromARGB(234, 255, 255, 255),
                            ],
                            stops: [0.25, 0.5],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Image.asset(
                                'assets/cardImg/image.png',
                                width: 150,
                              ),
                            ),
                            Text(
                              'Place Image',
                              style: GoogleFonts.audiowide(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['mp4', 'mov', 'avi', 'mkv'],
                      );
                      if (result != null) {
                        final path = result.files.single.path!;
                        setState(() {
                          vdoPath = File(path);
                        });
                      }
                      // Handle tap for the first container
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => VideoViewer(
                                vdoPath: vdoPath,
                              )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 40, right: 40, bottom: 20),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(203, 158, 158, 158),
                                offset: Offset(0.0, 0.0),
                                blurRadius: 2.8,
                                spreadRadius: 4,
                              ),
                            ],
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 233, 233, 234),
                                Color.fromARGB(234, 255, 255, 255),
                              ],
                              stops: [0.25, 0.75],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset('assets/cardImg/video.png',
                                    width: 150),
                              ),
                              Text(
                                'Place Video',
                                style: GoogleFonts.audiowide(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );
                      if (result != null) {
                        final path = result.files.single.path!;
                        setState(() {
                          adFile = File(path);
                        });
                      }
                      // Handle tap for the first container
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => PdfViewer(pdfpath: adFile)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 40, right: 40, bottom: 20),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(203, 158, 158, 158),
                                offset: Offset(0.0, 0.0),
                                blurRadius: 2.8,
                                spreadRadius: 4,
                              ),
                            ],
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(234, 255, 255, 255),
                                Color.fromARGB(255, 237, 237, 238)
                              ],
                              stops: [0.3, 0.75],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset('assets/cardImg/pdf.png',
                                    width: 150),
                              ),
                              Text(
                                'Place PDF',
                                style: GoogleFonts.audiowide(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ],
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
        onWillPop: () async {
          return !isLocked;
        });
  }

  Future<void> _showPasswordDialog(BuildContext context) {
    String enteredPassword = "";
    bool isPasswordCorrect = false;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Password'),
          content: TextField(
            onChanged: (value) {
              enteredPassword = value;
            },
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog
              },
              child: Text('Cancel'),
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
                        title: Text('Wrong Password'),
                        content: Text('Please try again.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Unlock'),
            ),
          ],
        );
      },
    );
  }
}
