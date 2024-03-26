import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/provider/cities_provider.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/widgets/admin_custom_appbar.dart';
import 'package:ev_pmis_app/widgets/common_pdf_view.dart';
import 'package:ev_pmis_app/widgets/nodata_available.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import '../../../../components/Loading_page.dart';
import '../../../../components/loading_pdf.dart';

class CivilReportAdmin extends StatefulWidget {
  final String? userId;
  String? cityName;
  final String? depoName;
  int? selectedIndex;
  CivilReportAdmin(
      {super.key,
      this.userId,
      required this.depoName,
      required this.cityName,
      this.selectedIndex});

  @override
  State<CivilReportAdmin> createState() => _CivilReportAdminState();
}

class _CivilReportAdminState extends State<CivilReportAdmin> {
  String pathTpoOpenFile = '';
  List<String> completeTabForCivil = [
    'Excavation',
    'BackFilling',
    'Brick / Block Massonary',
    'Doors, Windows, Hardware & Glazing',
    'False Ceiling',
    'Flooring & Tiling',
    'Grouting Inspection',
    'Ironite / Ips Flooring',
    'Painting',
    'Interlock Paving Work',
    'Wall Cladding & Roofing',
    'Water Proofing'
  ];

  List<String> tabForCivil = [
    'Exc',
    'BackFilling',
    'Massonary',
    'Glazzing',
    'Ceilling',
    'Flooring',
    'Inspection',
    'Ironite',
    'Painting',
    'Paving',
    'Roofing',
    'Proofing'
  ];

  final ReceivePort _port = ReceivePort();

  //Daily Project Row List for view summary
  List<List<dynamic>> rowList = [];
  String cityName = '';

  Future<List<List<dynamic>>> fetchData() async {
    await getRowsForFutureBuilder();
    return rowList;
  }

  @override
  void initState() {
    super.initState();
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            isProjectManager: false,
            depoName: widget.depoName,
            toSafety: true,
            showDepoBar: true,
            cityName: cityName,
            text: 'Quality Checklist',
            userId: widget.userId,
          )),
      body: FutureBuilder<List<List<dynamic>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;

            if (data.isEmpty) {
              return const NodataAvailable();
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DataTable(
                        columnSpacing: 20,
                        showBottomBorder: true,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[600]!,
                            width: 1.0,
                          ),
                        ),
                        headingRowColor:
                            MaterialStateColor.resolveWith((states) => white),
                        headingTextStyle: TextStyle(color: blue),
                        columns: const [
                          DataColumn(
                              label: Text(
                            'UserID',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          )),
                          DataColumn(
                              label: Text('Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ))),
                          DataColumn(
                              label: Text('Safety\nReport',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ))),
                          DataColumn(
                              label: Text('PDF\nDownload',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ))),
                        ],
                        rows: data.map(
                          (rowData) {
                            return DataRow(
                              cells: [
                                DataCell(Text(
                                  rowData[0],
                                  style: const TextStyle(fontSize: 12),
                                )),
                                DataCell(Text(rowData[2],
                                    style: const TextStyle(fontSize: 12))),
                                DataCell(ElevatedButton(
                                  onPressed: () {
                                    _generatePDF(rowData[0], rowData[2], 1);
                                  },
                                  child: const Text(
                                    'View',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                                DataCell(ElevatedButton(
                                  onPressed: () {
                                    downloadPDF(rowData[0], rowData[2], 0)
                                        .whenComplete(() {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              actionsAlignment:
                                                  MainAxisAlignment.center,
                                              actionsPadding:
                                                  const EdgeInsets.only(
                                                      top: 20, bottom: 20),
                                              actions: [
                                                const Image(
                                                  image: AssetImage(
                                                      'assets/downloaded_logo.png'),
                                                  height: 40,
                                                  width: 40,
                                                ),
                                                Text(
                                                  'Pdf Downloaded',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.blue[900]!),
                                                )
                                              ],
                                            );
                                          });
                                    });
                                    // _generatePDF(rowData[0], rowData[2], 2);
                                  },
                                  child: const Icon(Icons.download),
                                )),
                              ],
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  Future<void> getRowsForFutureBuilder() async {
    rowList.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc('${widget.depoName}')
        .collection('userId')
        .get();

    List<dynamic> userIdList = querySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < userIdList.length; i++) {
      QuerySnapshot userEntryDate = await FirebaseFirestore.instance
          .collection('CivilQualityChecklist')
          .doc('${widget.depoName}')
          .collection('userId')
          .doc(userIdList[i])
          .collection(tabForCivil[widget.selectedIndex!])
          .get();

      List<dynamic> withDateData = userEntryDate.docs.map((e) => e.id).toList();

      for (int j = 0; j < withDateData.length; j++) {
        rowList.add([userIdList[i], 'PDF', withDateData[j]]);
      }
    }
    print(rowList);
  }

  Future<File> savePDFToFile(Uint8List pdfData, String fileName) async {
    if (await Permission.storage.request().isGranted) {
      final documentDirectory =
          (await DownloadsPath.downloadsDirectory())?.path;
      final file = File('$documentDirectory/$fileName');

      int counter = 1;
      String newFilePath = file.path;
      pathTpoOpenFile = newFilePath;

      if (await File(newFilePath).exists()) {
        final baseName = fileName.split('.').first;
        final extension = fileName.split('.').last;
        newFilePath =
            '$documentDirectory/$baseName-${counter.toString()}.$extension';
        counter++;

        await file.copy(newFilePath);
        pathTpoOpenFile = newFilePath;
        counter++;
      } else {
        await file.writeAsBytes(pdfData);
        return file;
      }
    }
    return File('');
  }

  Future<void> downloadPDF(String userId, String date, int decision) async {
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
              color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
          messageTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w600));

      pr.show();

      final pdfData = await _generatePDF(userId, date, decision);

      await pr.hide();

      var fileName = 'Civil_Checklist_$userId.pdf';
      final savedPDFFile = await savePDFToFile(pdfData, fileName);
      print('File Created - ${savedPDFFile.path}');
    }
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'repeating channel id', 'repeating channel name',
            channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await FlutterLocalNotificationsPlugin().show(
        0, 'Civil Quality Pdf Downloaded', 'Tap to open', notificationDetails,
        payload: pathTpoOpenFile);
  }

  Future<Uint8List> _generatePDF(
      String userId, String date, int decision) async {
    final pr = ProgressDialog(context);

    if (decision == 1) {
      pr.style(
          progressWidgetAlignment: Alignment.center,
          message: 'Preparing Pdf View..',
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
    }

    final headerStyle =
        pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold);

    final fontData1 =
        await rootBundle.load('assets/fonts/Montserrat-Medium.ttf');
    final fontData2 = await rootBundle.load('assets/fonts/Montserrat-Bold.ttf');

    const cellStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 14,
    );

    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
    );

    //Getting safety Field Data from firestore

    DocumentSnapshot civilFieldDocSnapshot = await FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc('${widget.depoName}')
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[widget.selectedIndex!])
        .doc(date)
        .get();

    Map<String, dynamic> civilMapData = {};
    if (civilFieldDocSnapshot.exists) {
      civilMapData = civilFieldDocSnapshot.data() as Map<String, dynamic>;
    }

    List<List<dynamic>> fieldData = [
      ['Project :', '${civilMapData['projectName'] ?? ''}'],
      ['Date :', '${civilMapData['date'] ?? ''}'],
      ['Location :', '${civilMapData['location'] ?? ''}'],
      ['Component of structure : ', '${civilMapData['componentName'] ?? ''}'],
      ['Vendor / Sub Vendor :', '${civilMapData['vendor'] ?? ''}'],
      ['Grid / Axis & Level :', '${civilMapData['grid'] ?? ''}'],
      ['Drawing Number :', '${civilMapData['drawing'] ?? ''}'],
      ['Type of Filling :', '${civilMapData['filling'] ?? ''}'],
    ];

    List<pw.TableRow> rows = [];

    rows.add(pw.TableRow(children: [
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Sr No',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding:
              const pw.EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
          child: pw.Center(
              child: pw.Text('Activity',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Responsibility',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Reference',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Observation',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Image6',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Image7',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Image8',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
    ]));

    List<dynamic> userData = [];

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc('${widget.depoName}')
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[widget.selectedIndex!])
        .doc(date)
        .get();

    Map<String, dynamic> docData =
        documentSnapshot.data() as Map<String, dynamic>;
    if (docData.isNotEmpty) {
      userData.addAll(docData['data']);

      List<pw.Widget> imageUrls = [];

      for (Map<String, dynamic> mapData in userData) {
        String imagesPath =
            'QualityChecklist/civil_Engineer/$cityName/${widget.depoName}/$userId/${tabForCivil[widget.selectedIndex!]} Table/$date/${mapData['srNo']}';

        ListResult result =
            await FirebaseStorage.instance.ref().child(imagesPath).listAll();

        if (result.items.isNotEmpty) {
          for (var image in result.items) {
            String downloadUrl = await image.getDownloadURL();
            if (image.name.endsWith('.pdf')) {
              imageUrls.add(
                pw.Container(
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 100,
                    child: pw.UrlLink(
                        child: pw.Text(image.name), destination: downloadUrl)),
              );
            } else {
              final myImage = await networkImage(downloadUrl);
              imageUrls.add(
                pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 100,
                    height: 100,
                    child: pw.Center(
                      child: pw.Image(myImage),
                    )),
              );
            }
          }
          if (imageUrls.length < 8) {
            int imageLoop = 8 - imageUrls.length;
            for (int i = 0; i < imageLoop; i++) {
              imageUrls.add(
                pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 100,
                    child: pw.Text('')),
              );
            }
          }
        }
        result.items.clear();

        //Text Rows of PDF Table
        rows.add(pw.TableRow(children: [
          pw.Container(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Center(
                  child: pw.Text(mapData['srNo'].toString(),
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['checklist'],
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['responsibility'],
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['reference'].toString(),
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['observation'].toString(),
                      style: const pw.TextStyle(fontSize: 14)))),
        ]));

        if (imageUrls.isNotEmpty) {
          //Image Rows of PDF Table
          rows.add(pw.TableRow(children: [
            pw.Container(
                padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: pw.Text('')),
            pw.Container(
                padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                width: 60,
                height: 100,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      imageUrls[0],
                      imageUrls[1],
                    ])),
            imageUrls[2],
            imageUrls[3],
            imageUrls[4],
            imageUrls[5],
            imageUrls[6],
            imageUrls[7]
          ]));
        }
        imageUrls.clear();
      }
    }

    final pdf = pw.Document(
      pageMode: PdfPageMode.outlines,
    );

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
            base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
        pageFormat: const PdfPageFormat(1300, 900,
            marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
        orientation: pw.PageOrientation.natural,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child: pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                          'Civil Quality Report / ${completeTabForCivil[widget.selectedIndex!]} Table',
                          textScaleFactor: 2,
                          style: const pw.TextStyle(color: PdfColors.blue700)),
                      pw.SizedBox(width: 20),
                      pw.Container(
                        width: 120,
                        height: 120,
                        child: pw.Image(profileImage),
                      ),
                    ]),
              ]));
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.RichText(
                text: pw.TextSpan(children: [
              const pw.TextSpan(
                  text: 'UserId : ',
                  style: pw.TextStyle(color: PdfColors.black, fontSize: 17)),
              pw.TextSpan(
                  text: userId,
                  style: const pw.TextStyle(
                      color: PdfColors.blue700, fontSize: 15))
            ])),
          );
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    const pw.TextSpan(
                        text: 'Place : ',
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 17)),
                    pw.TextSpan(
                        text: '$cityName / ${widget.depoName}',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    const pw.TextSpan(
                        text: 'Date : ',
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 17)),
                    pw.TextSpan(
                        text: date,
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    pw.TextSpan(
                        text: 'UserID : $userId',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15)),
                  ])),
                ]),
            pw.SizedBox(height: 20)
          ]),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FixedColumnWidth(100),
              1: const pw.FixedColumnWidth(100),
            },
            headers: ['Details', 'Values'],
            headerStyle: headerStyle,
            headerPadding: const pw.EdgeInsets.all(10.0),
            data: fieldData,
            cellHeight: 35,
            cellStyle: cellStyle,
          )
        ],
      ),
    );

    //First Half Page

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
            base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
        pageFormat: const PdfPageFormat(1300, 900,
            marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
        orientation: pw.PageOrientation.natural,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child: pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                          'Civil Quality Report / ${completeTabForCivil[widget.selectedIndex!]} Table',
                          textScaleFactor: 2,
                          style: const pw.TextStyle(color: PdfColors.blue700)),
                      pw.Container(
                        width: 120,
                        height: 120,
                        child: pw.Image(profileImage),
                      ),
                    ]),
              ]));
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.RichText(
                text: pw.TextSpan(children: [
              const pw.TextSpan(
                  text: 'UserId : ',
                  style: pw.TextStyle(color: PdfColors.black, fontSize: 17)),
              pw.TextSpan(
                  text: userId,
                  style: const pw.TextStyle(
                      color: PdfColors.blue700, fontSize: 15))
            ])),
          );
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    const pw.TextSpan(
                        text: 'Place : ',
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 17)),
                    pw.TextSpan(
                        text: '$cityName / ${widget.depoName}',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    const pw.TextSpan(
                        text: 'Date : ',
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 17)),
                    pw.TextSpan(
                        text: date,
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
                  ])),
                ]),
            pw.SizedBox(height: 20)
          ]),
          pw.SizedBox(height: 10),
          pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FixedColumnWidth(160),
                2: const pw.FixedColumnWidth(70),
                3: const pw.FixedColumnWidth(70),
                4: const pw.FixedColumnWidth(70),
                5: const pw.FixedColumnWidth(70),
                6: const pw.FixedColumnWidth(70),
                7: const pw.FixedColumnWidth(70),
              },
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              tableWidth: pw.TableWidth.max,
              border: pw.TableBorder.all(),
              children: rows)
        ],
      ),
    );

    if (decision == 1) {
      pr.hide();
    }

    final Uint8List pdfData = await pdf.save();

    if (decision == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PdfViewScreen(
                    getContext: context,
                    pdfData: pdfData,
                    pageName: 'Civil Checklist Report',
                  )));
    }

    return pdfData;
  }
}
