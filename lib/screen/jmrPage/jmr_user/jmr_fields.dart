import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../../components/Loading_page.dart';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/model/jmr.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ev_pmis_app/authentication/authservice.dart';
import 'package:ev_pmis_app/datasource/jmr_datasource.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/nodata_available.dart';
import 'package:intl/intl.dart';

import 'jmr_table.dart';

class JmrFieldPage extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? title;
  String? jmrTab;
  int? jmrIndex;
  String? tabName;
  bool showTable;
  int? dataFetchingIndex;

  JmrFieldPage({
    super.key,
    this.title,
    // this.img,
    this.cityName,
    this.depoName,
    this.jmrTab,
    this.jmrIndex,
    this.tabName,
    required this.showTable,
    this.dataFetchingIndex,
  });

  @override
  State<JmrFieldPage> createState() => _JmrFieldPageState();
}

class _JmrFieldPageState extends State<JmrFieldPage> {
  final TextEditingController projectName = TextEditingController();
  final loiRefNum = TextEditingController();
  final siteLocation = TextEditingController();
  final refNo = TextEditingController();
  final date = TextEditingController();
  final note = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();

  List nextJmrIndex = [];
  List<List<dynamic>> data = [
    [
      '1',
      'Supply and Laying',
      'onboarding one no. of EV charger of 200kw',
      '8.31 (Additional)',
      'abstract of JMR sheet No 1 & Item Sr No 1',
      'Mtr',
      500.00,
      110,
      55000.00
    ],
  ];

  List<JMRModel> jmrtable = <JMRModel>[];
  int _excelRowNextIndex = 0;
  late JmrDataSource _jmrDataSource;
  late List<dynamic> jmrSyncList;
  late DataGridController _dataGridController;
  bool _isLoading = true;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  var alldata;
  dynamic userId;

  @override
  void initState() {
    super.initState();
    getUserId().whenComplete(() {
      _stream = FirebaseFirestore.instance
          .collection('JMRCollection')
          .doc(widget.depoName)
          .collection('userId')
          .doc(userId)
          .snapshots();
      if (widget.showTable == true) {
        _fetchDataFromFirestore().then((value) => {
              setState(() {
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
                _isLoading = false;
              })
            });
      } else {
        _isLoading = false;
        setState(() {});
      }
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
          ? LoadingPage()
          : Scaffold(
              appBar: PreferredSize(
                // ignore: sort_child_properties_last
                child: CustomAppBar(
                  store: () {
                    nextIndex().then((value) => StoreData());
                  },
                  height: 30,
                  isCentered: true,
                  isSync: false,
                  title:
                      'JMR / ${widget.depoName} / ${widget.title.toString()}',
                ),
                preferredSize: const Size.fromHeight(50),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      HeaderValue(context, widget.showTable, 'Project',
                          'Project Name', projectName),
                      HeaderValue(context, widget.showTable, 'Ref No ',
                          'Ref No', refNo),
                      HeaderValue(context, widget.showTable, 'LOI Ref\nNumber',
                          'LOI Ref Number', loiRefNum),
                      HeaderValue(context, widget.showTable, 'Date    ',
                          'Enter Date', date),
                      HeaderValue(context, widget.showTable, 'Site\nLocation',
                          'Site Location', siteLocation),
                      HeaderValue(
                          context, widget.showTable, 'Note     ', 'Note', note),
                      Container(
                        height: 60,
                        padding: const EdgeInsets.only(right: 10, top: 10),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 5.0, right: 16),
                              child: Text(
                                'Working \nDates       ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                                child: TextFormField(
                              controller: startDate,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.only(left: 4, right: 4),
                                  hintText: 'From'),
                            )),
                            const SizedBox(width: 10),
                            Expanded(
                                child: TextFormField(
                                    controller: endDate,
                                    decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 4, right: 4),
                                        border: OutlineInputBorder(),
                                        hintText: 'To')))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //   Center(
              floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JmrTablePage(
                                  date: date.text,
                                  endDate: endDate.text,
                                  note: note.text,
                                  projectName: projectName.text,
                                  refNo: refNo.text,
                                  loiRefNum: loiRefNum.text,
                                  startDate: startDate.text,
                                  siteLocation: siteLocation.text,
                                  dataFetchingIndex: widget.dataFetchingIndex,
                                  showTable: widget.showTable,
                                  title: widget.title,
                                  jmrTab: widget.jmrTab,
                                  cityName: widget.cityName,
                                  depoName: widget.depoName,
                                  jmrIndex: widget.jmrIndex,
                                  tabName: widget.tabName,
                                )));
                  },
                  label: widget.showTable
                      ? Row(
                          children: const [
                            Text(
                              'Next',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        )
                      : Row(
                          children: const [
                            Text(
                              'Proceed To Sync',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        )), // child: Image.asset(widget.img.toString()),
            ),
    );
  }

  Future<List<List<dynamic>>> selectExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      final excel = Excel.decodeBytes(result as List<int>);
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

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
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
        .doc(userId)
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
        .doc(userId)
        .set({'deponame': widget.depoName});

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .set({'deponame': widget.depoName});

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(userId)
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
        .doc(userId)
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
        .doc(userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${nextJmrIndex[0]}')
        .collection('date')
        .doc(DateFormat.yMMMMd().format(DateTime.now()))
        .set({
      'project': projectName.text,
      'loiRefNum': loiRefNum.text,
      'siteLocation': siteLocation.text,
      'refNo': refNo.text,
      'date': date.text,
      'note': note.text,
      'startDate': startDate.text,
      'endDate': endDate.text
    });

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrField')
        .collection('userId')
        .doc(userId)
        .set({'deponame': widget.depoName});

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrField')
        .collection('userId')
        .doc(userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .set({'deponame': widget.depoName});

    FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrField')
        .collection('userId')
        .doc(userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${nextJmrIndex[0]}')
        .set({'deponame': widget.depoName});
  }

  //Function to fetch data and show in JMR view

  Future<List<dynamic>> _fetchDataFromFirestore() async {
    data.clear();
    getFieldData();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrTable')
        .collection('userId')
        .doc(userId)
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
          .doc(userId)
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

        return jmrSyncList;
      }
    }

    return jmrSyncList;
  }

  Future<void> getFieldData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${widget.tabName}JmrField')
        .collection('userId')
        .doc(userId)
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
          .doc('${widget.tabName}JmrField')
          .collection('userId')
          .doc(userId)
          .collection('jmrTabName')
          .doc(widget.jmrTab)
          .collection('jmrTabIndex')
          .doc('jmr${widget.dataFetchingIndex}')
          .collection('date')
          .doc(tempList[i])
          .get();

      Map<String, dynamic> fieldData =
          documentSnapshot.data() as Map<String, dynamic>;

      projectName.text = fieldData['project'];
      loiRefNum.text = fieldData['loiRefNum'];
      siteLocation.text = fieldData['siteLocation'];
      refNo.text = fieldData['refNo'];
      date.text = fieldData['date'];
      note.text = fieldData['note'];
      startDate.text = fieldData['startDate'];
      endDate.text = fieldData['endDate'];

      print(
          'FieldData - ${projectName.text},${loiRefNum.text},${siteLocation.text},${refNo.text},${endDate.text}');
    }
  }

  void deleteRow(dynamic removeIndex) async {
    data.removeAt(removeIndex);
    print('Row Removed $removeIndex');
  }
}

List<JMRModel> getData() {
  return [
    JMRModel(
        srNo: 1,
        Description: 'Supply and Laying',
        Activity: 'Software',
        RefNo: '8.31 (Additional)',
        JmrAbstract: 'Dumble Door',
        Uom: 'Mtr',
        rate: 500.00,
        TotalQty: 110,
        TotalAmount: 55000.00),
  ];
}

HeaderValue(BuildContext context, bool isReadOnly, String title,
    String hintValue, TextEditingController fieldData) {
  return Container(
    padding: EdgeInsets.only(top: 5, bottom: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 300,
          child: TextFormField(
            readOnly: isReadOnly,
            controller: fieldData,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: hintValue,
              contentPadding: const EdgeInsets.only(left: 4, right: 4),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}
