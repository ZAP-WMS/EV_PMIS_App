import 'package:ev_pmis_app/screen/overviewpage/viewFIle.dart';
import 'package:ev_pmis_app/screen/overviewpage/view_excel.dart';
import 'package:flutter/material.dart';

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
                await FirebaseApi.downloadFile(file.ref);

                final snackBar = SnackBar(
                  content: Text('Downloaded ${file.name}'),
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
