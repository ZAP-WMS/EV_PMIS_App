import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/O_AND_M/o&m_datasource/daily_acdb_ManagementAdmin.dart';
import 'package:ev_pmis_app/O_AND_M/o&m_datasource/daily_pssManagementAdmin.dart';
import 'package:ev_pmis_app/PMIS/widgets/nodata_available.dart';
import 'package:ev_pmis_app/model_admin/daily_transfer_admin.dart';
import 'package:ev_pmis_app/PMIS/summary.dart';
import 'package:ev_pmis_app/model_admin/daily_acdb_admin_model.dart';
import 'package:ev_pmis_app/model_admin/daily_charger_admin_model.dart';
import 'package:ev_pmis_app/model_admin/daily_pss_admin.dart';
import 'package:ev_pmis_app/model_admin/daily_rmu_admin_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../components/Loading_page.dart';
import '../../PMIS/widgets/admin_custom_appbar.dart';
import '../../PMIS/widgets/navbar.dart';
import '../../components/loading_pdf.dart';
import '../../model_admin/daily_sfu_admin_model.dart';
import '../o&m_datasource/daily_chargerManagentAdmin.dart';
import '../o&m_datasource/daily_rmuManagementAdmin.dart';
import '../o&m_datasource/daily_sfuManagementAdmin.dart';
import '../o&m_datasource/daily_transformeradmindatasource.dart';
import '../../../PMIS/provider/summary_provider.dart';
import '../../../style.dart';
import '../../../utils/daily_managementlist.dart';
import '../../../utils/date_formart.dart';
import '../../../PMIS/widgets/progress_loading.dart';
import 'package:pdf/widgets.dart' as pw;

import '../user/management_screen/assigned_userlist.dart';

List<DailySfuAdminModel> _dailySfu = [];
List<DailyChargerAdminModel> _dailycharger = [];
List<DailyPssAdminModel> _dailyPss = [];
List<DailyTransformerAdminModel> _dailyTransfer = [];
List<DailyRmuAdminModel> _dailyrmu = [];
List<DailyAcdbAdminModel> _dailyacdb = [];

late DailySFUManagementAdminDataSource _dailySfuDataSource;
late DailyChargerManagementAdminDataSource _dailyChargerDataSource;
late DailyPssManagementAdminDataSource _dailyPssDataSource;
late DailyTranformerAdminDataSource _dailyTranformerDataSource;
late DailyRmuAdminDataSource _dailyRmuDataSource;
late DailyAcdbManagementAdminDataSource _dailyAcdbdatasource;
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
    _dailycharger.clear();
    _dailySfu.clear();
    _dailyPss.clear();
    _dailyTransfer.clear();
    _dailyrmu.clear();
    _dailyacdb.clear();

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
        _dailyChargerDataSource = DailyChargerManagementAdminDataSource(
            _dailycharger,
            context,
            widget.cityName!,
            widget.depoName!,
            selectedDate!,
            widget.userId!);

        _dailySfuDataSource = DailySFUManagementAdminDataSource(
            _dailySfu,
            context,
            widget.cityName!,
            widget.depoName!,
            selectedDate!,
            widget.userId!);

        _dailyPssDataSource = DailyPssManagementAdminDataSource(
            _dailyPss,
            context,
            widget.cityName!,
            widget.depoName!,
            selectedDate!,
            widget.userId!);

        _dailyTranformerDataSource = DailyTranformerAdminDataSource(
            _dailyTransfer,
            context,
            widget.cityName!,
            widget.depoName!,
            selectedDate!,
            widget.userId!);
        // ignore: use_build_context_synchronously
        _dailyRmuDataSource = DailyRmuAdminDataSource(_dailyrmu, context,
            widget.cityName!, widget.depoName!, selectedDate!, widget.userId!);
        _dataGridController = DataGridController();
        // ignore: use_build_context_synchronously
        _dailyAcdbdatasource = DailyAcdbManagementAdminDataSource(
            _dailyacdb,
            context,
            widget.cityName!,
            widget.depoName!,
            selectedDate!,
            widget.userId!);
        _dataGridController = DataGridController();
        getAllData();
        setState(() {
          _isloading = false;
        });
      },
    );

    // Initialize other data sources and controllers here
  }

  // Define column names and labels for all tabs
  List<List<String>> tabColumnNames = [
    adminchargercolumnNames,
    adminsfucolumnNames,
    adminpsscolumnNames,
    admintransformercolumnNames,
    adminrmucolumnNames,
    adminacdbcolumnNames
  ];

  List<List<String>> tabColumnLabels = [
    adminchargercolumnLabelNames,
    adminsfucolumnLabelNames,
    adminpsscolumnLabelNames,
    admiintransformerLabelNames,
    adminrmuLabelNames,
    adminacdbLabelNames
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
            _dailyChargerDataSource = DailyChargerManagementAdminDataSource(
                _dailycharger,
                context,
                widget.cityName!,
                widget.depoName!,
                selectedDate!,
                widget.userId!);

            _dailySfuDataSource = DailySFUManagementAdminDataSource(
                _dailySfu,
                context,
                widget.cityName!,
                widget.depoName!,
                selectedDate!,
                widget.userId!);

            _dailyPssDataSource = DailyPssManagementAdminDataSource(
                _dailyPss,
                context,
                widget.cityName!,
                widget.depoName!,
                selectedDate!,
                widget.userId!);

            _dailyTranformerDataSource = DailyTranformerAdminDataSource(
                _dailyTransfer,
                context,
                widget.cityName!,
                widget.depoName!,
                selectedDate!,
                widget.userId!);
            // ignore: use_build_context_synchronously
            _dailyRmuDataSource = DailyRmuAdminDataSource(
                _dailyrmu,
                context,
                widget.cityName!,
                widget.depoName!,
                selectedDate!,
                widget.userId!);
            _dataGridController = DataGridController();
            // ignore: use_build_context_synchronously
            _dailyAcdbdatasource = DailyAcdbManagementAdminDataSource(
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
          visible: true,
          // !(columnName == currentColumnNames[1]),
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
            makeAnEntryPage: UserList(
                cityName: widget.cityName,
                role: widget.role,
                depoName: widget.depoName,
                tabIndex: widget.tabIndex,
                tabletitle: widget.tabletitle,
                userId: widget.userId),
            //  DailyManagementPage(
            //     cityName: widget.cityName,
            //     role: widget.role,
            //     depoName: widget.depoName,
            //     tabIndex: widget.tabIndex,
            //     tabletitle: widget.tabletitle,
            //     userId: widget.userId
            // ),
            showDepoBar: true,
            toDaily: true,
            depoName: widget.depoName,
            cityName: widget.cityName,
            text: '${widget.tabletitle}',
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
                                    DateFormat.yMMMd().format(
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
                                    DateFormat.yMMMd().format(enddate!),
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
                      } else if (snapshot.hasData) {
                        return Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
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
                                            selectionMode: SelectionMode.single,
                                            navigationMode:
                                                GridNavigationMode.cell,
                                            columnWidthMode:
                                                ColumnWidthMode.fitByCellValue,
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
                                            selectionMode: SelectionMode.single,
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
                                    })));
                      } else {
                        // print(_dailyDataSource.rows[0]
                        //     .getCells()
                        //     .length);
                        return
                            // const Text('data 1');
                            const NodataAvailable();
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
          // Add the date to each map in the list
          for (var map in mapData) {
            map['Date'] = nextDate; // Add 'date' to the map
          }
          print(mapData);

          if (widget.tabIndex == 0) {
            _dailycharger.addAll(mapData
                .map((map) => DailyChargerAdminModel.fromjson(map))
                .toList());
          } else if (widget.tabIndex == 1) {
            _dailySfu.addAll(mapData
                .map((map) => DailySfuAdminModel.fromjson(map))
                .toList());

            // _dailySfu =
            //     mapData.map((map) => DailySfuAdminModel.fromjson(map)).toList();
          } else if (widget.tabIndex == 2) {
            _dailyPss.addAll(mapData
                .map((map) => DailyPssAdminModel.fromjson(map))
                .toList());
            // _dailyPss =
            //     mapData.map((map) => DailyPssModel.fromjson(map)).toList();
          } else if (widget.tabIndex == 3) {
            _dailyTransfer.addAll(mapData
                .map((map) => DailyTransformerAdminModel.fromjson(map))
                .toList());
            // _dailyTransfer = mapData
            //     .map((map) => DailyTransformerModel.fromjson(map))
            //     .toList();
          } else if (widget.tabIndex == 4) {
            _dailyrmu.addAll(mapData
                .map((map) => DailyRmuAdminModel.fromjson(map))
                .toList());
            // _dailyrmu =
            //     mapData.map((map) => DailyrmuModel.fromjson(map)).toList();
          } else {
            _dailyacdb.addAll(mapData
                .map((map) => DailyAcdbAdminModel.fromjson(map))
                .toList());
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

      pr.hide();
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
            mapData.map((map) => DailyChargerAdminModel.fromjson(map)).toList();
      } else if (widget.tabIndex == 1) {
        _dailySfu =
            mapData.map((map) => DailySfuAdminModel.fromjson(map)).toList();
      } else if (widget.tabIndex == 2) {
        _dailyPss =
            mapData.map((map) => DailyPssAdminModel.fromjson(map)).toList();
      } else if (widget.tabIndex == 3) {
        _dailyTransfer = mapData
            .map((map) => DailyTransformerAdminModel.fromjson(map))
            .toList();
      } else if (widget.tabIndex == 4) {
        _dailyrmu =
            mapData.map((map) => DailyRmuAdminModel.fromjson(map)).toList();
      } else {
        _dailyacdb =
            mapData.map((map) => DailyAcdbAdminModel.fromjson(map)).toList();
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
                                DailyChargerManagementAdminDataSource(
                                    _dailycharger,
                                    context,
                                    widget.cityName!,
                                    widget.depoName!,
                                    selectedDate!,
                                    widget.userId!);

                            _dailySfuDataSource =
                                DailySFUManagementAdminDataSource(
                                    _dailySfu,
                                    context,
                                    widget.cityName!,
                                    widget.depoName!,
                                    selectedDate!,
                                    widget.userId!);

                            _dailyPssDataSource =
                                DailyPssManagementAdminDataSource(
                                    _dailyPss,
                                    context,
                                    widget.cityName!,
                                    widget.depoName!,
                                    selectedDate!,
                                    widget.userId!);

                            _dailyTranformerDataSource =
                                DailyTranformerAdminDataSource(
                                    _dailyTransfer,
                                    context,
                                    widget.cityName!,
                                    widget.depoName!,
                                    selectedDate!,
                                    widget.userId!);
                            // ignore: use_build_context_synchronously
                            _dailyRmuDataSource = DailyRmuAdminDataSource(
                                _dailyrmu,
                                context,
                                widget.cityName!,
                                widget.depoName!,
                                selectedDate!,
                                widget.userId!);
                            _dataGridController = DataGridController();
                            // ignore: use_build_context_synchronously
                            _dailyAcdbdatasource =
                                DailyAcdbManagementAdminDataSource(
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
      String? fileName;
      if (widget.tabIndex == 0) {
        fileName = 'Charger_Checklist.pdf';
      }
      if (widget.tabIndex == 1) {
        fileName = 'Sfu_Checklist.pdf';
      }
      if (widget.tabIndex == 2) {
        fileName = 'Pss_Checklist.pdf';
      }
      if (widget.tabIndex == 3) {
        fileName = 'Transformer_Checklist.pdf';
      }
      if (widget.tabIndex == 4) {
        fileName = 'Rmu_Checklist.pdf';
      }
      if (widget.tabIndex == 5) {
        fileName = 'Acdb_Checklist.pdf';
      }

      final savedPDFFile = await savePDFToFile(pdfData, fileName!);

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

  Future<Uint8List> _generateDailyPDF() async {
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

    final fontData1 =
        await rootBundle.load('assets/fonts/Montserrat-Medium.ttf');
    final fontData2 = await rootBundle.load('assets/fonts/Montserrat-Bold.ttf');

    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
    );

    Map<String, dynamic> tableData = Map();
    dynamic datasource;
    if (widget.tabIndex == 0) {
      datasource = _dailyChargerDataSource;
    } else if (widget.tabIndex == 1) {
      datasource = _dailySfuDataSource;
    } else if (widget.tabIndex == 2) {
      datasource = _dailyPssDataSource;
    } else if (widget.tabIndex == 3) {
      datasource = _dailyTranformerDataSource;
    } else if (widget.tabIndex == 4) {
      datasource = _dailyRmuDataSource;
    } else if (widget.tabIndex == 5) {
      datasource = _dailyAcdbdatasource;
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

    headers = tabColumnLabels[widget.tabIndex];

    List<pw.TableRow> rows = [];

    // rows.add(pw.TableRow(
    //   children: headers.map((header) {
    //     return pw.Container(
    //       padding: const pw.EdgeInsets.all(2.0),
    //       child: pw.Center(
    //         child: pw.Text(
    //           header,
    //           style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //         ),
    //       ),
    //     );
    //   }).toList(),
    // ));

    pw.Widget buildTableCell(String text) {
      return pw.Container(
          padding: const pw.EdgeInsets.all(3.0),
          child: pw.Center(
              child: pw.Text(text, style: const pw.TextStyle(fontSize: 14))));
    }

    if (widget.tabIndex == 0) {
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
          // buildTableCell((i + 1).toString()),
          buildTableCell(tabledata2[i]['Date'].toString()),
          buildTableCell(tabledata2[i]['CN'].toString()),
          buildTableCell(tabledata2[i]['DC'].toString()),
          buildTableCell(tabledata2[i]['CGCA'].toString()),
          buildTableCell(tabledata2[i]['CGCB'].toString()),
          buildTableCell(tabledata2[i]['CGCCA'].toString()),
          buildTableCell(tabledata2[i]['CGCCB'].toString()),
          buildTableCell(tabledata2[i]['dl'].toString()),
          buildTableCell(tabledata2[i]['ARM'].toString()),
          buildTableCell(tabledata2[i]['EC'].toString()),
          buildTableCell(tabledata2[i]['CC'].toString()),
        ]));
      }
    }
    if (widget.tabIndex == 1) {
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
          // buildTableCell((i + 1).toString()),
          buildTableCell(tabledata2[i]['Date'].toString()),
          buildTableCell(tabledata2[i]['sfuNo'].toString()),
          buildTableCell(tabledata2[i]['fuc'].toString()),
          buildTableCell(tabledata2[i]['icc'].toString()),
          buildTableCell(tabledata2[i]['ictc'].toString()),
          buildTableCell(tabledata2[i]['occ'].toString()),
          buildTableCell(tabledata2[i]['octc'].toString()),
          buildTableCell(tabledata2[i]['ec'].toString()),
          buildTableCell(tabledata2[i]['cg'].toString()),
          buildTableCell(tabledata2[i]['dl'].toString()),
          buildTableCell(tabledata2[i]['vi'].toString()),
        ]));
      }
    }
    if (widget.tabIndex == 2) {
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
          // buildTableCell((i + 1).toString()),
          buildTableCell(tabledata2[i]['Date'].toString()),
          buildTableCell(tabledata2[i]['pssNo'].toString()),
          buildTableCell(tabledata2[i]['pbc'].toString()),
          buildTableCell(tabledata2[i]['ec'].toString()),
          buildTableCell(tabledata2[i]['pdl'].toString()),
          buildTableCell(tabledata2[i]['sgp'].toString()),
          buildTableCell(tabledata2[i]['wtiTemp'].toString()),
          buildTableCell(tabledata2[i]['otiTemp'].toString()),
          buildTableCell(tabledata2[i]['vpiPresence'].toString()),
          buildTableCell(tabledata2[i]['viMCCb'].toString()),
          buildTableCell(tabledata2[i]['vr'].toString()),
          buildTableCell(tabledata2[i]['ar'].toString()),
          buildTableCell(tabledata2[i]['mccbHandle'].toString()),
        ]));
      }
    }
    if (widget.tabIndex == 3) {
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
          // buildTableCell((i + 1).toString()),
          buildTableCell(tabledata2[i]['Date'].toString()),
          buildTableCell(tabledata2[i]['trNo'].toString()),
          buildTableCell(tabledata2[i]['pc'].toString()),
          buildTableCell(tabledata2[i]['ec'].toString()),
          buildTableCell(tabledata2[i]['ol'].toString()),
          buildTableCell(tabledata2[i]['oc'].toString()),
          buildTableCell(tabledata2[i]['wtiTemp'].toString()),
          buildTableCell(tabledata2[i]['otiTemp'].toString()),
          buildTableCell(tabledata2[i]['brk'].toString()),
          buildTableCell(tabledata2[i]['cta'].toString()),
        ]));
      }
    }
    if (widget.tabIndex == 4) {
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
          // buildTableCell((i + 1).toString()),
          buildTableCell(tabledata2[i]['Date'].toString()),
          buildTableCell(tabledata2[i]['rmuNo'].toString()),
          buildTableCell(tabledata2[i]['sgp'].toString()),
          buildTableCell(tabledata2[i]['vpi'].toString()),
          buildTableCell(tabledata2[i]['crd'].toString()),
          buildTableCell(tabledata2[i]['rec'].toString()),
          buildTableCell(tabledata2[i]['arm'].toString()),
          buildTableCell(tabledata2[i]['cbts'].toString()),
          buildTableCell(tabledata2[i]['cra'].toString()),
        ]));
      }
    }
    if (widget.tabIndex == 5) {
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
          // buildTableCell((i + 1).toString()),
          buildTableCell(tabledata2[i]['Date'].toString()),
          buildTableCell(tabledata2[i]['incomerNo'].toString()),
          buildTableCell(tabledata2[i]['vi'].toString()),
          buildTableCell(tabledata2[i]['vr'].toString()),
          buildTableCell(tabledata2[i]['ar'].toString()),
          buildTableCell(tabledata2[i]['acbbSwitch'].toString()),
          buildTableCell(tabledata2[i]['mccbHandle'].toString()),
          buildTableCell(tabledata2[i]['ccb'].toString()),
          buildTableCell(tabledata2[i]['arm'].toString()),
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
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child: pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Daily Report Table',
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
            columnWidths: Map.fromIterable(
              List.generate(headers.length, (index) => index),
              value: (index) => const pw.FixedColumnWidth(100),
            ),
            // {
            //   0: const pw.FixedColumnWidth(30),
            //   1: const pw.FixedColumnWidth(160),
            //   2: const pw.FixedColumnWidth(70),
            //   3: const pw.FixedColumnWidth(70),
            //   4: const pw.FixedColumnWidth(70),
            //   5: const pw.FixedColumnWidth(70),
            //   6: const pw.FixedColumnWidth(70),
            //   7: const pw.FixedColumnWidth(70),
            //   8: const pw.FixedColumnWidth(70),
            //   9: const pw.FixedColumnWidth(70),
            //   10: const pw.FixedColumnWidth(70),
            //   // 11: const pw.FixedColumnWidth(70),
            // },
            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
            tableWidth: pw.TableWidth.max,
            border: pw.TableBorder.all(),
            children: rows,
          )
        ],
      ),
    );

    pdfData = await pdf.save();
    pdfPath = 'Daily_Report.pdf';

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

  // Future<File> savePDFToFile(Uint8List pdfData, String fileName) async {
  //   final documentDirectory = (await DownloadsPath.downloadsDirectory())?.path;
  //   final file = File('$documentDirectory/$fileName');

  //   int counter = 1;
  //   String newFilePath = file.path;
  //   pathToOpenFile = newFilePath.toString();
  //   if (await File(newFilePath).exists()) {
  //     final baseName = fileName.split('.').first;
  //     final extension = fileName.split('.').last;
  //     newFilePath =
  //         '$documentDirectory/$baseName-${counter.toString()}.$extension';
  //     counter++;
  //     pathToOpenFile = newFilePath.toString();
  //     await file.copy(newFilePath);
  //     counter++;
  //   } else {
  //     await file.writeAsBytes(pdfData);
  //     return file;
  //   }
  //   return File('');
  // }
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
