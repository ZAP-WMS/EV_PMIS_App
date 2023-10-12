import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../style.dart';

import 'custom_appbar.dart';

class UploadDocument extends StatefulWidget {
  String? title;
  String? subtitle;
  String? cityName;
  String? depoName;
  dynamic userId;
  String? fldrName;
  String? date;
  int? srNo;
  String? pagetitle;

  UploadDocument({
    super.key,
    this.title,
    this.subtitle,
    required this.cityName,
    required this.depoName,
    required this.userId,
    required this.fldrName,
    this.date,
    this.srNo,
    this.pagetitle,
  });

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  FilePickerResult? result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: CustomAppBar(
              title: '${widget.cityName}/${widget.depoName}/Upload Checklist',
              isSync: false,
              isCentered: true,
              height: 50,
            )),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (result != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Selected file:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: result?.files.length ?? 0,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: blue),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(result?.files[index].name ?? '',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            );
                          })
                    ],
                  ),
                ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 100,
                      child: ElevatedButton(
                          onPressed: () async {
                            result = await FilePicker.platform.pickFiles(
                              withData: true,
                              type: FileType.any,
                              allowMultiple: true,
                              // allowedExtensions: ['pdf']
                            );
                            if (result == null) {
                              print("No file selected");
                            } else {
                              setState(() {});
                              result?.files.forEach((element) {
                                print(element.name);
                              });
                            }
                          },
                          child: const Text(
                            'Pick file',
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      width: 120,
                      height: 100,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (result != null) {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  content: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: blue,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                              Uint8List? fileBytes = result!.files.first.bytes;
                              String refname = (widget.title ==
                                      'QualityChecklist'
                                  ? '${widget.title}/${widget.subtitle}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.fldrName}/${widget.date}/${widget.srNo}/${result!.files.first.name}'
                                  : widget.pagetitle == 'ClosureReport'
                                      ? '${widget.pagetitle}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.fldrName}/${result!.files.first.name}'
                                      : '${widget.pagetitle}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.date}/${widget.fldrName}/${result!.files.first.name}');

                              // String? fileName = result!.files.first.name;

                              await FirebaseStorage.instance
                                  .ref(refname)
                                  .putData(
                                    fileBytes!,
                                    // SettableMetadata(contentType: 'application/pdf')
                                  )
                                  .whenComplete(() =>
                                      // setState(() => result == null)
                                      // );
                                      Navigator.pop(context));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Image is Uploaded')));
                            }
                          },
                          child: const Text(
                            'Upload file',
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                          'Back to ${widget.title == 'QualityChecklist' ? 'Quality Checklist' : widget.pagetitle}')),
                ),
              )
            ],
          ),
        ));
  }
}
