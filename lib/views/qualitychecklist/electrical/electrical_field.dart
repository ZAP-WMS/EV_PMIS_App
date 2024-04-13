import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/models/quality_checklistModel.dart';
import 'package:ev_pmis_app/views/citiespage/depot.dart';
import 'package:ev_pmis_app/widgets/appbar_back_date.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:ev_pmis_app/widgets/progress_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
import '../../../../widgets/activity_headings.dart';
import '../../../../widgets/custom_textfield.dart';
import '../../../../widgets/quality_list.dart';
import '../../safetyreport/safetyfield.dart';

class ElectricalField extends StatefulWidget {
  String? depoName;
  String? title;
  String? fielClnName;
  int? titleIndex;
  ElectricalField(
      {super.key,
      required this.depoName,
      required this.title,
      required this.fielClnName,
      required this.titleIndex});

  @override
  State<ElectricalField> createState() => _ElectricalFieldState();
}

class _ElectricalFieldState extends State<ElectricalField> {
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
          QualityPSSDataSource(qualitylisttable1, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();

      qualitylisttable2 = rmu_getData();
      _qualityrmuDataSource =
          QualityrmuDataSource(qualitylisttable2, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();

      qualitylisttable3 = ct_getData();
      _qualityctDataSource =
          QualityctDataSource(qualitylisttable3, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();

      qualitylisttable4 = cmu_getData();
      _qualitycmuDataSource =
          QualitycmuDataSource(qualitylisttable4, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();

      qualitylisttable5 = acdb_getData();
      _qualityacdDataSource =
          QualityacdDataSource(qualitylisttable5, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();

      qualitylisttable6 = ci_getData();
      _qualityCIDataSource =
          QualityCIDataSource(qualitylisttable6, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();

      qualitylisttable7 = cdi_getData();
      _qualityCDIDataSource =
          QualityCDIDataSource(qualitylisttable7, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();

      qualitylisttable8 = msp_getData();
      _qualityMSPDataSource =
          QualityMSPDataSource(qualitylisttable8, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();

      qualitylisttable9 = charger_getData();
      _qualityChargerDataSource = QualityChargerDataSource(
          qualitylisttable9, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();

      qualitylisttable10 = earth_pit_getData();
      _qualityEPDataSource =
          QualityEPDataSource(qualitylisttable10, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: const NavbarDrawer(),
        appBar: PreferredSize(
            // ignore: sort_child_properties_last
            child: CustomAppBarBackDate(
                depoName: '${widget.depoName!}',
                text: '${widget.title}',
                haveSummary: false,
                haveSynced: true,
                haveCalender: true,
                store: () {
                  showProgressDilogue(context);
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
                                              ? _qualitycmuDataSource
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
                }),
            preferredSize: const Size.fromHeight(80)),
        body: isLoading
            ? LoadingPage()
            :
            // StreamBuilder(
            //   stream: FirebaseFirestore.instance
            //       .collection('CivilQualityChecklistCollection')
            //       .doc('${widget.depoName}')
            //       .collection('userId')
            //       .doc('widget.currentDate')
            //       .snapshots(),
            //   builder: (context, snapshot) {
            //     return
            SingleChildScrollView(
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
                        //  widget.titleIndex! == 0
                        //     ? _stream
                        //     : widget.titleIndex! == 1
                        //         ? _stream1
                        //         : widget.titleIndex! == 2
                        //             ? _stream2
                        //             : widget.titleIndex! == 3
                        //                 ? _stream3
                        //                 : widget.titleIndex! == 4
                        //                     ? _stream4
                        //                     : widget.titleIndex! == 5
                        //                         ? _stream5
                        //                         : widget.titleIndex! == 6
                        //                             ? _stream6
                        //                             : widget.titleIndex! == 7
                        //                                 ? _stream7
                        //                                 : widget.titleIndex! == 8
                        //                                     ? _stream8
                        //                                     : widget.titleIndex! == 9
                        //                                         ? _stream9
                        //                                         : widget.titleIndex! ==
                        //                                                 10
                        //                                             ? _stream10
                        //                                             : _stream11,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingPage();
                          }
                          if (!snapshot.hasData ||
                              snapshot.data.exists == false) {
                            return
                                //  widget.isHeader!
                                //     ?
                                SfDataGridTheme(
                              data: SfDataGridThemeData(headerColor: blue),
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
                                allowEditing: true,
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
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: white,
                                          )),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Reference',
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
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
                                    width: 60,
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
                                    allowEditing: true,
                                    width: 50,
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
                            // alldata = '';
                            // alldata = snapshot.data['data'] as List<dynamic>;
                            // qualitylisttable1.clear();
                            // alldata.forEach((element) {
                            //   qualitylisttable1
                            //       .add(QualitychecklistModel.fromJson(element));
                            //   if (widget.fielClnName! == 'PSS') {
                            //     _qualityPSSDataSource = QualityPSSDataSource(
                            //         qualitylisttable1, cityName!, widget.depoName!);
                            //     _dataGridController = DataGridController();
                            //   } else if (widget.fielClnName == 'RMU') {
                            //     _qualityrmuDataSource = QualityrmuDataSource(
                            //         qualitylisttable2, cityName!, widget.depoName!);
                            //     _dataGridController = DataGridController();
                            //   } else if (widget.fielClnName == 'CT') {
                            //     _qualityctDataSource = QualityctDataSource(
                            //         qualitylisttable3, cityName!, widget.depoName!);
                            //     _dataGridController = DataGridController();
                            //   } else if (widget.fielClnName == 'CMU') {
                            //     _qualitycmuDataSource = QualitycmuDataSource(
                            //         qualitylisttable4, cityName!, widget.depoName!);
                            //     _dataGridController = DataGridController();
                            //   } else if (widget.fielClnName == 'ACDB') {
                            //     _qualityacdDataSource = QualityacdDataSource(
                            //         qualitylisttable5, cityName!, widget.depoName!);
                            //     _dataGridController = DataGridController();
                            //   } else if (widget.fielClnName == 'CI') {
                            //     _qualityCIDataSource = QualityCIDataSource(
                            //         qualitylisttable6, cityName!, widget.depoName!);
                            //     _dataGridController = DataGridController();
                            //   } else if (widget.fielClnName == 'CDI') {
                            //     _qualityCDIDataSource = QualityCDIDataSource(
                            //         qualitylisttable7, cityName!, widget.depoName!);
                            //     _dataGridController = DataGridController();
                            //   } else if (widget.fielClnName == 'MSP') {
                            //     _qualityMSPDataSource = QualityMSPDataSource(
                            //         qualitylisttable8, cityName!, widget.depoName!);
                            //     _dataGridController = DataGridController();
                            //   } else if (widget.fielClnName == 'CHARGER') {
                            //     _qualityChargerDataSource = QualityChargerDataSource(
                            //         qualitylisttable9, cityName!, widget.depoName!);
                            //     _dataGridController = DataGridController();
                            //   } else if (widget.fielClnName == 'EARTH PIT') {
                            //     _qualityEPDataSource = QualityEPDataSource(
                            //         qualitylisttable10, cityName!, widget.depoName!);
                            //     _dataGridController = DataGridController();
                            //   }
                            //   //  else if (widget.titleIndex! == 10) {
                            //   //   _qualityRoofingDataSource = QualityWCRDataSource(
                            //   //       qualitylisttable1,
                            //   //       widget.depoName!,
                            //   //       cityName!);
                            //   //   _dataGridController = DataGridController();
                            //   // } else if (widget.titleIndex! == 11) {
                            //   //   _qualityPROOFINGDataSource =
                            //   //       QualityPROOFINGDataSource(qualitylisttable1,
                            //   //           widget.depoName!, cityName!,selectedDate!);
                            //   //   _dataGridController = DataGridController();
                            //   // }
                            // });

                            return SfDataGridTheme(
                              data: SfDataGridThemeData(headerColor: blue),
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
                                // : widget.titleIndex! ==
                                //         10
                                //     ? _qualityRoofingDataSource
                                // : _qualityPROOFINGDataSource,

                                //key: key,
                                allowEditing: true,
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
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: white,
                                          )),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Reference',
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
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
                                    width: 60,
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
                                    allowEditing: true,
                                    width: 50,
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
                          } else {
                            // here w3e have to put Nodata page
                            return LoadingPage();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ));
    //  },
    //),
    // floatingActionButton: FloatingActionButton.extended(
    //   onPressed: () {
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => ElectricalTable(
    //             depoName: widget.depoName,
    //             title: widget.title,
    //             titleIndex: widget.titleIndex,
    //           ),
    //         ));
    //   },
    //   label: const Text('Proceed to Sync'),
    // ),
  }

  Widget electricalField(TextEditingController controller, String title) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: CustomTextField(
          controller: controller,
          labeltext: title,
          isSuffixIcon: false,
          // validatortext: '$title is Required',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next),
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
    isLoading = false;
    setState(() {});

    List<String> eleClnName = [
      'PSS',
      'RMU',
      'CT',
      'CMU',
      'ACDB',
      'CI',
      'CDI',
      'MSP',
      'CHARGER',
      'EARTH PIT'
    ];

    if (widget.fielClnName == 'RMU') {
      qualitylisttable2 = checkTable ? rmu_getData() : data;
      _qualityrmuDataSource =
          QualityrmuDataSource(qualitylisttable2, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();
      _dataGridController = DataGridController();
    } else if (widget.fielClnName == 'CT') {
      qualitylisttable3 = checkTable ? ct_getData() : data;
      _qualityctDataSource =
          QualityctDataSource(qualitylisttable3, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();
    } else if (widget.fielClnName == 'CMU') {
      qualitylisttable4 = checkTable ? cmu_getData() : data;
      _qualitycmuDataSource =
          QualitycmuDataSource(qualitylisttable4, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();
    } else if (widget.fielClnName == 'ACDB') {
      qualitylisttable5 = checkTable ? acdb_getData() : data;
      _qualityacdDataSource =
          QualityacdDataSource(qualitylisttable5, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();
    } else if (widget.fielClnName == 'CI') {
      qualitylisttable6 = checkTable ? ci_getData() : data;
      _qualityCIDataSource =
          QualityCIDataSource(qualitylisttable6, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();
    } else if (widget.fielClnName == 'CDI') {
      qualitylisttable7 = checkTable ? cdi_getData() : data;
      _qualityCDIDataSource =
          QualityCDIDataSource(qualitylisttable7, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();
    } else if (widget.fielClnName == 'MSP') {
      qualitylisttable8 = checkTable ? msp_getData() : data;
      _qualityMSPDataSource =
          QualityMSPDataSource(qualitylisttable8, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();
    } else if (widget.fielClnName == 'CHARGER') {
      qualitylisttable9 = checkTable ? charger_getData() : data;
      _qualityChargerDataSource = QualityChargerDataSource(
          qualitylisttable9, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();
    } else if (widget.fielClnName == 'EARTH PIT') {
      qualitylisttable10 = checkTable ? earth_pit_getData() : data;
      _qualityEPDataSource =
          QualityEPDataSource(qualitylisttable10, widget.depoName!, cityName!,selectedDate!);
      _dataGridController = DataGridController();
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
                              qualitylisttable1, widget.depoName!, cityName!,selectedDate!);
                          _dataGridController = DataGridController();

                          qualitylisttable2 = rmu_getData();
                          _qualityrmuDataSource = QualityrmuDataSource(
                              qualitylisttable2, widget.depoName!, cityName!,selectedDate!);
                          _dataGridController = DataGridController();

                          qualitylisttable3 = ct_getData();
                          _qualityctDataSource = QualityctDataSource(
                              qualitylisttable3, widget.depoName!, cityName!,selectedDate!);
                          _dataGridController = DataGridController();

                          qualitylisttable4 = cmu_getData();
                          _qualitycmuDataSource = QualitycmuDataSource(
                              qualitylisttable4, widget.depoName!, cityName!,selectedDate!);
                          _dataGridController = DataGridController();

                          qualitylisttable5 = acdb_getData();
                          _qualityacdDataSource = QualityacdDataSource(
                              qualitylisttable5, widget.depoName!, cityName!,selectedDate!);
                          _dataGridController = DataGridController();

                          qualitylisttable6 = ci_getData();
                          _qualityCIDataSource = QualityCIDataSource(
                              qualitylisttable6, widget.depoName!, cityName!,selectedDate!);
                          _dataGridController = DataGridController();

                          qualitylisttable7 = cdi_getData();
                          _qualityCDIDataSource = QualityCDIDataSource(
                              qualitylisttable7, widget.depoName!, cityName!,selectedDate!);
                          _dataGridController = DataGridController();

                          qualitylisttable8 = msp_getData();
                          _qualityMSPDataSource = QualityMSPDataSource(
                              qualitylisttable8, widget.depoName!, cityName!,selectedDate!);
                          _dataGridController = DataGridController();

                          qualitylisttable9 = charger_getData();
                          _qualityChargerDataSource = QualityChargerDataSource(
                              qualitylisttable9, widget.depoName!, cityName!,selectedDate!);
                          _dataGridController = DataGridController();

                          qualitylisttable10 = earth_pit_getData();
                          _qualityEPDataSource = QualityEPDataSource(
                              qualitylisttable10, widget.depoName!, cityName!,selectedDate!);
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
}
