import 'dart:io';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/components/loading_pdf.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:ev_pmis_app/widgets/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../style.dart';
import '../views/controller/upload_image_controller.dart';
import '../views/overviewpage/view_AllFiles.dart';
import 'custom_appbar.dart';

// ignore: must_be_immutable
class UploadDocument extends StatefulWidget {
  String? title;
  String? subtitle;
  String? cityName;
  String? depoName;
  dynamic userId;
  String? fldrName;
  String? date;
  int? srNo;
  String? role;

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
    this.role,
  });

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
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
                              onPressed: isFieldEditable == false
                                  ? null
                                  : () async {
                                      showPickerOptions(widget.title!);
                                      // result =
                                      //     await FilePicker.platform.pickFiles(
                                      //   withData: true,
                                      //   type: FileType.any,
                                      //   allowMultiple: false,

                                      //   // allowedExtensions: ['pdf']
                                      // );
                                      // if (result == null) {
                                      // } else {
                                      //   setState(() {});
                                      //   result?.files.forEach((element) {
                                      //     print(element.name);
                                      //   });
                                      // }
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
                              onPressed: isFieldEditable == false
                                  ? null
                                  : () async {
                                      if (imagePickerController
                                          .pickedImagePath.isNotEmpty) {
                                        final pr = ProgressDialog(context);
                                        pr.style(
                                          progressWidgetAlignment:
                                              Alignment.center,
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

                                        for (String imagePath
                                            in imagePickerController
                                                .pickedImagePath) {
                                          // Read the file as bytes
                                          File imageFile = File(imagePath);
                                          Uint8List fileBytes =
                                              await imageFile.readAsBytes();

                                          String imageName =
                                              imagePath.split('/').last;

                                          String refname = ((widget.title ==
                                                      "DetailedEngRFC" ||
                                                  widget.title ==
                                                      "DetailedEngShed" ||
                                                  widget.title ==
                                                      "DetailedEngEV")
                                              ? '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.date}/$imageName'
                                              : widget.title ==
                                                      'QualityChecklist'
                                                  ? '${widget.title}/${widget.subtitle}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.fldrName}/${widget.date}/${widget.srNo}/$imageName'
                                                  : widget.title ==
                                                          'ClosureReport'
                                                      ? '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.fldrName}/$imageName'
                                                      : widget.title ==
                                                              'KeyEvents'
                                                          ? '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.fldrName!}/$imageName'
                                                          : widget.title ==
                                                                  'Depot Insights'
                                                              ? '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.fldrName}/$imageName'
                                                              : '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.date}/${widget.fldrName}/$imageName');

                                          // String? fileName = result!.files.first.name;

                                          await FirebaseStorage.instance
                                              .ref(refname)
                                              .putData(
                                                fileBytes,
                                              );
                                        }

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
                                              style: TextStyle(color: white),
                                            ),
                                          ),
                                        );
                                      } else {
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'No file selected'),
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
