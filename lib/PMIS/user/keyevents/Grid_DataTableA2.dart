import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/PMIS/common_screen/citiespage/depot.dart';
import 'package:ev_pmis_app/PMIS/user/datasource/employee_datasource.dart';
import 'package:ev_pmis_app/PMIS/user/keyevents/key_events2.dart';

import 'package:flutter/material.dart';
import 'package:gantt_chart/gantt_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../FirebaseApi/firebase_api.dart';
import '../../models/employee.dart';
import '../../authentication/authservice.dart';
import '../../../components/Loading_page.dart';
import '../../provider/cities_provider.dart';
import '../../../style.dart';
import '../../widgets/custom_appbar.dart';
import '../screen/safetyfield.dart';

/// The application that contains datagrid on it.

/// The home page of the application which hosts the datagrid.
class StatutoryAprovalA2 extends StatefulWidget {
  /// Creates the home page.
  // String? userid;
  String? events;
  String? depoName;
  // String? cityName;

  StatutoryAprovalA2({Key? key, required this.events, required this.depoName})
      : super(key: key);

  @override
  _StatutoryAprovalA2State createState() => _StatutoryAprovalA2State();
}

class _StatutoryAprovalA2State extends State<StatutoryAprovalA2> {
  late EmployeeDataSource _employeeDataSource;
  List<Employee> _employees = <Employee>[];
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  List<dynamic> weightage = [];
  var alldata;
  bool _isLoading = false;
  bool _isInit = true;
  List<double> weight = [];
  List<int> yAxis = [];
  List<String> startDate = [];
  List<String> endDate = [];
  List<String> actualstart = [];
  List<String> actualend = [];
  List<int> srNo = [];
  List<ChartData> chartData = [];
  List<GanttEventBase> ganttdata = [];

  Stream? _stream;
  bool specificUser = true;
  QuerySnapshot? snap;
  dynamic companyId;
  int? num_id;
  List docss = [];
  final scrollController = ScrollController();

  @override
  void initState() {
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;

    getUserId();
    identifyUser();
    _stream = FirebaseFirestore.instance
        .collection('KeyEventsTable')
        .doc(widget.depoName!)
        .collection('KeyDataTable')
        .doc(userId)
        .collection('KeyAllEvents')
        .doc('${widget.depoName}${widget.events}')
        .snapshots();

    // _employeeDataSource = EmployeeDataSource(
    //     _employees, context, widget.userid!, cityName, widget.depoName);
    // _dataGridController = DataGridController();
    // getFirestoreData().whenComplete(() {
    //   if (_employees.length == 0 || _employees.isEmpty) {
    //     _employees = getEmployeeData();
    //   }
    //   _isLoading = false;
    //   _employeeDataSource = EmployeeDataSource(_employees, context,
    //       widget.userid!, cityName, widget.depoName);
    //   _dataGridController = DataGridController();
    // });

    // FirebaseApi.getAllId().then((value) {
    //   num_id = dataList.length;
    // _employeeDataSource = EmployeeDataSource(
    //     _employees, context, cityName, widget.depoName);
    // _dataGridController = DataGridController();

    // getTableData().whenComplete(() {
    //   nestedTableData(docss).whenComplete(() {
    //     print('object');
    //     _employeeDataSource = EmployeeDataSource(
    //         _employees, context, cityName, widget.depoName);
    //     _dataGridController = DataGridController();
    //   });
    // });

    super.initState();

    // });
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     getFirestoreData().whenComplete(() {
  //       setState(() {
  //         loadchartdata();
  //         if (_employees.length == 0 || _employees.isEmpty) {
  //           _employees = getEmployeeData();
  //         }
  //         _isLoading = false;
  //         _employeeDataSource = EmployeeDataSource(_employees, context);
  //         _dataGridController = DataGridController();
  //       });
  //       // _employeeDataSource = EmployeeDataSource(_employees);
  //       // _dataGridController = DataGridController();
  //     });
  //     //getFirestoreData() as List<Employee>;
  //     // getEmployeeData();

  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: CustomAppBar(
          depoName: widget.depoName ?? '',
          title: 'Key Events /${widget.depoName!}/${widget.events}',
          isSync: specificUser ? true : false,
          isCentered: true,
          height: 50,
          store: () {
            FirebaseApi()
                .defaultKeyEventsField('KeyEventsTable', widget.depoName!);
            FirebaseApi().nestedKeyEventsField(
              'KeyEventsTable',
              widget.depoName!,
              'KeyDataTable',
              userId,
            );
            storeData();
          },
        ),
        preferredSize: const Size.fromHeight(50),
      ),
      body: _isLoading
          ? LoadingPage()
          : StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                chartData = [];
                ganttdata = [];
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingPage();
                }
                if (!snapshot.hasData || snapshot.data.exists == false) {
                  _employees = getEmployeeData();
                  _employeeDataSource = EmployeeDataSource(
                      _employees, context, userId, cityName, widget.depoName);
                  _dataGridController = DataGridController();

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: _employees.length * 66,
                          child: Row(
                            children: [
                              Expanded(
                                child: SfDataGrid(
                                  source: _employeeDataSource,
                                  allowEditing: true,
                                  frozenColumnsCount: 2,
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
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                      allowEditing: true,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Sr No',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.values.first,
                                          style: tableheader,
                                          //    textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Activity',
                                      width: 100,
                                      allowEditing: true,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Activity',
                                          overflow: TextOverflow.values.first,
                                          style: tableheader,
                                        ),
                                      ),
                                    ),
                                    // GridColumn(
                                    //   columnName: 'viewbutton',
                                    //   width: 130,
                                    //   allowEditing: false,
                                    //   label: Container(
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     alignment: Alignment.center,
                                    //     child: const Text('View File ',
                                    //         style: TextStyle(
                                    //             fontWeight: FontWeight.bold,
                                    //             fontSize: 16)),
                                    //   ),
                                    // ),
                                    // GridColumn(
                                    //   columnName: 'uploadbutton',
                                    //   width: 130,
                                    //   allowEditing: false,
                                    //   label: Container(
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     alignment: Alignment.center,
                                    //     child: const Text('View File ',
                                    //         style: TextStyle(
                                    //             fontWeight: FontWeight.bold,
                                    //             fontSize: 16)),
                                    //   ),
                                    // ),
                                    GridColumn(
                                      columnName: 'OriginalDuration',
                                      allowEditing: true,
                                      width: 80,
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Original Duration',
                                            overflow: TextOverflow.values.first,
                                            textAlign: TextAlign.center,
                                            style: tableheader),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'StartDate',
                                      allowEditing: false,
                                      width: 85,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Start Date',
                                            overflow: TextOverflow.values.first,
                                            style: tableheader),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'EndDate',
                                      allowEditing: false,
                                      width: 85,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text('End Date',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: tableheader),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ActualStart',
                                      allowEditing: false,
                                      width: 140,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        alignment: Alignment.center,
                                        child: Text('Actual Start',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: tableheader),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ActualEnd',
                                      allowEditing: false,
                                      width: 85,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        alignment: Alignment.center,
                                        child: Text('Actual End',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: tableheader),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ActualDuration',
                                      width: 80,
                                      allowEditing: true,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Actual Duration',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: tableheader),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Delay',
                                      allowEditing: true,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Delay',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: tableheader),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'ReasonDelay',
                                      allowEditing: true,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Reason For Delay',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: tableheader),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Unit',
                                      allowEditing: true,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Unit',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: tableheader),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'QtyScope',
                                      allowEditing: true,
                                      width: 80,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Oty as per scope',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: tableheader),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'QtyExecuted',
                                      allowEditing: true,
                                      width: 80,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Qty executed',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: tableheader),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'BalancedQty',
                                      allowEditing: false,
                                      label: Container(
                                        width: 80,
                                        alignment: Alignment.center,
                                        child: Text('Balanced Qty',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: tableheader),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Progress',
                                      allowEditing: false,
                                      width: 80,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('% of Progress',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: tableheader),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'Weightage',
                                      allowEditing: true,
                                      label: Container(
                                        alignment: Alignment.center,
                                        child: Text('Weightage',
                                            overflow: TextOverflow.values.first,
                                            style: tableheader),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  width: 300,
                                  child: GanttChartView(
                                      scrollController: scrollController,
                                      scrollPhysics:
                                          const BouncingScrollPhysics(),
                                      maxDuration: null,
                                      // const Duration(days: 30 * 2),
                                      // optional, set to null for infinite horizontal scroll
                                      startDate:
                                          DateTime(2023, 8, 1), //required
                                      dayWidth: 40, //column width for each day
                                      dayHeaderHeight: 35,
                                      eventHeight: 45, //row height for events

                                      stickyAreaWidth: 80, //sticky area width
                                      showStickyArea:
                                          true, //show sticky area or not
                                      showDays: true, //show days or not
                                      startOfTheWeek: WeekDay
                                          .monday, //custom start of the week
                                      weekHeaderHeight: 30,
                                      weekEnds: const {
                                        // WeekDay.saturday,
                                        // WeekDay.sunday
                                      }, //custom weekends
                                      isExtraHoliday: (context, day) {
                                        //define custom holiday logic for each day
                                        return DateUtils.isSameDay(
                                            DateTime(2023, 7, 1), day);
                                      },
                                      events: ganttdata
                                      //  [
                                      //   //event relative to startDate
                                      //   // GanttRelativeEvent(
                                      //   //   relativeToStart:
                                      //   //       const Duration(days: 0),
                                      //   //   duration: const Duration(days: 5),
                                      //   //   displayName: '1',
                                      //   // ),
                                      //   //event with absolute start and end
                                      //   GanttAbsoluteEvent(
                                      //     startDate: DateTime(2022, 6, 10),
                                      //     endDate: DateTime(2022, 6, 16),
                                      //     displayName: '2',
                                      //   ),
                                      //   GanttAbsoluteEvent(
                                      //     startDate: DateTime(2022, 6, 10),
                                      //     endDate: DateTime(2022, 7, 25),
                                      //     displayName: '3',
                                      //   ),
                                      // ],
                                      ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  alldata = '';
                  alldata = snapshot.data['data'] as List<dynamic>;
                  _employees.clear();
                  // ganttdata.clear();
                  weight.clear();
                  startDate.clear();
                  endDate.clear();
                  actualstart.clear();
                  actualend.clear();
                  yAxis.clear();

                  alldata.forEach((element) {
                    _employees.add(Employee.fromJson(element));
                    _employeeDataSource = EmployeeDataSource(_employees,
                        context, userId!, cityName!, widget.depoName);
                    _dataGridController = DataGridController();
                  });
                  for (int i = 0; i < alldata.length; i++) {
                    var weightdata = alldata[i]['Weightage'];
                    var yaxisdata = alldata[i]['srNo'];
                    var Start = alldata[i]['StartDate'];
                    var End = alldata[i]['EndDate'];
                    var actualStart = alldata[i]['ActualStart'];
                    var actualEnd = alldata[i]['ActualEnd'];

                    weight.add(weightdata);
                    yAxis.add(yaxisdata);
                    startDate.add(Start);
                    endDate.add(End);
                    actualstart.add(actualStart);
                    actualend.add(actualEnd);
                  }
                  for (int i = 0; i <= weight.length - 1; i++) {
                    chartData.add(ChartData(
                        yAxis[i].toString(), weight[i], Colors.green));

                    ganttdata.add(GanttAbsoluteEvent(
                      displayNameBuilder: (context) {
                        return yAxis[i].toString();
                      },
                      startDate: DateFormat('dd-MM-yyyy').parse(startDate[i]),
                      endDate: DateFormat('dd-MM-yyyy').parse(endDate[i]),
                      //displayName: yAxis[i].toString()
                    ));

                    ganttdata.add(GanttAbsoluteEvent(
                      displayNameBuilder: (context) {
                        return '';
                      },
                      startDate: DateFormat('dd-MM-yyyy').parse(actualstart[i]),
                      endDate: DateFormat('dd-MM-yyyy').parse(actualend[i]),
                      //displayName: yAxis[i].toString()
                    ));
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: SfDataGrid(
                          source: _employeeDataSource,
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
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              allowEditing: true,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Sr No',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.values.first,
                                  style: tableheader,
                                  //    textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Activity',
                              width: 100,
                              allowEditing: true,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Activity',
                                  overflow: TextOverflow.values.first,
                                  style: tableheader,
                                ),
                              ),
                            ),
                            // GridColumn(
                            //   columnName: 'viewbutton',
                            //   width: 130,
                            //   allowEditing: false,
                            //   label: Container(
                            //     padding: const EdgeInsets.all(8.0),
                            //     alignment: Alignment.center,
                            //     child: const Text('View File ',
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 16)),
                            //   ),
                            // ),
                            // GridColumn(
                            //   columnName: 'uploadbutton',
                            //   width: 130,
                            //   allowEditing: false,
                            //   label: Container(
                            //     padding: const EdgeInsets.all(8.0),
                            //     alignment: Alignment.center,
                            //     child: const Text('View File ',
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 16)),
                            //   ),
                            // ),
                            GridColumn(
                              columnName: 'OriginalDuration',
                              allowEditing: true,
                              width: 80,
                              autoFitPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Original Duration',
                                    overflow: TextOverflow.values.first,
                                    textAlign: TextAlign.center,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'StartDate',
                              allowEditing: false,
                              width: 85,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Start Date',
                                    overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'EndDate',
                              allowEditing: false,
                              width: 85,
                              label: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                alignment: Alignment.center,
                                child: Text('End Date',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ActualStart',
                              allowEditing: false,
                              width: 140,
                              label: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                alignment: Alignment.center,
                                child: Text('Actual Start',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ActualEnd',
                              allowEditing: false,
                              width: 85,
                              label: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                alignment: Alignment.center,
                                child: Text('Actual End',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ActualDuration',
                              width: 80,
                              allowEditing: true,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Actual Duration',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Delay',
                              allowEditing: true,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Delay',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ReasonDelay',
                              allowEditing: true,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Reason For Delay',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Unit',
                              allowEditing: true,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Unit',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'QtyScope',
                              allowEditing: true,
                              width: 80,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Oty as per scope',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'QtyExecuted',
                              allowEditing: true,
                              width: 80,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Qty executed',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'BalancedQty',
                              allowEditing: false,
                              label: Container(
                                width: 80,
                                alignment: Alignment.center,
                                child: Text('Balanced Qty',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Progress',
                              allowEditing: false,
                              width: 80,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('% of Progress',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Weightage',
                              allowEditing: true,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Weightage',
                                    overflow: TextOverflow.values.first,
                                    style: tableheader),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                          width: 300,
                          height: _employees.length * 75,
                          child: SingleChildScrollView(
                            child: GanttChartView(
                                scrollController: scrollController,
                                scrollPhysics: const BouncingScrollPhysics(),
                                maxDuration: null,
                                // const Duration(days: 30 * 2),
                                // optional, set to null for infinite horizontal scroll
                                startDate: DateTime(2023, 8, 1), //required
                                dayWidth: 40, //column width for each day
                                dayHeaderHeight: 35,
                                eventHeight: 25, //row height for events

                                stickyAreaWidth: 80, //sticky area width
                                showStickyArea: true, //show sticky area or not
                                showDays: true, //show days or not
                                startOfTheWeek:
                                    WeekDay.monday, //custom start of the week
                                weekHeaderHeight: 30,
                                weekEnds: const {
                                  // WeekDay.saturday,
                                  // WeekDay.sunday
                                }, //custom weekends
                                isExtraHoliday: (context, day) {
                                  //define custom holiday logic for each day
                                  return DateUtils.isSameDay(
                                      DateTime(2023, 7, 1), day);
                                },
                                events: ganttdata
                                //  [
                                //   //event relative to startDate
                                //   // GanttRelativeEvent(
                                //   //   relativeToStart:
                                //   //       const Duration(days: 0),
                                //   //   duration: const Duration(days: 5),
                                //   //   displayName: '1',
                                //   // ),
                                //   //event with absolute start and end
                                //   GanttAbsoluteEvent(
                                //     startDate: DateTime(2022, 6, 10),
                                //     endDate: DateTime(2022, 6, 16),
                                //     displayName: '2',
                                //   ),
                                //   GanttAbsoluteEvent(
                                //     startDate: DateTime(2022, 6, 10),
                                //     endDate: DateTime(2022, 7, 25),
                                //     displayName: '3',
                                //   ),
                                // ],
                                ),
                          ))
                    ],
                  );
                }
              }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (() {
            _employees.add(
              Employee(
                srNo: 1,
                activity: '',
                originalDuration: 1,
                startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                actualstartDate:
                    DateFormat('dd-MM-yyyy').format(DateTime.now()),
                actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                actualDuration: 0,
                delay: 0,
                // // reasonDelay: '',
                unit: 0,
                scope: 0,
                qtyExecuted: 0,
                balanceQty: 0,
                percProgress: 0,
                weightage: 0.5,
              ),
            );
            _employeeDataSource.buildDataGridRows();
            _employeeDataSource.updateDatagridSource();
          })),
    );
  }

  Future<void> getFirestoreData() async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    CollectionReference tabledata = instance.collection('KeyEventsTable');

    DocumentSnapshot snapshot = await tabledata
        .doc(widget.depoName!)
        .collection('KeyDataTable')
        .doc(userId)
        .collection('KeyAllEvents')
        .doc('${widget.depoName}A2')
        .get();
    var data = snapshot.data() as Map;
    alldata = data['data'] as List<dynamic>;

    // _employees = [];
    alldata.forEach((element) {
      _employees.add(Employee.fromJson(element));
    });

    // for (int i = 0; i < alldata.length; i++) {
    //   var weightdata = alldata[i]['Weightage'];
    //   var yaxisdata = alldata[i]['srNo'];
    //   weight.add(weightdata);
    //   yAxis.add(yaxisdata);
    // }
  }

  // void loadchartdata() {
  //   for (int i = 0; i < weight.length; i++) {
  //     chartData.add(ChartData(yAxis[i].toString(), weight[i], Colors.green));
  //   }
  // }

  List<Employee> getEmployeeData() {
    return [
      Employee(
        srNo: 1,
        activity: 'Initial Survey Of Depot With TML & STA Team.',
        originalDuration: 1,
        startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        actualDuration: 0,
        delay: 0,
        // reasonDelay: '',
        unit: 0,
        scope: 0,
        qtyExecuted: 0,
        balanceQty: 0,
        percProgress: 0,
        weightage: 0.5,
      ),
      Employee(
          srNo: 2,
          activity: 'Details Survey Of Depot With TPC Civil & Electrical Team',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          // reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 1.0),
      Employee(
          srNo: 3,
          activity:
              'Survey Report Submission With Existing & Proposed Layout Drawings.',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          // reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0.3),
      Employee(
          srNo: 4,
          activity: 'Job Scope Finalization & Preparation Of BOQ',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          // reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0.5),
      Employee(
          srNo: 5,
          activity: 'Power Connection / Load Applied By STA To Discom.',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          // reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0.3)
    ];
  }

  void storeData() {
    Map<String, dynamic> table_data = Map();
    for (var i in _employeeDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'viewbutton' &&
            data.columnName != 'uploadbutton') {
          table_data[data.columnName] = data.value;
        }
      }

      tabledata2.add(table_data);
      print(tabledata2);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('KeyEventsTable')
        .doc(widget.depoName!)
        .collection('KeyDataTable')
        .doc(userId)
        .collection('KeyAllEvents')
        .doc('${widget.depoName}A2')
        // .collection(widget.userid!)
        // .doc('${widget.depoName}A2')
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      tabledata2.clear();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      companyId = value;
    });
  }

  identifyUser() async {
    snap = await FirebaseFirestore.instance.collection('Admin').get();

    if (snap!.docs[0]['Employee Id'] == companyId &&
        snap!.docs[0]['CompanyName'] == 'TATA MOTOR') {
      setState(() {
        specificUser = false;
      });
    }
  }

  Future getTableData() async {
    await FirebaseFirestore.instance
        .collection('KeyEventsTable')
        .doc(widget.depoName!)
        .collection('KeyDataTable')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        String documentId = element.id;
        print('Document ID: $documentId');
        docss.add(documentId);
        // nestedTableData(docss);
      });
    });
  }

  Future<void> nestedTableData(docss) async {
    for (int i = 0; i < docss.length; i++) {
      await FirebaseFirestore.instance
          .collection('KeyEventsTable')
          .doc(widget.depoName!)
          .collection('KeyDataTable')
          .doc(docss[i])
          .collection('KeyAllEvents')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          print('after');
          if (element.id == '${widget.depoName}A2') {
            for (int i = 0; i < element.data()['data'].length; i++) {
              _employees.add(Employee.fromJson(element.data()['data'][i]));
              print(_employees);
            }
          }
        });
      });
    }
    setState(() {
      _isLoading = false;
    });
  }
}
