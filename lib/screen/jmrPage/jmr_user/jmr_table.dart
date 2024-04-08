import 'dart:io';
import 'package:ev_pmis_app/components/loading_pdf.dart';
import 'package:ev_pmis_app/models/jmr.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../../../components/Loading_page.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ev_pmis_app/datasource/jmr_datasource.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/nodata_available.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class JmrTablePage extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? title;
  String? jmrTab;
  int? jmrIndex;
  String? tabName;
  bool showTable;
  int? dataFetchingIndex;
  String? loiRefNum;
  String? siteLocation;
  String? refNo;
  String? date;
  String? note;
  String? startDate;
  String? endDate;
  String? projectName;
  String userId;

  JmrTablePage(
      {super.key,
      this.title,
      // this.img,
      this.cityName,
      this.depoName,
      this.jmrTab,
      this.jmrIndex,
      this.tabName,
      required this.showTable,
      this.dataFetchingIndex,
      this.date,
      this.endDate,
      this.loiRefNum,
      this.note,
      this.projectName,
      this.refNo,
      this.siteLocation,
      this.startDate,
      required this.userId});

  @override
  State<JmrTablePage> createState() => _JmrTablePageState();
}

class _JmrTablePageState extends State<JmrTablePage> {
  final TextEditingController projectName = TextEditingController();
  final loiRefNum = TextEditingController();
  final siteLocation = TextEditingController();
  final refNo = TextEditingController();
  final date = TextEditingController();
  final note = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();

  String? pathToOpenFile;

  List nextJmrIndex = [];
  List<List<dynamic>> data = [
    ['', '', '', '', '', '', 0, 0, 0],
  ];

  List<JMRModel> jmrtable = <JMRModel>[];
  late JmrDataSource _jmrDataSource;
  List<dynamic> jmrSyncList = [];
  late DataGridController _dataGridController;
  bool _isLoading = true;
  List<dynamic> tabledata2 = [];
  var alldata;

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirestore().whenComplete(() {
      _isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: _isLoading
          ? const LoadingPage()
          : Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: CustomAppBar(
                  isDownload: widget.showTable,
                  downloadFun: downloadPDF,
                  depoName: widget.depoName ?? '',
                  store: () {
                    nextIndex().then((value) => StoreData());
                  },
                  height: 30,
                  isCentered: true,
                  isSync: widget.showTable ? false : true,
                  title: 'JMR',
                ),
              ),
              body: _isLoading
                  ? const LoadingPage()
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: SfDataGridTheme(
                              data: SfDataGridThemeData(
                                  headerColor: white, gridLineColor: blue),
                              child: SfDataGrid(
                                source: _jmrDataSource,
                                allowEditing: widget.showTable ? false : true,
                                frozenColumnsCount: 1,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                selectionMode: SelectionMode.single,
                                navigationMode: GridNavigationMode.cell,
                                columnWidthMode: ColumnWidthMode.auto,
                                editingGestureType: EditingGestureType.tap,
                                controller: _dataGridController,
                                allowColumnsResizing: true,
                                headerRowHeight: 60,
                                columns: [
                                  GridColumn(
                                    columnName: 'srNo',
                                    allowEditing: true,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('SrNo',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: blue)),
                                    ),
                                  ),
                                  GridColumn(
                                    width: 150,
                                    columnName: 'Description',
                                    allowEditing: true,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Description of items',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: blue)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Activity',
                                    allowEditing: true,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Activity Details',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: blue,
                                          )),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'RefNo',
                                    allowEditing: true,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('BOQ RefNo',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: blue)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Abstract',
                                    allowEditing: true,
                                    width: 180,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Abstract of JMR',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: blue)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'UOM',
                                    allowEditing: true,
                                    width: 80,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('UOM',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: blue)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Rate',
                                    allowEditing: true,
                                    width: 80,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Rate',
                                        overflow: TextOverflow.values.first,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'TotalQty',
                                    allowEditing: true,
                                    width: 120,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Total Qty',
                                        overflow: TextOverflow.values.first,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'TotalAmount',
                                    allowEditing: true,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Amount',
                                        overflow: TextOverflow.values.first,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Delete',
                                    allowEditing: false,
                                    width: 120,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Delete Row',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: blue,
                                          )
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5, bottom: 10),
                    child: Visibility(
                      visible: widget.showTable ? false : true,
                      child: FloatingActionButton(
                        hoverColor: Colors.blue[900],
                        heroTag: "btn1",
                        onPressed: () {
                          jmrtable.add(
                            JMRModel(
                              srNo: jmrtable.length + 1,
                              Description: '',
                              Activity: '',
                              RefNo: '',
                              JmrAbstract: '',
                              Uom: '',
                              rate: 0,
                              TotalQty: 0,
                              TotalAmount: 0,
                            ),
                          );
                          _dataGridController = DataGridController();
                          _jmrDataSource.buildDataGridRows();
                          _jmrDataSource.updateDatagridSource();
                          // setState(() {});a
                        },
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5, bottom: 10),
                    child: Visibility(
                      visible: widget.showTable ? false : true,
                      child: FloatingActionButton.extended(
                        hoverColor: Colors.blue[900],
                        heroTag: "btn2",
                        isExtended: true,
                        onPressed: () {
                          selectExcelFile().then((value) {
                            setState(() {});
                          });
                        },
                        label: const Text('Upload Excel'),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Future<List<List<dynamic>>> selectExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      String? filePath = result.files.single.path;
      // File file = File(result.files.single.path!);
      var bytes = File(filePath!).readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        final sheet = excel.tables[table];
        for (var rows in sheet!.rows.skip(1)) {
          List<dynamic> rowData = [];
          for (var cell in rows) {
            rowData.add(cell?.value.toString());
          }
          data.add(rowData);
        }
      }
    } else {
      print('File is Empty');
    }

    return data;
  }

  List<JMRModel> convertListToJmrModel(List<List<dynamic>> data) {
    return data.map((list) {
      return JMRModel(
          srNo: list[0],
          Description: list[1],
          Activity: list[2],
          RefNo: list[3],
          JmrAbstract: list[4],
          Uom: list[5],
          rate: list[6],
          TotalQty: list[7],
          TotalAmount: list[8]);
    }).toList();
  }

  Future<void> StoreData() async {
    Map<String, dynamic> tableData = {};
    for (var i in _jmrDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        tableData[data.columnName] = data.value;
      }
      tabledata2.add(tableData);
      tableData = {};
    }
    //Storing data in JmrField
    storeDataInJmrField();

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${nextJmrIndex[0]}')
        .collection('date')
        .doc(DateFormat.yMMMMd().format(DateTime.now()))
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

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(widget.userId)
        .set({'deponame': widget.depoName});

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .set({'deponame': widget.depoName});

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${nextJmrIndex[0]}')
        .set({'deponame': widget.depoName});

    nextJmrIndex.clear();
  }

  Future<void> nextIndex() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .get();

    nextJmrIndex.add(querySnapshot.docs.length + 1);
  }

  Future<void> storeDataInJmrField() async {
    //Adding Field Data
    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrField')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${nextJmrIndex[0]}')
        .collection('date')
        .doc(DateFormat.yMMMMd().format(DateTime.now()))
        .set({
      'project': widget.projectName,
      'loiRefNum': widget.loiRefNum,
      'siteLocation': widget.siteLocation,
      'refNo': widget.refNo,
      'date': widget.date,
      'note': widget.note,
      'startDate': widget.startDate,
      'endDate': widget.endDate
    });

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrField')
        .collection('userId')
        .doc(widget.userId)
        .set({'deponame': widget.depoName});

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrField')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .set({'deponame': widget.depoName});

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrField')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${nextJmrIndex[0]}')
        .set({'deponame': widget.depoName});
  }

  //Function to fetch data and show in JMR view

  Future<List<dynamic>> _fetchDataFromFirestore() async {
    data.clear();
    // getFieldData();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${widget.dataFetchingIndex}')
        .collection('date')
        .get();

    List<dynamic> tempList = querySnapshot.docs.map((date) => date.id).toList();

    for (int i = 0; i < tempList.length; i++) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('JMRCollection')
          .doc(widget.depoName)
          .collection('Table')
          .doc('${widget.tabName}JmrTable')
          .collection('userId')
          .doc(widget.userId)
          .collection('jmrTabName')
          .doc(widget.jmrTab)
          .collection('jmrTabIndex')
          .doc('jmr${widget.dataFetchingIndex}')
          .collection('date')
          .doc(tempList[i])
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data1 =
            documentSnapshot.data() as Map<String, dynamic>?;
        jmrSyncList = data1!.entries.map((entry) => entry.value).toList();
        if (widget.showTable) {
          for (dynamic item in jmrSyncList) {
            List<dynamic> tempData = [];
            if (item is List<dynamic>) {
              for (dynamic innerItem in item) {
                if (innerItem is Map<String, dynamic>) {
                  tempData = [
                    innerItem['srNo'],
                    innerItem['Description'],
                    innerItem['Activity'],
                    innerItem['RefNo'],
                    innerItem['Abstract'],
                    innerItem['Uom'],
                    innerItem['Rate'],
                    innerItem['TotalQty'],
                    innerItem['TotalAmount']
                  ];
                }
                data.add(tempData);
              }
            }
          }
        }
      }
    }
    jmrtable = convertListToJmrModel(data);
    _jmrDataSource = JmrDataSource(jmrtable, deleteRow);
    _dataGridController = DataGridController();

    return jmrSyncList;
  }

  Future<void> downloadPDF() async {
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
            color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
      );

      await pr.show();

      final pdfData = await _generatePDF();

      String fileName = 'Jmr Report.pdf';

      final savedPDFFile = await savePDFToFile(pdfData, fileName);

      await pr.hide();
    }

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'repeating channel id', 'repeating channel name',
            channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await FlutterLocalNotificationsPlugin().show(
        0, 'JMR Pdf Downloaded', 'Tap to open', notificationDetails,
        payload: pathToOpenFile);
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

  Future<Uint8List> _generatePDF() async {
    final headerStyle =
        pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);

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

    List<List<dynamic>> fieldData = [
      ['Project :', projectName.text],
      ['Ref Number :', refNo.text],
      ['LOI Ref Number :', loiRefNum.text],
      ['Date :', date.text],
      ['Site Location :', siteLocation.text],
      ['Note :', note.text],
      ['Start Date :', startDate.text],
      ['End Date :', endDate.text],
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
              child: pw.Text('Description',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Activity Details',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('BOQ RefNo',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Abstract',
          ))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'UOM',
          ))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Rate',
          ))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Total Qty',
          ))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text(
            'Amount',
          ))),
    ]));

    List<dynamic> userData = [];

    if (jmrSyncList.isNotEmpty) {
      userData = jmrSyncList[0];
      List<pw.Widget> imageUrls = [];

      for (Map<String, dynamic> mapData in userData) {
        //Text Rows of PDF Table
        rows.add(pw.TableRow(children: [
          pw.Container(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Center(
                  child: pw.Text(mapData['srNo'].toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Center(
                  child: pw.Text(mapData['Description'],
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 13,
                      )))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['Activity'],
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['RefNo'].toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['Abstract'].toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['Uom'].toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['Rate'].toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['TotalQty'].toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData['TotalAmount'].toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 13)))),
        ]));
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
                      pw.Text('Jmr Report',
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
              child: pw.Text('UserID - ${widget.userId}',
                  textScaleFactor: 1.5,
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
                  // pw.RichText(
                  //     text: pw.TextSpan(children: [
                  //   const pw.TextSpan(
                  //       text: 'Date : ',
                  //       style:
                  //           pw.TextStyle(color: PdfColors.black, fontSize: 17)),
                  //   pw.TextSpan(
                  //       text: date.text,
                  //       style: const pw.TextStyle(
                  //           color: PdfColors.blue700, fontSize: 15))
                  // ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    const pw.TextSpan(
                        text: 'UserID : ',
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 15)),
                    pw.TextSpan(
                        text: widget.userId,
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
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
                      pw.Text('JMR Report',
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
                ]),
            pw.SizedBox(height: 20)
          ]),
          pw.SizedBox(height: 10),
          pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FixedColumnWidth(120),
                2: const pw.FixedColumnWidth(120),
                3: const pw.FixedColumnWidth(120),
                4: const pw.FixedColumnWidth(120),
                5: const pw.FixedColumnWidth(120),
                6: const pw.FixedColumnWidth(70),
                7: const pw.FixedColumnWidth(50),
                8: const pw.FixedColumnWidth(50),
              },
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              tableWidth: pw.TableWidth.max,
              border: pw.TableBorder.all(),
              children: rows)
        ],
      ),
    );

    final Uint8List pdfData = await pdf.save();

    // Save the PDF file to device storage

    return pdfData;
  }

  void deleteRow(dynamic removeIndex) async {
    jmrtable.removeAt(removeIndex);
    print('Row Removed $removeIndex');
  }
}

List<JMRModel> getData() {
  return [
    JMRModel(
        srNo: 1,
        Description: '',
        Activity: '',
        RefNo: '',
        JmrAbstract: '',
        Uom: '',
        rate: 0.0,
        TotalQty: 0.0,
        TotalAmount: 0.0),
  ];
}

HeaderValue(String title, String hintValue, TextEditingController fieldData) {
  return Container(
    padding: const EdgeInsets.only(
      bottom: 4,
      top: 10,
      right: 5,
    ),
    width: 400,
    height: 60,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$title : ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: fieldData,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: hintValue,
              contentPadding: const EdgeInsets.all(4),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}
