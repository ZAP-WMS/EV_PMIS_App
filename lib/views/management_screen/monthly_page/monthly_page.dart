import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/views/safetyreport/safetyfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../components/Loading_page.dart';
import '../../../datasource/o&m_datasource/monthly_chargerdatasource.dart';
import '../../../datasource/o&m_datasource/monthly_filter.dart';
import '../../../models/o&m_model/monthly_charger.dart';
import '../../../models/o&m_model/monthly_filter.dart';
import '../../../style.dart';
import '../../../utils/daily_managementlist.dart';
import '../../../utils/date_formart.dart';
import '../../../utils/date_inputFormatter.dart';
import '../../../utils/upper_tableHeader.dart';
import '../../authentication/authservice.dart';

late MonthlyChargerManagementDataSource _monthlyChargerManagementDataSource;
late MonthlyFilterManagementDataSource _monthlyFilterManagementDataSource;

final TextEditingController _datecontroller = TextEditingController();
final TextEditingController _docRefcontroller = TextEditingController();
final TextEditingController _timecontroller = TextEditingController();
final TextEditingController _depotController = TextEditingController();
final TextEditingController _checkedbycontroller = TextEditingController();
final TextEditingController _remarkcontroller = TextEditingController();
List<MonthlyChargerModel> _monthlyChargerModel = [];
List<MonthlyFilterModel> _monthlyFilterModel = [];

class MonthlyManagementPage extends StatefulWidget {
  String? cityName;
  String? depoName;
  int tabIndex = 0;
  String? tabletitle;
  MonthlyManagementPage(
      {super.key,
      required this.cityName,
      required this.depoName,
      required this.tabIndex,
      required this.tabletitle});

  @override
  State<MonthlyManagementPage> createState() => _MonthlyManagementPageState();
}

class _MonthlyManagementPageState extends State<MonthlyManagementPage> {
  String? selectedDate = DateFormat.yMMM().format(DateTime.now());
  List<GridColumn> columns = [];
  bool _isloading = true;
  Stream? _stream;
  dynamic userId;

  late DataGridController _dataGridController;

  @override
  void initState() {
    // Example date
    DateTime date = DateTime.now();

    _stream = FirebaseFirestore.instance
        .collection('DailyManagementPage')
        .doc('${widget.depoName}')
        .collection(selectedDate.toString())
        .doc(userId)
        .snapshots();

    _dataGridController = DataGridController();
     getUserId().whenComplete(() {
      _fetchUserData();
      _monthlyChargerManagementDataSource = MonthlyChargerManagementDataSource(
          _monthlyChargerModel,
          context,
          widget.cityName!,
          widget.depoName!,
          selectedDate!,
          userId);
      _monthlyFilterManagementDataSource = MonthlyFilterManagementDataSource(
          _monthlyFilterModel,
          context,
          widget.cityName!,
          widget.depoName!,
          selectedDate!,
          userId);
      _dataGridController = DataGridController();
      getTableData().whenComplete(() {
        _monthlyChargerManagementDataSource =
            MonthlyChargerManagementDataSource(_monthlyChargerModel, context,
                widget.cityName!, widget.depoName!, selectedDate!, userId);
        _monthlyFilterManagementDataSource = MonthlyFilterManagementDataSource(
            _monthlyFilterModel,
            context,
            widget.cityName!,
            widget.depoName!,
            selectedDate!,
            userId);

        _monthlyFilterManagementDataSource = MonthlyFilterManagementDataSource(
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
    });

    super.initState();
  }

  List<List<String>> tabColumnNames = [
    monthlyChargerColumnName,
    monthlyFilterColumnName,
  ];

  List<List<String>> tabColumnLabels = [
    monthlyLabelColumnName,
    monthlyFilterLabelColumnName,
  ];
  @override
  Widget build(BuildContext context) {
    _depotController.text = widget.depoName.toString();

    List<String> currentColumnNames = tabColumnNames[widget.tabIndex];
    List<String> currentColumnLabels = tabColumnLabels[widget.tabIndex];

    columns.clear();
    for (String columnName in currentColumnNames) {
      columns.add(
        GridColumn(
          columnName: columnName,
          visible: true,
          allowEditing: columnName == 'Add' ||
                  columnName == 'Delete' ||
                  columnName == columnName[0]
              ? false
              : true,
          width: columnName == 'cn'
              ? MediaQuery.of(context).size.width * 0.2
              : MediaQuery.of(context).size.width *
                  0.3, // You can adjust this width as needed
          label: createColumnLabel(
            currentColumnLabels[currentColumnNames.indexOf(columnName)],
          ),
        ),
      );
    }
    return Scaffold(
      body: _isloading
          ? const LoadingPage()
          : SingleChildScrollView(
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: blue),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      customText(
                                          'Date:',
                                          'DD/MM/YYYY',
                                          _datecontroller,
                                          TextInputType.number,
                                          [DateInputFormatter()],
                                          true,
                                          true,
                                          context),
                                      customText(
                                          'Time:',
                                          '01:01:00',
                                          _timecontroller,
                                          TextInputType.datetime,
                                          [],
                                          true,
                                          true,
                                          context),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      customText(
                                          'Document Reference Number:',
                                          'doc1234',
                                          _docRefcontroller,
                                          TextInputType.name,
                                          [],
                                          false,
                                          false,
                                          context),
                                      customText(
                                          'Bus Depot Name:',
                                          'BBM',
                                          _depotController,
                                          TextInputType.name,
                                          [],
                                          false,
                                          true,
                                          context)
                                    ],
                                  ),
                                  // SizedBox(
                                  //   child: Text(
                                  //     'TPEVCSL/E-BUS/${widget.cityName}',
                                  //     style: tableheader,
                                  //     textAlign: TextAlign.center,
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                ],
                              ),
                            ]))),
                Padding(
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
                tableFooter(_remarkcontroller),
                Row(
                  children: [
                    Column(
                      children: [
                        customText('Checked by:', '', _checkedbycontroller,
                            TextInputType.name, [], false, false, context),
                      ],
                    ),
                  ],
                )
              ]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (widget.tabIndex == 0) {
              _monthlyChargerModel.add(MonthlyChargerModel(
                cn: _monthlyChargerManagementDataSource.dataGridRows.length + 1,
                gun1: '',
                gun2: '',
              ));
              _monthlyChargerManagementDataSource.buildDataGridRows();
              _monthlyChargerManagementDataSource.updateDatagridSource();
            } else {
              _monthlyFilterModel.add(MonthlyFilterModel(
                  cn: _monthlyFilterManagementDataSource.dataGridRows.length +
                      1,
                  fcd: '',
                  dgcd: ''));
              _monthlyFilterManagementDataSource.buildDataGridRows();
              _monthlyFilterManagementDataSource.updateDatagridSource();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _fetchUserData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('MonthlyManagementPage')
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
    });
  }

  Future<void> getTableData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('MonthlyManagementPage')
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

void monthlyManagementStoreData(
  BuildContext context,
  String userId,
  String depoName,
  String docName,
  int tabIndex,
  String selectedDate,
  // String time,
  // String refNum,
  // String remark,
  // String checkedBy,
) {
  Map<String, dynamic> tableData = Map();
  List<dynamic> tabledata2 = [];
  dynamic datasource;

  if (tabIndex == 0) {
    datasource = _monthlyChargerManagementDataSource;
  } else {
    datasource = _monthlyFilterManagementDataSource;
  }

  for (var i in datasource.dataGridRows) {
    for (var data in i.getCells()) {
      if (data.columnName != 'Add' && data.columnName != 'Delete') {
        tableData[data.columnName] = data.value;
      }
    }

    tabledata2.add(tableData);
    tableData = {};
  }

  FirebaseFirestore.instance
      .collection('MonthlyManagementPage')
      .doc(depoName)
      .collection('Checklist Name')
      .doc(docName)
      .collection(selectedDate)
      .doc(userId)
      .set({
    'date': selectedDate,
    'time': _timecontroller.text,
    'refNo': _docRefcontroller.text,
    'depotName': depoName,
    'remark': _remarkcontroller.text,
    'checkedBy': _checkedbycontroller.text,
    'data': tabledata2,
  }).whenComplete(() {
    tabledata2.clear();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Data are synced'),
      backgroundColor: blue,
    ));
  });
}
