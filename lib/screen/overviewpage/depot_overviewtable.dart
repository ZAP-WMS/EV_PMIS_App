import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../components/Loading_page.dart';
import '../../datasource/depot_overviewdatasource.dart';
import '../../model/depot_overview.dart';
import '../../provider/cities_provider.dart';
import '../../style.dart';
import '../homepage/gallery.dart';

late DepotOverviewDatasource _employeeDataSource;
List<DepotOverviewModel> _employees = <DepotOverviewModel>[];
late DataGridController _dataGridController;
List<dynamic> tabledata2 = [];

class OverviewTable extends StatefulWidget {
  String? depoName;
  // String? depoName;

  OverviewTable({
    this.depoName,
    super.key,
  });

  @override
  State<OverviewTable> createState() => _OverviewTableState();
}

class _OverviewTableState extends State<OverviewTable> {
  String? cityName;

  // TextEditingController _addressController = TextEditingController();

  List fileNames = [];

  Stream? _stream;
  var alldata;
  Uint8List? fileBytes;
  Uint8List? fileBytes1;
  Uint8List? fileBytes2;
  bool isdialog = false;
  bool _isloading = true;

  @override
  void initState() {
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;

    _employees = getEmployeeData();
    // ignore: use_build_context_synchronously
    _employeeDataSource = DepotOverviewDatasource(_employees, context);
    _dataGridController = DataGridController();

    _stream = FirebaseFirestore.instance
        .collection('OverviewCollectionTable')
        .doc(widget.depoName)
        .collection("OverviewTabledData")
        .doc(userId)
        .snapshots();

    _isloading = false;
    setState(() {});
    super.initState();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const NavbarDrawer(),
        appBar: CustomAppBar(
            title: '$cityName/Depot Overview/${widget.depoName}',
            height: 50,
            isSync: true,
            store: () {
              storeData(widget.depoName!, context);
            },
            isCentered: false),
        body: _isloading
            ? LoadingPage()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: 500,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: blue),
                        child: Text(
                          'Brief Overview of ${widget.depoName} E-Bus Depot',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: white),
                        )),
                  ),
                  Expanded(
                      child: StreamBuilder(
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data.exists == false) {
                        return SfDataGridTheme(
                          data: SfDataGridThemeData(headerColor: blue),
                          child: SfDataGrid(
                            source: _employeeDataSource,
                            allowEditing: true,
                            frozenColumnsCount: 2,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            // checkboxColumnSettings:
                            //     DataGridCheckboxColumnSettings(
                            //         showCheckboxOnHeader: false),
                            // showCheckboxColumn: true,
                            selectionMode: SelectionMode.multiple,
                            navigationMode: GridNavigationMode.cell,
                            columnWidthMode: ColumnWidthMode.auto,
                            editingGestureType: EditingGestureType.tap,
                            controller: _dataGridController,
                            onQueryRowHeight: (details) {
                              return details
                                  .getIntrinsicRowHeight(details.rowIndex);
                            },
                            columns: [
                              GridColumn(
                                visible: false,
                                columnName: 'srNo',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: true,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Sr No',
                                    style: tableheaderwhitecolor,
                                    softWrap: true,
                                    //   //  textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Date',
                                width: 130,
                                allowEditing: false,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Risk On Date',
                                    // overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor,
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'RiskDescription',
                                width: 180,
                                // autoFitPadding: tablepadding,
                                allowEditing: true,
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('Risk Description',
                                      //  textAlign: TextAlign.center,
                                      softWrap: true,
                                      overflow: TextOverflow.clip,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'TypeRisk',
                                width: 180,
                                allowEditing: false,
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('Type',
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'impactRisk',
                                width: 150,
                                allowEditing: false,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Impact Risk',
                                      // overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Owner',
                                allowEditing: true,
                                width: 150,
                                label: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text('Owner',
                                          textAlign: TextAlign.center,
                                          // overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                    Text('Person Who will manage the risk',
                                        // overflow: TextOverflow.values.first,
                                        textAlign: TextAlign.center,
                                        style: tableheadersubtitle)
                                  ],
                                ),
                              ),
                              GridColumn(
                                columnName: 'MigratingRisk',
                                allowEditing: true,
                                columnWidthMode: ColumnWidthMode.fitByCellValue,
                                width: 150,
                                label: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text('Mitigation Action',
                                          // overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                    Text(
                                        'Action to Mitigate the risk e.g reduce the likelihood',
                                        // overflow: TextOverflow.values.first,
                                        textAlign: TextAlign.center,
                                        style: tableheadersubtitle),
                                  ],
                                ),
                              ),
                              GridColumn(
                                columnName: 'ContigentAction',
                                allowEditing: true,
                                width: 180,
                                label: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      alignment: Alignment.center,
                                      child: Text('Contigent Action',
                                          // overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                    Text(
                                        'Action to be taken if the risk happens',
                                        // overflow: TextOverflow.values.first,
                                        textAlign: TextAlign.center,
                                        style: tableheadersubtitle)
                                  ],
                                ),
                              ),
                              GridColumn(
                                columnName: 'ProgressionAction',
                                allowEditing: true,
                                width: 180,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('Progression Action',
                                      // overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Reason',
                                allowEditing: true,
                                width: 150,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('Remark',
                                      // overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'TargetDate',
                                allowEditing: false,
                                width: 160,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('Target Completion Date Of Risk',
                                      // overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Status',
                                allowEditing: false,
                                width: 150,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('Status',
                                      // overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Add',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Add Row',
                                      // overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //   //  textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Delete',
                                autoFitPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                allowEditing: false,
                                width: 120,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.center,
                                  child: Text('Delete Row',
                                      // overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //   //  textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        alldata = '';
                        alldata = snapshot.data['data'] as List<dynamic>;
                        _employees.clear();
                        alldata.forEach((element) {
                          _employees.add(DepotOverviewModel.fromJson(element));
                          _employeeDataSource =
                              DepotOverviewDatasource(_employees, context);
                          _dataGridController = DataGridController();
                        });
                        return Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SfDataGridTheme(
                                data: SfDataGridThemeData(headerColor: blue),
                                child: SfDataGrid(
                                  source: _employeeDataSource,
                                  allowEditing: true,
                                  frozenColumnsCount: 2,
                                  gridLinesVisibility: GridLinesVisibility.both,
                                  headerGridLinesVisibility:
                                      GridLinesVisibility.both,
                                  selectionMode: SelectionMode.single,
                                  navigationMode: GridNavigationMode.cell,
                                  columnWidthMode: ColumnWidthMode.fill,
                                  editingGestureType: EditingGestureType.tap,
                                  controller: _dataGridController,
                                  onQueryRowHeight: (details) {
                                    return details.getIntrinsicRowHeight(
                                        details.rowIndex,
                                        canIncludeHiddenColumns: true);
                                  },
                                  columns: [
                                    GridColumn(
                                      visible: false,
                                      width: 100,
                                      columnName: 'srNo',
                                      allowEditing: true,
                                      label: Container(
                                        child: Text(
                                          'Sr No',
                                          style: tableheaderwhitecolor,
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Date',
                                      width: 130,
                                      allowEditing: false,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Risk On Date',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          style: tableheaderwhitecolor,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'RiskDescription',
                                      width: 180,
                                      allowEditing: true,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Risk Description',
                                            overflow: TextOverflow.ellipsis,
                                            style: tableheaderwhitecolor),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'TypeRisk',
                                      width: 180,
                                      allowEditing: false,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Type',
                                            softWrap:
                                                true, // Allow text to wrap
                                            overflow: TextOverflow.clip,
                                            style: tableheaderwhitecolor),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'impactRisk',
                                      width: 150,
                                      allowEditing: false,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Impact Risk',
                                            softWrap:
                                                true, // Allow text to wrap
                                            overflow: TextOverflow.clip,
                                            style: tableheaderwhitecolor),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Owner',
                                      allowEditing: true,
                                      width: 150,
                                      label: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text('Owner',
                                                softWrap:
                                                    true, // Allow text to wrap
                                                overflow: TextOverflow.clip,
                                                style: tableheaderwhitecolor),
                                          ),
                                          Text(
                                              'Person Who will manage the risk',
                                              softWrap:
                                                  true, // Allow text to wrap
                                              overflow: TextOverflow.clip,
                                              textAlign: TextAlign.center,
                                              style: tableheaderwhitecolor)
                                        ],
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'MigratingRisk',
                                      allowEditing: true,
                                      width: 150,
                                      label: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text('Mitigation Action',
                                                softWrap:
                                                    true, // Allow text to wrap
                                                overflow: TextOverflow.clip,
                                                style: tableheaderwhitecolor),
                                          ),
                                          Text(
                                              'Action to Mitigate the risk e.g reduce the likelihood',
                                              softWrap:
                                                  true, // Allow text to wrap
                                              overflow: TextOverflow.clip,
                                              style: tableheadersubtitle)
                                        ],
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ContigentAction',
                                      allowEditing: true,
                                      width: 180,
                                      label: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text('Contigent Action',
                                                softWrap:
                                                    true, // Allow text to wrap
                                                overflow: TextOverflow.clip,
                                                style: tableheaderwhitecolor),
                                          ),
                                          Text(
                                              'Action to be taken if the risk happens',
                                              softWrap:
                                                  true, // Allow text to wrap
                                              overflow: TextOverflow.clip,
                                              textAlign: TextAlign.center,

                                              //  textAlign: TextAlign.center,
                                              style: tableheadersubtitle)
                                        ],
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ProgressionAction',
                                      allowEditing: true,
                                      width: 180,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Progression Action',
                                            softWrap:
                                                true, // Allow text to wrap
                                            overflow: TextOverflow.clip,
                                            // overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Reason',
                                      allowEditing: true,
                                      width: 150,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Remark',
                                            softWrap:
                                                true, // Allow text to wrap
                                            overflow: TextOverflow.clip,
                                            // overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'TargetDate',
                                      allowEditing: false,
                                      width: 160,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                            'Target Completion Date Of Risk',
                                            softWrap:
                                                true, // Allow text to wrap
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                            style: tableheaderwhitecolor),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Status',
                                      allowEditing: false,
                                      width: 150,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Status',
                                            softWrap:
                                                true, // Allow text to wrap
                                            overflow: TextOverflow.clip,
                                            style: tableheaderwhitecolor),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Add',
                                      allowEditing: false,
                                      width: 120,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Add Row',
                                            softWrap:
                                                true, // Allow text to wrap
                                            overflow: TextOverflow.clip,
                                            style: tableheaderwhitecolor
                                            //   //  textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Delete',
                                      allowEditing: false,
                                      width: 120,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text('Delete Row',
                                            softWrap:
                                                true, // Allow text to wrap
                                            overflow: TextOverflow.clip,
                                            style: tableheaderwhitecolor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  )),
                ],
              ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  Get.back();
                },
                label: const Text('Previous Page'),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  heroTag: 'add',
                  onPressed: () {
                    _employees.add(
                      DepotOverviewModel(
                        srNo: 1,
                        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                        riskDescription: '',
                        typeRisk: 'Material Supply',
                        impactRisk: 'High',
                        owner: '',
                        migrateAction: ' ',
                        contigentAction: '',
                        progressAction: '',
                        reason: '',
                        targetDate:
                            DateFormat('dd-MM-yyyy').format(DateTime.now()),
                        status: 'Close',
                      ),
                    );

                    _employeeDataSource.buildDataGridRows();
                    _employeeDataSource.updateDatagridSource();
                  },
                  child: const Icon(Icons.add),
                ),
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      ),
    );
  }

  List<DepotOverviewModel> getEmployeeData() {
    return [
      DepotOverviewModel(
          srNo: 1,
          date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          riskDescription: '',
          typeRisk: 'Material Supply',
          impactRisk: 'High',
          owner: '',
          migrateAction: ' ',
          contigentAction: '',
          progressAction: '',
          reason: '',
          targetDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          status: 'Close')
    ];
  }
}

void storeData(String depoName, BuildContext context) {
  // _employeeDataSource = DepotOverviewDatasource(_employees, context);
  // _dataGridController = DataGridController();
  Map<String, dynamic> table_data = Map();
  for (var i in _employeeDataSource.dataGridRows) {
    for (var data in i.getCells()) {
      if (data.columnName != 'Add' || data.columnName != 'Delete') {
        table_data[data.columnName] = data.value;
      }
    }
    tabledata2.add(table_data);
    table_data = {};
  }

  FirebaseFirestore.instance
      .collection('OverviewCollectionTable')
      .doc(depoName)
      .collection("OverviewTabledData")
      .doc(userId)
      .set({
    'data': tabledata2,
  }).whenComplete(() {
    tabledata2.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Data are synced'),
      backgroundColor: blue,
    ));
  });

  // void storeData() {
  //   Map<String, dynamic> table_data = Map();
  //   for (var i in _employeeDataSource.dataGridRows) {
  //     for (var data in i.getCells()) {
  //       if (data.columnName != 'Add' || data.columnName != 'Delete') {
  //         table_data[data.columnName] = data.value;
  //       }
  //     }
  //     tabledata2.add(table_data);
  //     table_data = {};
  //   }

  //   FirebaseFirestore.instance
  //       .collection('OverviewCollectionTable')
  //       .doc(depoName)
  //       .collection("OverviewTabledData")
  //       .doc(userId)
  //       .set({
  //     'data': tabledata2,
  //   }).whenComplete(() {
  //     tabledata2.clear();
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: const Text('Data are synced'),
  //       backgroundColor: blue,
  //     ));
  //   });
  // }
}
