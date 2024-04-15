import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/models/daily_projectModel.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:ev_pmis_app/views/citiespage/depot.dart';
import 'package:ev_pmis_app/views/dailyreport/summary.dart';
import 'package:ev_pmis_app/widgets/progress_loading.dart';
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

class DailyProject extends StatefulWidget {
  String? cityName;
  String? depoName;
  String role;
  String? userId;

  DailyProject(
      {super.key,
      this.cityName,
      required this.depoName,
      required this.role,
      this.userId});

  @override
  State<DailyProject> createState() => _DailyProjectState();
}

class _DailyProjectState extends State<DailyProject> {
  final AuthService authService = AuthService();
  List<String> assignedDepots = [];
  bool isFieldEditable = false;
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
    getAssignedDepots();
    getTableData().whenComplete(
      () {
        _dailyDataSource = DailyDataSource(dailyproject, context,
            widget.cityName!, widget.depoName!, userId, selectedDate!);
        _dataGridController = DataGridController();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavbarDrawer(
        role: widget.role,
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppBarBackDate(
          depoName: widget.depoName ?? '',
          text: 'Daily Report',
          haveSynced: isFieldEditable ? true : false,
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
                  currentDate: selectedDate,
                  userId: userId,
                ),
              )),
          store: () async {
            showProgressDilogue(context);
            FirebaseApi().nestedKeyEventsField(
                'DailyProject3', widget.depoName!, 'userId', userId);
            storeData();
          },
          showDate: visDate,
          choosedate: () {
            chooseDate(context);
          },
        ),
      ),
      body: isLoading
          ? const LoadingPage()
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('DailyProject3')
                  .doc('${widget.depoName}')
                  .collection(selectedDate!)
                  .doc(userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.exists == false) {
                  dailyproject.clear();
                  _dailyDataSource.buildDataGridRows();
                  _dailyDataSource.updateDatagridSource();
                  return SfDataGridTheme(
                    data: SfDataGridThemeData(
                        gridLineColor: blue,
                        gridLineStrokeWidth: 2,
                        frozenPaneLineColor: blue,
                        frozenPaneLineWidth: 2),
                    child: SfDataGrid(
                        source: _dailyDataSource,
                        allowEditing: isFieldEditable,
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
                            allowEditing: false,
                            width: 100,
                            label: Container(
                              //Padding: tablepadding,
                              alignment: Alignment.center,
                              child: Text(
                                'Upload Image',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'view',
                            allowEditing: false,
                            width: 100,
                            label: Container(
                              //Padding: tablepadding,
                              alignment: Alignment.center,
                              child: Text(
                                'View Image',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Add',
                            allowEditing: false,
                            width: 70,
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
                  alldata = '';
                  alldata = snapshot.data!['data'] as List<dynamic>;
                  dailyproject.clear();
                  alldata.forEach((element) {
                    dailyproject.add(DailyProjectModel.fromjson(element));
                    _dailyDataSource = DailyDataSource(
                        dailyproject,
                        context,
                        widget.cityName!,
                        widget.depoName!,
                        userId,
                        selectedDate!);
                  });
                  _dataGridController = DataGridController();
                  _dailyDataSource.buildDataGridRows();
                  _dailyDataSource.updateDatagridSource();
                  return SfDataGridTheme(
                    data: SfDataGridThemeData(
                        gridLineColor: blue,
                        gridLineStrokeWidth: 2,
                        frozenPaneLineColor: blue,
                        frozenPaneLineWidth: 2),
                    child: SfDataGrid(
                        source: _dailyDataSource,
                        allowEditing: isFieldEditable,
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
                            width: 100,
                            label: Container(
                              //Padding: tablepadding,
                              alignment: Alignment.center,
                              child: Text(
                                'Upload Image',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'view',
                            //autoFit//Padding: tablepadding,
                            allowEditing: false,
                            width: 80,
                            label: Container(
                              //Padding: tablepadding,
                              alignment: Alignment.center,
                              child: Text(
                                'view Image',
                                overflow: TextOverflow.values.first,
                                style: tableheaderwhitecolor,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Add',
                            //autoFit//Padding: tablepadding,
                            allowEditing: false,
                            width: 70,
                            label: Container(
                              //Padding: tablepadding,
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
                }
              },
            ),
      floatingActionButton: isFieldEditable
          ? FloatingActionButton(
              onPressed: (() {
                dailyproject.add(DailyProjectModel(
                    siNo: _dailyDataSource.rows.length + 1,
                    typeOfActivity: '',
                    activityDetails: "",
                    progress: '',
                    status: ''));
                _dataGridController = DataGridController();
                _dailyDataSource.buildDataGridRows();
                _dailyDataSource.updateDatagridSource();
              }),
              child: const Icon(
                Icons.add,
              ),
            )
          : Container(),
    );
  }

  Future storeData() async {
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
        .collection(selectedDate!)
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

  void chooseDate(BuildContext dialogueContext) {
    showDialog(
        context: dialogueContext,
        builder: (dialogueContext) => AlertDialog(
              // title: const Text('All Date'),
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
                        // getTableData().whenComplete(() {
                        // _stream = FirebaseFirestore.instance
                        //     .collection('DailyProject3')
                        //     .doc('${widget.depoName}')
                        //     .collection(selectedDate!)
                        //     .doc(userId)
                        //     .snapshots();
                        // _dailyDataSource = DailyDataSource(
                        //     dailyproject,
                        //     context,
                        //     widget.cityName!,
                        //     widget.depoName!,
                        //     userId,
                        //     selectedDate!);
                        // _dataGridController = DataGridController();
                        // _dailyDataSource.buildDataGridRows();
                        // _dailyDataSource.updateDatagridSource();
                      });
                      //  });
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
        .collection(selectedDate!)
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

  Future getAssignedDepots() async {
    assignedDepots = await authService.getDepotList();
    isFieldEditable =
        authService.verifyAssignedDepot(widget.depoName!, assignedDepots);
  }
}
