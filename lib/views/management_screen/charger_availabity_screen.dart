import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/models/o&m_model/breakdown_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../FirebaseApi/firebase_api.dart';
import '../../components/Loading_page.dart';
import '../../datasource/o&m_datasource/breakdown_datasource.dart';
import '../../style.dart';
import '../../widgets/appbar_back_date.dart';
import '../../widgets/management_screen.dart';
import '../../widgets/progress_loading.dart';
import '../dailyreport/summary.dart';

class ChargerAvailabilityScreen extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? userId;
  String? role;
  ChargerAvailabilityScreen(
      {super.key,
      required this.cityName,
      this.depoName,
      this.userId,
      this.role});

  @override
  State<ChargerAvailabilityScreen> createState() =>
      _ChargerAvailabilityScreenState();
}

class _ChargerAvailabilityScreenState extends State<ChargerAvailabilityScreen> {
  bool isFieldEditable = true;
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
    // getUserId().whenComplete(() {
    breakdownDataManagementDataSource = BreakdownDataManagementDataSource(
        breakdowmModel,
        context,
        widget.cityName!,
        widget.depoName!,
        selectedDate!,
        widget.userId!);
    _dataGridController = DataGridController();

    // getTableData().whenComplete(
    //   () {
    //     breakdownDataManagementDataSource = BreakdownDataManagementDataSource(
    //         breakdowmModel,
    //         context,
    //         widget.cityName!,
    //         widget.depoName!,
    //         selectedDate!,
    //         widget.userId!);
    //     _dataGridController = DataGridController();
    //   },
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> currentColumnLabels = chargerAvailabilityClnName;

    columns.clear();
    for (String columnName in chargerAvailabilityClnName) {
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
            currentColumnLabels[currentColumnLabels.indexOf(columnName)],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: CustomAppBarBackDate(
            depoName: widget.depoName ?? '',
            text: 'Daily Report',
            haveSynced: isFieldEditable ? true : false,
            haveSummary: true,
            haveCalender: true,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewSummary(
                    cityName: widget.cityName.toString(),
                    depoName: widget.depoName.toString(),
                    role: widget.role,
                    id: 'Daily Report',
                    currentDate: selectedDate,
                    userId: widget.userId,
                  ),
                )),
            store: () async {
              showProgressDilogue(context);
              FirebaseApi().nestedKeyEventsField(
                  'DailyProject3', widget.depoName!, 'userId', widget.userId!);
              storeData();
            },
            showDate: visDate,
            choosedate: () {
              //chooseDate(context);
            },
          )),
      body: SfDataGridTheme(
        data: SfDataGridThemeData(
          headerColor: white, gridLineColor: blue),
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
                  rowHeight: 50,
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
                  rowHeight: 50,
                  controller: _dataGridController,
                  onQueryRowHeight: (details) {
                    return details.getIntrinsicRowHeight(details.rowIndex);
                  },
                  columns: columns);
            }
          },
        ),
      ),
      floatingActionButton: isFieldEditable
          ? FloatingActionButton(
              onPressed: (() {
                breakdowmModel.add(BreakdownModel(
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
                    year: '',
                    month: '',
                    agencyName: '',
                    faultResolvedBy: '',
                    status: '',
                    pending: '',
                    mttr: '',
                    remark: ''));
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
    Map<String, dynamic> tableData = Map();
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
        .collection(selectedDate!)
        .doc(widget.userId)
        .set({
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

  Future<void> getTableData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('BreakDownData')
        .doc('${widget.depoName}')
        .collection(selectedDate!)
        .doc(widget.userId)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> tempData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapData = tempData['data'];

      breakdowmModel =
          mapData.map((map) => BreakdownModel.fromjson(map)).toList();
      checkTable = false;
    }

    isLoading = false;
    setState(() {});
  }
}
