import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/PMIS/user/screen/safetyfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../components/Loading_page.dart';
import '../../../o&m_datasource/monthly_chargerdatasource.dart';
import '../../../o&m_datasource/monthly_filter.dart';
import '../../../o&m_model/monthly_charger.dart';
import '../../../o&m_model/monthly_filter.dart';
import '../../../../style.dart';
import '../../../../utils/daily_managementlist.dart';
import '../../../../utils/date_formart.dart';
import '../../../../utils/date_inputFormatter.dart';
import '../../../../utils/upper_tableHeader.dart';

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
  int titleIndex;
  String? tabletitle;
  String userId;
  String? date;
  MonthlyManagementPage({
    super.key,
    required this.cityName,
    required this.depoName,
    required this.titleIndex,
    required this.tabletitle,
    required this.userId,
    required this.date,
  });

  @override
  State<MonthlyManagementPage> createState() => _MonthlyManagementPageState();
}

class _MonthlyManagementPageState extends State<MonthlyManagementPage> {
  // String? widget.date = DateFormat.yMMM().format(DateTime.now());
  List<GridColumn> columns = [];
  bool _isloading = true;
  Stream? _stream;

  late DataGridController _dataGridController;

  @override
  void initState() {
    print('initial Index ${widget.titleIndex}');
    _monthlyChargerModel = [];
    _monthlyFilterModel = [];
    _stream = FirebaseFirestore.instance
        .collection('MonthlyManagementPage')
        .doc('${widget.depoName}')
        .collection(widget.date.toString())
        .doc(widget.userId)
        .snapshots();

    _dataGridController = DataGridController();
    // getUserId().whenComplete(() {
    _fetchUserData();
    _monthlyChargerManagementDataSource = MonthlyChargerManagementDataSource(
        _monthlyChargerModel,
        context,
        widget.cityName!,
        widget.depoName!,
        widget.date!,
        widget.userId);
    _monthlyFilterManagementDataSource = MonthlyFilterManagementDataSource(
        _monthlyFilterModel,
        context,
        widget.cityName!,
        widget.depoName!,
        widget.date!,
        widget.userId);
    _dataGridController = DataGridController();
    getTableData().whenComplete(() {
      _monthlyChargerManagementDataSource = MonthlyChargerManagementDataSource(
          _monthlyChargerModel,
          context,
          widget.cityName!,
          widget.depoName!,
          widget.date!,
          widget.userId);
      _monthlyFilterManagementDataSource = MonthlyFilterManagementDataSource(
          _monthlyFilterModel,
          context,
          widget.cityName!,
          widget.depoName!,
          widget.date!,
          widget.userId);

      _dataGridController = DataGridController();
    });
    _isloading = false;
    setState(() {});

    super.initState();
  }

  List<List<String>> tabColumnNames = [
    monthlyChargerColumnName,
    monthlyFilterColumnName
  ];

  List<List<String>> tabColumnLabels = [
    monthlyLabelColumnName,
    monthlyFilterLabelColumnName,
  ];
  @override
  Widget build(BuildContext context) {
    List<String> currentColumnNames = tabColumnNames[widget.titleIndex];
    List<String> currentColumnLabels = tabColumnLabels[widget.titleIndex];

    columns.clear();
    for (String columnName in currentColumnNames) {
      columns.add(
        GridColumn(
          columnName: columnName,
          visible: true,
          allowEditing: columnName == 'Add' ||
                  columnName == 'Delete' ||
                  columnName == columnName[0] ||
                  columnName == 'date'
              ? false
              : true,
          width: columnName == 'cn'
              ? MediaQuery.of(context).size.width * 0.2
              : MediaQuery.of(context).size.width *
                  0.38, // You can adjust this width as needed
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
                                          'Depo Name',
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
                              source: widget.titleIndex == 0
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
                              source: widget.titleIndex == 0
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
          if (widget.titleIndex == 0) {
            _monthlyChargerModel.add(MonthlyChargerModel(
              date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              cn: _monthlyChargerManagementDataSource.dataGridRows.length + 1,
              gun1: '',
              gun2: '',
            ));

            _dataGridController = DataGridController();
            _monthlyChargerManagementDataSource.buildDataGridRows();
            _monthlyChargerManagementDataSource.updateDatagridSource();
          } else {
            _monthlyFilterModel.add(MonthlyFilterModel(
                cn: _monthlyFilterManagementDataSource.dataGridRows.length + 1,
                date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                fcd: '',
                dgcd: ''));

            _dataGridController = DataGridController();
            _monthlyFilterManagementDataSource.buildDataGridRows();
            _monthlyFilterManagementDataSource.updateDatagridSource();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _fetchUserData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Avoid calling setState if the widget is already disposed
      if (mounted) {
        setState(() {
          // Set the initial value of the controller after fetching user data
          _depotController.text = widget.depoName.toString();
        });
      }
    });
    final snapshot = await FirebaseFirestore.instance
        .collection('MonthlyManagementPage')
        .doc(widget.depoName)
        .collection('Checklist Name')
        .doc(widget.tabletitle)
        .collection(widget.date.toString())
        .doc(widget.userId)
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

  Future<void> getTableData() async {
    print('Fetching data for date: ${widget.date.toString()}');

    // Show loading indicator or something else if necessary
    setState(() {
      checkTable = true; // show loading state
    });

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('MonthlyManagementPage')
          .doc(widget.depoName)
          .collection('Checklist Name')
          .doc(widget.tabletitle)
          .collection(widget.date.toString())
          .doc(widget.userId)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> tempData =
            documentSnapshot.data() as Map<String, dynamic>;
        List<dynamic> mapData = tempData['data'];

        // Clear old data before adding new data
        _monthlyChargerModel.clear();
        _monthlyFilterModel.clear();

        if (widget.tabletitle == 'Charger Reading Format') {
          _monthlyChargerModel.addAll(
              mapData.map((map) => MonthlyChargerModel.fromjson(map)).toList());
        } else {
          _monthlyFilterModel.addAll(
              mapData.map((map) => MonthlyFilterModel.fromjson(map)).toList());
        }

        setState(() {
          checkTable = false; // hide loading state
        });
      } else {
        // Handle case where data doesn't exist for the selected date
        print("No data found for date: ${widget.date.toString()}");
        setState(() {
          checkTable = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        checkTable = false; // hide loading state on error
      });
    }
  }

  // Future<void> getTableData() async {
  //   print('date${widget.date.toString()}');
  //   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //       .collection('MonthlyManagementPage')
  //       .doc(widget.depoName)
  //       .collection('Checklist Name')
  //       .doc(widget.tabletitle)
  //       .collection(widget.date.toString())
  //       .doc(widget.userId)
  //       .get();

  //   if (documentSnapshot.exists) {
  //     Map<String, dynamic> tempData =
  //         documentSnapshot.data() as Map<String, dynamic>;

  //     List<dynamic> mapData = tempData['data'];

  //     if (widget.tabletitle == 'Charger Reading Format') {
  //       _monthlyChargerModel.addAll(
  //           mapData.map((map) => MonthlyChargerModel.fromjson(map)).toList());
  //     } else {
  //       _monthlyFilterModel.addAll(
  //           mapData.map((map) => MonthlyFilterModel.fromjson(map)).toList());
  //     }
  //     checkTable = false;
  //     setState(() {});
  //   }
  // }
}

void monthlyManagementStoreData(
  BuildContext context,
  String userId,
  String depoName,
  String docName,
  int tabIndex,
  String date,
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
      .collection(date)
      .doc(userId)
      .set({
    'date': date,
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
