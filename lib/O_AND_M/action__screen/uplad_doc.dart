import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/components/loading_pdf.dart';
import 'package:ev_pmis_app/PMIS/authentication/authservice.dart';
import 'package:ev_pmis_app/PMIS/widgets/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../../../style.dart';
import '../../PMIS/common_screen/controller/upload_image_controller.dart';
import '../../PMIS/view_AllFiles.dart';
import '../../PMIS/widgets/custom_appbar.dart';

// ignore: must_be_immutable
class UploadPreventiveList extends StatefulWidget {
  String? title;
  String? subtitle;
  String? cityName;
  String? depoName;
  dynamic userId;
  String? fldrName;
  String? date;
  int? srNo;
  String? role;
  String? yearOption;
  String? colunmName;

  UploadPreventiveList({
    super.key,
    this.title,
    this.subtitle,
    required this.depoName,
    required this.userId,
    required this.fldrName,
    this.date,
    this.srNo,
    this.role,
    this.yearOption,
    this.colunmName,
  });

  @override
  State<UploadPreventiveList> createState() => _UploadPreventiveListState();
}

class _UploadPreventiveListState extends State<UploadPreventiveList> {
  FilePickerResult? result;
  final AuthService authService = AuthService();
  List<String> assignedCities = [];
  bool isFieldEditable = false;
  bool isLoading = true;

  @override
  void initState() {
    getAssignedDepots().whenComplete(() {
      isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    imagePickerController.pickedImagePath.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isImage = ['.jpeg', '.jpg', '.png'];
    widget.title = 'Preventive Maintenance';
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          depoName: widget.depoName ?? '',
          title: 'Upload Checklist',
          isSync: false,
          isCentered: true,
          height: 50,
        ),
      ),
      body: isLoading
          ? const LoadingPage()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 400,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(() {
                        if (imagePickerController
                            .pickedImagePath.value.isNotEmpty) {
                          return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, childAspectRatio: 1.0),
                              shrinkWrap: true,
                              itemCount:
                                  imagePickerController.pickedImagePath.length,
                              itemBuilder: (context, index) {
                                final filePath = imagePickerController
                                    .pickedImagePath[index];
                                bool isImageFile = isImage.any((extension) =>
                                    filePath.contains(extension));
                                return Center(
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: blue),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: isImageFile
                                            ? Image.file(
                                                File(imagePickerController
                                                    .pickedImagePath[index]),
                                                height: 50,
                                                width: 50
                                                //  fit: BoxFit.fill,
                                                )
                                            : imagePickerController
                                                    .pickedImagePath[index]
                                                    .contains('.pdf')
                                                ? Image.asset(
                                                    'assets/pdf_logo.jpeg',
                                                    height: 50,
                                                  )
                                                : imagePickerController
                                                        .pickedImagePath[index]
                                                        .contains('.mp4')
                                                    ? Image.asset(
                                                        'assets/video_image.jpg')
                                                    : imagePickerController.pickedImagePath[index]
                                                            .contains('.xlsx')
                                                        ? Image.asset('assets/excel.png',
                                                            height: 50)
                                                        : Image.asset(
                                                            'assets/other_file.png',
                                                            height: 50)));
                              });
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.2),
                            child: Text(
                              'Selected Files Displayed Here',
                              textAlign: TextAlign.center,
                              style: headlineBold,
                            ),
                          );
                        }
                      }),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 70,
                          child: ElevatedButton(
                              onPressed: () async {
                                showPickerOptions(widget.title!);
                              },
                              child: Text(
                                'Pick file',
                                style: uploadViewStyle,
                              )),
                        ),
                        const SizedBox(width: 15),
                        SizedBox(
                          width: 100,
                          height: 70,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (imagePickerController
                                    .pickedImagePath.isNotEmpty) {
                                  final pr = ProgressDialog(context);
                                  pr.style(
                                    progressWidgetAlignment: Alignment.center,
                                    message: 'Uploading...',
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
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                  pr.show();
                                  Uint8List? fileBytes;
                                  // Uint8List? fileBytes =
                                  //     result!.files.first.bytes;

                                  for (String imagePath in imagePickerController
                                      .pickedImagePath) {
                                    // Read the file as bytes
                                    File imageFile = File(imagePath);
                                    Uint8List fileBytes =
                                        await imageFile.readAsBytes();

                                    String imageName =
                                        imagePath.split('/').last;

                                    String refname =
                                        '${widget.title}/${widget.depoName}/${widget.userId}/${widget.fldrName}/$imageName';

                                    Map<String, dynamic> tableData = Map();
                                    List<dynamic> tabledata = [];
                                    tableData[widget.colunmName!] =
                                        DateFormat('dd-MM-yyyy')
                                            .format(DateTime.now());
                                    tabledata.add(tableData);

                                    await FirebaseFirestore.instance
                                        .collection('PreventiveMaintenance')
                                        .doc(widget.depoName)
                                        .collection(widget.yearOption!)
                                        .doc(widget.userId)
                                        .get() // Check if the document exists
                                        .then((docSnapshot) async {
                                      if (docSnapshot.exists) {
                                        // Document exists, update the 'submission Date' array
                                        if (docSnapshot.data()?['data'] !=
                                            null) {
                                          await FirebaseStorage.instance
                                              .ref(refname)
                                              .putData(fileBytes);
                                          await FirebaseFirestore.instance
                                              .collection(
                                                  'PreventiveMaintenance')
                                              .doc(widget.depoName)
                                              .collection(widget.yearOption!)
                                              .doc(widget.userId)
                                              .update({
                                            'submission Date':
                                                FieldValue.arrayUnion(
                                                    [tableData])
                                          }).whenComplete(() {
                                            tableData.clear();

                                            pr.hide();

                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: blue,
                                                content: Text(
                                                  'Files are Uploaded',
                                                  style:
                                                      TextStyle(color: white),
                                                ),
                                              ),
                                            );
                                            // ScaffoldMessenger.of(context)
                                            //     .showSnackBar(SnackBar(
                                            //   content:
                                            //       const Text('Data are added'),
                                            //   backgroundColor: blue,
                                            // ));
                                          });
                                        } else {
                                          // 'data' field does not exist, do not update 'submission Date'
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text('No data available'),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
                                      } else {
                                        // 'data' field does not exist, do not update 'submission Date'
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              'No data available.First Sync Table Data'),
                                          backgroundColor: Colors.red,
                                        ));
                                      }
                                      // else {
                                      //   // Document doesn't exist, create the document and set the 'submission Date' array
                                      //   await FirebaseFirestore.instance
                                      //       .collection('PrevntiveMaintenance')
                                      //       .doc(widget.depoName)
                                      //       .collection(widget.yearOption!)
                                      //       .doc(widget.userId)
                                      //       .set({
                                      //     'submission Date':
                                      //         FieldValue.arrayUnion(
                                      //             [tableData]),
                                      //   }).whenComplete(() {
                                      //     tableData.clear();
                                      //     ScaffoldMessenger.of(context)
                                      //         .showSnackBar(SnackBar(
                                      //       content:
                                      //           const Text('Data are added'),
                                      //       backgroundColor: blue,
                                      //     ));
                                      //   });
                                      // }
                                    });

                                    // await FirebaseFirestore.instance
                                    //     .collection('PrevntiveMaintenance')
                                    //     .doc(widget.depoName)
                                    //     .collection(widget.yearOption!)
                                    //     .doc(widget.userId)
                                    //     .update({'submission Date':  FieldValue.arrayUnion([tableData]),});
                                  }

                                  // pr.hide();

                                  // // ignore: use_build_context_synchronously
                                  // Navigator.pop(context);
                                  // // ignore: use_build_context_synchronously
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //     backgroundColor: blue,
                                  //     content: Text(
                                  //       'Files are Uploaded',
                                  //       style: TextStyle(color: white),
                                  //     ),
                                  //   ),
                                  // );
                                } else {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('No file selected'),
                                        content: const Text(
                                            'Please select a file to upload'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'OK',
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Text(
                                'Upload file',
                                style: uploadViewStyle,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Back to ${widget.title == 'QualityChecklist' ? 'Quality Checklist' : widget.title}',
                            style: uploadViewStyle,
                          )),
                    ),
                  ),
                  widget.title == 'Depot Insights'
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ViewAllPdf(
                                  title: 'Depot Insights',
                                  cityName: widget.cityName,
                                  depoName: widget.depoName,
                                  userId: widget.userId,
                                  docId: 'DepotImages',
                                );
                              },
                            ));
                          },
                          child: Text('View File', style: uploadViewStyle))
                      : Container()
                ],
              ),
            ),
    );
  }

  Future getAssignedDepots() async {
    assignedCities = await authService.getCityList();
    isFieldEditable = authService.verifyAssignedDepot(
      widget.cityName!,
      assignedCities,
    );
  }
}
