import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/models/closer_report.dart';
import 'package:ev_pmis_app/views/citiespage/depot.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../components/Loading_page.dart';
import '../../../datasource/closereport_datasource.dart';
import '../../../provider/cities_provider.dart';
import '../../../style.dart';

//This is a comment
class ClosureTable extends StatefulWidget {
  String depoName;
  ClosureTable({super.key, required this.depoName});

  @override
  State<ClosureTable> createState() => _ClosureTableState();
}

class _ClosureTableState extends State<ClosureTable> {
  Stream? _stream;
  List<CloserReportModel> closereport = <CloserReportModel>[];
  late CloseReportDataSource _closeReportDataSource;
  late DataGridController _dataGridController;
  dynamic alldata;
  String? cityName;
  List<dynamic> tabledata2 = [];
  @override
  void initState() {
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;
    closereport = getcloseReport();
    _closeReportDataSource = CloseReportDataSource(
        closereport, context, widget.depoName, cityName!, userId);
    _dataGridController = DataGridController();
    _stream = FirebaseFirestore.instance
        .collection('ClosureProjectReport')
        .doc(widget.depoName)
        .collection('ClosureReport')
        .doc(userId)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer:  NavbarDrawer(role: widget.role!),
      appBar: CustomAppBar(
        depoName: '${widget.depoName}',
        title: 'Closure Checklist',
        height: 50,
        isSync: true,
        isCentered: false,
        store: () {
          // closureField(widget.depoName);
          store();
        },
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          return StreamBuilder(
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingPage();
              }
              if (!snapshot.hasData || snapshot.data.exists == false) {
                return SfDataGridTheme(
                  data: SfDataGridThemeData(headerColor: blue),
                  child: SfDataGrid(
                    source: _closeReportDataSource,
                    //key: key,
                    allowEditing: true,
                    frozenColumnsCount: 1,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    selectionMode: SelectionMode.single,
                    navigationMode: GridNavigationMode.cell,
                    columnWidthMode: ColumnWidthMode.auto,
                    editingGestureType: EditingGestureType.tap,
                    controller: _dataGridController,

                    columns: [
                      GridColumn(
                        columnName: 'srNo',
                        width: 80,
                        autoFitPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
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
                        columnName: 'Content',
                        width: 350,
                        allowEditing: false,
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                              'List of Content for ${widget.depoName}  Infrastructure',
                              style: tableheaderwhitecolor),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Upload',
                        allowEditing: false,
                        visible: true,
                        width: 120,
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
                        allowEditing: false,
                        width: 120,
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
                    //         columnNames: ['Upload', 'View'],
                    //         child: Container(
                    //           padding: EdgeInsets.all(10),
                    //           child: Text(
                    //             'Attachment Details',
                    //             style:
                    //                 TextStyle(color: white, fontSize: 18),
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ))
                    //   ])
                    // ],
                  ),
                );
              } else if (snapshot.hasData) {
                // alldata = '';
                // alldata = snapshot.data['data'] as List<dynamic>;
                // qualitylisttable1.clear();
                alldata.forEach((element) {});
                return SfDataGridTheme(
                  data: SfDataGridThemeData(headerColor: blue),
                  child: SfDataGrid(
                    source: _closeReportDataSource,
                    //key: key,
                    allowEditing: true,
                    frozenColumnsCount: 1,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    selectionMode: SelectionMode.single,
                    navigationMode: GridNavigationMode.cell,
                    columnWidthMode: ColumnWidthMode.auto,
                    editingGestureType: EditingGestureType.tap,
                    controller: _dataGridController,

                    columns: [
                      GridColumn(
                        columnName: 'srNo',
                        width: 80,
                        autoFitPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
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
                        columnName: 'Content',
                        width: 350,
                        allowEditing: false,
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                              'List of Content for ${widget.depoName}  Infrastructure',
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
                        allowEditing: false,
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
          );
        },
      ),
    );
  }

  List<CloserReportModel> getcloseReport() {
    return [
      CloserReportModel(
        siNo: 1,
        content: 'Introduction of Project',
      ),
      CloserReportModel(
        siNo: 1.1,
        content: 'RFP for DTC Bus Project ',
      ),
      CloserReportModel(
        siNo: 1.2,
        content: 'Project Purchase Order or LOI or LOA ',
      ),
      CloserReportModel(
        siNo: 1.3,
        content: 'Project Governance Structure',
      ),
      CloserReportModel(
        siNo: 1.4,
        content: 'Site Location Details',
      ),
      CloserReportModel(
        siNo: 1.5,
        content: 'Final  Site Survey Report.',
      ),
      CloserReportModel(
        siNo: 1.6,
        content: 'BOQ (Bill of Quantity)',
      ),
    ];
  }

  void store() {
    Map<String, dynamic> table_data = Map();
    for (var i in _closeReportDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'Photo' && data.columnName != 'ViewPhoto') {
          table_data[data.columnName] = data.value;
        }
      }

      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('ClosureReportTable')
        .doc(widget.depoName)
        .collection('Closure Report')
        .doc(userId)
        // .collection(userId)
        // .doc(DateFormat.yMMMMd().format(DateTime.now()))
        .set(
      {'data': tabledata2},
      SetOptions(merge: true),
    ).whenComplete(() {
      tabledata2.clear();
      // Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }
}
