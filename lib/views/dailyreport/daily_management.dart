import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/views/citiespage/depot.dart';
import 'package:ev_pmis_app/views/dailyreport/summary.dart';
import 'package:ev_pmis_app/widgets/appbar_back_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../components/Loading_page.dart';
import '../../datasource/o&m_datasource/daily_acdbdatasource.dart';
import '../../datasource/o&m_datasource/daily_chargerManagement.dart';
import '../../datasource/o&m_datasource/daily_pssManagement.dart';
import '../../datasource/o&m_datasource/daily_rmudatasource.dart';
import '../../datasource/o&m_datasource/daily_sfudatasource.dart';
import '../../datasource/o&m_datasource/daily_transformerdatasource.dart';
import '../../models/o&m_model/daily_acdb.dart';
import '../../models/o&m_model/daily_charger.dart';
import '../../models/o&m_model/daily_pss.dart';
import '../../models/o&m_model/daily_rmu.dart';
import '../../models/o&m_model/daily_sfu.dart';
import '../../models/o&m_model/daily_transformer.dart';
import '../../provider/summary_provider.dart';
import '../../style.dart';
import '../../utils/daily_managementlist.dart';
import '../../utils/date_formart.dart';
import '../../utils/date_inputFormatter.dart';
import '../../utils/upper_tableHeader.dart';
import '../../widgets/progress_loading.dart';

List<DailySfuModel> _dailySfu = [];
List<DailyChargerModel> _dailycharger = [];
List<DailyPssModel> _dailyPss = [];
List<DailyTransformerModel> _dailyTransfer = [];
List<DailyrmuModel> _dailyrmu = [];
List<DailyAcdbModel> _dailyacdb = [];

late DailySFUManagementDataSource _dailySfuDataSource;
late DailyChargerManagementDataSource _dailyChargerDataSource;
late DailyPssManagementDataSource _dailyPssDataSource;
late DailyTranformerDataSource _dailyTranformerDataSource;
late DailyRmuDataSource _dailyRmuDataSource;
late DailyAcdbManagementDataSource _dailyAcdbdatasource;
late DataGridController _dataGridController;
List<dynamic> tabledata2 = [];
final TextEditingController _remarkController = TextEditingController();
final TextEditingController _checkedbycontroller = TextEditingController();
final TextEditingController _datecontroller = TextEditingController();
final TextEditingController _docRefcontroller = TextEditingController();
final TextEditingController _timecontroller = TextEditingController();
final TextEditingController _depotController = TextEditingController();

class DailyManagementPage extends StatefulWidget {
  String? cityName;
  String? depoName;
  int tabIndex = 0;
  String? tabletitle;
  String? userId;
  bool? isHeader;
  DateTime? startDate;
  DateTime? endDate;

  DailyManagementPage({
    super.key,
    required this.cityName,
    required this.depoName,
    required this.tabIndex,
    required this.tabletitle,
    required this.userId,
    this.isHeader = true,
    this.startDate,
    this.endDate,
  });

  @override
  State<DailyManagementPage> createState() => _DailyManagementPageState();
}

class _DailyManagementPageState extends State<DailyManagementPage> {
  bool isImagesAvailable = false;

  Stream? _stream;
  // ignore: prefer_typing_uninitialized_variables
  var alldata;
  SummaryProvider? _summaryProvider;

  bool _isloading = true;
  List<GridColumn> columns = [];
  String pagetitle = 'Daily Report';
  String? selectedDate = DateFormat.yMMMMd().format(DateTime.now());
  bool checkTable = true;

  @override
  void initState() {
    _initializeData();
    _summaryProvider = Provider.of<SummaryProvider>(context, listen: false);

    super.initState();
  }

  void _initializeData() async {
    await _fetchUserData();

    _stream = FirebaseFirestore.instance
        .collection('DailyManagementPage')
        .doc(widget.depoName)
        .collection('Checklist Name')
        .doc(widget.tabletitle)
        .collection(selectedDate.toString())
        .doc(widget.userId)
        .snapshots();

    getTableData().whenComplete(
      () {
        // ignore: use_build_context_synchronously
        _dailyChargerDataSource = DailyChargerManagementDataSource(
            _dailycharger,
            context,
            widget.cityName!,
            widget.depoName!,
            selectedDate!,
            widget.userId!);

        // ignore: use_build_context_synchronously
        _dailySfuDataSource = DailySFUManagementDataSource(_dailySfu, context,
            widget.cityName!, widget.depoName!, selectedDate!, widget.userId!);
        // ignore: use_build_context_synchronously
        _dailyPssDataSource = DailyPssManagementDataSource(_dailyPss, context,
            widget.cityName!, widget.depoName!, selectedDate!, widget.userId!);

        // ignore: use_build_context_synchronously
        _dailyTranformerDataSource = DailyTranformerDataSource(
            _dailyTransfer,
            context,
            widget.cityName!,
            widget.depoName!,
            selectedDate!,
            widget.userId!);
        // ignore: use_build_context_synchronously
        _dailyRmuDataSource = DailyRmuDataSource(_dailyrmu, context,
            widget.cityName!, widget.depoName!, selectedDate!, widget.userId!);
        _dataGridController = DataGridController();
        // ignore: use_build_context_synchronously
        _dailyAcdbdatasource = DailyAcdbManagementDataSource(
            _dailyacdb,
            context,
            widget.cityName!,
            widget.depoName!,
            selectedDate!,
            widget.userId!);
        _dataGridController = DataGridController();
      },
    );
    // Initialize other data sources and controllers here
  }

  // Define column names and labels for all tabs
  List<List<String>> tabColumnNames = [
    chargercolumnNames,
    sfucolumnNames,
    psscolumnNames,
    transformercolumnNames,
    rmucolumnNames,
    acdbcolumnNames
  ];

  List<List<String>> tabColumnLabels = [
    chargercolumnLabelNames,
    sfucolumnLabelNames,
    psscolumnLabelNames,
    transformerLabelNames,
    rmuLabelNames,
    acdbLabelNames
    // Labels for tab 1
    // Labels for tab 2
  ];
  @override
  Widget build(BuildContext context) {
    List<String> currentColumnNames = tabColumnNames[widget.tabIndex];
    List<String> currentColumnLabels = tabColumnLabels[widget.tabIndex];
    widget.isHeader!
        ? ''
        : _summaryProvider!.fetchManagementDailyData(
            widget.depoName!,
            widget.tabletitle!,
            widget.userId!,
            widget.startDate!,
            widget.endDate!);

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
          width: columnName == 'CN'
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppBarBackDate(
          text: widget.tabletitle!,
          depoName: widget.depoName,
          haveCalender: true,
          haveSummary: true,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewSummary(
                    depoName: widget.depoName,
                    cityName: widget.cityName,
                    userId: widget.userId,
                    tabIndex: widget.tabIndex,
                    titleName: widget.tabletitle,
                    id: 'Daily Management'),
              )),
          haveSynced: true,
          showDate: selectedDate,
          choosedate: () {
            chooseDate(context);
          },
          store: () {
            showProgressDilogue(context);
            dailyManagementStoreData(context, widget.userId!, widget.depoName!,
                widget.tabletitle!, widget.tabIndex, selectedDate!);
          },
        ),
      ),
      body: _isloading
          ? const LoadingPage()
          : SingleChildScrollView(
              child: Column(children: [
                widget.isHeader!
                    ? Padding(
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
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      customText(
                                          'Document Reference Number:',
                                          'DCASK12354',
                                          _docRefcontroller,
                                          TextInputType.name,
                                          [],
                                          false,
                                          false,
                                          context),
                                      customText(
                                          'Bus Depot Name:',
                                          widget.depoName!,
                                          _depotController,
                                          TextInputType.name,
                                          [],
                                          false,
                                          true,
                                          context),
                                    ],
                                  ),
                                ])))
                    : Container(),
                Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SfDataGridTheme(
                        data: SfDataGridThemeData(
                            headerColor: white, gridLineColor: blue),
                        child: SingleChildScrollView(
                          child: StreamBuilder(
                              stream: _stream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data.exists == false) {
                                  if (widget.tabIndex == 0) {
                                    _dailycharger.clear();
                                  } else if (widget.tabIndex == 1) {
                                    _dailySfu.clear();
                                  } else if (widget.tabIndex == 2) {
                                    _dailyPss.clear();
                                  } else if (widget.tabIndex == 3) {
                                    _dailyTransfer.clear();
                                  } else if (widget.tabIndex == 4) {
                                    _dailyrmu.clear();
                                  } else {
                                    _dailyacdb.clear();
                                  }

                                  return SfDataGrid(
                                      source: widget.tabIndex == 0
                                          ? _dailyChargerDataSource
                                          : widget.tabIndex == 1
                                              ? _dailySfuDataSource
                                              : widget.tabIndex == 2
                                                  ? _dailyPssDataSource
                                                  : widget.tabIndex == 3
                                                      ? _dailyTranformerDataSource
                                                      : widget.tabIndex == 4
                                                          ? _dailyRmuDataSource
                                                          : _dailyAcdbdatasource,
                                      allowEditing: true,
                                      frozenColumnsCount: 1,
                                      gridLinesVisibility:
                                          GridLinesVisibility.both,
                                      headerGridLinesVisibility:
                                          GridLinesVisibility.both,
                                      selectionMode: SelectionMode.single,
                                      navigationMode: GridNavigationMode.cell,
                                      columnWidthMode:
                                          ColumnWidthMode.fitByCellValue,
                                      editingGestureType:
                                          EditingGestureType.tap,
                                      rowHeight: 50,
                                      controller: _dataGridController,
                                      onQueryRowHeight: (details) {
                                        return details.getIntrinsicRowHeight(
                                            details.rowIndex);
                                      },
                                      columns: columns);
                                } else {
                                  return SfDataGrid(
                                      source: widget.tabIndex == 0
                                          ? _dailyChargerDataSource
                                          : widget.tabIndex == 1
                                              ? _dailySfuDataSource
                                              : widget.tabIndex == 2
                                                  ? _dailyPssDataSource
                                                  : widget.tabIndex == 3
                                                      ? _dailyTranformerDataSource
                                                      : widget.tabIndex == 4
                                                          ? _dailyRmuDataSource
                                                          : _dailyAcdbdatasource,
                                      allowEditing: true,
                                      frozenColumnsCount: 2,
                                      gridLinesVisibility:
                                          GridLinesVisibility.both,
                                      headerGridLinesVisibility:
                                          GridLinesVisibility.both,
                                      selectionMode: SelectionMode.single,
                                      navigationMode: GridNavigationMode.cell,
                                      editingGestureType:
                                          EditingGestureType.tap,
                                      rowHeight: 50,
                                      controller: _dataGridController,
                                      onQueryRowHeight: (details) {
                                        return details.getIntrinsicRowHeight(
                                            details.rowIndex);
                                      },
                                      columns: columns);
                                }
                              }),
                        ))),
                widget.isHeader!
                    ? tableFooter(_remarkController)
                    : Visibility(
                        visible: false,
                        child: Container(),
                      ),
                widget.isHeader!
                    ? Row(children: [
                        Column(
                          children: [
                            customText('Checked by:', '', _checkedbycontroller,
                                TextInputType.name, [], false, false, context)
                          ],
                        ),
                      ])
                    : Visibility(
                        visible: false,
                        child: Container(),
                      )
              ]),
            ),
      floatingActionButton: widget.isHeader!
          ? FloatingActionButton(
              onPressed: (() {
                if (widget.tabIndex == 0) {
                  _dailycharger.add(DailyChargerModel(
                      cn: _dailyChargerDataSource.dataGridRows.length + 1,
                      dc: '',
                      cgca: '',
                      cgcb: '',
                      cgcca: '',
                      cgccb: '',
                      dl: '',
                      arm: '',
                      ec: '',
                      cc: ''));
                  _dataGridController = DataGridController();
                  _dailyChargerDataSource.buildDataGridRows();
                  _dailyChargerDataSource.updateDatagridSource();
                } else if (widget.tabIndex == 1) {
                  _dailySfu.add(DailySfuModel(
                      sfuNo: _dailySfuDataSource.dataGridRows.length + 1,
                      fuc: '',
                      icc: 'icc',
                      ictc: 'ictc',
                      occ: 'occ',
                      octc: 'octc',
                      ec: 'ec',
                      cg: 'cg',
                      dl: 'dl',
                      vi: 'vi'));
                  _dataGridController = DataGridController();
                  _dailySfuDataSource.buildDataGridRows();
                  _dailySfuDataSource.updateDatagridSource();
                } else if (widget.tabIndex == 2) {
                  _dailyPss.add(DailyPssModel(
                      pssNo: _dailyPssDataSource.dataGridRows.length + 1,
                      pbc: '',
                      ec: '',
                      sgp: '',
                      pdl: '',
                      wtiTemp: '',
                      otiTemp: '',
                      vpiPresence: '',
                      viMCCb: '',
                      vr: '',
                      ar: '',
                      mccbHandle: ''));
                  _dataGridController = DataGridController();
                  _dailyPssDataSource.buildDataGridRows();
                  _dailyPssDataSource.updateDatagridSource();
                } else if (widget.tabIndex == 3) {
                  _dailyTransfer.add(DailyTransformerModel(
                      trNo: _dailyTranformerDataSource.dataGridRows.length + 1,
                      pc: '',
                      ec: '',
                      ol: '',
                      oc: '',
                      wtiTemp: '',
                      otiTemp: '',
                      brk: '',
                      cta: ''));
                  _dataGridController = DataGridController();
                  _dailyTranformerDataSource.buildDataGridRows();
                  _dailyTranformerDataSource.updateDatagridSource();
                } else if (widget.tabIndex == 4) {
                  _dailyrmu.add(DailyrmuModel(
                      rmuNo: _dailyRmuDataSource.dataGridRows.length + 1,
                      sgp: '',
                      vpi: '',
                      crd: '',
                      rec: '',
                      arm: '',
                      cbts: '',
                      cra: ''));
                  _dataGridController = DataGridController();
                  _dailyRmuDataSource.buildDataGridRows();
                  _dailyRmuDataSource.updateDatagridSource();
                } else {
                  _dailyacdb.add(DailyAcdbModel(
                      incomerNo: _dailyAcdbdatasource.dataGridRows.length + 1,
                      vi: '',
                      vr: '',
                      ar: '',
                      acdbSwitch: '',
                      mccbHandle: '',
                      ccb: '',
                      arm: ''));
                  _dataGridController = DataGridController();
                  _dailyAcdbdatasource.buildDataGridRows();
                  _dailyAcdbdatasource.updateDatagridSource();
                }
              }),
              child: const Icon(Icons.add))
          : Container(),
    );
  }

  Future<void> getTableData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('DailyManagementPage')
        .doc(widget.depoName)
        .collection('Checklist Name')
        .doc(widget.tabletitle)
        .collection(selectedDate.toString())
        .doc(widget.userId)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> tempData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapData = tempData['data'];
      print(mapData);

      List<String> titleName = [
        'Charger Checklist',
        'SFU Checklist',
        'PSS Checklist',
        'Transformer Checklist',
        'RMU Checklist',
        'ACDB Checklist',
      ];
      if (widget.tabIndex == 0) {
        _dailycharger =
            mapData.map((map) => DailyChargerModel.fromjson(map)).toList();
      } else if (widget.tabIndex == 1) {
        _dailySfu = mapData.map((map) => DailySfuModel.fromjson(map)).toList();
      } else if (widget.tabIndex == 2) {
        _dailyPss = mapData.map((map) => DailyPssModel.fromjson(map)).toList();
      } else if (widget.tabIndex == 3) {
        _dailyTransfer =
            mapData.map((map) => DailyTransformerModel.fromjson(map)).toList();
      } else if (widget.tabIndex == 4) {
        _dailyrmu = mapData.map((map) => DailyrmuModel.fromjson(map)).toList();
      } else {
        _dailyacdb =
            mapData.map((map) => DailyAcdbModel.fromjson(map)).toList();
      }
      checkTable = false;
      setState(() {});
    } else {
      if (widget.tabIndex == 0) {
        _dailycharger.clear();
      } else if (widget.tabIndex == 1) {
        _dailySfu.clear();
      } else if (widget.tabIndex == 2) {
        _dailyPss.clear();
      } else if (widget.tabIndex == 3) {
        _dailyTransfer.clear();
      } else if (widget.tabIndex == 4) {
        _dailyrmu.clear();
      } else {
        _dailyacdb.clear();
      }
    }
    _isloading = false;
    setState(() {});
  }

  void chooseDate(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              // title: const Text('All Date'),
              content: Container(
                  height: 400,
                  width: 500,
                  child: SfDateRangePicker(
                    view: DateRangePickerView.month,
                    showTodayButton: false,
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      // if (args.value is PickerDateRange) {
                      //   // rangeStartDate = args.value.startDate;
                      //   // rangeEndDate = args.value.endDate;
                      // } else {
                      //   final List<PickerDateRange> selectedRanges = args.value;
                      // }
                    },
                    selectionMode: DateRangePickerSelectionMode.single,
                    showActionButtons: true,
                    onSubmit: ((value) {
                      selectedDate = DateFormat.yMMMMd()
                          .format(DateTime.parse(value.toString()));
                      Navigator.pop(context);

                      setState(() {});
                    }),
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  )),
            ));
  }

  _fetchUserData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('DailyManagementPage')
        .doc(widget.depoName)
        .collection('Checklist Name')
        .doc(widget.tabletitle)
        .collection(selectedDate.toString())
        .doc(widget.userId)
        .get();

    if (snapshot.exists) {
      _datecontroller.text = snapshot.data()!['Date'] ?? '';
      _docRefcontroller.text = snapshot.data()!['DocRef'] ?? '';
      _timecontroller.text = snapshot.data()!['Time'] ?? '';
      _depotController.text = snapshot.data()!['DepotName'] ?? '';
      _checkedbycontroller.text = snapshot.data()!['checkedby'];
      _remarkController.text = snapshot.data()!['remark'];
    } else {
      _depotController.text = widget.depoName.toString();
      _datecontroller.text = ddmmyyyy;
      _timecontroller.text = ttmmss;
      _docRefcontroller.clear();
      _checkedbycontroller.clear();
      _remarkController.clear();
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
}

void dailyManagementStoreData(BuildContext context, String userId,
    String depoName, String docName, int tabIndex, String selectedDate) {
  Map<String, dynamic> tableData = Map();
  dynamic datasource;

  if (tabIndex == 0) {
    datasource = _dailyChargerDataSource;
  } else if (tabIndex == 1) {
    datasource = _dailySfuDataSource;
  } else if (tabIndex == 2) {
    datasource = _dailyPssDataSource;
  } else if (tabIndex == 3) {
    datasource = _dailyTranformerDataSource;
  } else if (tabIndex == 4) {
    datasource = _dailyRmuDataSource;
  } else {
    datasource = _dailyAcdbdatasource;
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
      .collection('DailyManagementPage')
      .doc(depoName)
      .collection('Checklist Name')
      .doc(docName)
      .collection(selectedDate.toString())
      .doc(userId)
      .set({
    'Date': _datecontroller.text,
    'DocRef': _docRefcontroller.text,
    'Time': _timecontroller.text,
    'DepotName': _depotController.text,
    'remark': _remarkController.text,
    'checkedby': _checkedbycontroller.text,
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
