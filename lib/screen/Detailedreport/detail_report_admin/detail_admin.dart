import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/datasource_admin/detailedengEV_datasource.dart';
import 'package:ev_pmis_app/datasource_admin/detailedengShed_datasource.dart';
import 'package:ev_pmis_app/datasource_admin/detailedeng_datasource.dart';
import 'package:ev_pmis_app/model_admin/detailed_engModel.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/views/Detailedreport/detailed_Eng.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/navbar.dart';

class DetailedEngAdmin extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? userId;
  String? role;
  DetailedEngAdmin(
      {super.key,
      required this.cityName,
      required this.depoName,
      this.userId,
      required this.role});

  @override
  State<DetailedEngAdmin> createState() => _DetailedEngAdmintState();
}

class _DetailedEngAdmintState extends State<DetailedEngAdmin>
    with TickerProviderStateMixin {
  TextEditingController selectedDepoController = TextEditingController();
  TextEditingController selectedCityController = TextEditingController();

  List<DetailedEngModelAdmin> detailedProject = <DetailedEngModelAdmin>[];
  List<DetailedEngModelAdmin> DetailedProjectev = <DetailedEngModelAdmin>[];
  List<DetailedEngModelAdmin> DetailedProjectshed = <DetailedEngModelAdmin>[];

  late DetailedEngSourceShed _detailedEngSourceShed;
  late DetailedEngSource _detailedDataSource;
  late DetailedEngSourceEV _detailedEngSourceev;

  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  List<dynamic> ev_tabledatalist = [];
  List<dynamic> shed_tabledatalist = [];
  TabController? _controller;
  int _selectedIndex = 0;
  Stream? _stream;
  Stream? _stream1;
  Stream? _stream2;
  var alldata;
  bool _isloading = true;
  dynamic userId;
  String? companyName;

  List id = [];

  @override
  void initState() {
    _detailedDataSource = DetailedEngSource(detailedProject, context,
        widget.cityName.toString(), widget.depoName.toString(), widget.role);
    _dataGridController = DataGridController();

    _detailedEngSourceev = DetailedEngSourceEV(DetailedProjectev, context,
        widget.cityName.toString(), widget.depoName.toString(), widget.role);
    _dataGridController = DataGridController();

    _detailedEngSourceShed = DetailedEngSourceShed(DetailedProjectshed, context,
        widget.cityName.toString(), widget.depoName.toString(), widget.role);
    _dataGridController = DataGridController();

    _controller = TabController(length: 3, vsync: this);

    getFieldUserId().whenComplete(
      () {
        getTableData(id).whenComplete(() {
          _detailedDataSource = DetailedEngSource(
              detailedProject,
              context,
              widget.cityName.toString(),
              widget.depoName.toString(),
              widget.role);
          _dataGridController = DataGridController();
          _detailedEngSourceev = DetailedEngSourceEV(
              DetailedProjectev,
              context,
              widget.cityName.toString(),
              widget.depoName.toString(),
              widget.role);
          _dataGridController = DataGridController();
          _detailedEngSourceShed = DetailedEngSourceShed(
              DetailedProjectshed,
              context,
              widget.cityName.toString(),
              widget.depoName.toString(),
              widget.role);
          _dataGridController = DataGridController();
          _isloading = false;
          setState(() {});
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        drawer: NavbarDrawer(role: widget.role),
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: blue,
            title: Column(
              children: [
                const Text(
                  'Detailed Engineering',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.depoName ?? '',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              widget.role == "projectManager"
                  ? Container(
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(
                        6.0,
                      ),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailedEng(
                                  depoName: widget.depoName,
                                  role: 'user',
                                  userId: widget.userId,
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: blue,
                          )),
                    )
                  : Container(),
            ],
            bottom: TabBar(
              onTap: (value) {
                _selectedIndex = value;
              },
              tabs: const [
                Tab(text: "RFC Drawings of Civil Activities"),
                Tab(text: "EV Layout Drawings of Electrical Activities"),
                Tab(text: "Shed Lighting Drawings & Specification"),
              ],
            )),
        body: _isloading
            ? const LoadingPage()
            : TabBarView(children: [
                tabScreen(),
                tabScreen1(),
                tabScreen2(),
              ]),
      ),
    );
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
      setState(() {});
    });
  }

  void StoreData() {
    Map<String, dynamic> table_data = Map();
    Map<String, dynamic> ev_table_data = Map();
    Map<String, dynamic> shed_table_data = Map();

    for (var i in _detailedDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName != 'ViewDrawing' ||
            data.columnName != "Delete") {
          table_data[data.columnName] = data.value;
        }
      }

      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('DetailEngineering')
        .doc('${widget.depoName}')
        .collection('RFC LAYOUT DRAWING')
        .doc(userId)
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      for (var i in _detailedEngSourceev.dataGridRows) {
        for (var data in i.getCells()) {
          if (data.columnName != 'button' ||
              data.columnName != 'ViewDrawing' ||
              data.columnName != "Delete") {
            ev_table_data[data.columnName] = data.value;
          }
        }

        ev_tabledatalist.add(ev_table_data);
        ev_table_data = {};
      }

      FirebaseFirestore.instance
          .collection('DetailEngineering')
          .doc('${widget.depoName}')
          .collection('EV LAYOUT DRAWING')
          .doc(userId)
          .set({
        'data': ev_tabledatalist,
      }).whenComplete(() {
        for (var i in _detailedEngSourceShed.dataGridRows) {
          for (var data in i.getCells()) {
            if (data.columnName != 'button' ||
                data.columnName != 'ViewDrawing' ||
                data.columnName != "Delete") {
              shed_table_data[data.columnName] = data.value;
            }
          }

          shed_tabledatalist.add(shed_table_data);
          shed_table_data = {};
        }

        FirebaseFirestore.instance
            .collection('DetailEngineering')
            .doc('${widget.depoName}')
            .collection('Shed LAYOUT DRAWING')
            .doc(userId)
            .set({
          'data': shed_tabledatalist,
        }).whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Data are synced'),
            backgroundColor: blue,
          ));
        });
      });
      // tabledata2.clear();
      // Navigator.pop(context);
    });
  }

  List<DetailedEngModelAdmin> getmonthlyReportEv() {
    return [
      DetailedEngModelAdmin(
        siNo: 2,
        title: 'EV Layout',
        number: 123458656,
        preparationDate: DateFormat().add_yMd().format(DateTime.now()),
        submissionDate: DateFormat().add_yMd().format(DateTime.now()),
        approveDate: DateFormat().add_yMd().format(DateTime.now()),
        releaseDate: DateFormat().add_yMd().format(DateTime.now()),
      ),
    ];
  }

  List<DetailedEngModelAdmin> getmonthlyReportShed() {
    return [
      DetailedEngModelAdmin(
        siNo: 2,
        title: 'EV Layout',
        number: 123458656,
        preparationDate: DateFormat().add_yMd().format(DateTime.now()),
        submissionDate: DateFormat().add_yMd().format(DateTime.now()),
        approveDate: DateFormat().add_yMd().format(DateTime.now()),
        releaseDate: DateFormat().add_yMd().format(DateTime.now()),
      ),
    ];
  }

  List<DetailedEngModelAdmin> getmonthlyReport() {
    return [
      DetailedEngModelAdmin(
        siNo: 1,
        title: 'EV Layout',
        number: 12345,
        preparationDate: DateFormat().add_yMd().format(DateTime.now()),
        submissionDate: DateFormat().add_yMd().format(DateTime.now()),
        approveDate: DateFormat().add_yMd().format(DateTime.now()),
        releaseDate: DateFormat().add_yMd().format(DateTime.now()),
      ),
    ];
  }

  tabScreen() {
    return Scaffold(
      body: Column(children: [
        Expanded(
            child: SfDataGridTheme(
          data: SfDataGridThemeData(headerColor: white, gridLineColor: blue),
          child: StreamBuilder(
            stream: _stream,
            builder: (context, snapshot) {
              return SfDataGrid(
                  source: _selectedIndex == 0
                      ? _detailedDataSource
                      : _detailedEngSourceev,
                  allowEditing: false,
                  frozenColumnsCount: 2,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  selectionMode: SelectionMode.single,
                  navigationMode: GridNavigationMode.cell,
                  columnWidthMode: ColumnWidthMode.auto,
                  editingGestureType: EditingGestureType.tap,
                  controller: _dataGridController,
                  columns: [
                    GridColumn(
                      visible: false,
                      columnName: 'SiNo',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 80,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('SI No.',
                            overflow: TextOverflow.values.first,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: blue)
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      visible: false,
                      columnName: 'button',
                      width: 130,
                      allowEditing: false,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('Upload Drawing ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: blue)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'ViewDrawing',
                      width: 120,
                      allowEditing: false,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('View Drawing ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Title',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 300,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Description',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Number',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 130,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Drawing Number',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'PreparationDate',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 170,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Preparation Date',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'SubmissionDate',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 170,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Submission Date',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'ApproveDate',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 170,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Approve Date',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'ReleaseDate',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 170,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Release Date',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      visible: false,
                      columnName: 'Delete',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 120,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Delete Row',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                  ]);
              //   }
            },
          ),
        )),
      ]),
    );
  }

  tabScreen1() {
    return Scaffold(
      body: Column(children: [
        Expanded(
            child: SfDataGridTheme(
          data: SfDataGridThemeData(headerColor: white, gridLineColor: blue),
          child: StreamBuilder(
              stream: _stream1,
              builder: (context, snapshot) {
                return SfDataGrid(
                    source: _selectedIndex == 0
                        ? _detailedDataSource
                        : _detailedEngSourceev,
                    allowEditing: false,
                    frozenColumnsCount: 2,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    selectionMode: SelectionMode.single,
                    navigationMode: GridNavigationMode.cell,
                    columnWidthMode: ColumnWidthMode.auto,
                    editingGestureType: EditingGestureType.tap,
                    controller: _dataGridController,
                    columns: [
                      GridColumn(
                        visible: false,
                        columnName: 'SiNo',
                        autoFitPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        allowEditing: true,
                        width: 80,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.center,
                          child: Text('SI No.',
                              overflow: TextOverflow.values.first,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue,
                              )
                              //    textAlign: TextAlign.center,
                              ),
                        ),
                      ),
                      GridColumn(
                        visible: false,
                        columnName: 'button',
                        width: 130,
                        allowEditing: false,
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text('Upload Drawing ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: blue)),
                        ),
                      ),
                      GridColumn(
                        columnName: 'ViewDrawing',
                        width: 130,
                        allowEditing: false,
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text('View Drawing ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: blue)),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Title',
                        autoFitPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        allowEditing: true,
                        width: 300,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.center,
                          child: Text('Description',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.values.first,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: blue)),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Number',
                        autoFitPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        allowEditing: true,
                        width: 130,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.center,
                          child: Text('Drawing Number',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.values.first,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: blue)
                              //    textAlign: TextAlign.center,
                              ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'PreparationDate',
                        autoFitPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        allowEditing: false,
                        width: 170,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.center,
                          child: Text('Preparation Date',
                              overflow: TextOverflow.values.first,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: blue)
                              //    textAlign: TextAlign.center,
                              ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'SubmissionDate',
                        autoFitPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        allowEditing: false,
                        width: 170,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.center,
                          child: Text('Submission Date',
                              overflow: TextOverflow.values.first,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: blue)
                              //    textAlign: TextAlign.center,
                              ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'ApproveDate',
                        autoFitPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        allowEditing: false,
                        width: 170,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.center,
                          child: Text('Approve Date',
                              overflow: TextOverflow.values.first,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: blue)
                              //    textAlign: TextAlign.center,
                              ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'ReleaseDate',
                        autoFitPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        allowEditing: false,
                        width: 170,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.center,
                          child: Text('Release Date',
                              overflow: TextOverflow.values.first,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: blue)
                              //    textAlign: TextAlign.center,
                              ),
                        ),
                      ),
                      GridColumn(
                        visible: false,
                        columnName: 'Delete',
                        autoFitPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        allowEditing: false,
                        width: 120,
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.center,
                          child: Text('Delete Row',
                              overflow: TextOverflow.values.first,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: blue)
                              //    textAlign: TextAlign.center,
                              ),
                        ),
                      ),
                    ]);
              }
              // },
              ),
        )),
      ]),
    );
  }

  tabScreen2() {
    return Scaffold(
      body: Column(children: [
        Expanded(
            child: SfDataGridTheme(
          data: SfDataGridThemeData(headerColor: white, gridLineColor: blue),
          child: StreamBuilder(
            stream: _stream2,
            builder: (context, snapshot) {
              return SfDataGrid(
                  source: _selectedIndex == 0
                      ? _detailedDataSource
                      : _detailedEngSourceShed,
                  allowEditing: false,
                  frozenColumnsCount: 2,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  selectionMode: SelectionMode.single,
                  navigationMode: GridNavigationMode.cell,
                  columnWidthMode: ColumnWidthMode.auto,
                  editingGestureType: EditingGestureType.tap,
                  controller: _dataGridController,
                  columns: [
                    GridColumn(
                      visible: false,
                      columnName: 'SiNo',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 80,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('SI No.',
                            overflow: TextOverflow.values.first,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      visible: false,
                      columnName: 'button',
                      width: 130,
                      allowEditing: false,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('Upload Drawing ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'ViewDrawing',
                      width: 130,
                      allowEditing: false,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('View Drawing ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Title',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 300,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Description',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Number',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 130,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Drawing Number',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'PreparationDate',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 170,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Preparation Date',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'SubmissionDate',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 170,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Submission Date',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'ApproveDate',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 170,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Approve Date',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'ReleaseDate',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 170,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Release Date',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      visible: false,
                      columnName: 'Delete',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 120,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Delete Row',
                            overflow: TextOverflow.values.first,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: blue)
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                  ]);
              //     }
            },
          ),
        )),
      ]),
    );
  }

  Future getFieldUserId() async {
    await FirebaseFirestore.instance
        .collection('DetailEngineering')
        .doc(widget.depoName!)
        .collection('RFC LAYOUT DRAWING')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        String documentId = element.id;
        id.add(documentId);
        print('$id');
        // nestedTableData(docss);
      });
    });
  }

  Future getTableData(doc_id) async {
    for (int i = 0; i < doc_id.length; i++) {
      await FirebaseFirestore.instance
          .collection('DetailEngineering')
          .doc('${widget.depoName}')
          .collection('RFC LAYOUT DRAWING')
          .doc(doc_id[i])
          .get()
          .then((value) {
        if (value.data() != null) {
          print(value.data()!['data'].length);
          for (int j = 0; j < value.data()!['data'].length; j++) {
            detailedProject
                .add(DetailedEngModelAdmin.fromjsaon(value.data()!['data'][j]));
          }
        }
      });
    }
    // .doc(widget.userid)
    // .snapshots();
    print(detailedProject.length);
    // setState(() {});

    await FirebaseFirestore.instance
        .collection('DetailEngineering')
        .doc('${widget.depoName}')
        .collection('EV LAYOUT DRAWING')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        for (int i = 0; i < element.data()["data"].length; i++) {
          print(element.data()["data"][i]);
          // DetailedProject
          //     .add(DetailedEngModel.fromJson(element.data()['data'][i]));
          DetailedProjectev.add(
              DetailedEngModelAdmin.fromjsaon(element.data()["data"][i]));
        }
      });
    });

    await FirebaseFirestore.instance
        .collection('DetailEngineering')
        .doc('${widget.depoName}')
        .collection('Shed LAYOUT DRAWING')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        for (int i = 0; i < element.data()["data"].length; i++) {
          print(element.data()["data"][i]);
          // DetailedProject
          //     .add(DetailedEngModel.fromJson(element.data()['data'][i]));
          DetailedProjectshed.add(
              DetailedEngModelAdmin.fromjsaon(element.data()["data"][i]));
        }
      });
    });
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<dynamic>> getDepoList(String pattern) async {
    List<dynamic> depoList = [];

    if (widget.cityName.toString().isNotEmpty) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('DepoName')
          .doc(widget.cityName)
          .collection('AllDepots')
          .get();

      depoList = querySnapshot.docs.map((deponame) => deponame.id).toList();

      if (pattern.isNotEmpty) {
        depoList = depoList
            .where((element) => element
                .toString()
                .toUpperCase()
                .startsWith(pattern.toUpperCase()))
            .toList();
      }
    } else {
      depoList.add('Please Select a City');
    }

    return depoList;
  }

  Future<List<dynamic>> getCityList(String pattern) async {
    List<dynamic> cityList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('DepoName').get();

    cityList = querySnapshot.docs.map((deponame) => deponame.id).toList();

    if (pattern.isNotEmpty) {
      cityList = cityList
          .where((element) => element
              .toString()
              .toUpperCase()
              .startsWith(pattern.toUpperCase()))
          .toList();
    }

    return cityList;
  }
}
