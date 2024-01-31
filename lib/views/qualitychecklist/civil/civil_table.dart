import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/views/citiespage/depot.dart';
import 'package:ev_pmis_app/widgets/activity_headings.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_Ironite_flooring.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_backfilling.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_ceiling.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_excavation.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_flooring.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_glazzing.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_inspection.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_massonary.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_painting.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_paving.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_proofing.dart';
import '../../../../QualityDatasource/qualityCivilDatasource/quality_roofing.dart';
import '../../../../components/Loading_page.dart';
import '../../../../provider/cities_provider.dart';
import '../../../../style.dart';
import '../../../../widgets/quality_list.dart';
import '../../../viewmodels/quality_checklistModel.dart';

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

class CivilTable extends StatefulWidget {
  String? depoName;
  String? title;
  int? titleIndex;
  CivilTable(
      {super.key,
      required this.depoName,
      required this.title,
      required this.titleIndex});

  @override
  State<CivilTable> createState() => _CivilTableState();
}

class _CivilTableState extends State<CivilTable> {
  String? cityName;
  Stream? _stream;
  late DataGridController _dataGridController;

  dynamic alldata;
  @override
  void initState() {
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;

    qualitylisttable1 = excavation_getData();
    _qualityExcavationDataSource = QualityExcavationDataSource(
        qualitylisttable1, widget.depoName!, cityName!);
    _dataGridController = DataGridController();

    qualitylisttable2 = backfilling_getData();
    _qualityBackFillingDataSource = QualityBackFillingDataSource(
        qualitylisttable2, widget.depoName!, cityName!);
    _dataGridController = DataGridController();

    qualitylisttable3 = massonary_getData();
    _qualityMassonaryDataSource = QualityMassonaryDataSource(
        qualitylisttable3, widget.depoName!, cityName!);
    _dataGridController = DataGridController();

    qualitylisttable4 = glazzing_getData();
    _qualityGlazzingDataSource = QualityGlazzingDataSource(
        qualitylisttable4, widget.depoName!, cityName!);
    _dataGridController = DataGridController();

    qualitylisttable5 = ceilling_getData();
    _qualityCeillingDataSource = QualityCeillingDataSource(
        qualitylisttable5, widget.depoName!, cityName!);
    _dataGridController = DataGridController();

    qualitylisttable6 = florring_getData();
    _qualityflooringDataSource = QualityflooringDataSource(
        qualitylisttable6, widget.depoName!, cityName!);
    _dataGridController = DataGridController();

    qualitylisttable7 = inspection_getData();
    _qualityInspectionDataSource = QualityInspectionDataSource(
        qualitylisttable7, widget.depoName!, cityName!);
    _dataGridController = DataGridController();

    qualitylisttable8 = ironite_florring_getData();
    _qualityIroniteflooringDataSource = QualityIroniteflooringDataSource(
        qualitylisttable8, widget.depoName!, cityName!);
    _dataGridController = DataGridController();

    qualitylisttable9 = painting_getData();
    _qualityPaintingDataSource = QualityPaintingDataSource(
        qualitylisttable9, widget.depoName!, cityName!);
    _dataGridController = DataGridController();

    qualitylisttable10 = paving_getData();
    _qualityPavingDataSource = QualityPavingDataSource(
        qualitylisttable10, widget.depoName!, cityName!);
    _dataGridController = DataGridController();

    qualitylisttable11 = roofing_getData();
    _qualityRoofingDataSource = QualityRoofingDataSource(
        qualitylisttable11, widget.depoName!, cityName!);
    _dataGridController = DataGridController();

    qualitylisttable12 = proofing_getData();
    _qualityProofingDataSource = QualityProofingDataSource(
        qualitylisttable12, widget.depoName!, cityName!);
    _dataGridController = DataGridController();

    _stream = FirebaseFirestore.instance
        .collection('CivilQualityChecklistCollection')
        .doc('${widget.depoName}')
        .collection('userId!')
        .doc('widget.currentDate')
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavbarDrawer(),
      appBar: CustomAppBar(
          depoName: widget.depoName ?? '',
          title: 'ChecklistTable/${widget.title}',
          height: 50,
          isSync: true,
          store: () {
            CivilstoreData(context, widget.depoName!, currentDate);
          },
          isCentered: true),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage();
          }
          if (!snapshot.hasData || snapshot.data.exists == false) {
            return SfDataGridTheme(
              data: SfDataGridThemeData(headerColor: blue),
              child: SfDataGrid(
                source: widget.titleIndex == 0
                    ? _qualityExcavationDataSource
                    : widget.titleIndex == 1
                        ? _qualityBackFillingDataSource
                        : widget.titleIndex == 2
                            ? _qualityMassonaryDataSource
                            : widget.titleIndex == 3
                                ? _qualityGlazzingDataSource
                                : widget.titleIndex == 4
                                    ? _qualityCeillingDataSource
                                    : widget.titleIndex == 5
                                        ? _qualityflooringDataSource
                                        : widget.titleIndex == 6
                                            ? _qualityInspectionDataSource
                                            : widget.titleIndex == 7
                                                ? _qualityIroniteflooringDataSource
                                                : widget.titleIndex == 8
                                                    ? _qualityPaintingDataSource
                                                    : widget.titleIndex == 9
                                                        ? _qualityPavingDataSource
                                                        : _qualityInspectionDataSource,

                allowEditing: true,
                frozenColumnsCount: 1,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                selectionMode: SelectionMode.single,
                navigationMode: GridNavigationMode.cell,
                columnWidthMode: ColumnWidthMode.auto,
                editingGestureType: EditingGestureType.tap,
                controller: _dataGridController,

                // onQueryRowHeight: (dwidget.titleIndex!etails) {
                //   return details.rowIndex == 0 ? 60.0 : 49.0;
                // },
                columns: [
                  GridColumn(
                    columnName: 'srNo',
                    width: 80,
                    autoFitPadding: const EdgeInsets.symmetric(horizontal: 16),
                    allowEditing: false,
                    label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      alignment: Alignment.center,
                      child: Text('Checks(Before Start of Backfill Activity)',
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
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      alignment: Alignment.center,
                      child: Text("Observation Comments by  Owner’s Engineer",
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
            alldata = '';
            alldata = snapshot.data['data'] as List<dynamic>;
            qualitylisttable1.clear();
            alldata.forEach((element) {
              qualitylisttable1.add(QualitychecklistModel.fromJson(element));
            });
            return SfDataGridTheme(
              data: SfDataGridThemeData(headerColor: blue),
              child: SfDataGrid(
                source: widget.titleIndex == 0
                    ? _qualityExcavationDataSource
                    : widget.titleIndex == 1
                        ? _qualityBackFillingDataSource
                        : widget.titleIndex == 2
                            ? _qualityMassonaryDataSource
                            : widget.titleIndex == 3
                                ? _qualityGlazzingDataSource
                                : widget.titleIndex == 4
                                    ? _qualityCeillingDataSource
                                    : widget.titleIndex == 5
                                        ? _qualityflooringDataSource
                                        : widget.titleIndex == 6
                                            ? _qualityInspectionDataSource
                                            : widget.titleIndex == 7
                                                ? _qualityIroniteflooringDataSource
                                                : widget.titleIndex == 8
                                                    ? _qualityPaintingDataSource
                                                    :
                                                    // widget.titleIndex ==
                                                    //         9
                                                    //     ?
                                                    _qualityPavingDataSource,
                // widget.titleIndex ==
                //         10
                //     ? _qualityRoofingDataSource
                //     : _qualityPROOFINGDataSource,

                //key: key,
                allowEditing: true,
                frozenColumnsCount: 2,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
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
                    autoFitPadding: const EdgeInsets.symmetric(horizontal: 16),
                    allowEditing: false,
                    label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      alignment: Alignment.center,
                      child: Text('Upload.',
                          overflow: TextOverflow.values.first,
                          style: tableheaderwhitecolor),
                    ),
                  ),
                  GridColumn(
                    columnName: 'View',
                    allowEditing: true,
                    width: 150,
                    label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
    );
  }

  CivilstoreData(BuildContext context, String depoName, String currentDate) {
    Map<String, dynamic> excavationTableData = Map();
    Map<String, dynamic> backfillingTableData = Map();
    Map<String, dynamic> massonaryTableData = Map();
    Map<String, dynamic> doorsTableData = Map();
    Map<String, dynamic> ceillingTableData = Map();
    Map<String, dynamic> flooringTableData = Map();
    Map<String, dynamic> inspectionTableData = Map();
    Map<String, dynamic> paintingTableData = Map();
    Map<String, dynamic> pavingTableData = Map();
    Map<String, dynamic> roofingTableData = Map();
    Map<String, dynamic> proofingTableData = Map();

    for (var i in _qualityExcavationDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          excavationTableData[data.columnName] = data.value;
        }
      }

      excavationtabledatalist.add(excavationTableData);
      excavationTableData = {};
    }

    FirebaseFirestore.instance
        .collection('QualityChecklist')
        .doc(depoName)
        .collection('Excavation TABLE DATA')
        .doc('Excavation')
        .collection(userId!)
        .doc(currentDate)
        .set({
      'data': excavationtabledatalist,
    }).whenComplete(() {
      excavationTableData.clear();
      for (var i in _qualityBackFillingDataSource.dataGridRows) {
        for (var data in i.getCells()) {
          if (data.columnName != 'button' ||
              data.columnName == 'View' ||
              data.columnName != 'Delete') {
            backfillingTableData[data.columnName] = data.value;
          }
        }
        backfillingtabledatalist.add(backfillingTableData);
        backfillingTableData = {};
      }

      FirebaseFirestore.instance
          .collection('QualityChecklist')
          .doc(depoName)
          .collection('BackFilling TABLE DATA')
          .doc('BackFilling')
          .collection(userId!)
          .doc(currentDate)
          .set({
        'data': backfillingtabledatalist,
      }).whenComplete(() {
        backfillingTableData.clear();
        for (var i in _qualityMassonaryDataSource.dataGridRows) {
          for (var data in i.getCells()) {
            if (data.columnName != 'button' ||
                data.columnName == 'View' ||
                data.columnName != 'Delete') {
              massonaryTableData[data.columnName] = data.value;
            }
          }

          massonarytabledatalist.add(massonaryTableData);
          massonaryTableData = {};
        }

        FirebaseFirestore.instance
            .collection('QualityChecklist')
            .doc(depoName)
            .collection('Massonary TABLE DATA')
            .doc('Massonary')
            .collection(userId!)
            .doc(currentDate)
            .set({
          'data': backfillingtabledatalist,
        }).whenComplete(() {
          massonaryTableData.clear();
          for (var i in _qualityGlazzingDataSource.dataGridRows) {
            for (var data in i.getCells()) {
              if (data.columnName != 'button' ||
                  data.columnName == 'View' ||
                  data.columnName != 'Delete') {
                doorsTableData[data.columnName] = data.value;
              }
            }
            doorstabledatalist.add(doorsTableData);
            doorsTableData = {};
          }

          FirebaseFirestore.instance
              .collection('QualityChecklist')
              .doc(depoName)
              .collection('Glazzing TABLE DATA')
              .doc('Glazzing')
              .collection(userId!)
              .doc(currentDate)
              .set({
            'data': doorstabledatalist,
          }).whenComplete(() {
            doorsTableData.clear();
            for (var i in _qualityCeillingDataSource.dataGridRows) {
              for (var data in i.getCells()) {
                if (data.columnName != 'button' ||
                    data.columnName != 'Delete') {
                  ceillingTableData[data.columnName] = data.value;
                }
              }
              ceillingtabledatalist.add(ceillingTableData);
              ceillingTableData = {};
            }

            FirebaseFirestore.instance
                .collection('QualityChecklist')
                .doc(depoName)
                .collection('CEILLING TABLE DATA')
                .doc('CEILLING DATA')
                .collection(userId!)
                .doc(currentDate)
                .set({
              'data': ceillingtabledatalist,
            }).whenComplete(() {
              ceillingTableData.clear();
              for (var i in _qualityflooringDataSource.dataGridRows) {
                for (var data in i.getCells()) {
                  if (data.columnName != 'button' ||
                      data.columnName == 'View' ||
                      data.columnName != 'Delete') {
                    flooringTableData[data.columnName] = data.value;
                  }
                }
                flooringtabledatalist.add(flooringTableData);
                flooringTableData = {};
              }

              FirebaseFirestore.instance
                  .collection('QualityChecklist')
                  .doc(depoName)
                  .collection('FLOORING TABLE DATA')
                  .doc('FLOORING DATA')
                  .collection(userId!)
                  .doc(currentDate)
                  .set({
                'data': flooringtabledatalist,
              }).whenComplete(() {
                flooringTableData.clear();
                for (var i in _qualityInspectionDataSource.dataGridRows) {
                  for (var data in i.getCells()) {
                    if (data.columnName != 'button' ||
                        data.columnName == 'View' ||
                        data.columnName != 'Delete') {
                      inspectionTableData[data.columnName] = data.value;
                    }
                  }
                  inspectiontabledatalist.add(inspectionTableData);
                  inspectionTableData = {};
                }

                FirebaseFirestore.instance
                    .collection('QualityChecklist')
                    .doc(depoName)
                    .collection('INSPECTION TABLE DATA')
                    .doc('INSPECTION DATA')
                    .collection(userId!)
                    .doc(currentDate)
                    .set({
                  'data': inspectiontabledatalist,
                }).whenComplete(() {
                  inspectionTableData.clear();
                  for (var i in _qualityflooringDataSource.dataGridRows) {
                    for (var data in i.getCells()) {
                      if (data.columnName != 'button' ||
                          data.columnName == 'View' ||
                          data.columnName != 'Delete') {
                        flooringTableData[data.columnName] = data.value;
                      }
                    }
                    flooringtabledatalist.add(flooringTableData);
                    flooringTableData = {};
                  }

                  FirebaseFirestore.instance
                      .collection('QualityChecklist')
                      .doc(depoName)
                      .collection('FLOORING TABLE DATA')
                      .doc('FLOORING DATA')
                      .collection(userId!)
                      .doc(currentDate)
                      .set({
                    'data': flooringtabledatalist,
                  }).whenComplete(() {
                    flooringTableData.clear();
                    for (var i in _qualityPaintingDataSource.dataGridRows) {
                      for (var data in i.getCells()) {
                        if (data.columnName != 'button' ||
                            data.columnName == 'View' ||
                            data.columnName != 'Delete') {
                          flooringTableData[data.columnName] = data.value;
                        }
                      }
                      paintingtabledatalist.add(paintingTableData);
                      paintingTableData = {};
                    }

                    FirebaseFirestore.instance
                        .collection('QualityChecklist')
                        .doc(depoName)
                        .collection('PAINTING TABLE DATA')
                        .doc('PAINTING DATA')
                        .collection(userId!)
                        .doc(currentDate)
                        .set({
                      'data': paintingtabledatalist,
                    }).whenComplete(() {
                      paintingTableData.clear();
                      for (var i in _qualityPavingDataSource.dataGridRows) {
                        for (var data in i.getCells()) {
                          if (data.columnName != 'button' ||
                              data.columnName == 'View' ||
                              data.columnName != 'Delete') {
                            pavingTableData[data.columnName] = data.value;
                          }
                        }
                        pavingtabledatalist.add(pavingTableData);
                        pavingTableData = {};
                      }

                      FirebaseFirestore.instance
                          .collection('QualityChecklist')
                          .doc(depoName)
                          .collection('PAVING TABLE DATA')
                          .doc('PAVING DATA')
                          .collection(userId!)
                          .doc(currentDate)
                          .set({
                        'data': pavingtabledatalist,
                      }).whenComplete(() {
                        pavingtabledatalist.clear();
                        for (var i in _qualityRoofingDataSource.dataGridRows) {
                          for (var data in i.getCells()) {
                            if (data.columnName != 'button' ||
                                data.columnName == 'View' ||
                                data.columnName != 'Delete') {
                              roofingTableData[data.columnName] = data.value;
                            }
                          }
                          roofingtabledatalist.add(roofingTableData);
                          roofingTableData = {};
                        }

                        FirebaseFirestore.instance
                            .collection('QualityChecklist')
                            .doc(depoName)
                            .collection('ROOFING TABLE DATA')
                            .doc('ROOFING DATA')
                            .collection(userId!)
                            .doc(currentDate)
                            .set({
                          'data': roofingtabledatalist,
                        }).whenComplete(() {
                          roofingTableData.clear();
                          for (var i
                              in _qualityProofingDataSource.dataGridRows) {
                            for (var data in i.getCells()) {
                              if (data.columnName != 'button' ||
                                  data.columnName == 'View' ||
                                  data.columnName != 'Delete') {
                                roofingTableData[data.columnName] = data.value;
                              }
                            }
                            roofingtabledatalist.add(roofingTableData);
                            roofingTableData = {};
                          }

                          FirebaseFirestore.instance
                              .collection('QualityChecklist')
                              .doc(depoName)
                              .collection('PROOFING TABLE DATA')
                              .doc('PROOFING DATA')
                              .collection(userId!)
                              .doc(currentDate)
                              .set({
                            'data': proofingtabledatalist,
                          }).whenComplete(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Data are synced'),
                              backgroundColor: blue,
                            ));
                          });
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }
}
