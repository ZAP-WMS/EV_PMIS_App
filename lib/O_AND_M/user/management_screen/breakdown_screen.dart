import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/O_AND_M/o&m_model/breakdown_model.dart';
import 'package:ev_pmis_app/PMIS/authentication/authservice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../components/Loading_page.dart';
import '../../o&m_datasource/breakdown_datasource.dart';
import '../../../style.dart';
import '../../../PMIS/widgets/appbar_back_date.dart';
import '../../../PMIS/widgets/management_screen.dart';
import '../../../PMIS/widgets/progress_loading.dart';

class BreakdownScreen extends StatefulWidget {
  final String? cityName;
  final String? depoName;
  final String? userId;
  final String? role;
  final String? roleCentre;

  const BreakdownScreen(
      {super.key,
      required this.cityName,
      this.depoName,
      this.userId,
      this.role,
      this.roleCentre});

  @override
  State<BreakdownScreen> createState() => _BreakdownScreenState();
}

class _BreakdownScreenState extends State<BreakdownScreen> {
  final AuthService authService = AuthService();
  List<String> assignedCities = [];
  bool isFieldEditable = false;
  bool isEntryClosed = false;
  String? visDate = DateFormat.yMMMd().format(DateTime.now());
  String? selectedDate = DateFormat.yMMM().format(DateTime.now());
  List<GridColumn> columns = [];
  late BreakdownDataManagementDataSource breakdownDataManagementDataSource;
  late DataGridController _dataGridController;
  List<BreakdownModel> breakdowmModel = [];
  Stream? _stream;
  List<dynamic> tabledata2 = [];
  bool isLoading = true;
  bool checkTable = true;

  @override
  void initState() {
    breakdownDataManagementDataSource = BreakdownDataManagementDataSource(
        breakdowmModel,
        context,
        widget.cityName!,
        widget.depoName!,
        selectedDate!,
        widget.userId!);
    _dataGridController = DataGridController();
    getAssignedDepots().whenComplete(() {
      getTableData().whenComplete(
        () {
          breakdownDataManagementDataSource = BreakdownDataManagementDataSource(
              breakdowmModel,
              context,
              widget.cityName!,
              widget.depoName!,
              selectedDate!,
              widget.userId!);
          _dataGridController = DataGridController();
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> currentColumnLabels = breakdownClnName;

    columns.clear();
    for (int i = 0; i < breakdownClnName.length; i++) {
      columns.add(
        GridColumn(
          columnName: breakdownClnName[i],
          visible: true,
          allowEditing: breakdownClnName[i] == 'Add' ||
                  breakdownClnName[i] == 'Delete' ||
                  breakdownClnName[i] == "Location" ||
                  breakdownClnName[i] == "Depot name" ||
                  breakdownClnName[i] == 'Fault Resolving' ||
                  breakdownClnName[i] == 'Fault Occurrance' ||
                  breakdownClnName[i] == 'faultRelated' ||
                  breakdownClnName[i] == 'Attribute to' ||
                  breakdownClnName[i] == 'Equipment Name' ||
                  breakdownClnName[i] == 'Chargers affected' ||
                  breakdownClnName[i] == 'Status'
              ? false
              : true,
          autoFitPadding: const EdgeInsets.all(
            8.0,
          ),
          width: breakdownClnName[i] == 'Delete'
              ? 50.0
              : breakdownClnName[i] == 'Sr.No.'
                  ? MediaQuery.of(context).size.width * 0.1
                  : breakdownClnName[i] == 'Fault Occurrance'
                      ? MediaQuery.of(context).size.width * 0.4
                      : breakdownClnName[i] == 'Fault Resolving'
                          ? MediaQuery.of(context).size.width * 0.4
                          : breakdownClnName[i] == 'Attribute to'
                              ? MediaQuery.of(context).size.width * 0.25
                              : breakdownClnName[i] == 'faultRelated'
                                  ? MediaQuery.of(context).size.width * 0.35
                                  : breakdownClnName[i] == 'Equipment Name'
                                      ? MediaQuery.of(context).size.width * 0.4
                                      : MediaQuery.of(context).size.width *
                                          0.3, // You can adjust this width as needed
          label: createColumnLabel(
            breakdownTableClnName[i],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBarBackDate(
            depoName: widget.depoName ?? '',
            text: 'Breakdown Page',
            haveSynced: showHideSync(),
            store: () async {
              showProgressDilogue(context);
              storeData();
            },
            showDate: visDate,
            choosedate: () {
              //chooseDate(context);
            },
          )),
      body: SfDataGridTheme(
        data: SfDataGridThemeData(headerColor: white, gridLineColor: blue),
        child: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage();
            } else if (!snapshot.hasData || snapshot.data.exists == false) {
              return SfDataGrid(
                  source: breakdownDataManagementDataSource,
                  allowEditing: true,
                  frozenColumnsCount: 1,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  selectionMode: SelectionMode.single,
                  navigationMode: GridNavigationMode.cell,
                  columnWidthMode: ColumnWidthMode.fitByCellValue,
                  editingGestureType: EditingGestureType.tap,
                  controller: _dataGridController,
                  onQueryRowHeight: (details) {
                    return details.getIntrinsicRowHeight(details.rowIndex);
                  },
                  columns: columns);
            } else {
              return SfDataGrid(
                source: breakdownDataManagementDataSource,
                allowEditing: true,
                frozenColumnsCount: 2,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                selectionMode: SelectionMode.single,
                navigationMode: GridNavigationMode.cell,
                editingGestureType: EditingGestureType.tap,
                controller: _dataGridController,
                onQueryRowHeight: (details) {
                  return details.getIntrinsicRowHeight(details.rowIndex);
                },
                columns: columns,
              );
            }
          },
        ),
      ),
      floatingActionButton: showHideSync()
          ? FloatingActionButton(
              onPressed: (() {
                breakdowmModel.add(
                  BreakdownModel(
                    srNo: breakdownDataManagementDataSource.rows.length + 1,
                    location: widget.cityName,
                    depotName: widget.depoName,
                    equipmentName: '',
                    chargersAffected: '',
                    faultType: '',
                    fault: '',
                    attributeTo: '',
                    faultOccurance: '',
                    faultResolving: '',
                    agencyName: '',
                    faultResolvedBy: '',
                    status: '',
                    mttr: '',
                    faultRelated: '',
                    remark: '',
                  ),
                );
                _dataGridController = DataGridController();
                breakdownDataManagementDataSource.buildDataGridRows();
                breakdownDataManagementDataSource.updateDatagridSource();
              }),
              child: const Icon(
                Icons.add,
              ),
            )
          : Container(),
    );
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

  Future storeData() async {
    Map<String, dynamic> tableData = {};
    for (var i in breakdownDataManagementDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' && data.columnName != 'Delete') {
          tableData[data.columnName] = data.value;
          // tableData.addAll({"Date": selectedDate});
        }
      }

      tabledata2.add(tableData);
      tableData = {};
    }

    FirebaseFirestore.instance
        .collection('BreakDownData')
        .doc('${widget.depoName}')
        // .collection(selectedDate!)
        // .doc(widget.userId)
        .set({'data': tabledata2, "isCloseEntry": true}).whenComplete(() {
      tabledata2.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }

  Future getCloseEntry() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("BreakDownData")
        .doc("${widget.depoName}")
        .get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      isEntryClosed = data['isCloseEntry'];
    }
  }

  bool showHideSync() {
    if (isFieldEditable && isEntryClosed == false) {
      return true;
    } else if (widget.role == 'admin') {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getTableData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('BreakDownData')
        .doc('${widget.depoName}')
        // .collection(selectedDate!)
        // .doc(widget.userId)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> tempData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapData = tempData['data'];

      breakdowmModel =
          mapData.map((map) => BreakdownModel.fromjson(map)).toList();
      checkTable = false;
    }
    await getCloseEntry();

    isLoading = false;
    setState(() {});
  }

  Future getAssignedDepots() async {
    assignedCities = await authService.getCityList();
    isFieldEditable = authService.verifyAssignedDepot(
      widget.cityName!,
      assignedCities,
    );
    print("isField - $isFieldEditable");
  }

  Future<void> getBreakdownData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("BreakDownData")
        .doc("${widget.depoName}")
        .get();

    Map<String, dynamic> mapData =
        documentSnapshot.data() as Map<String, dynamic>;
    List<dynamic> data = mapData['data'];
  }

  void datePicker() async {
    DateTimeRange? selectedDate = await showDateRangePicker(
        context: context,
        firstDate: DateTime(1950),
        lastDate: DateTime(2100),
        currentDate: DateTime.now());
    if (selectedDate != null) {
      print("SelectedDate $selectedDate");
    }
  }
}
