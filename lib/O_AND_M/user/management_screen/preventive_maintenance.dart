import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/PMIS/common_screen/citiespage/depot.dart';
import 'package:ev_pmis_app/PMIS/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../components/Loading_page.dart';
import '../../../style.dart';
import '../../o&m_datasource/preventive_yearly_dataSource.dart';
import '../../o&m_model/preventive_model.dart';

class PreventiveScreen extends StatefulWidget {
  String? depoName;
  String? cityName;
  String? userId;
  int? indexValue;
  PreventiveScreen(
      {super.key,
      required this.cityName,
      required this.depoName,
      required this.userId,
      required this.indexValue});

  @override
  State<PreventiveScreen> createState() => _PreventiveScreenState();
}

class _PreventiveScreenState extends State<PreventiveScreen> {
  List<GridColumn> columns = [];
  Stream? _stream;
  var alldata;
  var subDate;

  late DataGridController _dataGridController;
  late PreventiveYearlyDatasource _preventiveYearlyDatasource;
  List<PreventiveYearlyModel> _preventiveYearlyModel = [];
  List<String> yearlyEquipmentList = [];
  List<String> yearOption = ['Yearly', 'Half Yearly', 'Quarterly', 'Monthly'];

  @override
  void initState() {
    List<PreventiveYearlyModel> preventiveYearlyData = [
      PreventiveYearlyModel(
        srNo: 1,
        equipment: '1 Way RMU',
        frequency: 'Yearly',
        installationDate: '01-01-2024',
      ),
      PreventiveYearlyModel(
        srNo: 2,
        equipment: '3 Way RMU-1',
        frequency: 'Yearly',
        installationDate: '01-01-2024',
      ),
      PreventiveYearlyModel(
        srNo: 3,
        equipment: '3 Way RMU-2',
        frequency: 'Yearly',
        installationDate: '01-01-2024',
      ),
      PreventiveYearlyModel(
        srNo: 4,
        equipment: '4 Way RMU-1',
        frequency: 'Yearly',
        installationDate: '01-01-2024',
      ),
      PreventiveYearlyModel(
        srNo: 5,
        equipment: 'Transformer-1 / PSS',
        frequency: 'Yearly',
        installationDate: '01-01-2024',
      ),
      PreventiveYearlyModel(
        srNo: 6,
        equipment: 'Transformer-1 / PSS',
        frequency: 'Yearly',
        installationDate: '01-01-2024',
      ),
      PreventiveYearlyModel(
        srNo: 7,
        equipment: 'Transformer-1 / PSS',
        frequency: 'Yearly',
        installationDate: '01-01-2024',
      ),
      PreventiveYearlyModel(
        srNo: 8,
        equipment: 'ACDB-1',
        frequency: 'Yearly',
        installationDate: '01-01-2024',
      ),
      PreventiveYearlyModel(
        srNo: 9,
        equipment: 'Fire Extinguisher',
        frequency: 'Yearly',
        installationDate: '01-01-2024',
      ),
    ];

    List<PreventiveYearlyModel> preventiveHalfYearlyData = [
      PreventiveYearlyModel(
        srNo: 1,
        equipment: 'Substation & EV Charger Earthing Checks',
        frequency: 'Half Yearly',
        installationDate: '01-01-2024',
      ),
    ];

    List<PreventiveYearlyModel> preventiveQuarterlyData = [
      PreventiveYearlyModel(
        srNo: 1,
        equipment: 'PM of Chargers',
        frequency: 'Quarterly',
        installationDate: '01-01-2024',
      ),
      PreventiveYearlyModel(
        srNo: 2,
        equipment: 'PM of MCCB/SFU',
        frequency: 'Quarterly',
        installationDate: '01-01-2024',
      ),
    ];

    List<PreventiveYearlyModel> preventiveMonthlyData = [
      PreventiveYearlyModel(
        srNo: 1,
        equipment: 'Charger Filter Cleaning',
        frequency: 'Monthly',
        installationDate: '01-01-2024',
      ),
    ];

    _preventiveYearlyModel.addAll(widget.indexValue == 0
        ? preventiveYearlyData
        : widget.indexValue == 1
            ? preventiveHalfYearlyData
            : widget.indexValue == 2
                ? preventiveQuarterlyData
                : preventiveMonthlyData);
    _preventiveYearlyDatasource = PreventiveYearlyDatasource(
        _preventiveYearlyModel,
        context,
        widget.indexValue!,
        widget.cityName!,
        widget.depoName!,
        widget.userId!);

    _dataGridController = DataGridController();
    _preventiveYearlyDatasource.buildDataGridRows();
    _preventiveYearlyDatasource.updateDatagridSource();

    _stream = FirebaseFirestore.instance
        .collection('PreventiveMaintenance')
        .doc(widget.depoName)
        .collection(yearOption[widget.indexValue!])
        .doc(userId)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _preventiveYearlyDatasource.updateColumns([]);

    return Scaffold(
      appBar: CustomAppBar(
        depoName: widget.depoName ?? '',
        isCentered: true,
        title: 'Preventive Maintanance',
        height: 50,
        isSync: true,
        store: () async {
          // overviewFieldstore(widget.cityName!, widget.depoName!);
          _preventiveYearlyDatasource.preventiveMaintenanceStore(
              context, userId, widget.depoName!);
          // storeData(widget.depoName!, context);
        },
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
                  source: _preventiveYearlyDatasource,
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
                    // A function to calculate text height
                    return 115; // Add padding or margin as needed
                  },
                  // onQueryRowHeight: (details) {
                  //   return details.getIntrinsicRowHeight(details.rowIndex);
                  // },
                  columns: _preventiveYearlyDatasource.columns);
            } else {
              _preventiveYearlyDatasource.fetchDataFromFirebase();
              alldata = '';
              alldata = snapshot.data!['data'] as List<dynamic>;
              subDate = snapshot.data!['submission Date'] as List<dynamic>;
              _preventiveYearlyModel.clear();
              alldata.forEach((element) {
                _preventiveYearlyModel
                    .add(PreventiveYearlyModel.fromJson(element));

                _preventiveYearlyModel.forEach((model) {
                  List<DataGridCell> cells = [
                    DataGridCell<int>(columnName: 'srNo', value: model.srNo),
                    DataGridCell<String>(
                        columnName: 'equipment', value: model.equipment),
                    DataGridCell<String>(
                        columnName: 'frequency', value: model.frequency),
                    DataGridCell<String>(
                        columnName: 'installationDate',
                        value: model.installationDate),
                  ];
                  List<String> dates = [];

                  for (int i = 0; i < subDate.length; i++) {
                    // Each item in subDate is a Map with one key-value pair
                    Map<String, dynamic> maintenanceData =
                        subDate[i] as Map<String, dynamic>;

                    String columnName = maintenanceData.keys
                        .first; // Key is like 'Maintenance 1', 'Maintenance 2', etc.
                    String maintenanceDate = maintenanceData.values.first
                        .toString(); // Value is the date string

                    cells.add(
                      DataGridCell<String>(
                        columnName: columnName, // Set column name dynamically
                        value:
                            maintenanceDate, // Set the maintenance date value
                      ),
                    );
                    dates.add(maintenanceDate);
                  }
                  model.maintenanceDates = dates;

                  _preventiveYearlyDatasource.updateColumns(dates);
                });
              });

              print(
                  'Row length ${_preventiveYearlyDatasource.dataGridRows.length}');

              // Refresh the grid
              _dataGridController = DataGridController();
              _preventiveYearlyDatasource
                  .buildDataGridRows(); // Rebuild rows after adding data
              _preventiveYearlyDatasource
                  .updateDatagridSource(); // Update the grid source

              return SfDataGrid(
                  source: _preventiveYearlyDatasource,
                  allowEditing: true,
                  frozenColumnsCount: 1,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  selectionMode: SelectionMode.single,
                  navigationMode: GridNavigationMode.cell,
                  editingGestureType: EditingGestureType.tap,
                  rowHeight: 50,
                  controller: _dataGridController,
                  onQueryRowHeight: (details) {
                    // A function to calculate text height
                    return 115; // Add padding or margin as needed
                  },
                  columns: _preventiveYearlyDatasource.columns);
            }
          },
        ),
      ),
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
}
