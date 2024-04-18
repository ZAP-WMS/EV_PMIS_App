import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/views/citiespage/depot.dart';

import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:ev_pmis_app/widgets/progress_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../components/Loading_page.dart';
import '../../datasource/materialprocurement_datasource.dart';

import '../../provider/cities_provider.dart';
import '../../style.dart';
import '../../models/material_procurement.dart';
import '../../widgets/custom_appbar.dart';
import '../authentication/authservice.dart';

class MaterialProcurement extends StatefulWidget {
  String? depoName;
  String? userId;
  String? role;
  MaterialProcurement(
      {super.key, required this.depoName, this.userId, this.role});

  @override
  State<MaterialProcurement> createState() => _MaterialProcurementState();
}

class _MaterialProcurementState extends State<MaterialProcurement> {
  final AuthService authService = AuthService();
  List<String> assignedDepots = [];
  bool isFieldEditable = false;
  List<MaterialProcurementModel> _materialprocurement = [];
  List<MaterialProcurementModel> data = [];
  late MaterialDatasource _materialDatasource;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  bool checkTable = true;
  bool isLoading = true;
  dynamic alldata;
  String? cityName;

  @override
  void initState() {
    getAssignedDepots();
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;
    _materialDatasource = MaterialDatasource(
        _materialprocurement, context, cityName, widget.depoName);
    _dataGridController = DataGridController();

    getUserId().whenComplete(() {
      // getTableData().whenComplete(() {
      _stream = FirebaseFirestore.instance
          .collection('MaterialProcurement')
          .doc('${widget.depoName}')
          .collection('Material Data')
          .doc(userId)
          .snapshots();
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavbarDrawer(role: widget.role),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          depoName: widget.depoName ?? '',
          isCentered: true,
          title: 'Material Procurement',
          height: 50,
          isSync: isFieldEditable ? true : false,
          store: () {
            showProgressDilogue(context);
            storeData();
          },
        ),
      ),
      body: isLoading
          ? const LoadingPage()
          : Column(
            children: [
              SfDataGridTheme(
                  data: SfDataGridThemeData(
                    headerColor: white,
                    gridLineColor: blue,
                    gridLineStrokeWidth: 2,
                  ),
                  child: Expanded(
                    child: StreamBuilder(
                        stream: _stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data.exists == false) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: SfDataGrid(
                                  source: _materialDatasource,
                                  allowEditing: isFieldEditable,
                                  frozenColumnsCount: 1,
                                  gridLinesVisibility: GridLinesVisibility.both,
                                  headerGridLinesVisibility:
                                      GridLinesVisibility.both,
                                  selectionMode: SelectionMode.single,
                                  navigationMode: GridNavigationMode.cell,
                                  columnWidthMode: ColumnWidthMode.auto,
                                  editingGestureType: EditingGestureType.tap,
                                  controller: _dataGridController,
                                  columns: [
                                    GridColumn(
                                      columnName: 'cityName',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      allowEditing: true,
                                      width: 100,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'City Name',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: tableheaderwhitecolor,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'details',
                                      width: 250,
                                      allowEditing: true,
                                      label: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        alignment: Alignment.center,
                                        child: Text('Details Item Description',
                                            textAlign: TextAlign.center,
                                            style: tableheaderwhitecolor),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'olaNo',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 130,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text('OLA No',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'vendorName',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 130,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text('Vendor Name',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'oemApproval',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 150,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'OEM Drawing Approval by Engg',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'oemClearance',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 250,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                            'Manufacturing clearance Given to OEM',
                                            overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'croPlacement',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 250,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Delivery time line after Placement of CRO',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'croVendor',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 250,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'CRO release to Vendor',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'croNumber',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 120,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'CRO Number ',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'unit',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 120,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Unit',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'qty',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 120,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text('Qty',
                                            overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'materialSite',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: false,
                                      width: 250,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                            'Receipt of Material at site',
                                            overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Add',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: false,
                                      width: 80,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text('Add Row',
                                            overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Delete',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: false,
                                      width: 120,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text('Delete Row',
                                            overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                  ]),
                            );
                          } else {
                            alldata = '';
                            alldata = snapshot.data['data'] as List<dynamic>;
                            _materialprocurement.clear();
                            alldata.forEach((element) {
                              _materialprocurement.add(
                                MaterialProcurementModel.fromjson(
                                  element,
                                ),
                              );
                              _materialDatasource = MaterialDatasource(
                                  _materialprocurement,
                                  context,
                                  cityName,
                                  widget.depoName);
                            });
                            _dataGridController = DataGridController();
                            _materialDatasource.buildDataGridRows();
                            _materialDatasource.updateDatagridSource();

                            return SfDataGrid(
                                source: _materialDatasource,
                                allowEditing: isFieldEditable,
                                frozenColumnsCount: 1,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                selectionMode: SelectionMode.single,
                                navigationMode: GridNavigationMode.cell,
                                columnWidthMode: ColumnWidthMode.auto,
                                editingGestureType: EditingGestureType.tap,
                                controller: _dataGridController,
                                columns: [
                                  GridColumn(
                                    columnName: 'cityName',
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: true,
                                    width: 100,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('City Name',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: tableheaderwhitecolor
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'details',
                                    width: 250,
                                    allowEditing: true,
                                    label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: Text('Details Item Description',
                                          textAlign: TextAlign.center,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'olaNo',
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: true,
                                    width: 130,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('OLA No',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'vendorName',
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: true,
                                    width: 130,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('Vendor Name',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'oemApproval',
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: true,
                                    width: 150,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'OEM Drawing Approval by Engg',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'oemClearance',
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Manufacturing clearance given to OEM',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'croPlacement',
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Delivery time line after Placement of CRO',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'croVendor',
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'CRO release to Vendor',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'croNumber',
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: true,
                                    width: 120,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'CRO Number ',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'unit',
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: true,
                                    width: 120,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('Unit',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'qty',
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: true,
                                    width: 120,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('Qty',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'materialSite',
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: false,
                                    width: 250,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Receipt of Material at site',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Add',
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: false,
                                    width: 80,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Add Row',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Delete',
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: false,
                                    width: 80,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Delete Row',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ]);
                          }
                        }),
                  ))
            ]),
      floatingActionButton: isFieldEditable
          ? FloatingActionButton(
              onPressed: (() {
                _materialprocurement.add(
                  MaterialProcurementModel(
                    cityName: '',
                    details: '',
                    olaNo: '',
                    vendorName: '',
                    oemApproval: '',
                    oemClearance: '',
                    croPlacement: '',
                    croVendor: '',
                    croNumber: '',
                    unit: '',
                    qty: 1,
                    materialSite: DateFormat('dd-MM-yyyy').format(
                      DateTime.now(),
                    ),
                  ),
                );
                _dataGridController = DataGridController();
                _materialDatasource.buildDataGridRows();
                _materialDatasource.updateDatagridSource();
              }),
              child: const Icon(
                Icons.add,
              ),
            )
          : Container(),
    );
  }

  void storeData() {
    Map<String, dynamic> tableData = {};
    for (var i in _materialDatasource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button') {
          tableData[data.columnName] = data.value;
        }
      }

      tabledata2.add(tableData);
      tableData = {};
    }

    FirebaseFirestore.instance
        .collection('MaterialProcurement')
        .doc('${widget.depoName}')
        .collection('Material Data')
        .doc(userId)
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

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
      setState(() {});
    });
  }

  List<MaterialProcurementModel> getmonthlyReport() {
    return [
      MaterialProcurementModel(
          cityName: '',
          details: '',
          olaNo: '',
          vendorName: '',
          oemApproval: '',
          oemClearance: '',
          croPlacement: '',
          croVendor: '',
          croNumber: '',
          unit: '',
          qty: 1,
          materialSite: DateFormat().add_yMd().format(DateTime.now()))
    ];
  }

  // Future<void> getTableData() async {
  //   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //       .collection('MaterialProcurement')
  //       .doc('${widget.depoName}')
  //       .collection('Material Data')
  //       .doc(userId)
  //       .get();

  //   if (documentSnapshot.exists) {
  //     Map<String, dynamic> tempData =
  //         documentSnapshot.data() as Map<String, dynamic>;

  //     List<dynamic> mapData = tempData['data'];

  //     _materialprocurement =
  //         mapData.map((map) => MaterialProcurementModel.fromjson(map)).toList();
  //     checkTable = false;
  //   }

  //   isLoading = false;
  //   setState(() {});
  // }

  Future getAssignedDepots() async {
    assignedDepots = await authService.getDepotList();
    isFieldEditable =
        authService.verifyAssignedDepot(widget.depoName!, assignedDepots);
  }
}
