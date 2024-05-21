import 'dart:io';
import 'dart:typed_data';
import 'package:ev_pmis_app/components/loading_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends StatelessWidget {
  final BuildContext getContext;
  Uint8List? pdfData;
  String pageName;
  PdfViewScreen(
      {super.key,
      required this.pdfData,
      required this.pageName,
      required this.getContext});

  String pathToOpenPdf = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageName),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                downloadPDF(context);
              })
        ],
      ),
      body: SfPdfViewer.memory(
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        pdfData!,
      ),
    );
  }

  Future<void> downloadPDF(BuildContext context) async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      final pr = ProgressDialog(getContext);
      pr.style(
          progressWidgetAlignment: Alignment.center,
          message: 'Downloading file...',
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          progressWidget: const LoadingPdf(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          maxProgress: 100.0,
          progressTextStyle: const TextStyle(
              color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
          messageTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w600));

      pr.show();
      Future.delayed(const Duration(seconds: 1)).then((value) {
        pr.hide();
      });

      dynamic fileName = '$pageName.pdf';
      final savedPDFFile = await savePDFToFile(pdfData!, fileName);
      print('File Created - ${savedPDFFile.path}');
    }

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'repeating channel id', 'repeating channel name',
            channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await FlutterLocalNotificationsPlugin().show(
        0, '$pageName Pdf downloaded', 'Tap to open', notificationDetails,
        payload: pathToOpenPdf);
  }

  Future<File> savePDFToFile(Uint8List pdfData, String fileName) async {
    if (await Permission.storage.request().isGranted) {
      final documentDirectory =
          (await DownloadsPath.downloadsDirectory())?.path;
      final file = File('$documentDirectory/$fileName');

      int counter = 1;
      String newFilePath = file.path;
      pathToOpenPdf = newFilePath;

      if (await File(newFilePath).exists()) {
        final baseName = fileName.split('.').first;
        final extension = fileName.split('.').last;
        newFilePath =
            '$documentDirectory/$baseName-${counter.toString()}.$extension';
        counter++;
        pathToOpenPdf = newFilePath;
        await file.copy(newFilePath);
        counter++;
      } else {
        await file.writeAsBytes(pdfData);
        return file;
      }
    }
    return File('');
  }
}
