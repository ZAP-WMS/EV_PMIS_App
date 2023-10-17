import 'dart:typed_data';

import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends StatelessWidget {
  Uint8List? pdfData;
  PdfViewScreen({super.key, this.pdfData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Safety Report', height: 40, isSync: false, isCentered: true),
      body: SfPdfViewer.memory(pdfData!),
    );
  }
}
