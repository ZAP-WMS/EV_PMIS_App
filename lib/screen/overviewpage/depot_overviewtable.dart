// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../components/Loading_page.dart';
import '../../datasource/depot_overviewdatasource.dart';
import '../../model/home/overview/depot_overview.dart';
import '../../style.dart';
import '../../widgets/custom_appbar.dart';

class OverviewTable extends StatefulWidget {
  String? cityName;
  // String? depoName;

  OverviewTable({
    this.cityName,
    super.key,
  });

  @override
  State<OverviewTable> createState() => _OverviewTableState();
}

class _OverviewTableState extends State<OverviewTable> {
  late DepotOverviewDatasource _employeeDataSource;
  List<DepotOverviewModel> _employees = <DepotOverviewModel>[];
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];

  // TextEditingController _addressController = TextEditingController();
  bool _isloading = true;
  List fileNames = [];
  late TextEditingController _addressController,
      _scopeController,
      _chargerController,
      _ratingController,
      _loadController,
      _powersourceController,
      _elctricalManagerNameController,
      _electricalEngineerController,
      _electricalVendorController,
      _civilManagerNameController,
      _civilEngineerController,
      _civilVendorController;

  // var address,
  //     scope,
  //     required,
  //     charger,
  //     load,
  //     powerSource,
  //     boqElectrical,
  //     boqCivil,
  //     managername,
  //     electmanagername,
  //     elecEng,
  //     elecVendor,
  //     civilmanagername,
  //     civilEng,
  //     civilVendor;

  Stream? _stream, _stream1;
  var alldata;
  Uint8List? fileBytes;
  Uint8List? fileBytes1;
  Uint8List? fileBytes2;
  dynamic userId;
  bool _isEdit = true;
  bool isdialog = false;

  void initializeController() {
    _addressController = TextEditingController();
    _scopeController = TextEditingController();
    _chargerController = TextEditingController();
    _ratingController = TextEditingController();
    _loadController = TextEditingController();
    _powersourceController = TextEditingController();
    _elctricalManagerNameController = TextEditingController();
    _electricalEngineerController = TextEditingController();
    _electricalVendorController = TextEditingController();
    _civilManagerNameController = TextEditingController();
    _civilEngineerController = TextEditingController();
    _civilVendorController = TextEditingController();
  }

  @override
  void initState() {
    initializeController();
    @override
    void initState() {
      super.initState();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }

    _employees = getEmployeeData();
    // ignore: use_build_context_synchronously
    _employeeDataSource = DepotOverviewDatasource(_employees, context);
    _dataGridController = DataGridController();

    // getUserId().whenComplete(() {
    //   _employees = getEmployeeData();
    //   // ignore: use_build_context_synchronously
    //   _employeeDataSource = DepotOverviewDatasource(_employees, context);
    //   _dataGridController = DataGridController();
    //   _stream = FirebaseFirestore.instance
    //       .collection('OverviewCollectionTable')
    //       .doc(widget.depoName)
    //       .collection("OverviewTabledData")
    //       .doc(userId)
    //       .snapshots();

    //   _stream1 = FirebaseFirestore.instance
    //       .collection('OverviewCollection')
    //       .doc(widget.depoName)
    //       .collection('OverviewFieldData')
    //       .doc(userId)
    //       .snapshots();

    //   _fetchUserData();
    //   _isloading = false;
    //   setState(() {});
    // });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
            // _isloading
            //     ? LoadingPage()
            //     :
            Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: 500,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: blue),
                  child: Text(
                    'Brief Overview of ${widget.cityName} E-Bus Depot',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: white),
                  )),
            ),
            Expanded(
                child: StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data.exists == false) {
                  return SfDataGrid(
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
                      return details.getIntrinsicRowHeight(details.rowIndex);
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
                            style: tableheader,
                            softWrap: true,
                            //   //  textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Date',
                        width: 160,
                        allowEditing: false,
                        label: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Risk On Date',
                            // overflow: TextOverflow.values.first,
                            style: tableheader,
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
                              style: tableheader),
                        ),
                      ),
                      GridColumn(
                        columnName: 'TypeRisk',
                        width: 180,
                        allowEditing: false,
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text('Type', style: tableheader),
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
                              style: tableheader),
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
                              child: const Text('Owner',
                                  // overflow: TextOverflow.values.first,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                            const Text('Person Who will manage the risk',
                                // overflow: TextOverflow.values.first,
                                //  textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12))
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                            Text(
                                'Action to Mitigate the risk e.g reduce the likelihood',
                                // overflow: TextOverflow.values.first,
                                //  textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12))
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text('Contigent Action',
                                  // overflow: TextOverflow.values.first,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                            Text('Action to be taken if the risk happens',
                                // overflow: TextOverflow.values.first,
                                //  textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12))
                          ],
                        ),
                      ),
                      GridColumn(
                        columnName: 'ProgressionAction',
                        allowEditing: true,
                        width: 180,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text('Progression Action',
                              // overflow: TextOverflow.values.first,
                              style: tableheader),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Reason',
                        allowEditing: true,
                        width: 150,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text('Remark',
                              // overflow: TextOverflow.values.first,
                              style: tableheader),
                        ),
                      ),
                      GridColumn(
                        columnName: 'TargetDate',
                        allowEditing: false,
                        width: 160,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text('Target Completion Date Of Risk',
                              // overflow: TextOverflow.values.first,
                              //  textAlign: TextAlign.center,
                              style: tableheader),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Status',
                        allowEditing: false,
                        width: 150,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text('Status',
                              // overflow: TextOverflow.values.first,
                              style: tableheader),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Add',
                        autoFitPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        allowEditing: false,
                        width: 120,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.center,
                          child: Text('Add Row',
                              // overflow: TextOverflow.values.first,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.center,
                          child: Text('Delete Row',
                              // overflow: TextOverflow.values.first,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )
                              //   //  textAlign: TextAlign.center,
                              ),
                        ),
                      ),
                    ],
                  );
                } else {
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
                        child: SfDataGrid(
                          source: _employeeDataSource,
                          allowEditing: true,
                          frozenColumnsCount: 2,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
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
                                  style: tableheader,
                                  softWrap: true, // Allow text to wrap
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Date',
                              width: 160,
                              allowEditing: false,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Risk On Date',
                                    softWrap: true, // Allow text to wrap
                                    overflow: TextOverflow.clip,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'RiskDescription',
                              width: 200,
                              allowEditing: true,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Risk Description',
                                    overflow: TextOverflow.ellipsis,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'TypeRisk',
                              width: 180,
                              allowEditing: false,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Type',
                                    softWrap: true, // Allow text to wrap
                                    overflow: TextOverflow.clip,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'impactRisk',
                              width: 150,
                              allowEditing: false,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Impact Risk',
                                    softWrap: true, // Allow text to wrap
                                    overflow: TextOverflow.clip,
                                    style: tableheader),
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
                                    child: const Text('Owner',
                                        softWrap: true, // Allow text to wrap
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ),
                                  const Text('Person Who will manage the risk',
                                      softWrap: true, // Allow text to wrap
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))
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
                                    child: const Text('Mitigation Action',
                                        softWrap: true, // Allow text to wrap
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ),
                                  const Text(
                                      'Action to Mitigate the risk e.g reduce the likelihood',
                                      softWrap: true, // Allow text to wrap
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))
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
                                    child: const Text('Contigent Action',
                                        softWrap: true, // Allow text to wrap
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ),
                                  const Text(
                                      'Action to be taken if the risk happens',
                                      softWrap: true, // Allow text to wrap
                                      overflow: TextOverflow.clip,

                                      //  textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))
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
                                    softWrap: true, // Allow text to wrap
                                    overflow: TextOverflow.clip,
                                    // overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Reason',
                              allowEditing: true,
                              width: 150,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Remark',
                                    softWrap: true, // Allow text to wrap
                                    overflow: TextOverflow.clip,
                                    // overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'TargetDate',
                              allowEditing: false,
                              width: 160,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Target Completion Date Of Risk',
                                    softWrap: true, // Allow text to wrap
                                    overflow: TextOverflow.clip,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Status',
                              allowEditing: false,
                              width: 150,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Status',
                                    softWrap: true, // Allow text to wrap
                                    overflow: TextOverflow.clip,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Add',
                              allowEditing: false,
                              width: 120,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Add Row',
                                    softWrap: true, // Allow text to wrap
                                    overflow: TextOverflow.clip,
                                    style: tableheader
                                    //   //  textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Delete',
                              allowEditing: false,
                              width: 120,
                              label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.center,
                                child: Text('Delete Row',
                                    softWrap: true, // Allow text to wrap
                                    overflow: TextOverflow.clip,
                                    style: tableheader),
                              ),
                            ),
                          ],
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
          child: FloatingActionButton.extended(
            onPressed: () {
              Get.back();
            },
            label: Text('Previous Page'),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      ),
    );
  }

  // }

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

  // OverviewField(String title, TextEditingController controller) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         Container(
  //           width: 200,
  //           child: Text(title, textAlign: TextAlign.start, style: formtext),
  //         ),
  //         Container(
  //           width: 200,
  //           child: CustomTextField(
  //             controller: controller,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
