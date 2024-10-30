import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/PMIS/user/screen/safetyfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../components/Loading_page.dart';
import '../../PMIS/summary.dart';
import '../../PMIS/widgets/admin_custom_appbar.dart';
import '../../components/loading_pdf.dart';
import '../o&m_datasource/monthly_chargerdatasource.dart';
import '../o&m_datasource/monthly_filter.dart';
import '../o&m_model/monthly_charger.dart';
import '../o&m_model/monthly_filter.dart';
import '../../../../style.dart';
import '../../../../utils/daily_managementlist.dart';
import '../../../../utils/date_formart.dart';
import '../../../../PMIS/authentication/authservice.dart';
import '../user/management_screen/monthly_page/monthly_home.dart';

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

class MonthlyAdminManagementPage extends StatefulWidget {
  String? cityName;
  String? depoName;
  int tabIndex = 0;
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

    _stream = FirebaseFirestore.instance
        .collection('DailyManagementPage')
        .doc('${widget.depoName}')
        .collection(selectedDate.toString())
        .doc(userId)
        .snapshots();

    _dataGridController = DataGridController();
    getUserId().whenComplete(() {
      // _fetchUserData();
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

      _isloading = false;
      setState(() {});
    });

    super.initState();
  }

  List<List<String>> tabColumnNames = [
    monthlyChargerColumnName,
    monthlyFilterColumnName
  ];

  List<List<String>> tabColumnLabels = [
    monthlyLabelColumnName,
    monthlyFilterLabelColumnName
  ];

  DateTime? startdate = DateTime.now();
  DateTime? rangestartDate;
  @override
  Widget build(BuildContext context) {
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
                          Text(DateFormat.yMMMMd().format(startdate!))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SfDataGridTheme(
                  data: SfDataGridThemeData(
                      headerColor: white, gridLineColor: blue),
                  child: StreamBuilder(
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                            headerGridLinesVisibility: GridLinesVisibility.both,
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
                            headerGridLinesVisibility: GridLinesVisibility.both,
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
            _monthlyChargerModel = mapData
                .map((map) => MonthlyChargerModel.fromjson(map))
                .toList();
          } else {
            _monthlyFilterModel =
                mapData.map((map) => MonthlyFilterModel.fromjson(map)).toList();
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
