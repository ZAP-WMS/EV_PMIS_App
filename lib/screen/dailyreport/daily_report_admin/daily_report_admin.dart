import 'dart:io';
import 'dart:typed_data';
import 'package:ev_pmis_app/provider/summary_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/components/loading_pdf.dart';
import 'package:ev_pmis_app/datasource_admin/dailyproject_datasource.dart';
import 'package:ev_pmis_app/model_admin/daily_projectModel.dart';
import 'package:ev_pmis_app/screen/dailyreport/daily_report_user/daily_project.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:ev_pmis_app/widgets/admin_custom_appbar.dart';
import 'package:ev_pmis_app/widgets/nodata_available.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../views/dailyreport/summary.dart';
import '../../../widgets/navbar.dart';

List<int> globalRowIndex = [];

class DailyProjectAdmin extends StatefulWidget {
  String? userId;
  String? cityName;
  String? depoName;
  String role;

  DailyProjectAdmin(
      {super.key,
      this.userId,
      this.cityName,
      required this.depoName,
      required this.role});

  @override
  State<DailyProjectAdmin> createState() => _DailyProjectAdminState();
}

class _DailyProjectAdminState extends State<DailyProjectAdmin> {
  ProgressDialog? pr;
  String pathToOpenFile = '';
  Uint8List? pdfData;
  String? pdfPath;

  DateTime? startdate = DateTime.now();
  DateTime? enddate = DateTime.now();
  DateTime? rangestartDate;
  DateTime? rangeEndDate;
  List<DailyProjectModelAdmin> dailyProject = <DailyProjectModelAdmin>[];
  late DailyDataSource _dailyDataSource;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  bool _isLoading = true;
  bool specificUser = true;
  QuerySnapshot? snap;
  dynamic companyId;
  // dynamic alldata;
  List id = [];

  @override
  void initState() {
    pr = ProgressDialog(context,
        customBody:
            Container(height: 200, width: 100, child: const LoadingPdf()));

    getUserId();
    identifyUser();
    _dailyDataSource = DailyDataSource(
        dailyProject, context, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();
    super.initState();
    getAllData();
  }

  getAllData() {
    dailyProject.clear();
    id.clear();
    getTableData().whenComplete(
      () {
        nestedTableData(id, context).whenComplete(
          () {
            _dailyDataSource = DailyDataSource(
                dailyProject, context, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();
            _isLoading = false;
            setState(() {});
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavbarDrawer(role: widget.role),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          isProjectManager: widget.role == "projectManager" ? true : false,
          makeAnEntryPage: DailyProject(
            cityName: widget.cityName,
            role: widget.role,
            depoName: widget.depoName,
          ),
          showDepoBar: true,
          toDaily: true,
          depoName: widget.depoName,
          cityName: widget.cityName,
          text: ' Daily Report',
          userId: widget.userId,
          haveSynced: false,
          //specificUser ? true : false,
          isdownload: true,
          downloadFun: downloadPDF,
          haveSummary: false,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewSummary(
                cityName: widget.cityName.toString(),
                depoName: widget.depoName.toString(),
                id: 'Daily Report',
                userId: widget.userId,
              ),
            ),
          ),
          store: () {
            storeData();
          },
        ),
      ),
      body: _isLoading
          ? const LoadingPage()
          : Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.99,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 180,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: blue)),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('choose Date'),
                                        content: SizedBox(
                                          width: 400,
                                          height: 500,
                                          child: SfDateRangePicker(
                                            view: DateRangePickerView.year,
                                            showTodayButton: false,
                                            showActionButtons: true,
                                            selectionMode:
                                                DateRangePickerSelectionMode
                                                    .range,
                                            onSelectionChanged:
                                                (DateRangePickerSelectionChangedArgs
                                                    args) {
                                              if (args.value
                                                  is PickerDateRange) {
                                                rangestartDate =
                                                    args.value.startDate;
                                                rangeEndDate =
                                                    args.value.endDate;
                                              }
                                            },
                                            onSubmit: (value) {
                                              setState(() {
                                                startdate = DateTime.parse(
                                                    rangestartDate.toString());
                                                enddate = DateTime.parse(
                                                    rangeEndDate.toString());
                                              });

                                              getAllData();
                                              Navigator.pop(context);
                                            },
                                            onCancel: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.today,
                                  ),
                                ),
                                Text(
                                  DateFormat.yMMMMd().format(
                                    startdate!,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        width: 160,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: blue)),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  DateFormat.yMMMMd().format(enddate!),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingPage();
                    } else if (!snapshot.hasData ||
                        snapshot.data.exists == false) {
                      return Column(
                        children: [
                          Expanded(
                            child: SfDataGridTheme(
                              data: SfDataGridThemeData(
                                  gridLineColor: blue,
                                  gridLineStrokeWidth: 2,
                                  frozenPaneLineColor: blue,
                                  frozenPaneLineWidth: 2),
                              child: SfDataGrid(
                                  source: _dailyDataSource,
                                  allowEditing: true,
                                  frozenColumnsCount: 1,
                                  gridLinesVisibility: GridLinesVisibility.both,
                                  headerGridLinesVisibility:
                                      GridLinesVisibility.both,
                                  selectionMode: SelectionMode.single,
                                  navigationMode: GridNavigationMode.cell,
                                  columnWidthMode: ColumnWidthMode.auto,
                                  editingGestureType: EditingGestureType.tap,
                                  controller: _dataGridController,
                                  columns: [
                                    GridColumn(
                                      columnName: 'Date',
                                      visible: true,
                                      allowEditing: true,
                                      width: 150,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Date',
                                            overflow: TextOverflow.values.first,
                                            textAlign: TextAlign.center,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'SiNo',
                                      visible: false,
                                      allowEditing: true,
                                      width: 70,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('SI No.',
                                            overflow: TextOverflow.values.first,
                                            textAlign: TextAlign.center,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'TypeOfActivity',
                                      allowEditing: true,
                                      width: 200,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Type of Activity',
                                            overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ActivityDetails',
                                      allowEditing: true,
                                      width: 220,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Activity Details',
                                            overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Progress',
                                      allowEditing: true,
                                      width: 320,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Progress',
                                            overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Status',
                                      allowEditing: true,
                                      width: 320,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Remark / Status',
                                            overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'View',
                                      allowEditing: false,
                                      width: 140,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('View Image',
                                            overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      );
                    } else {
                      print(_dailyDataSource.rows[0].getCells().length);
                      return const NodataAvailable();
                    }
                  },
                ),
              )
            ]),
    );
  }

  void storeData() {
    Map<String, dynamic> table_data = Map();
    for (var i in _dailyDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button') {
          table_data[data.columnName] = data.value;
        }
      }

      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('DailyProject3')
        .doc('${widget.depoName}')
        .collection(DateFormat.yMMMMd().format(DateTime.now()))
        .doc(widget.userId)
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      tabledata2.clear();
      // Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      companyId = value;
    });
  }

  identifyUser() async {
    snap = await FirebaseFirestore.instance.collection('Admin').get();

    for (int i = 0; i < snap!.docs.length; i++) {
      if (snap!.docs[i]['Employee Id'] == companyId &&
          snap!.docs[i]['CompanyName'] == 'TATA MOTOR') {
        setState(() {
          specificUser = false;
        });
      }
    }
  }

  Future getTableData() async {
    await FirebaseFirestore.instance
        .collection('DailyProject3')
        .doc(widget.depoName!)
        .collection(DateFormat.yMMMMd().format(DateTime.now(),),)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        String documentId = element.id;
        id.add(documentId);
        // nestedTableData(docss);
      });
    });
  }

  Future<void> nestedTableData(docss, BuildContext pageContext) async {
    final pr = ProgressDialog(pageContext);
    pr.style(
        progressWidgetAlignment: Alignment.center,
        message: 'Loading Data....',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const LoadingPdf(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        maxProgress: 100.0,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600));

    await pr.show();

    for (int i = 0; i < docss.length; i++) {
      for (DateTime initialdate = startdate!;
          initialdate.isBefore(enddate!.add(const Duration(days: 1)));
          initialdate = initialdate.add(const Duration(days: 1))) {
        String temp = DateFormat.yMMMMd().format(initialdate);
        await FirebaseFirestore.instance
            .collection('DailyProject3')
            .doc(widget.depoName!)
            .collection(temp)
            .doc(docss[i])
            .get()
            .then((value) {
          if (value.data() != null) {
            for (int j = 0; j < value.data()!['data'].length; j++) {
              globalRowIndex.add(i + 1);
              globalItemLengthList.add(0);
              dailyProject.add(
                  DailyProjectModelAdmin.fromjson(value.data()!['data'][j]));
            }
          }
        });
      }
    }
    pr.hide();
  }

  Future<void> downloadPDF() async {
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
          color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
    );

    await pr.show();

    final pdfData = await _generateDailyPDF();

    String fileName = 'Daily Report';

    final savedPDFFile = await savePDFToFile(pdfData, fileName);

    await pr.hide();

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'repeating channel id', 'repeating channel name',
            channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await FlutterLocalNotificationsPlugin().show(
        0, 'Pdf Downloaded', 'Tap to open', notificationDetails,
        payload: pathToOpenFile);
  }

  Future<File> savePDFToFile(Uint8List pdfData, String fileName) async {
    
      final documentDirectory =
          (await DownloadsPath.downloadsDirectory())?.path;
      final file = File('$documentDirectory/$fileName');

      int counter = 1;
      String newFilePath = file.path;
      pathToOpenFile = newFilePath.toString();
      if (await File(newFilePath).exists()) {
        final baseName = fileName.split('.').first;
        final extension = fileName.split('.').last;
        newFilePath =
            '$documentDirectory/$baseName-${counter.toString()}.$extension';
        counter++;
        pathToOpenFile = newFilePath.toString();
        await file.copy(newFilePath);
        counter++;
      } else {
        await file.writeAsBytes(pdfData);
        return file;
      }
      return File('');
    
  }

  Future<Uint8List> _generateDailyPDF() async {
    print('generating daily pdf');
    pr!.style(
      progressWidgetAlignment: Alignment.center,
      // message: 'Loading Data....',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: const LoadingPdf(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      maxProgress: 100.0,
      progressTextStyle: const TextStyle(
          color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
      messageTextStyle: const TextStyle(
          color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
    );

    final summaryProvider =
        Provider.of<SummaryProvider>(context, listen: false);

    final headerStyle =
        pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);

    final fontData1 =
        await rootBundle.load('assets/fonts/Montserrat-Medium.ttf');
    final fontData2 = await rootBundle.load('assets/fonts/Montserrat-Bold.ttf');

    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
    );

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
              child: pw.Text('Date',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Type of Activity',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Activity Details',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Progress',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Remark / Status',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Image1',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Image2',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
    ]));

    List<pw.Widget> imageUrls = [];

    for (int i = 0; i < dailyProject.length; i++) {
      String imagesPath =
          '/Daily Report/${widget.cityName}/${widget.depoName}/${widget.userId}/${dailyProject[i].date}/${globalRowIndex[i]}';

      ListResult result =
          await FirebaseStorage.instance.ref().child(imagesPath).listAll();

      if (result.items.isNotEmpty) {
        for (var image in result.items) {
          String downloadUrl = await image.getDownloadURL();
          if (image.name.endsWith('.pdf')) {
            imageUrls.add(
              pw.Container(
                  width: 60,
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: pw.UrlLink(
                      child: pw.Text(image.name,
                          style: const pw.TextStyle(color: PdfColors.blue)),
                      destination: downloadUrl)),
            );
          } else {
            final myImage = await networkImage(downloadUrl);
            imageUrls.add(
              pw.Container(
                  padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                  width: 60,
                  height: 80,
                  child: pw.Center(
                    child: pw.Image(myImage),
                  )),
            );
          }
        }

        if (imageUrls.length < 2) {
          int imageLoop = 2 - imageUrls.length;
          for (int i = 0; i < imageLoop; i++) {
            imageUrls.add(
              pw.Container(
                  padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                  width: 60,
                  height: 80,
                  child: pw.Text('')),
            );
          }
        } else if (imageUrls.length > 2) {
          int imageLoop = 10 - imageUrls.length;
          for (int i = 0; i < imageLoop; i++) {
            imageUrls.add(
              pw.Container(
                  padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                  width: 80,
                  height: 100,
                  child: pw.Text('')),
            );
          }
        }
      } else {
        for (int i = 0; i < 2; i++) {
          imageUrls.add(
            pw.Container(
                padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                width: 60,
                height: 80,
                child: pw.Text('')),
          );
        }
      }
      result.items.clear();

      //Text Rows of PDF Table
      rows.add(pw.TableRow(children: [
        pw.Container(
            padding: const pw.EdgeInsets.all(3.0),
            child: pw.Center(
                child: pw.Text((i + 1).toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(2.0),
            child: pw.Center(
                child: pw.Text(dailyProject[i].date.toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(2.0),
            child: pw.Center(
                child: pw.Text(dailyProject[i].typeOfActivity.toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(2.0),
            child: pw.Center(
                child: pw.Text(dailyProject[i].activityDetails.toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(2.0),
            child: pw.Center(
                child: pw.Text(dailyProject[i].progress.toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(2.0),
            child: pw.Center(
                child: pw.Text(dailyProject[i].status.toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        imageUrls[0],
        imageUrls[1]
      ]));

      if (imageUrls.length - 2 > 0) {
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
                    imageUrls[2],
                    imageUrls[3],
                  ])),
          imageUrls[4],
          imageUrls[5],
          imageUrls[6],
          imageUrls[7],
          imageUrls[8],
          imageUrls[9]
        ]));
      }
      imageUrls.clear();
    }

    final pdf = pw.Document(
      pageMode: PdfPageMode.outlines,
    );

    //First Half Page

    pdf.addPage(
      pw.MultiPage(
        maxPages: 100,
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
                      pw.Text('Daily Report Table',
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
              child: pw.Text('User ID - ${widget.userId}',
                  // 'Page ${context.pageNumber} of ${context.pagesCount}',
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
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 17)),
                    pw.TextSpan(
                        text: '${widget.cityName} / ${widget.depoName}',
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
                        text:
                            '${startdate!.day}-${startdate!.month}-${startdate!.year} to ${enddate!.day}-${enddate!.month}-${enddate!.year}',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    pw.TextSpan(
                        text: 'UserID : ${widget.userId}',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15)),
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
            children: rows,
          )
        ],
      ),
    );

    pdfData = await pdf.save();
    pdfPath = 'Daily Report.pdf';

    return pdfData!;
  }
}
