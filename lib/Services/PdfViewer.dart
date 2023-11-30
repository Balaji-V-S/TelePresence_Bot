import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

  class PdfViewer extends StatefulWidget {
  const PdfViewer({Key? key, required this.pdfpath}) : super(key: key);
    final File pdfpath;

    @override
    State<PdfViewer> createState() => _PdfViewerState();
  }

  class _PdfViewerState extends State<PdfViewer> {
    late PdfControllerPinch pdfControllerPinch;

    int totalPageCount = 0, currentPage = 1;

    @override
    void initState() {
      super.initState();
      pdfControllerPinch = PdfControllerPinch(
          document: PdfDocument.openFile(widget.pdfpath.path));
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
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
