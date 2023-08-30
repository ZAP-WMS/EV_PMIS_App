import 'package:ev_pmis_app/screen/overviewpage/viewFIle.dart';
import 'package:ev_pmis_app/screen/overviewpage/view_excel.dart';
import 'package:excel/excel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../../FirebaseApi/firebase_api.dart';

import 'package:http/http.dart' as http;

import '../../style.dart';

class ImagePage extends StatefulWidget {
  final FirebaseFile file;

  const ImagePage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isImage = ['.jpeg', '.jpg', '.png'].any(widget.file.name.contains);
    final isPdf = ['.pdf'].any(widget.file.name.contains);
    final isexcel = ['.xlsx'].any(widget.file.name.contains);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.file.name),
        backgroundColor: blue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () async {
              await FirebaseApi.downloadFile(widget.file.ref);

              final snackBar = SnackBar(
                content: Text('Downloaded ${widget.file.name}'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          const SizedBox(width: 12),
          IconButton(
              onPressed: () {
                FirebaseStorage.instance
                    .ref()
                    .child(widget.file.url)
                    .delete()
                    .then((value) {
                  print('Delete Successfull');
                  Navigator.pop(context);
                });
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: isImage
          ? Image.network(
              widget.file.url,
              height: double.infinity,
              fit: BoxFit.cover,
            )
          : isPdf
              ? ViewFile(path: widget.file.url)
              : isexcel
                  ? ViewExcel(path: widget.file.ref.toString())
                  : const Center(
                      child: Text(
                        'Cannot be displayed',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
    );
  }
}
