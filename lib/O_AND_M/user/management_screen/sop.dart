import 'dart:io';
import 'package:dio/dio.dart' as dioLib;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../../../PMIS/provider/pdf_controller.dart';
import '../../../PMIS/widgets/custom_appbar.dart';
import '../../../style.dart';

// Your ImagePickerController or any other controller managing state
class PdfPickerController extends GetxController {
  // Create an observable list of files (or paths)
  var pickedImagePath =
      <String>[].obs; // You can change this to a list of File if needed.

  // Method to pick PDF file and update pickedImagePath
  void addPickedFile(String path) {
    pickedImagePath.add(path);
  }

  // You can also implement a remove method if needed
  void removePickedFile(String path) {
    pickedImagePath.remove(path);
  }
}

class SopScreen extends StatefulWidget {
  String? depoName;
  final String? role;
  final String? userId;
  final String? roleCentre;

  SopScreen(
      {super.key, this.depoName, this.role, this.userId, this.roleCentre});

  @override
  State<SopScreen> createState() => _SopScreenState();
}

class _SopScreenState extends State<SopScreen> {
  PdfController pdfController = PdfController();
  String pathToOpenFile = '';

  @override
  void initState() {
    print(widget.depoName);
    super.initState();
    imagePickerController.pickedImagePath.clear();
    fileNames.clear();
    pdfController = Get.put(PdfController());
  }

  List<String> fileNames = []; // List to store only file names
  final PdfPickerController imagePickerController =
      Get.put(PdfPickerController()); // Make sure to initialize the controller

  // Method to pick PDF files
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['pdf'] // Only allow PDF files
        );

    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        // Handle each selected file
        imagePickerController.addPickedFile(file.path.toString());

        fileNames = imagePickerController.pickedImagePath
            .map((filePath) => filePath.split('/').last)
            .toList();
        print(file.path);
      }
    }
  }

  Future<void> uploadFiles() async {
    for (String filepath in imagePickerController.pickedImagePath) {
      File file = File(filepath);

      // Ensure that the file is a PDF
      if (file.existsSync() && file.path.endsWith('.pdf')) {
        // You might want to generate a unique filename based on the file or a timestamp
        String fileName = file.path.split('/').last;

        try {
          // Upload the PDF file to Firebase Storage
          await FirebaseStorage.instance
              .ref(
                  'Sop Checklist/$fileName') // Folder structure in Firebase Storage
              .putFile(file);
          pdfController.fetchPdfUrls();
          print('File uploaded successfully');
        } catch (e) {
          print('Error uploading file: $e');
        }
      } else {
        print('The file is not a PDF or does not exist: $filepath');
      }
    }
  }

  Future<File> savePDFToFile(Uint8List pdfData, String fileName) async {
    final documentDirectory = (await DownloadsPath.downloadsDirectory())?.path;
    File file = File('$documentDirectory/$fileName');

    int counter = 1;
    String newFilePath = file.path;
    pathToOpenFile = newFilePath;

    while (await file.exists()) {
      String newName =
          '${fileName.substring(0, fileName.lastIndexOf('.'))}-$counter${fileName.substring(fileName.lastIndexOf('.'))}';
      file = File('$documentDirectory/$newName');
      pathToOpenFile = file.path;
      counter++;
    }
    await file.writeAsBytes(pdfData);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    pdfController = Get.put(PdfController());
    final pr = ProgressDialog(context);
    return Scaffold(
      appBar: CustomAppBar(
        depoName: '${widget.depoName}',
        title: 'SOP Report',
        height: 50,
        isSync: false,
        isCentered: false,
      ),
      body: Column(
        children: [
          widget.role == 'Admin' || widget.role == 'projectManager'
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: pickFile, // Trigger file picker
                          child: Text(
                            'Pick file',
                            style: uploadViewStyle,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            uploadFiles();
                          },
                          child: Text(
                            'Upload',
                            style: uploadViewStyle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() {
                          if (imagePickerController
                              .pickedImagePath.isNotEmpty) {
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.0,
                              ),
                              shrinkWrap: true,
                              itemCount:
                                  imagePickerController.pickedImagePath.length,
                              itemBuilder: (context, index) {
                                final filePath = imagePickerController
                                    .pickedImagePath[index];

                                return Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: blue),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Image.asset(
                                          'assets/pdf_logo.jpeg', // Display a PDF logo for now
                                          height: 50,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Expanded(
                                          child: Text(
                                        fileNames[index],
                                        textAlign: TextAlign.center,
                                      ))
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.02),
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
                  ],
                )
              : Container(),
          Obx(() {
            if (pdfController.pdfUrls.isEmpty) {
              return const Center(
                  child: Text("No files available",
                      style: TextStyle(fontSize: 18, color: Colors.grey)));
            } else if (pdfController.pdfUrls.isNotEmpty &&
                pdfController.pdfUrls.value == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: pdfController.pdfNames.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors
                                  .white, // Set background color (optional)
                              borderRadius: BorderRadius.circular(
                                  10), // Optional rounded corners
                              border: Border.all(
                                color: Colors.grey, // Border color
                                width: 1, // Border width
                              )),
                          child: ListTile(
                            title: Text(
                              pdfController.pdfNames[index],
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            trailing: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Ensures that the icons don't take up extra space
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.download, color: blue),
                                    onPressed: () async {
                                      downloadFile(pdfController.pdfUrls[index],
                                          pdfController.pdfNames[index]);
                                    },
                                  ),
                                  widget.role == 'Admin' ||
                                          widget.role == 'projectManager'
                                      ? IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () async {
                                            // Call the remove function when the delete icon is pressed
                                            await _removeFile(
                                                pdfController.pdfUrls[index]);
                                            Get.snackbar("File Removed",
                                                "${pdfController.pdfNames[index]} has been removed",
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor: red,
                                                colorText: white);
                                          },
                                        )
                                      : Container()
                                ]),
                            onTap: () async {
                              final url = pdfController.pdfNames[index];
                              // if (await canLaunch(url)) {
                              //   await launch(url);
                              // } else {
                              //   print('Could not launch the URL');
                              // }
                            },
                          ),
                        ),
                      );
                    }),
              );
            }
          })
        ],
      ),
    );
  }

  Future<void> _removeFile(String fileUrl) async {
    try {
      // Extract the file path from the URL (the part after 'firebasestorage.com/o/')
      final refPath = Uri.parse(fileUrl).pathSegments.last;
      final storageRef = FirebaseStorage.instance.ref(refPath);

      // Delete the file from Firebase Storage
      await storageRef.delete();
      pdfController.fetchPdfUrls();
    } catch (e) {
      print("Error removing file: $e");
    }
  }

  Future<void> downloadFile(String fileUrl, String fileName) async {
    try {
      print(fileUrl);
      final pr = ProgressDialog(context);

      // Get the app's document directory to save the file
      var dir = await getApplicationDocumentsDirectory();
      String savePath = '${dir.path}/$fileName';

      // Initialize Dio with the new alias 'dioLib'
      dioLib.Dio dioInstance = dioLib.Dio(); // Use dioLib for Dio instance

      // Start downloading the file and save it to the specified path
      dioLib.Response response = await dioInstance.download(fileUrl, savePath);

      // Assuming response is the downloaded data. This part is important if you need to process or save the data as PDF.
      final savedPDFFile =
          File(savePath); // Create a File object using the save path.

      // Hide the progress indicator (if any is being shown)
      await pr.hide();

      // Set up notification details
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
              'repeating channel id', 'repeating channel name',
              channelDescription: 'repeating description');
      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      // Show the notification with the file path as payload
      await FlutterLocalNotificationsPlugin().show(
          0, '$fileName ', 'Tap to open', notificationDetails,
          payload: savedPDFFile.path);

      // Notify the user that the file has been downloaded
      Get.snackbar(
        "Download Successful",
        "File has been saved to your device.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Handle errors during the download
      print("Download Error: $e");
      Get.snackbar(
        "Download Failed",
        "Error: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
