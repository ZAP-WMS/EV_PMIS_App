import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:ev_pmis_app/views/citiespage/depot.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:ev_pmis_app/widgets/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../FirebaseApi/firebase_api.dart';
import '../../components/Loading_page.dart';
import '../../datasource/monthlyproject_datasource.dart';
import '../../provider/cities_provider.dart';
import '../../style.dart';
import '../../models/monthly_projectModel.dart';
import '../../widgets/appbar_back_date.dart';

import '../dailyreport/summary.dart';

class MonthlyProject extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? userId;
  String? role;

  MonthlyProject(
      {super.key,
      this.cityName,
      required this.depoName,
      this.role,
      this.userId});

  @override
  State<MonthlyProject> createState() => _MonthlyProjectState();
}

class _MonthlyProjectState extends State<MonthlyProject> {
  final AuthService authService = AuthService();
  List<String> assignedCities = [];
  bool isFieldEditable = false;
  List<MonthlyProjectModel> monthlyProject = <MonthlyProjectModel>[];
  late MonthlyDataSource monthlyDataSource;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  bool checkTable = true;
  bool isLoading = true;
  Stream? _stream;
  dynamic alldata;
  String title = 'Monthly Project';

  @override
  void initState() {
    getAssignedDepots().whenComplete(() {
      widget.cityName =
          Provider.of<CitiesProvider>(context, listen: false).getName;

      _stream = FirebaseFirestore.instance
          .collection('MonthlyProjectReport2')
          .doc('${widget.depoName}')
          .collection('userId')
          .doc(userId)
          .collection('Monthly Data')
          .doc(DateFormat.yMMM().format(DateTime.now()))
          .snapshots();

      monthlyDataSource = MonthlyDataSource(monthlyProject, context);
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
      drawer:  NavbarDrawer(role: widget.role,),
      appBar: PreferredSize(
          // ignore: sort_child_properties_last
          child: CustomAppBarBackDate(
            depoName: widget.depoName,
            text: 'Monthly Report/${DateFormat('MMMM').format(DateTime.now())}',

            //  ${DateFormat.yMMMMd().format(DateTime.now())}',
            haveCalender: false,
            haveSynced: isFieldEditable ? true : false,
            haveSummary: true,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewSummary(
                    cityName: widget.cityName.toString(),
                    depoName: widget.depoName.toString(),
                    id: 'Monthly Report',
                    userId: userId,
                  ),
                )),
            store: () {
              showProgressDilogue(context);
              FirebaseApi().nestedKeyEventsField(
                  'MonthlyProjectReport2', widget.depoName!, 'userId', userId);
              storeData();
            },
          ),
          preferredSize: const Size.fromHeight(50)),
      body: isLoading
          ? const LoadingPage()
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LoadingPage();
                        } else if (!snapshot.hasData ||
                            snapshot.data.exists == false) {
                          monthlyProject = getmonthlyReport();
                          monthlyDataSource =
                              MonthlyDataSource(monthlyProject, context);
                          _dataGridController = DataGridController();

                          return SfDataGridTheme(
                            data: SfDataGridThemeData(
                                headerColor: white,
                                gridLineColor: blue,
                                gridLineStrokeWidth: 2),
                            child: SfDataGrid(
                                source: monthlyDataSource,
                                allowEditing: isFieldEditable,
                                frozenColumnsCount: 1,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                selectionMode: SelectionMode.single,
                                navigationMode: GridNavigationMode.cell,
                                columnWidthMode: ColumnWidthMode.fill,
                                editingGestureType: EditingGestureType.tap,
                                controller: _dataGridController,
                                onQueryRowHeight: (details) {
                                  return details
                                      .getIntrinsicRowHeight(details.rowIndex);
                                },
                                columns: [
                                  GridColumn(
                                    columnName: 'ActivityNo',
                                    allowEditing: false,
                                    width: 65,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text("Sr No.",
                                          // 'Activities SI. No as per Gant Chart',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: tableheaderwhitecolor
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'ActivityDetails',
                                    allowEditing: false,
                                    width: 250,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Activities Details',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Progress',
                                    allowEditing: true,
                                    width: 150,
                                    label: Container(
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
                                    width: 150,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Remark/Status',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Action',
                                    allowEditing: true,
                                    width: 150,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Next Month Action Plan',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                ]),
                          );
                        } else {
                          alldata = snapshot.data['data'] as List<dynamic>;
                          monthlyProject.clear();
                          alldata.forEach((element) {
                            monthlyProject
                                .add(MonthlyProjectModel.fromjson(element));
                            monthlyDataSource =
                                MonthlyDataSource(monthlyProject, context);
                            _dataGridController = DataGridController();
                          });
                          return SfDataGridTheme(
                            data: SfDataGridThemeData(
                                headerColor: white,
                                gridLineColor: blue,
                                gridLineStrokeWidth: 2),
                            child: SfDataGrid(
                                source: monthlyDataSource,
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
                                columns: [
                                  GridColumn(
                                    columnName: 'ActivityNo',
                                    allowEditing: false,
                                    width: 65,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text("Sr No.",
                                          // 'Activities SI. No as per Gant Chart',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: tableheaderwhitecolor
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'ActivityDetails',
                                    allowEditing: false,
                                    width: 250,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Activities Details',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Progress',
                                    allowEditing: true,
                                    width: 150,
                                    label: Container(
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
                                    width: 150,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Remark/Status',
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Action',
                                    allowEditing: true,
                                    width: 150,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Next Month Action Plan',
                                        overflow: TextOverflow.values.first,
                                        style: tableheaderwhitecolor,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ]),
                          );
                        }
                      }),
                ),
              ],
            ),
    );
  }

  void storeData() {
    Map<String, dynamic> table_data = Map();
    for (var i in monthlyDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button') {
          table_data[data.columnName] = data.value;
        }
        table_data['User ID'] = userId;
      }

      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('MonthlyProjectReport2')
        .doc('${widget.depoName}')
        // .collection('AllMonthData')
        .collection('userId')
        .doc(userId)
        .collection('Monthly Data')
        // .collection('MonthData')
        .doc(DateFormat.yMMM().format(DateTime.now()))
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

  List<MonthlyProjectModel> getmonthlyReport() {
    return [
      MonthlyProjectModel(
          activityNo: 'A1',
          activityDetails: 'Letter of Award From TML',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A2',
          activityDetails:
              'Site Survey, Job scope finalization  and Proposed layout submission',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A3',
          activityDetails:
              'Detailed Engineering for Approval of  Civil & Electrical  Layout, GA Drawing from TML',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A4',
          activityDetails: 'Site Mobalization activity Completed',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A5',
          activityDetails: 'Approval of statutory clearances of BUS Depot',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A6',
          activityDetails: 'Procurement of Order Finalisation Completed',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A7',
          activityDetails: 'Receipt of all Materials at Site',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A8',
          activityDetails: 'Civil Infra Development completed at Bus Depot',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A9',
          activityDetails:
              'Electrical Infra Development completed at Bus Depot',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A10',
          activityDetails: 'Bus Depot work Completed & Handover to TML',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
    ];
  }


  Future<void> getTableData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('MonthlyProjectReport2')
        .doc('${widget.depoName}')
        .collection('userId')
        .doc(userId)
        .collection('Monthly Data')
        .doc(DateFormat.yMMM().format(DateTime.now()))
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> tempData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapData = tempData['data'];

      monthlyProject =
          mapData.map((map) => MonthlyProjectModel.fromjson(map)).toList();
      checkTable = false;
    }

    isLoading = false;
    setState(() {});
  }

  Future getAssignedDepots() async {
    assignedCities = await authService.getCityList();
    isFieldEditable =
        authService.verifyAssignedDepot(
          widget.cityName!, assignedCities,
        );
  }
  
}
