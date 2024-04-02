import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/components/loading_pdf.dart';
import 'package:ev_pmis_app/models/quality_checklistModel.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:ev_pmis_app/views/citiespage/depot.dart';
import 'package:ev_pmis_app/widgets/appbar_back_date.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../QualityDatasource/qualityElectricalDatasource/quality_EP.dart';
import '../../../../QualityDatasource/qualityElectricalDatasource/quality_acdb.dart';
import '../../../../QualityDatasource/qualityElectricalDatasource/quality_cdi.dart';
import '../../../../QualityDatasource/qualityElectricalDatasource/quality_charger.dart';
import '../../../../QualityDatasource/qualityElectricalDatasource/quality_ci.dart';
import '../../../../QualityDatasource/qualityElectricalDatasource/quality_cmu.dart';
import '../../../../QualityDatasource/qualityElectricalDatasource/quality_ct.dart';
import '../../../../QualityDatasource/qualityElectricalDatasource/quality_msp.dart';
import '../../../../QualityDatasource/qualityElectricalDatasource/quality_pss.dart';
import '../../../../QualityDatasource/qualityElectricalDatasource/quality_rmu.dart';
import '../../../../components/Loading_page.dart';
import '../../../../provider/cities_provider.dart';
import '../../../../style.dart';
import '../../../../widgets/custom_textfield.dart';
import '../../../../widgets/quality_list.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ElectricalField extends StatefulWidget {
  String? depoName;
  String? title;
  String? fielClnName;
  int? titleIndex;
  String? role;
  ElectricalField(
      {super.key,
      required this.depoName,
      required this.title,
      this.role,
      required this.fielClnName,
      required this.titleIndex});

  @override
  State<ElectricalField> createState() => _ElectricalFieldState();
}

class _ElectricalFieldState extends State<ElectricalField> {
  final AuthService authService = AuthService();
  List<String> assignedDepots = [];
  bool isFieldEditable = false;
  String pathToOpenFile = '';
  List<QualitychecklistModel> data = [];
  bool checkTable = true;
  bool isLoading = true;
  String? selectedDate = DateFormat.yMMMMd().format(DateTime.now());
  String? visDate = DateFormat.yMMMd().format(DateTime.now());

  String? cityName;
  Stream? _stream;
  dynamic alldata;
  late DataGridController _dataGridController;
  late QualityPSSDataSource _qualityPSSDataSource;
  late QualityrmuDataSource _qualityrmuDataSource;
  late QualityctDataSource _qualityctDataSource;
  late QualitycmuDataSource _qualitycmuDataSource;
  late QualityacdDataSource _qualityacdDataSource;
  late QualityCIDataSource _qualityCIDataSource;
  late QualityCDIDataSource _qualityCDIDataSource;
  late QualityMSPDataSource _qualityMSPDataSource;
  late QualityChargerDataSource _qualityChargerDataSource;
  late QualityEPDataSource _qualityEPDataSource;

  List<dynamic> psstabledatalist = [];
  List<dynamic> rmutabledatalist = [];
  List<dynamic> cttabledatalist = [];
  List<dynamic> cmutabledatalist = [];
  List<dynamic> acdbtabledatalist = [];
  List<dynamic> citabledatalist = [];
  List<dynamic> cditabledatalist = [];
  List<dynamic> msptabledatalist = [];
  List<dynamic> chargertabledatalist = [];
  List<dynamic> eptabledatalist = [];

  List<QualitychecklistModel> qualitylisttable1 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable2 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable3 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable4 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable5 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable6 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable7 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable8 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable9 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable10 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable11 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable12 = <QualitychecklistModel>[];

  late TextEditingController nameController,
      docController,
      vendorController,
      dateController,
      olaController,
      panelController,
      depotController,
      customerController;

  void initializeController() {
    nameController = TextEditingController();
    docController = TextEditingController();
    vendorController = TextEditingController();
    dateController = TextEditingController();
    // dateController = TextEditingController();
    olaController = TextEditingController();
    panelController = TextEditingController();
    depotController = TextEditingController();
    customerController = TextEditingController();
  }

  @override
  void initState() {
    getAssignedDepots();
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;
    _stream = FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc('${widget.depoName}')
        .collection('userId')
        .doc(userId)
        .collection(widget.fielClnName!)
        .doc(selectedDate)
        .snapshots();

    initializeController();
    _fetchUserData();

    getTableData().whenComplete(() {
      qualitylisttable1 = checkTable ? getData() : data;
      _qualityPSSDataSource =
          QualityPSSDataSource(qualitylisttable1, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable2 = checkTable ? rmu_getData() : data;
      _qualityrmuDataSource =
          QualityrmuDataSource(qualitylisttable2, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable3 = checkTable ? ct_getData() : data;
      _qualityctDataSource =
          QualityctDataSource(qualitylisttable3, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable4 = checkTable ? cmu_getData() : data;
      _qualitycmuDataSource =
          QualitycmuDataSource(qualitylisttable4, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable5 = checkTable ? acdb_getData() : data;
      _qualityacdDataSource =
          QualityacdDataSource(qualitylisttable5, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable6 = checkTable ? ci_getData() : data;
      _qualityCIDataSource =
          QualityCIDataSource(qualitylisttable6, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable7 = checkTable ? cdi_getData() : data;
      _qualityCDIDataSource =
          QualityCDIDataSource(qualitylisttable7, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable8 = checkTable ? msp_getData() : data;
      _qualityMSPDataSource =
          QualityMSPDataSource(qualitylisttable8, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable9 = checkTable ? charger_getData() : data;
      _qualityChargerDataSource = QualityChargerDataSource(
          qualitylisttable9, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable10 = checkTable ? earth_pit_getData() : data;
      _qualityEPDataSource =
          QualityEPDataSource(qualitylisttable10, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      isLoading = false;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavbarDrawer(role: widget.role),
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: CustomAppBarBackDate(
                isDownload: true,
                downloadFun: downloadPDF,
                depoName: widget.depoName!,
                text: '${widget.title}',
                haveSummary: false,
                haveSynced: isFieldEditable ? true : false,
                haveCalender: true,
                store: () {
                  _showDialog(context);
                  storeData(
                      context,
                      widget.fielClnName == 'PSS'
                          ? _qualityPSSDataSource
                          : widget.fielClnName == 'RMU'
                              ? _qualityrmuDataSource
                              : widget.fielClnName == 'CT'
                                  ? _qualityctDataSource
                                  : widget.fielClnName == 'CMU'
                                      ? _qualitycmuDataSource
                                      : widget.fielClnName == 'ACDB'
                                          ? _qualityacdDataSource
                                          : widget.fielClnName == 'CI'
                                              ? _qualityCIDataSource
                                              : widget.fielClnName == 'CDI'
                                                  ? _qualityCDIDataSource
                                                  : widget.fielClnName == 'MSP'
                                                      ? _qualityMSPDataSource
                                                      : widget.fielClnName ==
                                                              'CHARGER'
                                                          ? _qualityChargerDataSource
                                                          : _qualityEPDataSource,
                      widget.depoName!,
                      selectedDate!);
                  FirebaseFirestore.instance
                      .collection('ElectricalChecklistField')
                      .doc('${widget.depoName}')
                      .collection('userId')
                      .doc(userId)
                      .collection(widget.fielClnName!)
                      .doc(selectedDate)
                      .set({
                    'employeeName': nameController.text,
                    'docNo': docController.text,
                    'vendor': vendorController.text,
                    'date': dateController.text,
                    'olaNumber': olaController.text,
                    'panelNumber': panelController.text,
                    'depotName': depotController.text,
                    'customerName': customerController.text
                  });
                },
                showDate: visDate,
                choosedate: () {
                  chooseDate(context);
                })),
        body: isLoading
            ? const LoadingPage()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    electricalField(nameController, 'Employee Name'),
                    electricalField(docController, 'Dist EV'),
                    electricalField(vendorController, 'Vendor Name'),
                    electricalField(dateController, 'Date'),
                    electricalField(olaController, 'Ola No'),
                    electricalField(panelController, 'Panel No'),
                    electricalField(depotController, 'Depot Name'),
                    electricalField(customerController, 'Customer Name'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: StreamBuilder(
                        stream: _stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data.exists == false) {
                            return
                                //  widget.isHeader!
                                //     ?
                                SfDataGridTheme(
                              data: SfDataGridThemeData(
                                  gridLineColor: blue,
                                  gridLineStrokeWidth: 2,
                                  frozenPaneLineColor: blue),
                              child: SfDataGrid(
                                source: widget.fielClnName == 'PSS'
                                    ? _qualityPSSDataSource
                                    : widget.fielClnName == 'RMU'
                                        ? _qualityrmuDataSource
                                        : widget.fielClnName == 'CT'
                                            ? _qualityctDataSource
                                            : widget.fielClnName == 'CMU'
                                                ? _qualitycmuDataSource
                                                : widget.fielClnName == 'ACDB'
                                                    ? _qualityacdDataSource
                                                    : widget.fielClnName == 'CI'
                                                        ? _qualitycmuDataSource
                                                        : widget.fielClnName ==
                                                                'CDI'
                                                            ? _qualityCDIDataSource
                                                            : widget.fielClnName ==
                                                                    'MSP'
                                                                ? _qualityMSPDataSource
                                                                : widget.fielClnName ==
                                                                        'CHARGER'
                                                                    ? _qualityChargerDataSource
                                                                    : _qualityEPDataSource,
                                // widget.titleIndex! == 10
                                //     ? _qualityRoofingDataSource
                                //     : _qualityPROOFINGDataSource,

                                //key: key,
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

                                // onQueryRowHeight: (details) {
                                //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                // },
                                columns: [
                                  GridColumn(
                                    columnName: 'srNo',
                                    width: 80,
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: false,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('Sr No',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    width: 350,
                                    columnName: 'checklist',
                                    allowEditing: false,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('ACTIVITY',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'responsibility',
                                    width: 250,
                                    allowEditing: true,
                                    label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: Text('RESPONSIBILITY',
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Reference',
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('DOCUMENT REFERENCE',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'observation',
                                    allowEditing: true,
                                    width: 200,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('OBSERVATION',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Upload',
                                    allowEditing: false,
                                    visible: true,
                                    width: 150,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('Upload',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'View',
                                    allowEditing: false,
                                    width: 150,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('View',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  // GridColumn(
                                  //   columnName: 'Delete',
                                  //   autoFitPadding:
                                  //       const EdgeInsets.symmetric(
                                  //           horizontal: 16),
                                  //   allowEditing: false,
                                  //   visible: true,
                                  //   width: 120,
                                  //   label: Container(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 8.0),
                                  //     alignment: Alignment.center,
                                  //     child: Text('Delete Row',
                                  //         overflow:
                                  //             TextOverflow.values.first,
                                  //         style: TextStyle(
                                  //             fontWeight: FontWeight.bold,
                                  //             fontSize: 16,
                                  //             color: white)
                                  //         //    textAlign: TextAlign.center,
                                  //         ),
                                  //   ),
                                  // ),
                                ],

                                // stackedHeaderRows: [
                                //   StackedHeaderRow(cells: [
                                //     StackedHeaderCell(
                                //         columnNames: ['SrNo'],
                                //         child: Container(child: Text('Project')))
                                //   ])
                                // ],
                              ),
                            );
                            // : Center(
                            //     child: Container(
                            //       padding: EdgeInsets.all(25),
                            //       decoration: BoxDecoration(
                            //           borderRadius:
                            //               BorderRadius.circular(20),
                            //           border: Border.all(color: blue)),
                            //       child: const Text(
                            //         '     No data available yet \n Please wait for admin process',
                            //         style: TextStyle(
                            //             fontSize: 30,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //     ),
                            //   );
                          } else if (snapshot.hasData) {
                            return SfDataGridTheme(
                              data: SfDataGridThemeData(
                                  gridLineColor: blue,
                                  gridLineStrokeWidth: 2,
                                  frozenPaneLineColor: blue),
                              child: SfDataGrid(
                                source: widget.fielClnName == 'PSS'
                                    ? _qualityPSSDataSource
                                    : widget.fielClnName == 'RMU'
                                        ? _qualityrmuDataSource
                                        : widget.fielClnName == 'CT'
                                            ? _qualityctDataSource
                                            : widget.fielClnName == 'CMU'
                                                ? _qualitycmuDataSource
                                                : widget.fielClnName == 'ACDB'
                                                    ? _qualityacdDataSource
                                                    : widget.fielClnName == 'CI'
                                                        ? _qualityCIDataSource
                                                        : widget.fielClnName ==
                                                                'CDI'
                                                            ? _qualityCDIDataSource
                                                            : widget.fielClnName ==
                                                                    'MSP'
                                                                ? _qualityMSPDataSource
                                                                : widget.fielClnName ==
                                                                        'CHARGER'
                                                                    ? _qualityChargerDataSource
                                                                    : _qualityEPDataSource,
                                // : widget.titleIndex! ==
                                //         10
                                //     ? _qualityRoofingDataSource
                                // : _qualityPROOFINGDataSource,

                                //key: key,
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

                                // onQueryRowHeight: (details) {
                                //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                // },
                                columns: [
                                  GridColumn(
                                    columnName: 'srNo',
                                    width: 80,
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: false,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('Sr No',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    width: 350,
                                    columnName: 'checklist',
                                    allowEditing: false,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('ACTIVITY',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'responsibility',
                                    width: 250,
                                    allowEditing: true,
                                    label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: Text('RESPONSIBILITY',
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Reference',
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('DOCUMENT REFERENCE',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'observation',
                                    allowEditing: true,
                                    width: 200,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('OBSERVATION',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Upload',
                                    allowEditing: false,
                                    visible: true,
                                    width: 150,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('Upload',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'View',
                                    allowEditing: false,
                                    width: 150,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('View',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                ],

                                // stackedHeaderRows: [
                                //   StackedHeaderRow(cells: [
                                //     StackedHeaderCell(
                                //         columnNames: ['SrNo'],
                                //         child: Container(child: Text('Project')))
                                //   ])
                                // ],
                              ),
                            );
                          } else {
                            // here we have to put Nodata page
                            return const LoadingPage();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ));

    // ),
  }

  Widget electricalField(TextEditingController controller, String title) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: CustomTextField(
          isFieldEditable: isFieldEditable,
          controller: controller,
          labeltext: title,
          // validatortext: '$title is Required',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next),
    );
  }

  void _showDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: CircularProgressIndicator(
              color: blue,
            ),
          ),
        ),
      ),
    );
  }

  storeData(BuildContext context, dynamic datasource, String depoName,
      String currentDate) {
    Map<String, dynamic> pssTableData = Map();
    Map<String, dynamic> rmuTableData = Map();
    Map<String, dynamic> ctTableData = Map();
    Map<String, dynamic> cmuTableData = Map();
    Map<String, dynamic> acdbTableData = Map();
    Map<String, dynamic> ciTableData = Map();
    Map<String, dynamic> cdiTableData = Map();
    Map<String, dynamic> mspTableData = Map();
    Map<String, dynamic> chargerTableData = Map();
    Map<String, dynamic> epTableData = Map();

    for (var i in datasource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'Upload' && data.columnName != 'View') {
          pssTableData[data.columnName] = data.value;
        }
      }

      psstabledatalist.add(pssTableData);
      pssTableData = {};
    }

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(widget.fielClnName!)
        .doc(selectedDate)
        .set({
      'data': psstabledatalist,
    }).whenComplete(() {
      psstabledatalist.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }

  void _fetchUserData() async {
    await FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(widget.depoName)
        .collection("userId")
        .doc(userId)
        .collection(widget.fielClnName!)
        .doc(selectedDate)
        .get()
        .then((ds) {
      if (ds.exists) {
        setState(() {
          nameController.text = ds.data()!['employeeName'] ?? '';
          docController.text = ds.data()!['docNo'] ?? '';
          vendorController.text = ds.data()!['vendor'] ?? '';
          dateController.text = ds.data()!['date'] ?? '';
          olaController.text = ds.data()!['olaNumber'] ?? '';
          panelController.text = ds.data()!['panelNumber'] ?? '';
          depotController.text = ds.data()!['depotName'] ?? '';
          customerController.text = ds.data()!['customerName'] ?? '';
        });
      } else {
        nameController.clear();
        docController.clear();
        vendorController.clear();
        dateController.clear();
        olaController.clear();
        panelController.clear();
        depotController.clear();
        customerController.clear();
      }
    });
  }

  Future<void> getTableData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection(widget.fielClnName!)
        .doc(selectedDate)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> tempData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapData = tempData['data'];

      data = mapData.map((map) => QualitychecklistModel.fromJson(map)).toList();
      checkTable = false;
    }
  }

  void chooseDate(BuildContext dialogcontext) {
    showDialog(
        context: dialogcontext,
        builder: (dialogcontext) => AlertDialog(
              title: const Text('All Date'),
              content: Container(
                  height: MediaQuery.of(dialogcontext).size.height * 0.8,
                  width: MediaQuery.of(dialogcontext).size.width * 0.8,
                  child: SfDateRangePicker(
                    selectionShape: DateRangePickerSelectionShape.rectangle,
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

                      visDate = DateFormat.yMMMd()
                          .format(DateTime.parse(value.toString()));
                      Navigator.pop(context);
                      setState(() {
                        checkTable = true;
                        _fetchUserData();
                        data.clear();
                        getTableData().whenComplete(() {
                          qualitylisttable1 = checkTable ? getData() : data;
                          _qualityPSSDataSource = QualityPSSDataSource(
                              qualitylisttable1, widget.depoName!, cityName!);
                          _dataGridController = DataGridController();

                          qualitylisttable2 = rmu_getData();
                          _qualityrmuDataSource = QualityrmuDataSource(
                              qualitylisttable2, widget.depoName!, cityName!);
                          _dataGridController = DataGridController();

                          qualitylisttable3 = ct_getData();
                          _qualityctDataSource = QualityctDataSource(
                              qualitylisttable3, widget.depoName!, cityName!);
                          _dataGridController = DataGridController();

                          qualitylisttable4 = cmu_getData();
                          _qualitycmuDataSource = QualitycmuDataSource(
                              qualitylisttable4, widget.depoName!, cityName!);
                          _dataGridController = DataGridController();

                          qualitylisttable5 = acdb_getData();
                          _qualityacdDataSource = QualityacdDataSource(
                              qualitylisttable5, widget.depoName!, cityName!);
                          _dataGridController = DataGridController();

                          qualitylisttable6 = ci_getData();
                          _qualityCIDataSource = QualityCIDataSource(
                              qualitylisttable6, widget.depoName!, cityName!);
                          _dataGridController = DataGridController();

                          qualitylisttable7 = cdi_getData();
                          _qualityCDIDataSource = QualityCDIDataSource(
                              qualitylisttable7, widget.depoName!, cityName!);
                          _dataGridController = DataGridController();

                          qualitylisttable8 = msp_getData();
                          _qualityMSPDataSource = QualityMSPDataSource(
                              qualitylisttable8, widget.depoName!, cityName!);
                          _dataGridController = DataGridController();

                          qualitylisttable9 = charger_getData();
                          _qualityChargerDataSource = QualityChargerDataSource(
                              qualitylisttable9, widget.depoName!, cityName!);
                          _dataGridController = DataGridController();

                          qualitylisttable10 = earth_pit_getData();
                          _qualityEPDataSource = QualityEPDataSource(
                              qualitylisttable10, widget.depoName!, cityName!);
                          _dataGridController = DataGridController();
                        });
                      });
                    }),
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  )),
            ));
  }

  Future<Uint8List> _generateElectricalPdf() async {
    final headerStyle =
        pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);

    final fontData1 =
        await rootBundle.load('assets/fonts/Montserrat-Medium.ttf');
    final fontData2 = await rootBundle.load('assets/fonts/Montserrat-Bold.ttf');

    const cellStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 14,
    );

    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
    );

    List<List<dynamic>> fieldData = [
      ['Employee Name :', nameController.text],
      ['OLA Number :', olaController.text],
      ['Doc No. :', docController.text],
      ['Panel Sr.No. : ', panelController.text],
      ['Vendor Name :', vendorController.text],
      ['Depot Name :', depotController.text],
      ['Date :', dateController.text],
      ['Customer Name :', customerController.text],
    ];

    List<pw.TableRow> rows = [];

    rows.add(pw.TableRow(children: [
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Sr No',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding:
              const pw.EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
          child: pw.Center(
              child: pw.Text('Activity',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Responsibility',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Document Reference',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Observation',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Image1',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Image2',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Image3',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
    ]));

    if (data.isNotEmpty) {
      List<pw.Widget> imageUrls = [];

      for (QualitychecklistModel mapData in data) {
        String imagesPath =
            'QualityChecklist/Electrical_Engineer/$cityName/${widget.depoName}/$userId/${widget.fielClnName} Table/$selectedDate/${mapData.srNo}';
        print('imagePath - $imagesPath');
        ListResult result =
            await FirebaseStorage.instance.ref().child(imagesPath).listAll();

        if (result.items.isNotEmpty) {
          for (var image in result.items) {
            String downloadUrl = await image.getDownloadURL();
            if (image.name.endsWith('.pdf')) {
              imageUrls.add(
                pw.Container(
                    width: 60,
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: pw.UrlLink(
                        child: pw.Text(image.name,
                            style: const pw.TextStyle(color: PdfColors.blue)),
                        destination: downloadUrl)),
              );
            } else {
              final myImage = await networkImage(downloadUrl);
              imageUrls.add(
                pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 100,
                    child: pw.Center(
                      child: pw.Image(myImage),
                    )),
              );
            }
          }
          if (imageUrls.length < 3) {
            int imageLoop = 3 - imageUrls.length;
            for (int i = 0; i < imageLoop; i++) {
              imageUrls.add(
                pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 100,
                    child: pw.Text('')),
              );
            }
          } else {
            if (imageUrls.length > 3) {
              int imageLoop = 11 - imageUrls.length;
              for (int i = 0; i < imageLoop; i++) {
                imageUrls.add(
                  pw.Container(
                      padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                      width: 60,
                      height: 100,
                      child: pw.Text('')),
                );
              }
            }
          }
        } else {
          int imageLoop = 3;
          for (int i = 0; i < imageLoop; i++) {
            imageUrls.add(
              pw.Container(
                  padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                  width: 60,
                  height: 100,
                  child: pw.Text('')),
            );
          }
        }

        result.items.clear();

        //Text Rows of PDF Table
        rows.add(pw.TableRow(children: [
          pw.Container(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Center(
                  child: pw.Text(mapData.srNo.toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.checklist,
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.responsibility,
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.reference.toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.observation.toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 14)))),
          imageUrls[0],
          imageUrls[1],
          imageUrls[2]
        ]));

        if (imageUrls.length - 3 > 0) {
          //Image Rows of PDF Table
          rows.add(pw.TableRow(children: [
            pw.Container(
                padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: pw.Text('')),
            pw.Container(
                padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                width: 60,
                height: 100,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      imageUrls[3],
                      imageUrls[4],
                    ])),
            imageUrls[5],
            imageUrls[6],
            imageUrls[7],
            imageUrls[8],
            imageUrls[9],
            imageUrls[10],
          ]));
        }
        imageUrls.clear();
      }
    }

    final pdf = pw.Document(
      pageMode: PdfPageMode.outlines,
    );

    pdf.addPage(
      pw.MultiPage(
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
                      pw.Text(
                          'Electrical Quality Report / ${widget.fielClnName} Table',
                          textScaleFactor: 2,
                          style: const pw.TextStyle(color: PdfColors.blue700)),
                      pw.SizedBox(width: 20),
                      pw.Container(
                        width: 120,
                        height: 120,
                        child: pw.Image(profileImage),
                      ),
                    ]),
              ]));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text('User ID - $userId',
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
                        text: '$cityName / ${widget.depoName}',
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
                        text: selectedDate,
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    pw.TextSpan(
                        text: 'UserID : $userId',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15)),
                  ])),
                ]),
            pw.SizedBox(height: 20)
          ]),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FixedColumnWidth(100),
              1: const pw.FixedColumnWidth(100),
            },
            headers: ['Details', 'Values'],
            headerStyle: headerStyle,
            headerPadding: const pw.EdgeInsets.all(10.0),
            data: fieldData,
            cellHeight: 35,
            cellStyle: cellStyle,
          )
        ],
      ),
    );

    //First Half Page

    pdf.addPage(
      pw.MultiPage(
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
                      pw.Text(
                          'Electrical Quality Report / ${widget.fielClnName} Table',
                          textScaleFactor: 2,
                          style: const pw.TextStyle(color: PdfColors.blue700)),
                      pw.Container(
                        width: 120,
                        height: 120,
                        child: pw.Image(profileImage),
                      ),
                    ]),
              ]));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text('User ID - $userId',
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
                  pw.Text(
                    'Place:  $cityName/${widget.depoName}',
                    textScaleFactor: 1.6,
                  ),
                  pw.Text(
                    'Date:  $selectedDate ',
                    textScaleFactor: 1.6,
                  )
                ]),
            pw.SizedBox(height: 20)
          ]),
          pw.SizedBox(height: 10),
          pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FixedColumnWidth(160),
                2: const pw.FixedColumnWidth(70),
                3: const pw.FixedColumnWidth(70),
                4: const pw.FixedColumnWidth(70),
                5: const pw.FixedColumnWidth(70),
                6: const pw.FixedColumnWidth(70),
                7: const pw.FixedColumnWidth(70),
              },
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              tableWidth: pw.TableWidth.max,
              border: pw.TableBorder.all(),
              children: rows)
        ],
      ),
    );

    final Uint8List pdfData = await pdf.save();
    final String pdfPath =
        'ElectricalQualityReport_${widget.fielClnName}($userId/$selectedDate).pdf';

    // Save the PDF file to device storage

    return pdfData;
  }

  Future<void> downloadPDF() async {
    if (await Permission.storage.request().isGranted) {
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

      final pdfData = await _generateElectricalPdf();

      String fileName = 'ElectricalQualityReport.pdf';

      final savedPDFFile = await savePDFToFile(pdfData, fileName);

      await pr.hide();
    }

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'repeating channel id', 'repeating channel name',
            channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await FlutterLocalNotificationsPlugin().show(
        0, 'Electric Quality Downloaded', 'Tap to open', notificationDetails,
        payload: pathToOpenFile);
  }

  Future<File> savePDFToFile(Uint8List pdfData, String fileName) async {
    if (await Permission.storage.request().isGranted) {
      final documentDirectory =
          (await DownloadsPath.downloadsDirectory())?.path;
      final file = File('$documentDirectory/$fileName');

      int counter = 1;
      String newFilePath = file.path;
      await file.writeAsBytes(pdfData);
      pathToOpenFile = newFilePath.toString();
      return file;
      // }
    }
    return File('');
  }

  Future getAssignedDepots() async {
    assignedDepots = await authService.getDepotList();
    isFieldEditable =
        authService.verifyAssignedDepot(widget.depoName!, assignedDepots);
  }
}
