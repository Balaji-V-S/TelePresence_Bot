import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../Services/imageViewer.dart';
import '../Services/PdfViewer.dart';
import '../Services/videoViewer.dart';

class AdBuilder extends StatefulWidget {
  const AdBuilder({super.key});

  @override
  State<AdBuilder> createState() => _AdBuilderState();
}

class _AdBuilderState extends State<AdBuilder> {
  late File adFile;

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
                onTap: () {
                  // Handle tap for the first container
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ImageViewer()));
                  print('Tapped on Image');
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 40, right: 40, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.blue),
                    child: const Center(
                      child: Text(
                        'Container 1',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Handle tap for the first container
                  print('Tapped on Video');
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const VideoViewer()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 40, right: 40, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.blue),
                    child: const Center(
                      child: Text(
                        'Container 2',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.any,
                    
                  );
                  if (result != null) {
                    final path = result.files.single.path!;
                    setState(() {
                      adFile = File(path);
                    });
                  }
                  // Handle tap for the first container
                  print('Tapped on PDF');
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => PdfViewer(pdfpath: adFile)));
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 40, right: 40, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.blue),
                    child: const Center(
                      child: Text(
                        'Container 3',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )));
  }
}
