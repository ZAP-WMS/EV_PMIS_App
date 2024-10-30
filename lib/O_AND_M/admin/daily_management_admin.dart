import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/PMIS/summary.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../components/Loading_page.dart';
import '../../PMIS/widgets/admin_custom_appbar.dart';
import '../../PMIS/widgets/navbar.dart';
import '../../components/loading_pdf.dart';
import '../o&m_datasource/daily_acdbdatasource.dart';
import '../o&m_datasource/daily_chargerManagement.dart';
import '../o&m_datasource/daily_pssManagement.dart';
import '../o&m_datasource/daily_rmudatasource.dart';
import '../o&m_datasource/daily_sfudatasource.dart';
import '../o&m_datasource/daily_transformerdatasource.dart';
import '../o&m_model/daily_acdb.dart';
import '../o&m_model/daily_charger.dart';
import '../o&m_model/daily_pss.dart';
import '../o&m_model/daily_rmu.dart';
import '../o&m_model/daily_sfu.dart';
import '../o&m_model/daily_transformer.dart';
import '../../../PMIS/provider/summary_provider.dart';
import '../../../style.dart';
import '../../../utils/daily_managementlist.dart';
import '../../../utils/date_formart.dart';
import '../../../PMIS/widgets/progress_loading.dart';
import '../user/dailyreport/daily_management.dart';
import '../user/dailyreport/daily_management_home.dart';
import 'package:pdf/widgets.dart' as pw;

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

List<dynamic> availableUserId = [];
List<int> globalIndexList = [];

class DailyManagementAdminPage extends StatefulWidget {
  String? cityName;
  String? depoName;
  int tabIndex = 0;
  String? tabletitle;
  String? userId;
  bool? isHeader;
  DateTime? startDate;
  DateTime? endDate;
  String role;

  DailyManagementAdminPage(
      {super.key,
      required this.cityName,
      required this.depoName,
      required this.tabIndex,
      required this.tabletitle,
      required this.userId,
      this.isHeader = true,
      this.startDate,
      this.endDate,
      required this.role});

  @override
  State<DailyManagementAdminPage> createState() =>
      _DailyManagementAdminPageState();
}

class _DailyManagementAdminPageState extends State<DailyManagementAdminPage> {
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
  DateTime? startdate = DateTime.now();
  DateTime? enddate = DateTime.now();
  DateTime? rangestartDate;
  DateTime? rangeEndDate;
  List<dynamic> chosenDateList = [];
  Map<String, dynamic> useridWithData = {};
  List id = [];
  ProgressDialog? pr;
  String pathToOpenFile = '';
  Uint8List? pdfData;
  String? pdfPath;

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
        _dailyChargerDataSource = DailyChargerManagementDataSource(
            _dailycharger,
            context,
            widget.cityName!,
            widget.depoName!,
            selectedDate!,
            widget.userId!);

        _dailySfuDataSource = DailySFUManagementDataSource(_dailySfu, context,
            widget.cityName!, widget.depoName!, selectedDate!, widget.userId!);

        _dailyPssDataSource = DailyPssManagementDataSource(_dailyPss, context,
            widget.cityName!, widget.depoName!, selectedDate!, widget.userId!);

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
        setState(() {
          _isloading = false;
        });
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

  getAllData() {
    // dailyProject.clear();
    // id.clear();
    getTableData().whenComplete(
      () {
        nestedTableData(context).whenComplete(
          () {
            _dailyChargerDataSource = DailyChargerManagementDataSource(
                _dailycharger,
                context,
                widget.cityName!,
                widget.depoName!,
                selectedDate!,
                widget.userId!);

            _dailySfuDataSource = DailySFUManagementDataSource(
                _dailySfu,
                context,
                widget.cityName!,
                widget.depoName!,
                selectedDate!,
                widget.userId!);

            _dailyPssDataSource = DailyPssManagementDataSource(
                _dailyPss,
                context,
                widget.cityName!,
                widget.depoName!,
                selectedDate!,
                widget.userId!);

            _dailyTranformerDataSource = DailyTranformerDataSource(
                _dailyTransfer,
                context,
                widget.cityName!,
                widget.depoName!,
                selectedDate!,
                widget.userId!);
            // ignore: use_build_context_synchronously
            _dailyRmuDataSource = DailyRmuDataSource(
                _dailyrmu,
                context,
                widget.cityName!,
                widget.depoName!,
                selectedDate!,
                widget.userId!);
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
            setState(() {
              _isloading = false;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // getTableData()
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
          visible: !(columnName == currentColumnNames   [0]),
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
        drawer: NavbarDrawer(role: widget.role),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            isProjectManager: widget.role == "projectManager" ? true : false,
            makeAnEntryPage: DailyManagementPage(
                cityName: widget.cityName,
                role: widget.role,
                depoName: widget.depoName,
                tabIndex: widget.tabIndex,
                tabletitle: widget.tabletitle,
                userId: widget.userId),
            showDepoBar: true,
            toDaily: true,
            depoName: widget.depoName,
            cityName: widget.cityName,
            text: 'Daily Report',
            userId: widget.userId,
            haveSynced: false,
            //specificUser ? true : false,
            isdownload: false,
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
              showProgressDilogue(context);
              dailyManagementStoreData(
                  context,
                  widget.userId!,
                  widget.depoName!,
                  widget.tabletitle!,
                  widget.tabIndex,
                  selectedDate!);
            },
            
          ),
          
        ),
        body: _isloading
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
                          width: MediaQuery.of(context).size.width * 0.5,
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
                                          // title: const Text('choose Date'),
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
                                                      rangestartDate
                                                          .toString());
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
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          width: 150,
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
                        return Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Expanded(
                              child: SfDataGridTheme(
                                  data: SfDataGridThemeData(
                                      headerColor: white, gridLineColor: blue),
                                  child: StreamBuilder(
                                      stream: _stream,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData ||
                                            snapshot.data.exists == false) {
                                          return SfDataGrid(
                                              source: widget.tabIndex == 0
                                                  ? _dailyChargerDataSource
                                                  : widget.tabIndex == 1
                                                      ? _dailySfuDataSource
                                                      : widget.tabIndex == 2
                                                          ? _dailyPssDataSource
                                                          : widget.tabIndex == 3
                                                              ? _dailyTranformerDataSource
                                                              : widget.tabIndex ==
                                                                      4
                                                                  ? _dailyRmuDataSource
                                                                  : _dailyAcdbdatasource,
                                              allowEditing: false,
                                              frozenColumnsCount: 1,
                                              gridLinesVisibility:
                                                  GridLinesVisibility.both,
                                              headerGridLinesVisibility:
                                                  GridLinesVisibility.both,
                                              selectionMode:
                                                  SelectionMode.single,
                                              navigationMode:
                                                  GridNavigationMode.cell,
                                              columnWidthMode: ColumnWidthMode
                                                  .fitByCellValue,
                                              editingGestureType:
                                                  EditingGestureType.tap,
                                              rowHeight: 50,
                                              controller: _dataGridController,
                                              onQueryRowHeight: (details) {
                                                return details
                                                    .getIntrinsicRowHeight(
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
                                                              : widget.tabIndex ==
                                                                      4
                                                                  ? _dailyRmuDataSource
                                                                  : _dailyAcdbdatasource,
                                              allowEditing: false,
                                              frozenColumnsCount: 2,
                                              gridLinesVisibility:
                                                  GridLinesVisibility.both,
                                              headerGridLinesVisibility:
                                                  GridLinesVisibility.both,
                                              selectionMode:
                                                  SelectionMode.single,
                                              navigationMode:
                                                  GridNavigationMode.cell,
                                              editingGestureType:
                                                  EditingGestureType.tap,
                                              rowHeight: 50,
                                              controller: _dataGridController,
                                              onQueryRowHeight: (details) {
                                                return details
                                                    .getIntrinsicRowHeight(
                                                        details.rowIndex);
                                              },
                                              columns: columns);
                                        }
                                      })),
                            ));
                      } else {
                        // print(_dailyDataSource.rows[0]
                        //     .getCells()
                        //     .length);
                        return const Text('data 1');
                        //   const NodataAvailable();
                      }
                    },
                  ),
                )
              ]));
  }

  Future<void> nestedTableData(BuildContext pageContext) async {
    globalIndexList.clear();
    availableUserId.clear();
    chosenDateList.clear();

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

    useridWithData.clear();
    for (DateTime initialdate = startdate!;
        initialdate.isBefore(enddate!.add(const Duration(days: 1)));
        initialdate = initialdate.add(const Duration(days: 1))) {
      // useridWithData.clear();
      print(initialdate);

      String nextDate = DateFormat.yMMMMd().format(initialdate);

      QuerySnapshot userIdQuery = await FirebaseFirestore.instance
          .collection('DailyManagementPage')
          .doc(widget.depoName)
          .collection('Checklist Name')
          .doc(widget.tabletitle)
          .collection(nextDate)
          .get();

      List<dynamic> userList = userIdQuery.docs.map((e) => e.id).toList();

      for (int i = 0; i < userList.length; i++) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('DailyManagementPage')
            .doc(widget.depoName)
            .collection('Checklist Name')
            .doc(widget.tabletitle)
            .collection(nextDate)
            .doc(userList[i])
            .get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> tempData =
              documentSnapshot.data() as Map<String, dynamic>;

          List<dynamic> mapData = tempData['data'];

          if (widget.tabIndex == 0) {
            _dailycharger.addAll(
                mapData.map((map) => DailyChargerModel.fromjson(map)).toList());
            print('date data $nextDate');
            print(mapData);
            // _dailycharger =
            //     mapData.map((map) => DailyChargerModel.fromjson(map)).toList();
          } else if (widget.tabIndex == 1) {
            _dailySfu.addAll(
                mapData.map((map) => DailySfuModel.fromjson(map)).toList());

            // _dailySfu =
            //     mapData.map((map) => DailySfuModel.fromjson(map)).toList();
          } else if (widget.tabIndex == 2) {
            _dailyPss.addAll(
                mapData.map((map) => DailyPssModel.fromjson(map)).toList());
            // _dailyPss =
            //     mapData.map((map) => DailyPssModel.fromjson(map)).toList();
          } else if (widget.tabIndex == 3) {
            _dailyTransfer.addAll(mapData
                .map((map) => DailyTransformerModel.fromjson(map))
                .toList());
            // _dailyTransfer = mapData
            //     .map((map) => DailyTransformerModel.fromjson(map))
            //     .toList();
          } else if (widget.tabIndex == 4) {
            _dailyrmu.addAll(
                mapData.map((map) => DailyrmuModel.fromjson(map)).toList());
            // _dailyrmu =
            //     mapData.map((map) => DailyrmuModel.fromjson(map)).toList();
          } else {
            _dailyacdb.addAll(
                mapData.map((map) => DailyAcdbModel.fromjson(map)).toList());
            // _dailyacdb =
            //     mapData.map((map) => DailyAcdbModel.fromjson(map)).toList();
          }
          checkTable = false;
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
        pr.hide();
      }

      print('global indexes are - $globalIndexList');
    }
  }

  Future<void> getTableData() async {
    await FirebaseFirestore.instance
        .collection('DailyManagementPage')
        .doc(widget.depoName)
        .collection('Checklist Name')
        .doc(widget.tabletitle)
        .collection(selectedDate.toString())
        .get()
        .then((value) {
      value.docs.forEach((element) {
        String documentId = element.id;
        id.add(documentId);
      });
    });

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

                      setState(() {
                        nestedTableData(context).whenComplete(
                          () {
                            _dailyChargerDataSource =
                                DailyChargerManagementDataSource(
                                    _dailycharger,
                                    context,
                                    widget.cityName!,
                                    widget.depoName!,
                                    selectedDate!,
                                    widget.userId!);

                            _dailySfuDataSource = DailySFUManagementDataSource(
                                _dailySfu,
                                context,
                                widget.cityName!,
                                widget.depoName!,
                                selectedDate!,
                                widget.userId!);

                            _dailyPssDataSource = DailyPssManagementDataSource(
                                _dailyPss,
                                context,
                                widget.cityName!,
                                widget.depoName!,
                                selectedDate!,
                                widget.userId!);

                            _dailyTranformerDataSource =
                                DailyTranformerDataSource(
                                    _dailyTransfer,
                                    context,
                                    widget.cityName!,
                                    widget.depoName!,
                                    selectedDate!,
                                    widget.userId!);
                            // ignore: use_build_context_synchronously
                            _dailyRmuDataSource = DailyRmuDataSource(
                                _dailyrmu,
                                context,
                                widget.cityName!,
                                widget.depoName!,
                                selectedDate!,
                                widget.userId!);
                            _dataGridController = DataGridController();
                            // ignore: use_build_context_synchronously
                            _dailyAcdbdatasource =
                                DailyAcdbManagementDataSource(
                                    _dailyacdb,
                                    context,
                                    widget.cityName!,
                                    widget.depoName!,
                                    selectedDate!,
                                    widget.userId!);
                            _dataGridController = DataGridController();
                            setState(() {
                              _isloading = false;
                            });
                          },
                        );
                      });
                    }),
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  )),
            ));
  }

  _fetchUserData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('DailyManagementAdminPage')
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

  Future<void> downloadPDF() async {
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

    final headers = [
      'Sr No',
      'Date',
      'Type of Activity',
      'Activity Details',
      'Progress',
      'Remark / Status',
      'Image1',
      'Image2',
    ];

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
    List<pw.Widget> imageUrls = [];

    // for (int i = 0; i < dailyProject.length; i++) {
    //   String imagesPath =
    //       '/Daily Report/${widget.cityName}/${widget.depoName}/${availableUserId[i]}/${chosenDateList[i]}/${globalIndexList[i]}';

    //   ListResult result =
    //       await FirebaseStorage.instance.ref().child(imagesPath).listAll();

    //   if (result.items.isNotEmpty) {
    //     for (var image in result.items) {
    //       String downloadUrl = await image.getDownloadURL();
    //       if (image.name.endsWith('.pdf')) {
    //         imageUrls.add(
    //           pw.Container(
    //               width: 60,
    //               alignment: pw.Alignment.center,
    //               padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
    //               child: pw.UrlLink(
    //                   child: pw.Text(image.name,
    //                       style: const pw.TextStyle(color: PdfColors.blue)),
    //                   destination: downloadUrl)),
    //         );
    //       } else {
    //         final myImage = await networkImage(downloadUrl);
    //         imageUrls.add(
    //           pw.Container(
    //               padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
    //               width: 60,
    //               height: 80,
    //               child: pw.Center(
    //                 child: pw.Image(myImage),
    //               )),
    //         );
    //       }
    //     }

    //     if (imageUrls.length < 2) {
    //       int imageLoop = 2 - imageUrls.length;
    //       for (int i = 0; i < imageLoop; i++) {
    //         imageUrls.add(
    //           pw.Container(
    //               padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
    //               width: 60,
    //               height: 80,
    //               child: pw.Text('')),
    //         );
    //       }
    //     } else if (imageUrls.length > 2) {
    //       int imageLoop = 10 - imageUrls.length;
    //       for (int i = 0; i < imageLoop; i++) {
    //         imageUrls.add(
    //           pw.Container(
    //               padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
    //               width: 80,
    //               height: 100,
    //               child: pw.Text('')),
    //         );
    //       }
    //     }
    //   } else {
    //     for (int i = 0; i < 2; i++) {
    //       imageUrls.add(
    //         pw.Container(
    //             padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
    //             width: 60,
    //             height: 80,
    //             child: pw.Text('')),
    //       );
    //     }
    //   }
    //   result.items.clear();

    //   //Text Rows of PDF Table
    //   rows.add(pw.TableRow(children: [
    //     pw.Container(
    //         padding: const pw.EdgeInsets.all(3.0),
    //         child: pw.Center(
    //             child: pw.Text((i + 1).toString(),
    //                 style: const pw.TextStyle(fontSize: 14)))),
    //     pw.Container(
    //         padding: const pw.EdgeInsets.all(2.0),
    //         child: pw.Center(
    //             child: pw.Text(dailyProject[i].date.toString(),
    //                 style: const pw.TextStyle(fontSize: 14)))),
    //     pw.Container(
    //         padding: const pw.EdgeInsets.all(2.0),
    //         child: pw.Center(
    //             child: pw.Text(dailyProject[i].typeOfActivity.toString(),
    //                 style: const pw.TextStyle(fontSize: 14)))),
    //     pw.Container(
    //         padding: const pw.EdgeInsets.all(2.0),
    //         child: pw.Center(
    //             child: pw.Text(dailyProject[i].activityDetails.toString(),
    //                 style: const pw.TextStyle(fontSize: 14)))),
    //     pw.Container(
    //         padding: const pw.EdgeInsets.all(2.0),
    //         child: pw.Center(
    //             child: pw.Text(dailyProject[i].progress.toString(),
    //                 style: const pw.TextStyle(fontSize: 14)))),
    //     pw.Container(
    //         padding: const pw.EdgeInsets.all(2.0),
    //         child: pw.Center(
    //             child: pw.Text(dailyProject[i].status.toString(),
    //                 style: const pw.TextStyle(fontSize: 14)))),
    //     imageUrls[0],
    //     imageUrls[1]
    //   ]));

    //   if (imageUrls.length - 2 > 0) {
    //     //Image Rows of PDF Table
    //     rows.add(pw.TableRow(children: [
    //       pw.Container(
    //           padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
    //           child: pw.Text('')),
    //       pw.Container(
    //           padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
    //           width: 60,
    //           height: 100,
    //           child: pw.Row(
    //               mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    //               children: [
    //                 imageUrls[2],
    //                 imageUrls[3],
    //               ])),
    //       imageUrls[4],
    //       imageUrls[5],
    //       imageUrls[6],
    //       imageUrls[7],
    //       imageUrls[8],
    //       imageUrls[9]
    //     ]));
    //   }
    //   imageUrls.clear();
    // }

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

  Future<File> savePDFToFile(Uint8List pdfData, String fileName) async {
    final documentDirectory = (await DownloadsPath.downloadsDirectory())?.path;
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
      .collection('DailyManagementAdminPage')
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
