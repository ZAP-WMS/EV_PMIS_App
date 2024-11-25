import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/O_AND_M/o&m_datasource/monthly_adminChargerDataSource.dart';
import 'package:ev_pmis_app/O_AND_M/o&m_datasource/monthly_filterAdminDatasource.dart';
import 'package:ev_pmis_app/PMIS/common_screen/citiespage/depot.dart';
import 'package:ev_pmis_app/PMIS/user/screen/safetyfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../components/Loading_page.dart';
import '../../components/loading_pdf.dart';
import '../../style.dart';
import '../o&m_datasource/monthly_chargerdatasource.dart';
import '../o&m_datasource/monthly_filter.dart';
import '../o&m_model/monthly_charger.dart';
import '../o&m_model/monthly_filter.dart';
import '../../../../utils/daily_managementlist.dart';
import '../../../../utils/date_formart.dart';
import '../../../../PMIS/authentication/authservice.dart';
import 'package:pdf/widgets.dart' as pw;

late MonthlyAdminChargerManagentDatasourc _monthlyChargerManagementDataSource;
late MonthlyAdminFilterManagentDatasource _monthlyFilterManagementDataSource;

final TextEditingController _datecontroller = TextEditingController();
final TextEditingController _docRefcontroller = TextEditingController();
final TextEditingController _timecontroller = TextEditingController();
final TextEditingController _depotController = TextEditingController();
final TextEditingController _checkedbycontroller = TextEditingController();
final TextEditingController _remarkcontroller = TextEditingController();
List<MonthlyChargerModel> _monthlyChargerModel = [];
List<MonthlyFilterModel> _monthlyFilterModel = [];
Uint8List? pdfData;

class MonthlyAdminManagementPage extends StatefulWidget {
  String? cityName;
  String? depoName;
  int tabIndex;
  String? tabletitle;
  String userId;
  String role;
  MonthlyAdminManagementPage({
    super.key,
    required this.cityName,
    required this.depoName,
    required this.tabIndex,
    required this.tabletitle,
    required this.userId,
    required this.role,
  });

  @override
  State<MonthlyAdminManagementPage> createState() =>
      _MonthlyAdminManagementPageState();
}

class _MonthlyAdminManagementPageState
    extends State<MonthlyAdminManagementPage> {
  String? selectedDate = DateFormat.yMMM().format(DateTime.now());
  List<GridColumn> columns = [];
  bool _isloading = true;
  Stream? _stream;
  dynamic userId;
  late DataGridController _dataGridController;

  @override
  void initState() {
    // Example date
    _monthlyChargerModel.clear();
    _monthlyFilterModel.clear();

    _dataGridController = DataGridController();
    nestedTableData(startdate, context);
    getUserId().whenComplete(() {
      _stream = FirebaseFirestore.instance
          .collection('MonthlyManagementPage')
          .doc('${widget.depoName}')
          .collection('Checklist Name')
          .doc(widget.tabletitle)
          .collection(selectedDate.toString())
          .doc(widget.userId)
          .snapshots();
      // _fetchUserData();
      _monthlyChargerManagementDataSource =
          MonthlyAdminChargerManagentDatasourc(_monthlyChargerModel, context,
              widget.cityName!, widget.depoName!, selectedDate!, userId);
      _monthlyFilterManagementDataSource = MonthlyAdminFilterManagentDatasource(
          _monthlyFilterModel,
          context,
          widget.cityName!,
          widget.depoName!,
          selectedDate!,
          userId);
      _dataGridController = DataGridController();
    });
    _isloading = false;
    setState(() {});
    super.initState();
  }

  DateTime? startdate = DateTime.now();
  DateTime? rangestartDate;

  @override
  Widget build(BuildContext context) {
    getUserId().whenComplete(() {
      _monthlyChargerManagementDataSource =
          MonthlyAdminChargerManagentDatasourc(_monthlyChargerModel, context,
              widget.cityName!, widget.depoName!, selectedDate!, userId);
      _monthlyFilterManagementDataSource = MonthlyAdminFilterManagentDatasource(
          _monthlyFilterModel,
          context,
          widget.cityName!,
          widget.depoName!,
          selectedDate!,
          userId);
      _dataGridController = DataGridController();

      _depotController.text = widget.depoName.toString();
    });

    List<List<String>> tabColumnNames = [
      monthlyChargerColumnName,
      monthlyFilterColumnName
    ];

    List<List<String>> tabColumnLabels = [
      monthlyLabelColumnName,
      monthlyFilterLabelColumnName
    ];

    List<String> currentColumnNames = tabColumnNames[widget.tabIndex];
    List<String> currentColumnLabels = tabColumnLabels[widget.tabIndex];

    columns.clear();

    for (String columnName in currentColumnNames) {
      columns.add(
        GridColumn(
          columnName: columnName,
          visible: columnName == 'Add' || columnName == 'Delete' ? false : true,
          allowEditing: false,

          width: columnName == 'cn'
              ? MediaQuery.of(context).size.width * 0.2
              : MediaQuery.of(context).size.width *
                  0.35, // You can adjust this width as needed
          label: createColumnLabel(
            currentColumnLabels[currentColumnNames.indexOf(columnName)],
          ),
        ),
      );
    }
    return Scaffold(
      body: _isloading
          ? const LoadingPage()
          : Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 250,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: blue)),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: SizedBox(
                                      width: 400,
                                      height: 500,
                                      child: SfDateRangePicker(
                                        view: DateRangePickerView.year,
                                        showTodayButton: false,
                                        showActionButtons: true,
                                        selectionMode:
                                            DateRangePickerSelectionMode.single,
                                        onSelectionChanged:
                                            (DateRangePickerSelectionChangedArgs
                                                args) {
                                          if (args.value is PickerDateRange) {
                                            rangestartDate =
                                                args.value.startDate;
                                          }
                                        },
                                        onSubmit: (value) {
                                          setState(() {
                                            startdate = DateTime.parse(
                                                value.toString());
                                          });
                                          print(startdate);
                                          nestedTableData(startdate, context)
                                              .whenComplete(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                        onCancel: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.today)),
                          Text(DateFormat.yMMMM().format(startdate!))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                        headerColor: white, gridLineColor: blue),
                    child: StreamBuilder(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LoadingPage();
                        } else if (!snapshot.hasData ||
                            snapshot.data.exists == false) {
                          return SfDataGrid(
                              source: widget.tabIndex == 0
                                  ? _monthlyChargerManagementDataSource
                                  : _monthlyFilterManagementDataSource,
                              allowEditing: true,
                              frozenColumnsCount: 1,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              selectionMode: SelectionMode.single,
                              navigationMode: GridNavigationMode.cell,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              editingGestureType: EditingGestureType.tap,
                              rowHeight: 50,
                              controller: _dataGridController,
                              onQueryRowHeight: (details) {
                                return details
                                    .getIntrinsicRowHeight(details.rowIndex);
                              },
                              columns: columns);
                        } else {
                          return SfDataGrid(
                              source: widget.tabIndex == 0
                                  ? _monthlyChargerManagementDataSource
                                  : _monthlyFilterManagementDataSource,
                              allowEditing: true,
                              frozenColumnsCount: 2,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              selectionMode: SelectionMode.single,
                              navigationMode: GridNavigationMode.cell,
                              editingGestureType: EditingGestureType.tap,
                              rowHeight: 50,
                              controller: _dataGridController,
                              onQueryRowHeight: (details) {
                                return details
                                    .getIntrinsicRowHeight(details.rowIndex);
                              },
                              columns: columns);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ]),
    );
  }

  Future<void> nestedTableData(
      DateTime? initialdate, BuildContext pageContext) async {
    // globalIndexList.clear();
    // availableUserId.clear();
    // chosenDateList.clear();

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

    setState(() {
      _isloading = true;
    });

    // for (DateTime initialdate = startdate!;
    //     initialdate.isBefore(enddate!.add(const Duration(days: 1)));
    //     initialdate = initialdate.add(const Duration(days: 1))) {
    // useridWithData.clear();

    String nextDate = DateFormat.yMMM().format(initialdate!);

    QuerySnapshot userIdQuery = await FirebaseFirestore.instance
        .collection('MonthlyManagementPage')
        .doc(widget.depoName)
        .collection('Checklist Name')
        .doc(widget.tabletitle)
        .collection(nextDate.toString())
        .get();

    List<dynamic> userList = userIdQuery.docs.map((e) => e.id).toList();
    if (userList.length != 0) {
      for (int i = 0; i < userList.length; i++) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('MonthlyManagementPage')
            .doc(widget.depoName)
            .collection('Checklist Name')
            .doc(widget.tabletitle)
            .collection(nextDate.toString())
            .doc(userList[i])
            .get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> tempData =
              documentSnapshot.data() as Map<String, dynamic>;

          List<dynamic> mapData = tempData['data'];

          if (widget.tabIndex == 0) {
            _monthlyChargerModel.addAll(mapData
                .map((map) => MonthlyChargerModel.fromjson(map))
                .toList());
            // _monthlyChargerModel = mapData
            //     .map((map) => MonthlyChargerModel.fromjson(map))
            //     .toList();
          } else {
            _monthlyFilterModel.addAll(mapData
                .map((map) => MonthlyFilterModel.fromjson(map))
                .toList());
            // _monthlyFilterModel =
            //     mapData.map((map) => MonthlyFilterModel.fromjson(map)).toList();
          }
        }
      }
    } else {
      _monthlyChargerModel.clear();
      _monthlyFilterModel.clear();
    }
    _isloading = false;
    setState(() {});
    pr.hide();
  }

  _fetchUserData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('MonthlyAdminManagementPage')
        .doc(widget.depoName)
        .collection('Checklist Name')
        .doc(widget.tabletitle)
        .collection(selectedDate.toString())
        .doc(userId)
        .get();

    if (snapshot.exists) {
      _datecontroller.text = snapshot.data()!['date'] ?? '';
      _docRefcontroller.text = snapshot.data()!['refNo'] ?? '';
      _timecontroller.text = snapshot.data()!['time'] ?? '';
      _depotController.text = snapshot.data()!['depotName'] ?? '';
      _checkedbycontroller.text = snapshot.data()!['checkedBy'];
      _remarkcontroller.text = snapshot.data()!['remark'];
    } else {
      _docRefcontroller.clear();
      _datecontroller.text = ddmmyyyy;
      _timecontroller.text = DateFormat('HH:mm:ss').format(DateTime.now());
      _depotController.clear();
      _checkedbycontroller.clear();
      _remarkcontroller.clear();
    }
  }

  Widget createColumnLabel(String labelText) {
    return Container(
      alignment: Alignment.center,
      child: Text(labelText,
          overflow: TextOverflow.values.first,
          textAlign: TextAlign.center,
          style: tableheader),
    );
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
      setState(() {});
    });
  }

  Future<void> getTableData() async {
    _monthlyChargerModel.clear();
    _monthlyFilterModel.clear();
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('MonthlyAdminManagementPage')
        .doc(widget.depoName)
        .collection('Checklist Name')
        .doc(widget.tabletitle)
        .collection(selectedDate.toString())
        .doc(userId)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> tempData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapData = tempData['data'];
      print(mapData);

      // List<String> titleName = [
      //   'Charger Checklist',
      //   'SFU Checklist',
      //   'PSS Checklist',
      //   'Transformer Checklist',
      //   'RMU Checklist',
      //   'ACDB Checklist',
      // ];
      if (widget.tabIndex == 0) {
        _monthlyChargerModel =
            mapData.map((map) => MonthlyChargerModel.fromjson(map)).toList();
      } else {
        _monthlyFilterModel =
            mapData.map((map) => MonthlyFilterModel.fromjson(map)).toList();
      }
      checkTable = false;
      setState(() {});
    }
  }
}

Future<void> downloadPDF(
    BuildContext context,
    String cityName,
    String depoName,
    // String pathToOpenFile,
    // Uint8List? pdfData,
    // String? pdfPath,
    int tabIndex) async {
  if (await Permission.manageExternalStorage.request().isGranted) {
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
    final pdfData = await _generateDailyPDF(pr, tabIndex, cityName, depoName);
    String? fileName;
    if (tabIndex == 0) {
      fileName = 'Charger_Reading_Format.pdf';
    } else {
      fileName = 'Charger_Filter.pdf';
    }

    final savedPDFFile = await savePDFToFile(pdfData, fileName);

    await pr.hide();

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'repeating channel id', 'repeating channel name',
            channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await FlutterLocalNotificationsPlugin().show(
        0, fileName, 'Tap to open', notificationDetails,
        payload: savedPDFFile.path);
  }
}

Future<Uint8List> _generateDailyPDF(
    ProgressDialog? pr, int tabIndex, String cityName, String depoName) async {
  // String pathToOpenFile;
  String pdfPath;
  pr?.style(
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

  final headerStyle =
      pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);

  final fontData1 = await rootBundle.load('assets/fonts/Montserrat-Medium.ttf');
  final fontData2 = await rootBundle.load('assets/fonts/Montserrat-Bold.ttf');

  final profileImage = pw.MemoryImage(
    (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
  );

  Map<String, dynamic> tableData = Map();
  dynamic datasource;
  if (tabIndex == 0) {
    datasource = _monthlyChargerManagementDataSource;
  } else {
    datasource = _monthlyFilterManagementDataSource;
  }

  List<String> headers = [];
  headers.clear();
  tabledata2.clear();

  for (var i in datasource.dataGridRows) {
    tableData = {};
    for (var data in i.getCells()) {
      if (data.columnName != 'button' && data.columnName != 'Delete') {
        tableData[data.columnName] = data.value;
      }
    }
    tabledata2.add(tableData);
  }

  List<List<String>> tabColumnLabels = [
    monthlyAdminchargerLabelColumnName,
    monthlyAdminFilterName
  ];

  headers = tabColumnLabels[tabIndex];

  List<pw.TableRow> rows = [];

  pw.Widget buildTableCell(String text) {
    return pw.Container(
        padding: const pw.EdgeInsets.all(3.0),
        child: pw.Center(
            child: pw.Text(text, style: const pw.TextStyle(fontSize: 14))));
  }

  if (tabIndex == 0) {
    rows.add(pw.TableRow(
      children: headers.map((header) {
        return pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
            child: pw.Text(
              header,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    ));
    for (int i = 0; i < tabledata2.length; i++) {
      rows.add(pw.TableRow(children: [
        buildTableCell((i + 1).toString()),
        buildTableCell(tabledata2[i]['date'].toString()),
        buildTableCell(tabledata2[i]['gun1'].toString()),
        buildTableCell(tabledata2[i]['gun2'].toString()),
      ]));
    }
  }
  if (tabIndex == 1) {
    rows.clear();
    rows.add(pw.TableRow(
      children: headers.map((header) {
        return pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
            child: pw.Text(
              header,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    ));
    for (int i = 0; i < tabledata2.length; i++) {
      rows.add(pw.TableRow(children: [
        buildTableCell((i + 1).toString()),
        buildTableCell(tabledata2[i]['date'].toString()),
        buildTableCell(tabledata2[i]['fcd'].toString()),
        buildTableCell(tabledata2[i]['dgcd'].toString()),
      ]));
    }
  }

  final pdf = pw.Document(pageMode: PdfPageMode.outlines);

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
                    bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey))),
            child: pw.Column(children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Monthly Report Table',
                        textScaleFactor: 2,
                        style: const pw.TextStyle(color: PdfColors.blue700)),
                    // pw.Container(
                    //   width: 120,
                    //   height: 120,
                    //   child: pw.Image(profileImage),
                    // ),
                  ]),
            ]));
      },
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text('User ID - $userId',
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
                      text: '$cityName / $depotname',
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
                      text: selectedDate,
                      // '${startdate!.day}-${startdate!.month}-${startdate!.year} to ${enddate!.day}-${enddate!.month}-${enddate!.year}',
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
        pw.Table(
          columnWidths: Map.fromIterable(
            List.generate(headers.length, (index) => index),
            value: (index) => const pw.FixedColumnWidth(100),
          ),
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          tableWidth: pw.TableWidth.max,
          border: pw.TableBorder.all(),
          children: rows,
        )
      ],
    ),
  );

  pdfData = await pdf.save();
  pdfPath = 'Monthly_Report.pdf';

  return pdfData!;
}

Future<File> savePDFToFile(Uint8List pdfData, String fileName) async {
  // Get the path to the downloads directory
  final documentDirectory = (await DownloadsPath.downloadsDirectory())?.path;

  if (documentDirectory == null) {
    // Return an empty file if the directory is null
    return File('');
  }

  final file = File('$documentDirectory/$fileName');
  int counter = 1;
  String newFilePath = file.path;

  // Check if the file already exists and find a unique name
  while (await File(newFilePath).exists()) {
    final baseName = fileName.split('.').first;
    final extension = fileName.split('.').last;
    newFilePath =
        '$documentDirectory/$baseName-${counter.toString()}.$extension';
    counter++;
  }

  // Write the PDF data to the new file
  await File(newFilePath).writeAsBytes(pdfData);

  // Return the File object for the newly created file
  return File(newFilePath);
}
