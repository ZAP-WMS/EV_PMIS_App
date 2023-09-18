import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/screen/dailyreport/summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../FirebaseApi/firebase_api.dart';
import '../../authentication/authservice.dart';
import '../../components/Loading_page.dart';
import '../../model/daily_projectModel.dart';
import '../../datasource/dailyproject_datasource.dart';
import '../../provider/cities_provider.dart';
import '../../style.dart';
import '../../widgets/appbar_back_date.dart';
import '../../widgets/navbar.dart';
import '../homepage/gallery.dart';

String? selectedDate = DateFormat.yMMMMd().format(DateTime.now());
String? showDate = DateFormat.yMMMd().format(DateTime.now());

class DailyProject extends StatefulWidget {
  String? cityName;
  String? depoName;

  DailyProject({super.key, this.cityName, required this.depoName});

  @override
  State<DailyProject> createState() => _DailyProjectState();
}

class _DailyProjectState extends State<DailyProject> {
  List<DailyProjectModel> dailyproject = <DailyProjectModel>[];
  late DailyDataSource _dailyDataSource;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  var alldata;
  bool _isloading = true;

  @override
  void initState() {
    widget.cityName =
        Provider.of<CitiesProvider>(context, listen: false).getName;

    // selectedDate = DateFormat.yMMMMd().format(DateTime.now());

    dailyproject = getmonthlyReport();
    // _dailyDataSource = DailyDataSource(
    //     dailyproject, context, widget.cityName!, widget.depoName!, userId);
    // _dataGridController = DataGridController();

    getmonthlyReport();
    dailyproject = getmonthlyReport();
    _dailyDataSource = DailyDataSource(
        dailyproject, context, widget.cityName!, widget.depoName!, userId!);
    _dataGridController = DataGridController();

    _isloading = false;
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _stream = FirebaseFirestore.instance
        .collection('DailyProjectReport2')
        .doc('${widget.depoName}')
        .collection('userId')
        .doc(userId)
        .collection('date')
        .doc(selectedDate)
        .snapshots();
    return Scaffold(
      drawer: const NavbarDrawer(),
      appBar: PreferredSize(
          // ignore: sort_child_properties_last
          child: CustomAppBarBackDate(
              text: '${widget.cityName}/${widget.depoName}/Daily Report',

              //  ${DateFormat.yMMMMd().format(DateTime.now())}',
              haveSynced: true,
              haveSummary: true,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewSummary(
                      cityName: widget.cityName.toString(),
                      depoName: widget.depoName.toString(),
                      id: 'Daily Report',
                      userId: userId,
                    ),
                  )),
              store: () {
                _showDialog(context);
                FirebaseApi().nestedKeyEventsField(
                    'DailyProjectReport2', widget.depoName!, 'userId', userId!);
                storeData();
              },
              choosedate: () {
                chooseDate(context);
              }),
          preferredSize: const Size.fromHeight(50)),
      body: _isloading
          ? LoadingPage()
          : Column(children: [
              Expanded(
                  child: StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingPage();
                  } else if (!snapshot.hasData ||
                      snapshot.data.exists == false) {
                    dailyproject = getmonthlyReport();
                    _dailyDataSource = DailyDataSource(dailyproject, context,
                        widget.cityName!, widget.depoName!, userId!);
                    _dataGridController = DataGridController();
                    return SfDataGridTheme(
                      data: SfDataGridThemeData(headerColor: blue),
                      child: SfDataGrid(
                          source: _dailyDataSource,
                          allowEditing: true,
                          frozenColumnsCount: 2,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          selectionMode: SelectionMode.single,
                          navigationMode: GridNavigationMode.cell,
                          columnWidthMode: ColumnWidthMode.fitByCellValue,
                          editingGestureType: EditingGestureType.tap,
                          controller: _dataGridController,
                          onQueryRowHeight: (details) {
                            return details
                                .getIntrinsicRowHeight(details.rowIndex);
                          },
                          columns: [
                            GridColumn(
                              columnName: 'Date',
                              visible: false,
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 150,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Date',
                                    overflow: TextOverflow.values.first,
                                    textAlign: TextAlign.center,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),

                            GridColumn(
                              columnName: 'SiNo',
                              visible: false,
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 70,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('SI No.',
                                    overflow: TextOverflow.values.first,
                                    textAlign: TextAlign.center,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            // GridColumn(
                            //   columnName: 'Date',
                            //   autoFitPadding:
                            //       tablepadding,
                            //   allowEditing: false,
                            //   width: 160,
                            //   label: Container(
                            //     padding: tablepadding,
                            //     alignment: Alignment.center,
                            //     child: Text('Date',
                            //         textAlign: TextAlign.center,
                            //         overflow: TextOverflow.values.first,
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 16,
                            //             color: white)),
                            //   ),
                            // ),
                            // GridColumn(
                            //   visible: false,
                            //   columnName: 'State',
                            //   autoFitPadding:
                            //       tablepadding,
                            //   allowEditing: true,
                            //   width: 120,
                            //   label: Container(
                            //     padding: tablepadding,
                            //     alignment: Alignment.center,
                            //     child: Text('State',
                            //         textAlign: TextAlign.center,
                            //         overflow: TextOverflow.values.first,
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 16,
                            //             color: white)
                            //         //    textAlign: TextAlign.center,
                            //         ),
                            //   ),
                            // ),
                            // GridColumn(
                            //   visible: false,
                            //   columnName: 'DepotName',
                            //   autoFitPadding:
                            //       tablepadding,
                            //   allowEditing: true,
                            //   width: 150,
                            //   label: Container(
                            //     padding: tablepadding,
                            //     alignment: Alignment.center,
                            //     child: Text('Depot Name',
                            //         overflow: TextOverflow.values.first,
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 16,
                            //             color: white)
                            //         //    textAlign: TextAlign.center,
                            //         ),
                            //   ),
                            // ),
                            GridColumn(
                              columnName: 'TypeOfActivity',
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 200,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Type of Activity',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ActivityDetails',
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 220,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Activity Details',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Progress',
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              columnWidthMode: ColumnWidthMode.fill,
                              width: 300,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Progress',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Status',
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 280,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Remark / Status',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'upload',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 150,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Upload Image',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'view',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 120,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('View Image',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Add',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 120,
                              label: Container(
                                padding: tablepadding,
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
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 120,
                              label: Container(
                                padding: tablepadding,
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
                    dailyproject.clear();
                    alldata.forEach((element) {
                      dailyproject.add(DailyProjectModel.fromjson(element));
                      _dailyDataSource = DailyDataSource(dailyproject, context,
                          widget.cityName!, widget.depoName!, userId!);
                      _dataGridController = DataGridController();
                    });
                    return SfDataGridTheme(
                      data: SfDataGridThemeData(headerColor: blue),
                      child: SfDataGrid(
                          source: _dailyDataSource,
                          allowEditing: true,
                          frozenColumnsCount: 2,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          selectionMode: SelectionMode.single,
                          navigationMode: GridNavigationMode.cell,
                          editingGestureType: EditingGestureType.tap,
                          controller: _dataGridController,
                          onQueryRowHeight: (details) {
                            return details
                                .getIntrinsicRowHeight(details.rowIndex);
                          },
                          columns: [
                            GridColumn(
                              columnName: 'Date',
                              visible: false,
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 70,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Date',
                                    overflow: TextOverflow.values.first,
                                    textAlign: TextAlign.center,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'SiNo',
                              visible: false,
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 70,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('SI No.',
                                    overflow: TextOverflow.values.first,
                                    textAlign: TextAlign.center,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'TypeOfActivity',
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 200,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Type of Activity',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ActivityDetails',
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 220,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Activity Details',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Progress',
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 300,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Progress',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Status',
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 280,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Remark / Status',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'upload',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 150,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Upload Image',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'view',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 120,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('view Image',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Add',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 120,
                              label: Container(
                                padding: tablepadding,
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
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 120,
                              label: Container(
                                padding: tablepadding,
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
                  }
                },
              ))
            ]),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (() {
            dailyproject.add(DailyProjectModel(
                siNo: 1,
                // date: DateFormat().add_yMd(storeData()).format(DateTime.now()),
                // state: "Maharashtra",
                // depotName: 'depotName',
                typeOfActivity: 'Electrical Infra',
                activityDetails: "Initial Survey of DEpot",
                progress: '',
                status: ''));
            _dailyDataSource.buildDataGridRows();
            _dailyDataSource.updateDatagridSource();
          })),
    );
  }

  void storeData() {
    Map<String, dynamic> tableData = Map();
    for (var i in _dailyDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' && data.columnName != 'Delete') {
          tableData[data.columnName] = data.value;
          tableData.addAll({"Date": selectedDate});
        }
      }

      tabledata2.add(tableData);
      tableData = {};
    }

    FirebaseFirestore.instance
        .collection('DailyProjectReport2')
        .doc('${widget.depoName}')
        .collection('userId')
        .doc(userId)
        .collection('date')
        .doc(selectedDate.toString())
        // .doc(DateFormat.yMMMMd().format(DateTime.now()))
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

  List<DailyProjectModel> getmonthlyReport() {
    return [
      DailyProjectModel(
          siNo: 1,
          // date: DateFormat().add_yMd().format(DateTime.now()),
          // state: "Maharashtra",
          // depotName: 'depotName',
          typeOfActivity: '',
          activityDetails: '',
          progress: '',
          status: '')
    ];
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

  void chooseDate(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('All Date'),
              content: Container(
                  height: 400,
                  width: 500,
                  child: SfDateRangePicker(
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
                      Navigator.pop(context);
                      setState(() {});
                    }),
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  )),
            ));
  }
}
