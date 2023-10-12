import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../FirebaseApi/firebase_api.dart';
import '../../components/Loading_page.dart';
import '../../datasource/monthlyproject_datasource.dart';
import '../../model/monthly_projectModel.dart';
import '../../provider/cities_provider.dart';
import '../../style.dart';
import '../../widgets/appbar_back_date.dart';

import '../dailyreport/summary.dart';
import '../homepage/gallery.dart';

class MonthlyProject extends StatefulWidget {
  String? cityName;
  String? depoName;

  MonthlyProject({super.key, this.cityName, required this.depoName});

  @override
  State<MonthlyProject> createState() => _MonthlyProjectState();
}

class _MonthlyProjectState extends State<MonthlyProject> {
  List<MonthlyProjectModel> monthlyProject = <MonthlyProjectModel>[];
  late MonthlyDataSource monthlyDataSource;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  dynamic alldata;
  bool _isloading = true;
  String title = 'Monthly Project';

  @override
  void initState() {
    // getUserId().whenComplete(() {
    widget.cityName =
        Provider.of<CitiesProvider>(context, listen: false).getName;
    _stream = FirebaseFirestore.instance
        .collection('MonthlyProjectReport2')
        .doc('${widget.depoName}')
        // .collection('AllMonthData')
        .collection('userId')
        .doc(userId)
        .collection('Monthly Data')
        // .collection('MonthData')
        .doc(DateFormat.yMMM().format(DateTime.now()))
        .snapshots();
    _isloading = false;
    setState(() {});
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavbarDrawer(),
      appBar: PreferredSize(
          // ignore: sort_child_properties_last
          child: CustomAppBarBackDate(
              text:
                  '${widget.depoName}/Monthly Report/${DateFormat('MMMM').format(DateTime.now())}',

              //  ${DateFormat.yMMMMd().format(DateTime.now())}',
              haveCalender: false,
              haveSynced: true,
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
                _showDialog(context);
                FirebaseApi().nestedKeyEventsField('MonthlyProjectReport2',
                    widget.depoName!, 'userId', userId!);
                storeData();
              },
              choosedate: () {
                // chooseDate(context);
              }),
          // CustomAppBar(
          //   title:
          //       ' ${widget.cityName}/ ${widget.depoName} / Monthly Report / ${DateFormat('MMMM').format(DateTime.now())}',
          //   isSync: true,
          //   height: 50,
          //   // onTap: () => Navigator.push(
          //   //     context,
          //   //     MaterialPageRoute(
          //   //       builder: (context) => ViewSummary(
          //   //         cityName: widget.cityName.toString(),
          //   //         depoName: widget.depoName.toString(),
          //   //         id: 'Monthly Report',
          //   //         userId: userId,
          //   //       ),
          //   //     )),
          //   // haveSynced: true,
          //   store: () {
          //     // _showDialog(context);
          //     // FirebaseApi().defaultKeyEventsField(
          //     //     'MonthlyProjectReport', widget.depoName!);
          //     FirebaseApi().nestedKeyEventsField(
          //         'MonthlyProjectReport2', widget.depoName!, 'userId', userId!);
          //     storeData();
          //   },
          // ),

          preferredSize: const Size.fromHeight(50)),
      body: _isloading
          ? LoadingPage()
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingPage();
                        } else if (!snapshot.hasData ||
                            snapshot.data.exists == false) {
                          monthlyProject = getmonthlyReport();
                          monthlyDataSource =
                              MonthlyDataSource(monthlyProject, context);
                          _dataGridController = DataGridController();

                          return SfDataGridTheme(
                            data: SfDataGridThemeData(headerColor: blue),
                            child: SfDataGrid(
                                source: monthlyDataSource,
                                allowEditing: true,
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
                                    autoFitPadding: tablepadding,
                                    allowEditing: false,
                                    width: 80,
                                    label: Container(
                                      padding: tablepadding,
                                      alignment: Alignment.center,
                                      child: Text(
                                          'Activities SI. No as per Gant Chart',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: tableheaderwhitecolor
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'ActivityDetails',
                                    autoFitPadding: tablepadding,
                                    allowEditing: false,
                                    width: 350,
                                    label: Container(
                                      padding: tablepadding,
                                      alignment: Alignment.center,
                                      child: Text('Activities Details',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),

                                  // GridColumn(
                                  //   columnName: 'Months',
                                  //   autoFitPadding:
                                  //       tablepadding,
                                  //   allowEditing: false,
                                  //   width: 200,
                                  //   label: Container(
                                  //     padding:
                                  //         tablepadding,
                                  //     alignment: Alignment.center,
                                  //     child: Text('Months',
                                  //         textAlign: TextAlign.center,
                                  //         overflow: TextOverflow.values.first,
                                  //         style: TextStyle(
                                  //             fontWeight: FontWeight.bold,
                                  //             fontSize: 16,
                                  //             color: white)),
                                  //   ),
                                  // ),
                                  // GridColumn(
                                  //   columnName: 'Duration',
                                  //   autoFitPadding:
                                  //       tablepadding,
                                  //   allowEditing: false,
                                  //   width: 120,
                                  //   label: Container(
                                  //     padding:
                                  //         tablepadding,
                                  //     alignment: Alignment.center,
                                  //     child: Text('Duration in Days',
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
                                  //   columnName: 'StartDate',
                                  //   autoFitPadding:
                                  //       tablepadding,
                                  //   allowEditing: false,
                                  //   width: 160,
                                  //   label: Container(
                                  //     padding:
                                  //         tablepadding,
                                  //     alignment: Alignment.center,
                                  //     child: Text('Start Date',
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
                                  //   columnName: 'EndDate',
                                  //   autoFitPadding:
                                  //       tablepadding,
                                  //   allowEditing: false,
                                  //   width: 120,
                                  //   label: Container(
                                  //     padding:
                                  //         tablepadding,
                                  //     alignment: Alignment.center,
                                  //     child: Text('End Date',
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
                                    columnName: 'Progress',
                                    autoFitPadding: tablepadding,
                                    allowEditing: true,
                                    width: 250,
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
                                    width: 250,
                                    label: Container(
                                      padding: tablepadding,
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
                                    autoFitPadding: tablepadding,
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      padding: tablepadding,
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
                            data: SfDataGridThemeData(headerColor: blue),
                            child: SfDataGrid(
                                source: monthlyDataSource,
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
                                  return details
                                      .getIntrinsicRowHeight(details.rowIndex);
                                },
                                columns: [
                                  GridColumn(
                                    columnName: 'ActivityNo',
                                    autoFitPadding: tablepadding,
                                    allowEditing: false,
                                    width: 70,
                                    label: Container(
                                      padding: tablepadding,
                                      alignment: Alignment.center,
                                      child: Text("SI No.",
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
                                    autoFitPadding: tablepadding,
                                    allowEditing: false,
                                    width: 350,
                                    label: Container(
                                      padding: tablepadding,
                                      alignment: Alignment.center,
                                      child: Text('Activities Details',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),

                                  // GridColumn(
                                  //   columnName: 'Months',
                                  //   autoFitPadding:
                                  //       tablepadding,
                                  //   allowEditing: false,
                                  //   width: 200,
                                  //   label: Container(
                                  //     padding:
                                  //         tablepadding,
                                  //     alignment: Alignment.center,
                                  //     child: Text('Months',
                                  //         textAlign: TextAlign.center,
                                  //         overflow: TextOverflow.values.first,
                                  //         style: TextStyle(
                                  //             fontWeight: FontWeight.bold,
                                  //             fontSize: 16,
                                  //             color: white)),
                                  //   ),
                                  // ),
                                  // GridColumn(
                                  //   columnName: 'Duration',
                                  //   autoFitPadding:
                                  //       tablepadding,
                                  //   allowEditing: false,
                                  //   width: 120,
                                  //   label: Container(
                                  //     padding:
                                  //         tablepadding,
                                  //     alignment: Alignment.center,
                                  //     child: Text('Duration in Days',
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
                                  //   columnName: 'StartDate',
                                  //   autoFitPadding:
                                  //       tablepadding,
                                  //   allowEditing: false,
                                  //   width: 160,
                                  //   label: Container(
                                  //     padding:
                                  //         tablepadding,
                                  //     alignment: Alignment.center,
                                  //     child: Text('Start Date',
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
                                  //   columnName: 'EndDate',
                                  //   autoFitPadding:
                                  //       tablepadding,
                                  //   allowEditing: false,
                                  //   width: 120,
                                  //   label: Container(
                                  //     padding:
                                  //         tablepadding,
                                  //     alignment: Alignment.center,
                                  //     child: Text('End Date',
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
                                    columnName: 'Progress',
                                    autoFitPadding: tablepadding,
                                    allowEditing: true,
                                    width: 250,
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
                                    width: 250,
                                    label: Container(
                                      padding: tablepadding,
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
                                    autoFitPadding: tablepadding,
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      padding: tablepadding,
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
}
