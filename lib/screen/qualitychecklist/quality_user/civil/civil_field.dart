import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/QualityDatasource/qualityCivilDatasource/quality_paving.dart';
import 'package:ev_pmis_app/components/loading_pdf.dart';
import 'package:ev_pmis_app/models/quality_checklistModel.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:ev_pmis_app/views/citiespage/depot.dart';
import 'package:ev_pmis_app/views/qualitychecklist/quality_checklist.dart';
import 'package:ev_pmis_app/widgets/appbar_back_date.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:ev_pmis_app/widgets/progress_loading.dart';
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
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../FirebaseApi/firebase_api.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_Ironite_flooring.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_backfilling.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_ceiling.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_excavation.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_flooring.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_glazzing.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_inspection.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_massonary.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_painting.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_proofing.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_roofing.dart';
import '../../../../components/Loading_page.dart';
import '../../../../provider/cities_provider.dart';
import '../../../../style.dart';
import '../../../../views/dailyreport/summary.dart';
import '../../../../widgets/custom_textfield.dart';
import '../../../../widgets/quality_list.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CivilField extends StatefulWidget {
  String? depoName;
  String? title;
  int? index;
  String fieldclnName;
  bool isloading = true;
  String? currentDate;
  String? role;

  CivilField(
      {super.key,
      required this.depoName,
      required this.title,
      required this.fieldclnName,
      required this.index,
      this.role});

  @override
  State<CivilField> createState() => _CivilFieldState();
}

class _CivilFieldState extends State<CivilField> {
  final AuthService authService = AuthService();
  List<String> assignedDepots = [];
  bool isFieldEditable = false;
  String pathToOpenFile = '';
  ProgressDialog? pr;
  String? cityName;
  Stream? _stream;
  late TextEditingController projectController,
      locationController,
      vendorController,
      drawingController,
      dateController,
      componentController,
      gridController,
      fillingController;

  void initializeController() {
    projectController = TextEditingController();
    locationController = TextEditingController();
    vendorController = TextEditingController();
    drawingController = TextEditingController();
    dateController = TextEditingController();
    componentController = TextEditingController();
    gridController = TextEditingController();
    fillingController = TextEditingController();
  }

  List<String> completeTabForCivil = [
    'Excavation',
    'BackFilling',
    'Brick / Block Massonary',
    'Doors, Windows, Hardware & Glazing',
    'False Ceiling',
    'Flooring & Tiling',
    'Grouting Inspection',
    'Ironite / Ips Flooring',
    'Painting',
    'Interlock Paving Work',
    'Wall Cladding & Roofing',
    'Water Proofing'
  ];

  List<QualitychecklistModel> data = [];
  bool checkTable = true;
  bool isLoading = true;
  List<dynamic> excavationtabledatalist = [];

  late QualityExcavationDataSource _qualityExcavationDataSource;
  late QualityBackFillingDataSource _qualityBackFillingDataSource;
  late QualityMassonaryDataSource _qualityMassonaryDataSource;
  late QualityGlazzingDataSource _qualityGlazzingDataSource;
  late QualityCeillingDataSource _qualityCeillingDataSource;
  late QualityIroniteflooringDataSource _qualityIroniteflooringDataSource;
  late QualityflooringDataSource _qualityflooringDataSource;
  late QualityInspectionDataSource _qualityInspectionDataSource;
  late QualityPaintingDataSource _qualityPaintingDataSource;
  late QualityRoofingDataSource _qualityRoofingDataSource;
  late QualityProofingDataSource _qualityProofingDataSource;
  late QualityPavingDataSource _qualityPavingDataSource;

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
  late DataGridController _dataGridController;

  String? selectedDate = DateFormat.yMMMMd().format(DateTime.now());
  String? visDate = DateFormat.yMMMd().format(DateTime.now());

  @override
  void initState() {
    _stream = FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc('${widget.depoName}')
        .collection('userId')
        .doc(userId)
        .collection(widget.fieldclnName)
        .doc(selectedDate)
        .snapshots();
    getAssignedDepots();
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;
    pr = ProgressDialog(context,
        customBody:
            Container(height: 200, width: 100, child: const LoadingPdf()));

    initializeController();
    _fetchUserData();

    getTableData().whenComplete(() {
      qualitylisttable1 = checkTable ? excavation_getData() : data;
      _qualityExcavationDataSource = QualityExcavationDataSource(
          qualitylisttable1, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable2 = checkTable ? backfilling_getData() : data;
      _qualityBackFillingDataSource = QualityBackFillingDataSource(
          qualitylisttable2, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable3 = checkTable ? massonary_getData() : data;
      _qualityMassonaryDataSource = QualityMassonaryDataSource(
          qualitylisttable3, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable4 = checkTable ? glazzing_getData() : data;
      _qualityGlazzingDataSource = QualityGlazzingDataSource(
          qualitylisttable4, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable5 = checkTable ? ceilling_getData() : data;
      _qualityCeillingDataSource = QualityCeillingDataSource(
          qualitylisttable5, cityName!, widget.depoName!);
      qualitylisttable6 = checkTable ? florring_getData() : data;
      _dataGridController = DataGridController();

      _qualityflooringDataSource = QualityflooringDataSource(
          qualitylisttable6, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable7 = checkTable ? inspection_getData() : data;
      _qualityInspectionDataSource = QualityInspectionDataSource(
          qualitylisttable7, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable8 = checkTable ? ironite_florring_getData() : data;
      _qualityIroniteflooringDataSource = QualityIroniteflooringDataSource(
          qualitylisttable8, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable9 = checkTable ? painting_getData() : data;
      _qualityPaintingDataSource = QualityPaintingDataSource(
          qualitylisttable9, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable10 = checkTable ? paving_getData() : data;
      _qualityPavingDataSource = QualityPavingDataSource(
          qualitylisttable10, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable11 = checkTable ? roofing_getData() : data;
      _qualityRoofingDataSource = QualityRoofingDataSource(
          qualitylisttable11, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

      qualitylisttable12 = checkTable ? proofing_getData() : data;
      _qualityProofingDataSource = QualityProofingDataSource(
          qualitylisttable12, cityName!, widget.depoName!);
      _dataGridController = DataGridController();

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
          // ignore: sort_child_properties_last
          child: CustomAppBarBackDate(
              downloadFun: downloadPDF,
              depoName: widget.depoName!,
              text: '${widget.title}',
              haveCalender: true,
              haveSynced: isFieldEditable ? true : false,
              isDownload: true,
              haveSummary: false,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewSummary(
                      cityName: cityName,
                      depoName: widget.depoName.toString(),
                      id: 'Quality Checklist',
                      userId: userId,
                    ),
                  )),
              store: () async {
                showProgressDilogue(context);
                civilStoreData(
                    context,
                    widget.fieldclnName == 'Exc'
                        ? _qualityExcavationDataSource
                        : widget.fieldclnName == 'BackFilling'
                            ? _qualityBackFillingDataSource
                            : widget.fieldclnName == 'Massonary'
                                ? _qualityMassonaryDataSource
                                : widget.fieldclnName == 'Glazzing'
                                    ? _qualityGlazzingDataSource
                                    : widget.fieldclnName == 'Ceilling'
                                        ? _qualityCeillingDataSource
                                        : widget.fieldclnName == 'Flooring'
                                            ? _qualityflooringDataSource
                                            : widget.fieldclnName ==
                                                    'Inspection'
                                                ? _qualityInspectionDataSource
                                                : widget.fieldclnName ==
                                                        'Ironite'
                                                    ? _qualityIroniteflooringDataSource
                                                    : widget.fieldclnName ==
                                                            'Painting'
                                                        ? _qualityPaintingDataSource
                                                        : widget.fieldclnName ==
                                                                'Paving'
                                                            ? _qualityPavingDataSource
                                                            : widget.fieldclnName ==
                                                                    'Roofing'
                                                                ? _qualityRoofingDataSource
                                                                : _qualityProofingDataSource,
                    widget.depoName!,
                    selectedDate!);
                await FirebaseFirestore.instance
                    .collection('CivilChecklistField')
                    .doc('${widget.depoName}')
                    .collection('userId')
                    .doc(userId)
                    .collection(widget.fieldclnName)
                    .doc(selectedDate)
                    .set({
                  'projectName': projectController.text,
                  'location': locationController.text,
                  'vendor': vendorController.text,
                  'drawing': drawingController.text,
                  'date': dateController.text,
                  'componentName': componentController.text,
                  'grid': gridController.text,
                  'filling': fillingController.text
                });
                FirebaseApi().nestedKeyEventsField(
                    'CivilChecklistField', widget.depoName!, 'userId', userId);
              },
              showDate: visDate,
              choosedate: () {
                chooseDate(context);
              }),

          preferredSize: const Size.fromHeight(60),
        ),
        body: isLoading
            ? const LoadingPage()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    safetyField(projectController, 'Project Name',
                        TextInputAction.next),
                    safetyField(
                        locationController, 'Location', TextInputAction.next),
                    safetyField(vendorController, 'Vendor / SubVendor',
                        TextInputAction.next),
                    safetyField(
                        drawingController, 'Drawing No.', TextInputAction.next),
                    safetyField(dateController, 'Date', TextInputAction.next),
                    safetyField(componentController,
                        'Component of the Structure', TextInputAction.next),
                    safetyField(gridController, 'Grid / Axis Level',
                        TextInputAction.next),
                    safetyField(fillingController, 'Type of Filling',
                        TextInputAction.done),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: StreamBuilder(
                        stream: _stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data!.exists == false) {
                            return SfDataGridTheme(
                              data: SfDataGridThemeData(
                                  gridLineColor: blue,
                                  headerColor: white,
                                  gridLineStrokeWidth: 2,
                                  frozenPaneLineColor: blue),
                              child: SfDataGrid(
                                source: widget.fieldclnName == 'Exc'
                                    ? _qualityExcavationDataSource
                                    : widget.fieldclnName == 'BackFilling'
                                        ? _qualityBackFillingDataSource
                                        : widget.fieldclnName == 'Massonary'
                                            ? _qualityMassonaryDataSource
                                            : widget.fieldclnName == 'Glazzing'
                                                ? _qualityGlazzingDataSource
                                                : widget.fieldclnName ==
                                                        'Ceilling'
                                                    ? _qualityCeillingDataSource
                                                    : widget.fieldclnName ==
                                                            'Flooring'
                                                        ? _qualityflooringDataSource
                                                        : widget.fieldclnName ==
                                                                'Inspection'
                                                            ? _qualityInspectionDataSource
                                                            : widget.fieldclnName ==
                                                                    'Ironite'
                                                                ? _qualityIroniteflooringDataSource
                                                                : widget.fieldclnName ==
                                                                        'Painting'
                                                                    ? _qualityPaintingDataSource
                                                                    : widget.fieldclnName ==
                                                                            'Paving'
                                                                        ? _qualityPavingDataSource
                                                                        : widget.fieldclnName ==
                                                                                'Roofing'
                                                                            ? _qualityRoofingDataSource
                                                                            : _qualityProofingDataSource,

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
                                onQueryRowHeight: (details) {
                                  return details
                                      .getIntrinsicRowHeight(details.rowIndex);
                                },
                                // onQueryRowHeight: (dwidget.index!etails) {
                                //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                // },
                                columns: [
                                  GridColumn(
                                    columnName: 'srNo',
                                    width: 55,
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
                                    width: 300,
                                    columnName: 'checklist',
                                    allowEditing: false,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                          'Checks(Before Start of Backfill Activity)',
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
                                      child: Text("Contractor’s Site Engineer",
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
                                      child: Text("Owner’s Site Engineer",
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
                                      child: Text(
                                          "Observation Comments by  Owner’s Engineer",
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Upload',
                                    allowEditing: false,
                                    visible: true,
                                    width: 110,
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
                                    width: 110,
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
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return SfDataGridTheme(
                              data: SfDataGridThemeData(
                                  headerColor: white, gridLineColor: blue),
                              child: SfDataGrid(
                                source: widget.fieldclnName == 'Exc'
                                    ? _qualityExcavationDataSource
                                    : widget.fieldclnName == 'BackFilling'
                                        ? _qualityBackFillingDataSource
                                        : widget.fieldclnName == 'Massonary'
                                            ? _qualityMassonaryDataSource
                                            : widget.fieldclnName == 'Glazzing'
                                                ? _qualityGlazzingDataSource
                                                : widget.fieldclnName ==
                                                        'Ceilling'
                                                    ? _qualityCeillingDataSource
                                                    : widget.fieldclnName ==
                                                            'Flooring'
                                                        ? _qualityflooringDataSource
                                                        : widget.fieldclnName ==
                                                                'Inspection'
                                                            ? _qualityInspectionDataSource
                                                            : widget.fieldclnName ==
                                                                    'Ironite'
                                                                ? _qualityIroniteflooringDataSource
                                                                : widget.fieldclnName ==
                                                                        'Painting'
                                                                    ? _qualityPaintingDataSource
                                                                    : widget.fieldclnName ==
                                                                            'Paving'
                                                                        ? _qualityPavingDataSource
                                                                        : widget.fieldclnName ==
                                                                                'Roofing'
                                                                            ? _qualityRoofingDataSource
                                                                            : _qualityProofingDataSource,
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
                                    width: 55,
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
                                    width: 300,
                                    columnName: 'checklist',
                                    allowEditing: false,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                          'Checks(Before Start of Backfill Activity)',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
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
                                      child: Text("Contractor’s Site Engineer",
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
                                      child: Text("Owner’s Site Engineer",
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
                                      child: Text(
                                          "Observation Comments by  Owner’s Engineer",
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Upload',
                                    allowEditing: false,
                                    visible: true,
                                    width: 110,
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
                                    width: 110,
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
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ],
                ),

                // floatingActionButton: FloatingActionButton.extended(
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => CivilTable(
                //             depoName: widget.depoName,
                //             title: widget.title,
                //             index: widget.index,
                //           ),
                //         ));
                //   },
                //   label: const Text('Proceed to Sync'),
                // ),
              ));
  }

  Widget safetyField(TextEditingController controller, String title,
      TextInputAction inputType) {
    return Container(
      height: 45,
      padding: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: CustomTextField(
        isFieldEditable: isFieldEditable,
        controller: controller,
        labeltext: title,
        // validatortext: '$title is Required',
        keyboardType: TextInputType.text,
        textInputAction: inputType,
      ),
    );
  }

  civilStoreData(BuildContext context, dynamic datasource, String depoName,
      String currentDate) {
    Map<String, dynamic> excavationTableData = Map();

    for (var i in datasource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'Upload' && data.columnName != 'View') {
          excavationTableData[data.columnName] = data.value;
        }
      }

      excavationtabledatalist.add(excavationTableData);
      print('TableList - $excavationtabledatalist');
      excavationTableData = {};
    }

    FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(widget.fieldclnName)
        .doc(currentDate)
        .set({
      'data': excavationtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', widget.depoName!, 'userId', userId);
      excavationtabledatalist.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }

  void _fetchUserData() async {
    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(widget.depoName)
        .collection("userId")
        .doc(userId)
        .collection(widget.fieldclnName)
        .doc(selectedDate)
        .get()
        .then((ds) {
      if (ds.exists) {
        setState(() {
          projectController.text = ds.data()!['projectName'] ?? '';
          locationController.text = ds.data()!['location'] ?? '';
          vendorController.text = ds.data()!['vendor'] ?? '';
          drawingController.text = ds.data()!['drawing'] ?? '';
          dateController.text = ds.data()!['date'] ?? '';
          componentController.text = ds.data()!['componentName'] ?? '';
          gridController.text = ds.data()!['grid'] ?? '';
          fillingController.text = ds.data()!['filling'] ?? '';
        });
      } else {
        projectController.clear();
        locationController.clear();
        vendorController.clear();
        drawingController.clear();
        dateController.clear();
        componentController.clear();
        gridController.clear();
        fillingController.clear();
      }
    });
  }

  Future<void> getTableData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection(widget.fieldclnName)
        .doc(selectedDate)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> tempData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapData = tempData['data'];
      print(mapData);

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
                        (DateRangePickerSelectionChangedArgs args) {},
                    selectionMode: DateRangePickerSelectionMode.single,
                    showActionButtons: true,
                    onSubmit: ((value) {
                      selectedDate = DateFormat.yMMMMd()
                          .format(DateTime.parse(value.toString()));

                      visDate = DateFormat.yMMMd()
                          .format(DateTime.parse(value.toString()));
                      //     print(showDate);
                      Navigator.pop(context);
                      setState(() {
                        checkTable = true;
                        _fetchUserData();
                        data.clear();
                        getTableData();
                      });
                    }),
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  )),
            ));
  }

  Future<Uint8List> _generateCivilPdf() async {
    data = widget.fieldclnName == 'Exc'
        ? qualitylisttable1
        : widget.fieldclnName == 'BackFilling'
            ? qualitylisttable2
            : widget.fieldclnName == 'Massonary'
                ? qualitylisttable3
                : widget.fieldclnName == 'Glazzing'
                    ? qualitylisttable4
                    : widget.fieldclnName == 'Ceilling'
                        ? qualitylisttable5
                        : widget.fieldclnName == 'Flooring'
                            ? qualitylisttable6
                            : widget.fieldclnName == 'Inspection'
                                ? qualitylisttable7
                                : widget.fieldclnName == 'Ironite'
                                    ? qualitylisttable8
                                    : widget.fieldclnName == 'Painting'
                                        ? qualitylisttable9
                                        : widget.fieldclnName == 'Paving'
                                            ? qualitylisttable10
                                            : widget.fieldclnName == 'Roofing'
                                                ? qualitylisttable11
                                                : qualitylisttable12;
    await pr!.show();
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
      ['PROJECT :', projectController.text],
      ['Date :', dateController.text],
      ['Location :', locationController.text],
      ['Component of structure : ', componentController.text],
      ['Vendor / Sub Vendor :', vendorController.text],
      ['Grid / Axis & Level :', gridController.text],
      ['Drawing Number :', drawingController.text],
      ['Type of Filling :', fillingController.text],
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
              child: pw.Text('Reference',
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

    List<dynamic> userData = [];

    if (data.isNotEmpty) {
      List<pw.Widget> imageUrls = [];

      for (QualitychecklistModel mapData in data) {
        String imagesPath =
            'QualityChecklist/civil_Engineer/$cityName/${widget.depoName}/$userId/${widget.fieldclnName} Table/$selectedDate/${mapData.srNo}';
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
        pageFormat: const PdfPageFormat(
          1300,
          900,
          marginLeft: 70,
          marginRight: 70,
          marginBottom: 80,
          marginTop: 40,
        ),
        orientation: pw.PageOrientation.natural,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                    bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey)),
              ),
              child: pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Civil Quality Report / ${widget.fieldclnName} Table',
                        textScaleFactor: 2,
                        style: const pw.TextStyle(
                          color: PdfColors.blue700,
                        ),
                      ),
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
                    text: pw.TextSpan(
                      children: [
                        const pw.TextSpan(
                            text: 'Place : ',
                            style: pw.TextStyle(
                                color: PdfColors.black, fontSize: 17)),
                        pw.TextSpan(
                          text: '$cityName / ${widget.depoName}',
                          style: const pw.TextStyle(
                            color: PdfColors.blue700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    const pw.TextSpan(
                        text: 'Date : ',
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 17)),
                    pw.TextSpan(
                        text: date,
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
                        'Civil Quality Report / ${widget.fieldclnName} Table',
                        textScaleFactor: 2,
                        style: const pw.TextStyle(
                          color: PdfColors.blue700,
                        ),
                      ),
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
                    'Date:  $date ',
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
        'CivilQualityReport_${widget.title}($userId/$selectedDate).pdf';

    // Save the PDF file to device storage
    pr!.hide();

    return pdfData;
  }

  Future<void> downloadPDF() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
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

      final pdfData = await _generateCivilPdf();

      String fileName = 'CivilQualityReport.pdf';

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
        0, 'Civil Quality Downloaded', 'Tap to open', notificationDetails,
        payload: pathToOpenFile);
  }

  Future<File> savePDFToFile(Uint8List pdfData, String fileName) async {
    final documentDirectory = (await DownloadsPath.downloadsDirectory())?.path;
    File file = File('$documentDirectory/$fileName');

    int counter = 1;
    String newFilePath = file.path;
    pathToOpenFile = newFilePath;

    while (await file.exists()) {
      String newName =
          '${fileName.substring(0, fileName.lastIndexOf('.'))}-$counter${fileName.substring(fileName.lastIndexOf('.'))}';
      file = File('$documentDirectory/$newName');
      pathToOpenFile = file.path;
      counter++;
    }
    await file.writeAsBytes(pdfData);
    return file;
  }

  Future getAssignedDepots() async {
    assignedDepots = await authService.getDepotList();
    isFieldEditable =
        authService.verifyAssignedDepot(widget.depoName!, assignedDepots);
  }
}
