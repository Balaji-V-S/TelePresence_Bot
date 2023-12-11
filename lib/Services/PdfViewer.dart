import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({Key? key, required this.pdfpath}) : super(key: key);
  final File pdfpath;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> with WidgetsBindingObserver {
  late PdfControllerPinch pdfControllerPinch;

  int totalPageCount = 0, currentPage = 1;
  bool isLocked=false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    pdfControllerPinch =
        PdfControllerPinch(document: PdfDocument.openFile(widget.pdfpath.path));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isLocked;
      },
      child: Scaffold(
        body: _buildUI(),
        floatingActionButton: FloatingActionButton.large(
            backgroundColor: Colors.white,
            elevation: 50,
            onPressed: () {
              setState(() {
                isLocked = !isLocked;
              });
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
            },
            child: isLocked
                ? const Icon(
                    Icons.lock_outline,
                    color: Color.fromRGBO(0, 0, 0, 1),
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

  Widget _buildUI() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Total Pages: ${totalPageCount}"),
            IconButton(
              onPressed: () {
                pdfControllerPinch.previousPage(
                  duration: Duration(
                    milliseconds: 500,
                  ),
                  curve: Curves.linear,
                );
              },
              icon: Icon(
                Icons.arrow_back,
              ),
            ),
            Text("Current Page: ${currentPage}"),
            IconButton(
              onPressed: () {
                pdfControllerPinch.nextPage(
                  duration: Duration(
                    milliseconds: 500,
                  ),
                  curve: Curves.linear,
                );
              },
              icon: Icon(
                Icons.arrow_forward,
              ),
            ),
          ],
        ),
        _pdfView(),
      ],
    );
  }

  Widget _pdfView() {
    return Expanded(
      child: PdfViewPinch(
        scrollDirection: Axis.vertical,
        controller: pdfControllerPinch,
        onDocumentLoaded: (doc) {
          setState(() {
            totalPageCount = doc.pagesCount;
          });
        },
        onPageChanged: (page) {
          setState(() {
            currentPage = page;
          });
        },
      ),
    );
  }
}
