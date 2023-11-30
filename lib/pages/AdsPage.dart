// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../Services/ImageViewer.dart';
import '../Services/PdfViewer.dart';
import '../Services/VideoViewer.dart';

class AdBuilder extends StatefulWidget {
  const AdBuilder({super.key});

  @override
  State<AdBuilder> createState() => _AdBuilderState();
}

class _AdBuilderState extends State<AdBuilder> {
  late File adFile;
  late File selectedImg;
  late File vdoPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/Images/appBar.png',
                fit: BoxFit.contain,
                height: 35,
              ),
            ),
            Container(
                padding: const EdgeInsets.only(right: 90, left: 10),
                child: Text('TeleMate',
                    style: GoogleFonts.jost(
                        fontSize: 20, fontWeight: FontWeight.bold)))
          ],
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 254, 252, 252),
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
      body: Center(
        child: Column(
          children: [
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
                          Color.fromARGB(234, 64, 33, 137),
                          Color.fromARGB(255, 64, 20, 135)
                        ],
                        stops: [0.25, 0.5],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: Image.asset('assets/cardImg/image.png'),
                        ),
                        const SizedBox(width: 120),
                        Text(
                          'Place Image',
                          style: GoogleFonts.jost(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
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
                            Color(0xff5536ab),
                            Color.fromARGB(255, 65, 33, 137)
                          ],
                          stops: [0.25, 0.5],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Image.asset('assets/cardImg/video.png'),
                          ),
                          const SizedBox(width: 120),
                          Text(
                            'Place Video',
                            style: GoogleFonts.jost(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                            Color.fromARGB(234, 64, 33, 137),
                            Color.fromARGB(255, 64, 20, 135)
                          ],
                          stops: [0.3, 0.75],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Image.asset('assets/cardImg/pdf.png'),
                          ),
                          const SizedBox(width: 120),
                          Text(
                            'Place PDF',
                            style: GoogleFonts.jost(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
    );
  }
}
