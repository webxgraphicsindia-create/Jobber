import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfPreviewScreen extends StatefulWidget {
  final String filePath;

  const PdfPreviewScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  _PdfPreviewScreenState createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  int? _pages;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController? _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: AppBar(
        title: Text("Resume Preview"),
        backgroundColor: Colors.blueAccent,
      ),*/
      body: Stack(
        children: [
          PDFView(
            filePath: widget.filePath,
            enableSwipe: true,
            swipeHorizontal: false, // Set to false for vertical scrolling
            autoSpacing: true,
            pageFling: true,
            onRender: (_pages) {
              setState(() {
                this._pages = _pages;
                pdfReady = true;
              });
            },
            onViewCreated: (PDFViewController vc) {
              _pdfViewController = vc;
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                _currentPage = page ?? 0;
              });
            },
            onError: (error) {
              print("PDFView error: ${error.toString()}");
            },
            onPageError: (page, error) {
              print("$page: ${error.toString()}");
            },
          ),
          if (!pdfReady)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: _pages != null && _pages! > 0
          ? FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Page ${_currentPage + 1} of $_pages"),
      )
          : Container(),
    );
  }
}
