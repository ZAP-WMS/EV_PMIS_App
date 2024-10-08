import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/O_AND_M/o&m_datasource/charger_availablity_datasource.dart';
import 'package:ev_pmis_app/O_AND_M/o&m_model/chargerAvailability_model.dart';
import 'package:excel/excel.dart'   as Excel;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../components/Loading_page.dart';
import '../../../style.dart';
import '../../../PMIS/widgets/appbar_back_date.dart';
import '../../../PMIS/widgets/management_screen.dart';

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
  int targetTime = 0;
  bool toShowTimeloss = false;
  Map<String, dynamic> mttrData = {};
  String startDate = DateFormat.yMMMd().format(DateTime.now());
  String endDate = DateFormat.yMMMd().format(DateTime.now());
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
  bool dateRangeSelected = false;
  List<List<dynamic>> excelData = [];

  @override
  void initState() {
    // loadExcelData();
    getTableData(0).whenComplete(() {
      chargerAvailabilityDataSource = ChargerAvailabilityDataSource(
          chargerModel,
          context,
          widget.cityName!,
          widget.depoName!,
          selectedDate!,
          widget.userId!,
          toShowTimeloss,
          mttrData,
          targetTime);
      _dataGridController = DataGridController();

      isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  Future<List<void>> loadExcelData() async {
    List<List<dynamic>> excelData = [];
    // Load the Excel file from assets
    ByteData data = await rootBundle.load('assets/dashboard_data.xlsx');
    var bytes = data.buffer.asUint8List();

    // Decode the Excel file
    var excel = Excel.Excel.decodeBytes(bytes);

    // Read the data from the first sheet
    for (var table in excel.tables.keys) {
      if (table == 'For Charger Availability') {
        print(table); //sheet Name
        print(excel.tables[table]?.maxCols);
        print(excel.tables[table]?.maxRows);
        for (var table in excel.tables.keys) {
          var sheet = excel.tables[table];
          for (var row in sheet!.rows.skip(1)) {
            // skip header row
            print(row);
            excelData.add(row);
            print(excelData);
          }
        }
      }
    }
    return excelData;
  }

  @override
  Widget build(BuildContext context) {
    List<String> currentColumnLabels = chargerAvailabilityClnName;

    columns.clear();
    for (String columnName in chargerAvailabilityClnName) {
      columns.add(
        GridColumn(
          columnName: columnName,
          autoFitPadding: const EdgeInsets.all(8.0),
          allowEditing: columnName == 'Add' ||
                  columnName == 'Delete' ||
                  columnName == "TargetTime" ||
                  columnName == columnName[0]
              ? false
              : true,
          width: columnName == 'Sr.No.'
              ? 60
              : columnName == "ChargerNo"
                  ? MediaQuery.of(context).size.width * 0.35
                  : 100,
          label: createColumnLabel(
            currentColumnLabels[currentColumnLabels.indexOf(columnName)],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBarBackDate(
          store: storeData,
          depoName: widget.depoName ?? '',
          text: 'Charger Availability',
          haveSynced: widget.role == "user" ? false : true,
        ),
      ),
      body: isLoading
          ? const LoadingPage()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.78,
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
                                source: chargerAvailabilityDataSource,
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
                                source: chargerAvailabilityDataSource,
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
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: _dateRange,
                          child: Container(
                            height: 40,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.0),
                              border: Border.all(
                                color: blue,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: blue,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(startDate)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: _dateRange,
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                3.0,
                              ),
                              border: Border.all(
                                color: blue,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: blue,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(endDate)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: widget.role != "user"
          ? FloatingActionButton(
              onPressed: (() {
                chargerModel.add(ChargerAvailabilityModel(
                  srNo: chargerAvailabilityDataSource.dataGridRows.length + 1,
                  location: widget.cityName,
                  depotName: widget.depoName,
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
    Map<String, dynamic> tableData = {};
    for (var i in chargerAvailabilityDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' && data.columnName != 'Delete') {
          tableData[data.columnName] = data.value;
        }
      }

      tabledata2.add(tableData);
      tableData = {};
    }

    FirebaseFirestore.instance
        .collection('ChargerAvailability')
        .doc('${widget.depoName}')
        // .collection(selectedDate!)
        // .doc(widget.userId)
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

  Future<void> getTableData(int targetTime) async {
    chargerModel.clear();
    List<dynamic> temp = [];
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('ChargerAvailability')
        .doc('${widget.depoName}')
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> tempData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapData = tempData['data'];

      if (dateRangeSelected) {
        for (Map<String, dynamic> data in mapData) {
          data["TargetTime"] = targetTime;
          temp.add(data);
        }

        chargerModel = temp
            .map((map1) => ChargerAvailabilityModel.fromjson(map1))
            .toList();
      } else {
        chargerModel = mapData
            .map((map2) => ChargerAvailabilityModel.fromjson(map2))
            .toList();
      }
    }
  }

  Future<void> _dateRange() async {
    dateRangeSelected = true;
    if (isLoading == false) {
      setState(() {
        isLoading = true;
      });
    }
    DateTimeRange? selectedDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(
        2100,
      ),
      currentDate: DateTime.now(),
      helpText: "Choose Start And End Date",
    );
    if (selectedDate != null) {
      startDate = DateFormat.yMMMd().format(selectedDate.start);
      endDate = DateFormat.yMMMd().format(selectedDate.end);
      print("startDate - $startDate");
      print("endDate - $endDate");
      targetTime =
          (selectedDate!.end.difference(selectedDate.start).inDays + 1) * 24;
      // print("Charger Availability - ${targetTime * 24}");
      await getTimeLossData();
      getTableData(targetTime).whenComplete(() {
        dateRangeSelected = false;
        chargerAvailabilityDataSource = ChargerAvailabilityDataSource(
            chargerModel,
            context,
            widget.cityName!,
            widget.depoName!,
            selectedDate.toString(),
            widget.userId!,
            toShowTimeloss,
            mttrData,
            targetTime);
        // _dataGridController = DataGridController();
        chargerAvailabilityDataSource.buildDataGridRows();
        chargerAvailabilityDataSource.updateDatagridSource();
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future<void> getTimeLossData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("ChargerAvailability")
        .doc("${widget.depoName}")
        .get();

    Map<String, dynamic> mapData =
        documentSnapshot.data() as Map<String, dynamic>;
    List<dynamic> chargerAvailData = mapData['data'];

    //Fetch Breakdown Data
    DocumentSnapshot breakdownSnap = await FirebaseFirestore.instance
        .collection("BreakDownData")
        .doc("${widget.depoName}")
        .get();

    Map<String, dynamic> breakdownData =
        breakdownSnap.data() as Map<String, dynamic>;
    List<dynamic> breakdownMapData = breakdownData['data'];

    for (Map<String, dynamic> chargerData in chargerAvailData) {
      double totalMttr = 0.0;
      for (int i = 0; i < breakdownMapData.length; i++) {
        if (chargerData["ChargerNo"].toString().toLowerCase().trim() ==
            breakdownMapData[i]["Equipment Name"]
                .toString()
                .toLowerCase()
                .trim()) {
          totalMttr =
              totalMttr + double.parse(breakdownMapData[i]["MTTR"].toString());
        }
      }
      mttrData[chargerData["ChargerNo"]] = totalMttr;
    }
    toShowTimeloss = true;
    // print("MttrData - $mttrData");
  }
}
