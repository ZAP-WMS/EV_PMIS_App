import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/components/loading_pdf.dart';
import 'package:ev_pmis_app/views/monthlyreport/monthly_project.dart';
import 'package:ev_pmis_app/widgets/admin_custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../../../components/Loading_page.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../widgets/common_pdf_view.dart';

class MonthlySummary extends StatefulWidget {
  final String? userId;
  final String? cityName;
  final String? depoName;
  final String? id;
  String role;

  MonthlySummary(
      {super.key,
      this.userId,
      this.cityName,
      required this.depoName,
      this.id,
      required this.role});
  @override
  State<MonthlySummary> createState() => _MonthlySummaryState();
}

class _MonthlySummaryState extends State<MonthlySummary> {
  bool enableLoading = false;
  String pathToOpenFile = '';

  List<dynamic> temp = [];

  //Daily Project Row List for view summary
  List<List<dynamic>> rowList = [];

  // Daily project available user ID List
  List<dynamic> presentUser = [];

  //All user id list
  List<dynamic> userList = [];

  // Daily Project data entry date list
  List<dynamic> userEntryDate = [];

  // Daily Project data according to entry date
  List<dynamic> dailyProjectData = [];

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  Future<List<List<dynamic>>> fetchData() async {
    await getMonthlyData();
    return rowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: CustomAppBar(
          isProjectManager: widget.role == 'projectManager' ? false : true,
          makeAnEntryPage: MonthlyProject(depoName: widget.depoName),
          toMonthly: true,
          showDepoBar: true,
          cityName: widget.cityName,
          userId: widget.userId,
          depoName: widget.depoName,
          text: 'Monthly Report',
        ),
        preferredSize: const Size.fromHeight(50),
      ),
      body: enableLoading
          ? const LoadingPage()
          : FutureBuilder<List<List<dynamic>>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingPage();
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error fetching data'),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;

                  if (data.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Data Available for Selected Depo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(
                            left: 3.0, right: 3.0, bottom: 5.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DataTable(
                            showBottomBorder: true,
                            sortAscending: true,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[600]!,
                                width: 1.0,
                              ),
                            ),
                            columnSpacing: 20.0,
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue[800]!),
                            headingTextStyle:
                                const TextStyle(color: Colors.white),
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'UserID',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Monthly\nReport',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'PDF\nDownload',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                            rows: data.map(
                              (rowData) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(rowData[0]),
                                    ),
                                    DataCell(Text(rowData[2])),
                                    DataCell(SizedBox(
                                      height: 30,
                                      width: 60,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _generatePDF(
                                              rowData[0], rowData[2], 1);
                                        },
                                        child: const Text(
                                          'View',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    )),
                                    DataCell(
                                      SizedBox(
                                        height: 30,
                                        width: 60,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            downloadPDF(
                                                    rowData[0], rowData[2], 2)
                                                .whenComplete(() {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      actionsAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      actionsPadding:
                                                          const EdgeInsets.only(
                                                              top: 20,
                                                              bottom: 20),
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
                                                              color: Colors
                                                                  .blue[900]!),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            });
                                          },
                                          child: const Icon(Icons.download),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Container();
              },
            ),
    );
  }

  Future<void> getMonthlyData() async {
    rowList.clear();
    QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
        .collection('MonthlyProjectReport2')
        .doc('${widget.depoName}')
        .collection('userId')
        .get();
    List<dynamic> userIdList = querySnapshot1.docs.map((e) => e.id).toList();
    for (int i = 0; i < userIdList.length; i++) {
      QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
          .collection('MonthlyProjectReport2')
          .doc('${widget.depoName}')
          .collection('userId')
          .doc('${userIdList[i]}')
          .collection('Monthly Data')
          .get();

      List<dynamic> monthlyDate = querySnapshot2.docs.map((e) => e.id).toList();
      for (int j = 0; j < monthlyDate.length; j++) {
        rowList.add([userIdList[i], 'PDF', monthlyDate[j]]);
      }
    }
  }

  Future<File> savePDFToFile(Uint8List pdfData, String fileName) async {
    if (await Permission.storage.request().isGranted) {
      final documentDirectory =
          (await DownloadsPath.downloadsDirectory())?.path;
      final file = File('$documentDirectory/$fileName');

      int counter = 1;
      String newFilePath = file.path;
      pathToOpenFile = newFilePath;

      if (await File(newFilePath).exists()) {
        final baseName = fileName.split('.').first;
        final extension = fileName.split('.').last;
        newFilePath =
            '$documentDirectory/$baseName-${counter.toString()}.$extension';
        counter++;
        pathToOpenFile = newFilePath;
        await file.copy(newFilePath);
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

      const fileName = 'Monthly Report.pdf';
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
        0, 'Monthly Report Pdf downloaded', 'Tap to open', notificationDetails,
        payload: pathToOpenFile);
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

    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
    );

    final headerStyle =
        pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold);

    const cellStyle = pw.TextStyle(
      fontSize: 13,
    );

    List<List<dynamic>> allData = [];
    List<dynamic> userData = [];
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('MonthlyProjectReport2')
        .doc('${widget.depoName}')
        .collection('userId')
        .doc(userId)
        .collection('Monthly Data')
        .doc(date)
        .get();

    Map<String, dynamic> docData =
        documentSnapshot.data() as Map<String, dynamic>;
    if (docData.isNotEmpty) {
      userData.addAll(docData['data']);
      for (Map<String, dynamic> mapData in userData) {
        allData.add([
          mapData['ActivityDetails'].toString().trim() == 'null' ||
                  mapData['ActivityDetails'].toString().trim() == 'Null'
              ? ''
              : mapData['ActivityDetails'],
          mapData['Progress'].toString().trim() == 'null' ||
                  mapData['Progress'].toString().trim() == 'Null'
              ? ''
              : mapData['Progress'],
          mapData['Status'].toString().trim() == 'null' ||
                  mapData['Status'].toString().trim() == 'Null'
              ? ''
              : mapData['Status'],
          mapData['Action'].toString().trim() == 'null' ||
                  mapData['Action'].toString().trim() == 'Null'
              ? ''
              : mapData['Action'],
        ]);
      }
    }

    final pdf = pw.Document(pageMode: PdfPageMode.outlines);
    final fontData2 =
        await rootBundle.load('assets/fonts/Montserrat-Medium.ttf');

    pdf.addPage(pw.MultiPage(
        theme: pw.ThemeData.withFont(
          bold: pw.Font.ttf(fontData2),
        ),
        pageFormat: const PdfPageFormat(1300, 900,
            marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
        orientation: pw.PageOrientation.natural,
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        //Header part of PDF
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
                      pw.Text('Monthly Report',
                          textScaleFactor: 2,
                          style: const pw.TextStyle(color: PdfColors.blue700)),
                      pw.Container(
                        width: 100,
                        height: 100,
                        child: pw.Image(profileImage),
                      ),
                    ]),
              ]));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  // 'Page ${context.pageNumber} of ${context.pagesCount}',
                  'User ID - $userId',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.black)));
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
                            style: pw.TextStyle(
                                color: PdfColors.black, fontSize: 17)),
                        pw.TextSpan(
                            text: '${widget.cityName} / ${widget.depoName}',
                            style: const pw.TextStyle(
                                color: PdfColors.blue700, fontSize: 15))
                      ])),
                      pw.RichText(
                          text: pw.TextSpan(children: [
                        const pw.TextSpan(
                            text: 'Month : ',
                            style: pw.TextStyle(
                                color: PdfColors.black, fontSize: 17)),
                        pw.TextSpan(
                            text: date,
                            style: const pw.TextStyle(
                                color: PdfColors.blue700, fontSize: 15))
                      ])),
                      pw.RichText(
                          text: pw.TextSpan(children: [
                        const pw.TextSpan(
                            text: 'UserID : ',
                            style: pw.TextStyle(
                                color: PdfColors.black, fontSize: 15)),
                        pw.TextSpan(
                            text: userId,
                            style: const pw.TextStyle(
                                color: PdfColors.blue700, fontSize: 15))
                      ])),
                    ]),
                pw.SizedBox(height: 20)
              ]),
              pw.Table.fromTextArray(
                columnWidths: {
                  0: const pw.FixedColumnWidth(250),
                  1: const pw.FixedColumnWidth(250),
                  2: const pw.FixedColumnWidth(250),
                  3: const pw.FixedColumnWidth(250),
                },
                headers: [
                  'Activity Details',
                  'Progress',
                  'Status',
                  'Next Month Action Plan'
                ],
                headerStyle: headerStyle,
                headerHeight: 30,
                cellHeight: 20,
                cellStyle: cellStyle,
                context: context,
                data: allData,
              ),
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
            ]));

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
                    pageName: 'Monthly Report',
                  )));
    }

    return pdfData;
  }
}
