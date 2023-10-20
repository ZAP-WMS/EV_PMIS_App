import 'dart:typed_data';

import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends StatelessWidget {
  Uint8List? pdfData;
  String? pageName;
  PdfViewScreen({super.key, required this.pdfData, required this.pageName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: '$pageName', height: 40, isSync: false, isCentered: true),
      body: SfPdfViewer.memory(
        pdfData!,
      ),
    );
  }
}
