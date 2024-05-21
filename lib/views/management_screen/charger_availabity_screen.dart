import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/PMIS/user/datasource/o&m_datasource/charger_availablity_datasource.dart';
import 'package:ev_pmis_app/models/o&m_model/chargerAvailability_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../FirebaseApi/firebase_api.dart';
import '../../components/Loading_page.dart';
import '../../style.dart';
import '../../PMIS/widgets/appbar_back_date.dart';
import '../../PMIS/widgets/management_screen.dart';
import '../../PMIS/widgets/progress_loading.dart';
import '../../PMIS/summary.dart';

class ChargerAvailabilityScreen extends StatefulWidget {
  final String? cityName;
  final String? depoName;
  final String? userId;
  final String? role;
  const ChargerAvailabilityScreen(
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
  late ChargerAvailabilityDataSource chargerAvailabilityDataSource;
  late DataGridController _dataGridController;
  List<ChargerAvailabilityModel> chargerModel = [];
  Stream? _stream;
  List<dynamic> tabledata2 = [];
  bool isLoading = true;
  bool checkTable = true;

  @override
  void initState() {
    // getUserId().whenComplete(() {
    chargerAvailabilityDataSource = ChargerAvailabilityDataSource(
        chargerModel,
        context,
        widget.cityName!,
        widget.depoName!,
        selectedDate!,
        widget.userId!);
    _dataGridController = DataGridController();

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
          width: columnName == 'Sr.No.' ? 60 : 100,
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
          text: 'Charger Availability',
          haveSynced: false,
          haveSummary: false,
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
        ),
      ),
      body: SfDataGridTheme(
        data: SfDataGridThemeData(headerColor: white, gridLineColor: blue),
        child: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage();
            } else if (!snapshot.hasData || snapshot.data.exists == false) {
              return SfDataGrid(
                  source: chargerAvailabilityDataSource,
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
                  source: chargerAvailabilityDataSource,
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
                chargerModel.add(ChargerAvailabilityModel(
                  srNo: chargerAvailabilityDataSource.dataGridRows.length + 1,
                  location: '',
                  depotName: '',
                  chargerNo: '',
                  chargerSrNo: '',
                  chargerMake: '',
                  targetTime: 0,
                  timeLoss: 0,
                  availability: 0.0,
                  remarks: '',
                ));
                _dataGridController = DataGridController();
                chargerAvailabilityDataSource.buildDataGridRows();
                chargerAvailabilityDataSource.updateDatagridSource();
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
    for (var i in chargerAvailabilityDataSource.dataGridRows) {
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
        .collection('ChargerAvailabilityData')
        .doc('${widget.depoName}')
        .collection(selectedDate!)
        .doc(widget.userId)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> tempData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapData = tempData['data'];

      chargerModel =
          mapData.map((map) => ChargerAvailabilityModel.fromjson(map)).toList();
      checkTable = false;
    }

    isLoading = false;
    setState(() {});
  }
}
