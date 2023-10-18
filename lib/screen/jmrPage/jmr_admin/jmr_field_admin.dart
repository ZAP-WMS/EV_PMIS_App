import 'package:ev_pmis_app/screen/jmrPage/jmr_admin/jmr_table_admin.dart';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/model/jmr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ev_pmis_app/datasource/jmr_datasource.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';

class JmrFieldPageAdmin extends StatefulWidget {
  String? userId;
  String? cityName;
  String? depoName;
  String? title;
  String? jmrTab;
  int? jmrIndex;
  String? tabName;
  bool showTable;
  int? dataFetchingIndex;

  JmrFieldPageAdmin({
    super.key,
    required this.userId,
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
  State<JmrFieldPageAdmin> createState() => _JmrFieldPageAdminState();
}

class _JmrFieldPageAdminState extends State<JmrFieldPageAdmin> {
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

  @override
  void initState() {
    super.initState();

    _stream = FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('userId')
        .doc(widget.userId)
        .snapshots();
    if (widget.showTable == true) {
      print('Running');
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
                  height: 30,
                  isCentered: true,
                  isSync: false,
                  title:
                      'JMR / ${widget.depoName} / ${widget.title.toString()}',
                ),
                preferredSize: const Size.fromHeight(50),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    HeaderValue(context, widget.showTable, 'Project',
                        'Project Name', projectName),
                    HeaderValue(
                        context, widget.showTable, 'Ref No ', 'Ref No', refNo),
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
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5.0),
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
              //   Center(
              floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JmrTablePageAdmin(
                                  userId: widget.userId,
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
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${widget.dataFetchingIndex}')
        .collection('date')
        .get();

    List<dynamic> tempList = querySnapshot.docs.map((date) => date.id).toList();
    print(tempList);

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
        .doc(widget.userId)
        .collection('jmrTabName')
        .doc(widget.jmrTab)
        .collection('jmrTabIndex')
        .doc('jmr${widget.dataFetchingIndex}')
        .collection('date')
        .get();

    List<dynamic> tempList = querySnapshot.docs.map((date) => date.id).toList();
    print(tempList);

    for (int i = 0; i < tempList.length; i++) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('JMRCollection')
          .doc(widget.depoName)
          .collection('Table')
          .doc('${widget.tabName}JmrField')
          .collection('userId')
          .doc(widget.userId)
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
    padding: const EdgeInsets.only(
      left: 4,
      bottom: 4,
      top: 10,
      right: 4,
    ),
    width: MediaQuery.of(context).size.width,
    height: 70,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
