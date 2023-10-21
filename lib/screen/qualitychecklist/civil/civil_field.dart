import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/screen/homepage/gallery.dart';
import 'package:ev_pmis_app/widgets/activity_headings.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../QualityDatasource/qualityCivilDatasource/quality_Ironite_flooring.dart';
import '../../../QualityDatasource/qualityCivilDatasource/quality_backfilling.dart';
import '../../../QualityDatasource/qualityCivilDatasource/quality_ceiling.dart';
import '../../../QualityDatasource/qualityCivilDatasource/quality_excavation.dart';
import '../../../QualityDatasource/qualityCivilDatasource/quality_flooring.dart';
import '../../../QualityDatasource/qualityCivilDatasource/quality_glazzing.dart';
import '../../../QualityDatasource/qualityCivilDatasource/quality_inspection.dart';
import '../../../QualityDatasource/qualityCivilDatasource/quality_massonary.dart';
import '../../../QualityDatasource/qualityCivilDatasource/quality_painting.dart';
import '../../../QualityDatasource/qualityCivilDatasource/quality_paving.dart';
import '../../../QualityDatasource/qualityCivilDatasource/quality_proofing.dart';
import '../../../QualityDatasource/qualityCivilDatasource/quality_roofing.dart';
import '../../../components/Loading_page.dart';
import '../../../model/quality_checklistModel.dart';
import '../../../provider/cities_provider.dart';
import '../../../style.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/quality_list.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class CivilField extends StatefulWidget {
  String? depoName;
  String? title;
  int? index;
  String fieldclnName;
  bool isloading = true;
  String? currentDate;

  CivilField(
      {super.key,
      required this.depoName,
      required this.title,
      required this.fieldclnName,
      required this.index});

  @override
  State<CivilField> createState() => _CivilFieldState();
}

class _CivilFieldState extends State<CivilField> {
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

  List<QualitychecklistModel> data = [];
  bool checkTable = true;
  bool isLoading = true;
  List<dynamic> excavationtabledatalist = [];
  List<dynamic> backfillingtabledatalist = [];
  List<dynamic> massonarytabledatalist = [];
  List<dynamic> doorstabledatalist = [];
  List<dynamic> ceillingtabledatalist = [];
  List<dynamic> flooringtabledatalist = [];
  List<dynamic> inspectiontabledatalist = [];
  List<dynamic> inronitetabledatalist = [];
  List<dynamic> paintingtabledatalist = [];
  List<dynamic> pavingtabledatalist = [];
  List<dynamic> roofingtabledatalist = [];
  List<dynamic> proofingtabledatalist = [];

  late QualityExcavationDataSource _qualityExcavationDataSource;
  late QualityBackFillingDataSource _qualityBackFillingDataSource;
  late QualityMassonaryDataSource _qualityMassonaryDataSource;
  late QualityGlazzingDataSource _qualityGlazzingDataSource;
  late QualityCeillingDataSource _qualityCeillingDataSource;
  late QualityIroniteflooringDataSource _qualityIroniteflooringDataSource;
  late QualityflooringDataSource _qualityflooringDataSource;
  late QualityInspectionDataSource _qualityInspectionDataSource;
  late QualityPaintingDataSource _qualityPaintingDataSource;
  late QualityPavingDataSource _qualityPavingDataSource;
  late QualityRoofingDataSource _qualityRoofingDataSource;
  late QualityProofingDataSource _qualityProofingDataSource;

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

  @override
  void initState() {
    print('Init method running');
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;
    _stream = FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc('${widget.depoName}')
        .collection('userId')
        .doc(userId)
        .collection(widget.fieldclnName)
        .doc(currentDate)
        .snapshots();

    initializeController();
    _fetchUserData();

    getTableData().whenComplete(() {
      qualitylisttable1 = checkTable ? excavation_getData() : data;
      _qualityExcavationDataSource = QualityExcavationDataSource(
          qualitylisttable1, widget.depoName!, cityName!);
      _dataGridController = DataGridController();

      qualitylisttable1 = checkTable ? excavation_getData() : data;
      _qualityExcavationDataSource = QualityExcavationDataSource(
          qualitylisttable1, widget.depoName!, cityName!);
      _dataGridController = DataGridController();

      qualitylisttable2 = checkTable ? backfilling_getData() : data;
      _qualityBackFillingDataSource = QualityBackFillingDataSource(
          qualitylisttable2, widget.depoName!, cityName!);
      _dataGridController = DataGridController();

      qualitylisttable3 = checkTable ? massonary_getData() : data;
      _qualityMassonaryDataSource = QualityMassonaryDataSource(
          qualitylisttable3, widget.depoName!, cityName!);
      _dataGridController = DataGridController();

      qualitylisttable4 = checkTable ? glazzing_getData() : data;
      _qualityGlazzingDataSource = QualityGlazzingDataSource(
          qualitylisttable4, widget.depoName!, cityName!);
      _dataGridController = DataGridController();

      qualitylisttable5 = checkTable ? ceilling_getData() : data;
      _qualityCeillingDataSource = QualityCeillingDataSource(
          qualitylisttable5, widget.depoName!, cityName!);
      _dataGridController = DataGridController();

      qualitylisttable6 = checkTable ? florring_getData() : data;
      _qualityflooringDataSource = QualityflooringDataSource(
          qualitylisttable6, widget.depoName!, cityName!);
      _dataGridController = DataGridController();

      qualitylisttable7 = checkTable ? inspection_getData() : data;
      _qualityInspectionDataSource = QualityInspectionDataSource(
          qualitylisttable7, widget.depoName!, cityName!);
      _dataGridController = DataGridController();

      qualitylisttable8 = checkTable ? ironite_florring_getData() : data;
      _qualityIroniteflooringDataSource = QualityIroniteflooringDataSource(
          qualitylisttable8, widget.depoName!, cityName!);
      _dataGridController = DataGridController();

      qualitylisttable9 = checkTable ? painting_getData() : data;
      _qualityPaintingDataSource = QualityPaintingDataSource(
          qualitylisttable9, widget.depoName!, cityName!);
      _dataGridController = DataGridController();

      qualitylisttable10 = checkTable ? paving_getData() : data;
      _qualityPavingDataSource = QualityPavingDataSource(
          qualitylisttable10, widget.depoName!, cityName!);
      _dataGridController = DataGridController();

      qualitylisttable11 = checkTable ? roofing_getData() : data;
      _qualityRoofingDataSource = QualityRoofingDataSource(
          qualitylisttable11, widget.depoName!, cityName!);
      _dataGridController = DataGridController();

      qualitylisttable12 = checkTable ? proofing_getData() : data;
      _qualityProofingDataSource = QualityProofingDataSource(
          qualitylisttable12, widget.depoName!, cityName!);
      _dataGridController = DataGridController();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavbarDrawer(),
      appBar: CustomAppBar(
          title: '${widget.depoName!}/${widget.title}',
          height: 50,
          isSync: true,
          store: () async {
            _showDialog(context);
            CivilstoreData(
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
                                        : widget.fieldclnName == 'Inspection'
                                            ? _qualityInspectionDataSource
                                            : widget.fieldclnName == 'Ironite'
                                                ? _qualityIroniteflooringDataSource
                                                : widget.fieldclnName ==
                                                        'Painting'
                                                    ? _qualityPaintingDataSource
                                                    : widget.fieldclnName ==
                                                            'Paving'
                                                        ? _qualityPaintingDataSource
                                                        : widget.fieldclnName ==
                                                                'Roofing'
                                                            ? _qualityRoofingDataSource
                                                            : _qualityProofingDataSource,
                widget.depoName!,
                currentDate);
            await FirebaseFirestore.instance
                .collection('CivilChecklistField')
                .doc('${widget.depoName}')
                .collection('userId')
                .doc(userId)
                .collection(widget.fieldclnName)
                .doc(currentDate)
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
          },
          isCentered: false),
      body: isLoading
          ? LoadingPage()
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('CivilChecklistField')
                  .doc('${widget.depoName}')
                  .collection('userId')
                  .doc(userId)
                  .collection(widget.fieldclnName)
                  .doc(currentDate)
                  .snapshots(),
              builder: (context, snapshot) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      safetyField(projectController, 'Project Name'),
                      safetyField(locationController, 'Location'),
                      safetyField(vendorController, 'Vendor / SubVendor'),
                      safetyField(drawingController, 'Drawing No.'),
                      safetyField(dateController, 'Date'),
                      safetyField(
                          componentController, 'Component of the Structure'),
                      safetyField(gridController, 'Grid / Axis Level'),
                      safetyField(fillingController, 'Type of Filling'),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: StreamBuilder(
                          stream: _stream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LoadingPage();
                            }
                            if (!snapshot.hasData ||
                                snapshot.data.exists == false) {
                              return SfDataGridTheme(
                                data: SfDataGridThemeData(headerColor: blue),
                                child: SfDataGrid(
                                  source: widget.fieldclnName == 'Exc'
                                      ? _qualityExcavationDataSource
                                      : widget.fieldclnName == 'BackFilling'
                                          ? _qualityBackFillingDataSource
                                          : widget.fieldclnName == 'Massonary'
                                              ? _qualityMassonaryDataSource
                                              : widget.fieldclnName ==
                                                      'Glazzing'
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
                                                                          ? _qualityPaintingDataSource
                                                                          : widget.fieldclnName == 'Roofing'
                                                                              ? _qualityRoofingDataSource
                                                                              : _qualityProofingDataSource,

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
                                  onQueryRowHeight: (details) {
                                    return details.getIntrinsicRowHeight(
                                        details.rowIndex);
                                  },
                                  // onQueryRowHeight: (dwidget.index!etails) {
                                  //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                  // },
                                  columns: [
                                    GridColumn(
                                      columnName: 'srNo',
                                      width: 80,
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
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
                                        child:
                                            Text("Contractor’s Site Engineer",
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
                                      allowEditing: true,
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
                              // : Center(
                              //     child: Container(
                              //       padding: EdgeInsets.all(25),
                              //       decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(20),
                              //           border: Border.all(color: blue)),
                              //       child: const Text(
                              //         '     No data available yet \n Please wait for admin process',
                              //         style: TextStyle(
                              //             fontSize: 30, fontWeight: FontWeight.bold),
                              //       ),
                              //     ),
                              //   );
                            } else if (snapshot.hasData) {
                              getTableData();
                              // alldata = '';
                              // alldata = snapshot.data['data'] as List<dynamic>;
                              // qualitylisttable1.clear();
                              // alldata.forEach((element) {
                              //   qualitylisttable1
                              //       .add(QualitychecklistModel.fromJson(element));
                              //   widget.fieldclnName == 'Exc'
                              //       ? _qualityExcavationDataSource =
                              //           QualityExcavationDataSource(qualitylisttable1,
                              //               widget.depoName!, cityName!)
                              //       : widget.fieldclnName == 'BackFilling'
                              //           ? _qualityBackFillingDataSource =
                              //               QualityBackFillingDataSource(
                              //                   qualitylisttable1,
                              //                   widget.depoName!,
                              //                   cityName!)
                              //           : widget.fieldclnName == 'Massonary'
                              //               ? _qualityMassonaryDataSource =
                              //                   QualityMassonaryDataSource(
                              //                       qualitylisttable1,
                              //                       widget.depoName!,
                              //                       cityName!)
                              //               : widget.fieldclnName == 'Glazzing'
                              //                   ? _qualityGlazzingDataSource =
                              //                       QualityGlazzingDataSource(
                              //                           qualitylisttable1,
                              //                           widget.depoName!,
                              //                           cityName!)
                              //                   : widget.fieldclnName == 'Ceilling'
                              //                       ? _qualityCeillingDataSource =
                              //                           QualityCeillingDataSource(
                              //                               qualitylisttable1,
                              //                               widget.depoName!,
                              //                               cityName!)
                              //                       : widget.fieldclnName ==
                              //                               'Flooring'
                              //                           ? _qualityflooringDataSource =
                              //                               QualityflooringDataSource(
                              //                                   qualitylisttable1,
                              //                                   widget.depoName!,
                              //                                   cityName!)
                              //                           : widget.fieldclnName == 'Inspection'
                              //                               ? _qualityInspectionDataSource = QualityInspectionDataSource(qualitylisttable1, widget.depoName!, cityName!)
                              //                               : widget.fieldclnName == 'Ironite'
                              //                                   ? _qualityIroniteflooringDataSource = QualityIroniteflooringDataSource(qualitylisttable1, widget.depoName!, cityName!)
                              //                                   : widget.fieldclnName == 'Painting'
                              //                                       ? _qualityPaintingDataSource = QualityPaintingDataSource(qualitylisttable1, widget.depoName!, cityName!)
                              //                                       : widget.fieldclnName == 'Paving'
                              //                                           ? _qualityPavingDataSource = QualityPavingDataSource(qualitylisttable1, widget.depoName!, cityName!)
                              //                                           : widget.fieldclnName == 'Roofing'
                              //                                               ? _qualityRoofingDataSource = QualityRoofingDataSource(qualitylisttable1, widget.depoName!, cityName!)
                              //                                               : QualityProofingDataSource(qualitylisttable1, widget.depoName!, cityName!);
                              //   _dataGridController = DataGridController();
                              // });

                              return SfDataGridTheme(
                                data: SfDataGridThemeData(headerColor: blue),
                                child: SfDataGrid(
                                  source: widget.fieldclnName == 'Exc'
                                      ? _qualityExcavationDataSource
                                      : widget.fieldclnName == 'BackFilling'
                                          ? _qualityBackFillingDataSource
                                          : widget.fieldclnName == 'Massonary'
                                              ? _qualityMassonaryDataSource
                                              : widget.fieldclnName ==
                                                      'Glazzing'
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
                                                                          ? _qualityPaintingDataSource
                                                                          : widget.fieldclnName == 'Roofing'
                                                                              ? _qualityRoofingDataSource
                                                                              : _qualityProofingDataSource,
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
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
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
                                        child:
                                            Text("Contractor’s Site Engineer",
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
                                      allowEditing: true,
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
                );
              },
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
    );
  }

  Widget safetyField(TextEditingController controller, String title) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: CustomTextField(
          controller: controller,
          labeltext: title,
          validatortext: '$title is Required',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next),
    );
  }

  CivilstoreData(BuildContext context, dynamic datasource, String depoName,
      String currentDate) {
    Map<String, dynamic> excavationTableData = Map();
    // Map<String, dynamic> backfillingTableData = Map();
    // Map<String, dynamic> massonaryTableData = Map();
    // Map<String, dynamic> doorsTableData = Map();
    // Map<String, dynamic> ceillingTableData = Map();
    // Map<String, dynamic> flooringTableData = Map();
    // Map<String, dynamic> inspectionTableData = Map();
    // Map<String, dynamic> paintingTableData = Map();
    // Map<String, dynamic> pavingTableData = Map();
    // Map<String, dynamic> roofingTableData = Map();
    // Map<String, dynamic> proofingTableData = Map();

    for (var i in datasource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'Upload' && data.columnName != 'View') {
          excavationTableData[data.columnName] = data.value;
        }
      }

      excavationtabledatalist.add(excavationTableData);
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
      excavationtabledatalist.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
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

  void _fetchUserData() async {
    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(widget.depoName)
        .collection("userId")
        .doc(userId)
        .collection(widget.fieldclnName)
        .doc(currentDate)
        .get()
        .then((ds) {
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
    });
  }

  Future<void> getTableData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection(widget.fieldclnName)
        .doc(currentDate)
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

    // if (widget.fieldclnName == 'BackFilling') {
    //   qualitylisttable2 = checkTable ? backfilling_getData() : data;
    //   _qualityBackFillingDataSource = QualityBackFillingDataSource(
    //       qualitylisttable2, widget.depoName!, cityName!);
    //   _dataGridController = DataGridController();
    // } else if (widget.fieldclnName == 'Exc') {
    //   qualitylisttable1 = checkTable ? excavation_getData() : data;
    //   _qualityExcavationDataSource = QualityExcavationDataSource(
    //       qualitylisttable1, widget.depoName!, cityName!);
    //   _dataGridController = DataGridController();
    // } else if (widget.fieldclnName == 'BackFilling') {
    //   qualitylisttable3 = checkTable ? massonary_getData() : data;
    //   _qualityMassonaryDataSource = QualityMassonaryDataSource(
    //       qualitylisttable3, widget.depoName!, cityName!);
    //   _dataGridController = DataGridController();
    // } else if (widget.fieldclnName == 'Glazzing') {
    //   qualitylisttable4 = checkTable ? glazzing_getData() : data;
    //   _qualityGlazzingDataSource = QualityGlazzingDataSource(
    //       qualitylisttable4, widget.depoName!, cityName!);
    //   _dataGridController = DataGridController();
    // } else if (widget.fieldclnName == 'Ceilling') {
    //   qualitylisttable5 = checkTable ? ceilling_getData() : data;
    //   _qualityCeillingDataSource = QualityCeillingDataSource(
    //       qualitylisttable5, widget.depoName!, cityName!);
    //   _dataGridController = DataGridController();
    // } else if (widget.fieldclnName == 'Flooring') {
    //   qualitylisttable6 = checkTable ? florring_getData() : data;
    //   _qualityflooringDataSource = QualityflooringDataSource(
    //       qualitylisttable6, widget.depoName!, cityName!);
    //   _dataGridController = DataGridController();
    // } else if (widget.fieldclnName == 'Inspection') {
    //   qualitylisttable7 = checkTable ? inspection_getData() : data;
    //   _qualityInspectionDataSource = QualityInspectionDataSource(
    //       qualitylisttable7, widget.depoName!, cityName!);
    //   _dataGridController = DataGridController();
    // } else if (widget.fieldclnName == 'Ironite') {
    //   qualitylisttable8 = checkTable ? ironite_florring_getData() : data;
    //   _qualityIroniteflooringDataSource = QualityIroniteflooringDataSource(
    //       qualitylisttable8, widget.depoName!, cityName!);
    //   _dataGridController = DataGridController();
    // } else if (widget.fieldclnName == 'Painting') {
    //   qualitylisttable9 = checkTable ? painting_getData() : data;
    //   _qualityPaintingDataSource = QualityPaintingDataSource(
    //       qualitylisttable9, widget.depoName!, cityName!);
    //   _dataGridController = DataGridController();
    // } else if (widget.fieldclnName == 'Paving') {
    //   qualitylisttable10 = checkTable ? paving_getData() : data;
    //   _qualityPavingDataSource = QualityPavingDataSource(
    //       qualitylisttable10, widget.depoName!, cityName!);
    //   _dataGridController = DataGridController();
    // } else if (widget.fieldclnName == 'Roofing') {
    //   print('roofing');
    //   qualitylisttable11 = checkTable ? roofing_getData() : data;
    //   _qualityRoofingDataSource = QualityRoofingDataSource(
    //       qualitylisttable11, widget.depoName!, cityName!);
    //   _dataGridController = DataGridController();
    // } else if (widget.fieldclnName == 'Proofing') {
    //   print('Proofing');
    //   qualitylisttable12 = checkTable ? proofing_getData() : data;
    //   _qualityProofingDataSource = QualityProofingDataSource(
    //       qualitylisttable12, widget.depoName!, cityName!);
    //   _dataGridController = DataGridController();
    // }
  }
}
