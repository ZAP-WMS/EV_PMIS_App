import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/viewmodels/daily_projectModel.dart';
import 'package:ev_pmis_app/views/citiespage/depot.dart';
import 'package:ev_pmis_app/views/dailyreport/summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../FirebaseApi/firebase_api.dart';
import '../../../components/Loading_page.dart';
import '../../../datasource/dailyproject_datasource.dart';
import '../../../provider/cities_provider.dart';
import '../../../style.dart';
import '../../../widgets/appbar_back_date.dart';
import '../../../widgets/navbar.dart';

List<bool> isShowPinIcon = [];
List<int> globalItemLengthList = [];

class DailyProject extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? role;

  DailyProject({super.key, this.cityName, required this.depoName, this.role});

  @override
  State<DailyProject> createState() => _DailyProjectState();
}

class _DailyProjectState extends State<DailyProject> {
  bool isLoading = true;
  bool checkTable = true;
  List<DailyProjectModel> dailyproject = <DailyProjectModel>[];
  late DailyDataSource _dailyDataSource;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  var alldata;

  String? selectedDate = DateFormat.yMMMMd().format(DateTime.now());
  String? visDate = DateFormat.yMMMd().format(DateTime.now());

  @override
  void initState() {
    widget.cityName =
        Provider.of<CitiesProvider>(context, listen: false).getName;

    _dailyDataSource = DailyDataSource(dailyproject, context, widget.cityName!,
        widget.depoName!, userId, selectedDate!);
    _dataGridController = DataGridController();
    getmonthlyReport();
    // dailyproject = getmonthlyReport();
    _stream = FirebaseFirestore.instance
        .collection('DailyProject3')
        .doc('${widget.depoName}')
        .collection(selectedDate.toString())
        .doc(userId)
        .snapshots();

    getTableData().whenComplete(() {
      _dailyDataSource = DailyDataSource(dailyproject, context,
          widget.cityName!, widget.depoName!, userId, selectedDate!);
      _dataGridController = DataGridController();
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
              depoName: widget.depoName ?? '',
              text: 'Daily Report',
              //  ${DateFormat.yMMMMd().format(DateTime.now())}',
              haveSynced: true,
              haveSummary: true,
              haveCalender: true,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewSummary(
                      cityName: widget.cityName.toString(),
                      depoName: widget.depoName.toString(),
                      role: widget.role,
                      id: 'Daily Report',
                      userId: userId,
                    ),
                  )),
              store: () {
                _showDialog(context);
                FirebaseApi().nestedKeyEventsField(
                    'DailyProject3', widget.depoName!, 'userId', userId);
                storeData();
              },
              showDate: visDate,
              choosedate: () {
                chooseDate(context);
              }),
          preferredSize: const Size.fromHeight(80)),
      body: isLoading
          ? const LoadingPage()
          : Column(children: [
              Expanded(
                child: StreamBuilder(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data.exists == false) {
                      return SfDataGridTheme(
                        data: SfDataGridThemeData(
                            gridLineColor: blue,
                            gridLineStrokeWidth: 2,
                            frozenPaneLineColor: blue,
                            frozenPaneLineWidth: 2),
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
                                //autoFit//Padding: tablepadding,
                                allowEditing: true,
                                width: 150,
                                label: Container(
                                  //Padding: tablepadding,
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
                                //autoFit//Padding: tablepadding,
                                allowEditing: true,
                                width: 70,
                                label: Container(
                                  //Padding: tablepadding,
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
                              //     //Padding: tablepadding,
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
                              //     //Padding: tablepadding,
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
                              //     //Padding: tablepadding,
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
                                //autoFit//Padding: tablepadding,
                                allowEditing: true,
                                width: 200,
                                label: Container(
                                  //Padding: tablepadding,
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
                                //autoFit//Padding: tablepadding,
                                allowEditing: true,
                                width: 220,
                                label: Container(
                                  //Padding: tablepadding,
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
                                //autoFit//Padding: tablepadding,
                                allowEditing: true,
                                columnWidthMode: ColumnWidthMode.fill,
                                width: 300,
                                label: Container(
                                  //Padding: tablepadding,
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
                                //autoFit//Padding: tablepadding,
                                allowEditing: true,
                                width: 280,
                                label: Container(
                                  //Padding: tablepadding,
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
                                //autoFit//Padding: tablepadding,
                                allowEditing: false,
                                width: 150,
                                label: Container(
                                  //Padding: tablepadding,
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
                                //autoFit//Padding: tablepadding,
                                allowEditing: false,
                                width: 120,
                                label: Container(
                                  //Padding: tablepadding,
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
                                //autoFit//Padding: tablepadding,
                                allowEditing: false,
                                width: 120,
                                label: Container(
                                  //Padding: tablepadding,
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
                                //autoFit//Padding: tablepadding,
                                allowEditing: false,
                                width: 120,
                                label: Container(
                                  //Padding: tablepadding,
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
                      // alldata = '';
                      // alldata = snapshot.data['data'] as List<dynamic>;
                      // dailyproject.clear();
                      // alldata.forEach((element) {
                      //   dailyproject.add(DailyProjectModel.fromjson(element));
                      //   _dailyDataSource = DailyDataSource(
                      //       dailyproject,
                      //       context,
                      //       widget.cityName!,
                      //       widget.depoName!,
                      //       userId!,
                      //       selectedDate!);
                      //   _dataGridController = DataGridController();
                      // });
                      return SfDataGridTheme(
                          data: SfDataGridThemeData(
                              gridLineColor: blue,
                              gridLineStrokeWidth: 2,
                              frozenPaneLineColor: blue,
                              frozenPaneLineWidth: 2),
                          child: SfDataGrid(
                              source: _dailyDataSource,
                              allowEditing: true,
                              frozenColumnsCount: 2,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
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
                                  //autoFit//Padding: tablepadding,
                                  allowEditing: true,
                                  width: 70,
                                  label: Container(
                                    //Padding: tablepadding,
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
                                  //autoFit//Padding: tablepadding,
                                  allowEditing: true,
                                  width: 70,
                                  label: Container(
                                    //Padding: tablepadding,
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
                                  //autoFit//Padding: tablepadding,
                                  allowEditing: true,
                                  width: 200,
                                  label: Container(
                                    // //Padding: tablepadding,
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
                                  //autoFit//Padding: tablepadding,
                                  allowEditing: true,
                                  width: 220,
                                  label: Container(
                                    //Padding: tablepadding,
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
                                  //autoFit//Padding: tablepadding,
                                  allowEditing: true,
                                  width: 300,
                                  label: Container(
                                    //Padding: tablepadding,
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
                                  //autoFit//Padding: tablepadding,
                                  allowEditing: true,
                                  width: 280,
                                  label: Container(
                                    //Padding: tablepadding,
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
                                  //autoFit//Padding: tablepadding,
                                  allowEditing: false,
                                  width: 150,
                                  label: Container(
                                    //Padding: tablepadding,
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
                                  //autoFit//Padding: tablepadding,
                                  allowEditing: false,
                                  width: 120,
                                  label: Container(
                                    //Padding: tablepadding,
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
                                  //autoFit//Padding: tablepadding,
                                  allowEditing: false,
                                  width: 120,
                                  label: Container(
                                    //Padding: tablepadding,
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
                                  //autoFit//Padding: tablepadding,
                                  allowEditing: false,
                                  width: 120,
                                  label: Container(
                                    //Padding: tablepadding,
                                    alignment: Alignment.center,
                                    child: Text('Delete Row',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor
                                        //    textAlign: TextAlign.center,
                                        ),
                                  ),
                                ),
                              ]));
                    }
                  },
                ),
              )
            ]),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (() {
            dailyproject.add(DailyProjectModel(
                siNo: _dailyDataSource.rows.length + 1,
                // date: DateFormat().add_yMd(storeData()).format(DateTime.now()),
                // state: "Maharashtra",
                // depotName: 'depotName',
                typeOfActivity: '',
                activityDetails: "",
                progress: '',
                status: ''));
            print(_dailyDataSource.rows.length + 1);
            _dataGridController = DataGridController();

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
        .collection('DailyProject3')
        .doc('${widget.depoName}')
        .collection(selectedDate.toString())
        .doc(userId)
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

  void chooseDate(BuildContext dialogueContext) {
    showDialog(
        context: dialogueContext,
        builder: (dialogueContext) => AlertDialog(
              title: const Text('All Date'),
              content: SizedBox(
                  height: MediaQuery.of(dialogueContext).size.height * 0.8,
                  width: MediaQuery.of(dialogueContext).size.width * 0.8,
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
                      // print(showDate);
                      Navigator.pop(context);
                      setState(() {
                        checkTable = true;
                        dailyproject.clear();
                        getTableData().whenComplete(() {
                          _stream = FirebaseFirestore.instance
                              .collection('DailyProject3')
                              .doc('${widget.depoName}')
                              .collection(selectedDate.toString())
                              .doc(userId)
                              .snapshots();
                          _dailyDataSource = DailyDataSource(
                              dailyproject,
                              context,
                              widget.cityName!,
                              widget.depoName!,
                              userId,
                              selectedDate!);
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

  Future<void> getTableData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('DailyProject3')
        .doc('${widget.depoName}')
        .collection(selectedDate.toString())
        .doc(userId)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> tempData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapData = tempData['data'];

      dailyproject =
          mapData.map((map) => DailyProjectModel.fromjson(map)).toList();
      checkTable = false;
    }

    isLoading = false;
    setState(() {});
  }
}
