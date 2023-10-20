import 'package:ev_pmis_app/components/loading_pdf.dart';
import 'package:ev_pmis_app/screen/overviewpage/viewFIle.dart';
import 'package:ev_pmis_app/screen/overviewpage/view_excel.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../FirebaseApi/firebase_api.dart';
import '../../style.dart';

class ImagePage extends StatelessWidget {
  final FirebaseFile file;

  const ImagePage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = ['.jpeg', '.jpg', '.png'].any(file.name.contains);
    final isPdf = ['.pdf'].any(file.name.contains);
    print('fileurl' + file.url);
    return Scaffold(
        appBar: AppBar(
          title: Text(file.name),
          backgroundColor: blue,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () async {
                if (await Permission.storage.request().isGranted) {
                  final pr = ProgressDialog(context);

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
                          color: Colors.black,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w400),
                      messageTextStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600));

                  pr.show();
                  await FirebaseApi.downloadFile(file.ref).whenComplete(() {
                    pr.hide();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actionsAlignment: MainAxisAlignment.center,
                            actionsPadding:
                                const EdgeInsets.only(top: 20, bottom: 20),
                            actions: [
                              const Image(
                                image: AssetImage('assets/downloaded_logo.png'),
                                height: 40,
                                width: 40,
                              ),
                              Text(
                                'File Downloaded',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.blue[900]!),
                              )
                            ],
                          );
                        });
                  });
                } else {
                  print('Permission is Denied');
                }
              },
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: isImage
            ? Center(
                child: Image.network(
                  file.url,
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.height,
                  fit: BoxFit.contain,
                ),
              )
            : isPdf
                ? ViewFile(path: file.url)
                : ViewExcel(
                    path: file.ref,
                  )
        //  const Center(
        //     child: Text(
        //       'Cannot be displayed',
        //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //     ),
        //   ),
        );
  }
}
