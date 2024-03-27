import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/components/loading_pdf.dart';
import 'package:ev_pmis_app/datasource_admin/dailyproject_datasource.dart';
import 'package:ev_pmis_app/model_admin/daily_projectModel.dart';
import 'package:ev_pmis_app/screen/dailyreport/daily_report_user/daily_project.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:ev_pmis_app/widgets/admin_custom_appbar.dart';
import 'package:ev_pmis_app/widgets/nodata_available.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../views/dailyreport/summary.dart';
import '../../../widgets/navbar.dart';

class DailyProjectAdmin extends StatefulWidget {
  String? userId;
  String? cityName;
  String? depoName;
  String role;

  DailyProjectAdmin(
      {super.key,
      this.userId,
      this.cityName,
      required this.depoName,
      required this.role});

  @override
  State<DailyProjectAdmin> createState() => _DailyProjectAdminState();
}

class _DailyProjectAdminState extends State<DailyProjectAdmin> {
  DateTime? startdate = DateTime.now();
  DateTime? enddate = DateTime.now();
  DateTime? rangestartDate;
  DateTime? rangeEndDate;
  List<DailyProjectModelAdmin> dailyProject = <DailyProjectModelAdmin>[];
  late DailyDataSource _dailyDataSource;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  bool _isLoading = true;
  bool specificUser = true;
  QuerySnapshot? snap;
  dynamic companyId;
  // dynamic alldata;
  List id = [];

  @override
  void initState() {
    getUserId();
    identifyUser();
    _dailyDataSource = DailyDataSource(
        dailyProject, context, widget.cityName!, widget.depoName!);
    _dataGridController = DataGridController();
    super.initState();
    getAllData();
  }

  getAllData() {
    dailyProject.clear();
    id.clear();
    getTableData().whenComplete(
      () {
        nestedTableData(id, context).whenComplete(
          () {
            _dailyDataSource = DailyDataSource(
                dailyProject, context, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();
            _isLoading = false;
            setState(() {});
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavbarDrawer(role: widget.role),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            isProjectManager: widget.role == "projectManager" ? true : false,
            makeAnEntryPage: DailyProject(
                cityName: widget.cityName,
                role: widget.role,
                depoName: widget.depoName),
            showDepoBar: true,
            toDaily: true,
            depoName: widget.depoName,
            cityName: widget.cityName,
            text: ' Daily Report',
            userId: widget.userId,
            haveSynced: false,
            //specificUser ? true : false,
            isdownload: true,
            haveSummary: false,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewSummary(
                    cityName: widget.cityName.toString(),
                    depoName: widget.depoName.toString(),
                    role: widget.role,
                    id: 'Daily Report',
                    userId: widget.userId,
                  ),
                )),
            store: () {
              storeData();
            },
          )),
      body: _isLoading
          ? const LoadingPage()
          : Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.99,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 180,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: blue)),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('choose Date'),
                                          content: SizedBox(
                                            width: 400,
                                            height: 500,
                                            child: SfDateRangePicker(
                                              view: DateRangePickerView.year,
                                              showTodayButton: false,
                                              showActionButtons: true,
                                              selectionMode:
                                                  DateRangePickerSelectionMode
                                                      .range,
                                              onSelectionChanged:
                                                  (DateRangePickerSelectionChangedArgs
                                                      args) {
                                                if (args.value
                                                    is PickerDateRange) {
                                                  rangestartDate =
                                                      args.value.startDate;
                                                  rangeEndDate =
                                                      args.value.endDate;
                                                }
                                              },
                                              onSubmit: (value) {
                                                setState(() {
                                                  startdate = DateTime.parse(
                                                      rangestartDate
                                                          .toString());
                                                  enddate = DateTime.parse(
                                                      rangeEndDate.toString());
                                                });

                                                getAllData();
                                                Navigator.pop(context);
                                              },
                                              onCancel: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.today)),
                                Text(
                                  DateFormat.yMMMMd().format(startdate!),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        width: 160,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: blue)),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  DateFormat.yMMMMd().format(enddate!),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingPage();
                    } else if (!snapshot.hasData ||
                        snapshot.data.exists == false) {
                      return Column(
                        children: [
                          Expanded(
                            child: SfDataGridTheme(
                              data: SfDataGridThemeData(
                                  gridLineColor: blue,
                                  gridLineStrokeWidth: 2,
                                  frozenPaneLineColor: blue,
                                  frozenPaneLineWidth: 2),
                              child: SfDataGrid(
                                  source: _dailyDataSource,
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
                                  columns: [
                                    GridColumn(
                                      columnName: 'Date',
                                      visible: true,
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 150,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
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
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 70,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
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
                                    //       const EdgeInsets.symmetric(
                                    //           horizontal: 16),
                                    //   allowEditing: false,
                                    //   width: 160,
                                    //   label: Container(
                                    //     padding: const EdgeInsets.symmetric(
                                    //         horizontal: 8.0),
                                    //     alignment: Alignment.center,
                                    //     child: Text(' ,
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
                                    //       const EdgeInsets.symmetric(horizontal: 16),
                                    //   allowEditing: true,
                                    //   width: 120,
                                    //   label: Container(
                                    //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                    //       const EdgeInsets.symmetric(horizontal: 16),
                                    //   allowEditing: true,
                                    //   width: 150,
                                    //   label: Container(
                                    //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 200,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
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
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 220,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
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
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 320,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
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
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: true,
                                      width: 320,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text('Remark / Status',
                                            overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'View',
                                      autoFitPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      allowEditing: false,
                                      width: 140,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        alignment: Alignment.center,
                                        child: Text('View Image',
                                            overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor
                                            //    textAlign: TextAlign.center,
                                            ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      );
                    } else {
                      print(_dailyDataSource.rows[0].getCells().length);
                      // alldata = '';
                      // alldata = snapshot.data['data'] as List<dynamic>;
                      // DailyProject.clear();
                      // alldata.forEach((element) {
                      //   DailyProject.add(DailyProjectModel.fromjson(element));
                      //   _dailyDataSource = DailyDataSource(
                      //       DailyProject, context, widget.depoName!);
                      //   _dataGridController = DataGridController();
                      // });
                      return const NodataAvailable();
                      // return Expanded(
                      //   child: Column(
                      //     children: [
                      //       SfDataGridTheme(
                      //         data: SfDataGridThemeData(headerColor: blue),
                      //         child: SfDataGrid(
                      //             source: _dailyDataSource,
                      //             allowEditing: true,
                      //             frozenColumnsCount: 2,
                      //             gridLinesVisibility: GridLinesVisibility.both,
                      //             headerGridLinesVisibility:
                      //                 GridLinesVisibility.both,
                      //             selectionMode: SelectionMode.single,
                      //             navigationMode: GridNavigationMode.cell,
                      //             columnWidthMode: ColumnWidthMode.auto,
                      //             editingGestureType: EditingGestureType.tap,
                      //             controller: _dataGridController,
                      //             columns: [
                      //               GridColumn(
                      //                 columnName: 'SiNo',
                      //                 autoFitPadding:
                      //                     const EdgeInsets.symmetric(
                      //                         horizontal: 16),
                      //                 allowEditing: true,
                      //                 width: 70,
                      //                 label: Container(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 8.0),
                      //                   alignment: Alignment.center,
                      //                   child: Text('SI No.',
                      //                       overflow: TextOverflow.values.first,
                      //                       textAlign: TextAlign.center,
                      //                       style: TextStyle(
                      //                           fontWeight: FontWeight.bold,
                      //                           fontSize: 16,
                      //                           color: white)
                      //                       //    textAlign: TextAlign.center,
                      //                       ),
                      //                 ),
                      //               ),
                      //               // GridColumn(
                      //               //   columnName: 'Date',
                      //               //   autoFitPadding:
                      //               //       const EdgeInsets.symmetric(
                      //               //           horizontal: 16),
                      //               //   allowEditing: false,
                      //               //   width: 160,
                      //               //   label: Container(
                      //               //     padding: const EdgeInsets.symmetric(
                      //               //         horizontal: 8.0),
                      //               //     alignment: Alignment.center,
                      //               //     child: Text('Date',
                      //               //         textAlign: TextAlign.center,
                      //               //         overflow: TextOverflow.values.first,
                      //               //         style: TextStyle(
                      //               //             fontWeight: FontWeight.bold,
                      //               //             fontSize: 16,
                      //               //             color: white)),
                      //               //   ),
                      //               // ),
                      //               // GridColumn(
                      //               //   visible: false,
                      //               //   columnName: 'State',
                      //               //   autoFitPadding:
                      //               //       const EdgeInsets.symmetric(horizontal: 16),
                      //               //   allowEditing: true,
                      //               //   width: 120,
                      //               //   label: Container(
                      //               //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //               //     alignment: Alignment.center,
                      //               //     child: Text('State',
                      //               //         textAlign: TextAlign.center,
                      //               //         overflow: TextOverflow.values.first,
                      //               //         style: TextStyle(
                      //               //             fontWeight: FontWeight.bold,
                      //               //             fontSize: 16,
                      //               //             color: white)
                      //               //         //    textAlign: TextAlign.center,
                      //               //         ),
                      //               //   ),
                      //               // ),
                      //               // GridColumn(
                      //               //   visible: false,
                      //               //   columnName: 'DepotName',
                      //               //   autoFitPadding:
                      //               //       const EdgeInsets.symmetric(horizontal: 16),
                      //               //   allowEditing: true,
                      //               //   width: 150,
                      //               //   label: Container(
                      //               //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //               //     alignment: Alignment.center,
                      //               //     child: Text('Depot Name',
                      //               //         overflow: TextOverflow.values.first,
                      //               //         style: TextStyle(
                      //               //             fontWeight: FontWeight.bold,
                      //               //             fontSize: 16,
                      //               //             color: white)
                      //               //         //    textAlign: TextAlign.center,
                      //               //         ),
                      //               //   ),
                      //               // ),
                      //               GridColumn(
                      //                 columnName: 'TypeOfActivity',
                      //                 autoFitPadding:
                      //                     const EdgeInsets.symmetric(
                      //                         horizontal: 16),
                      //                 allowEditing: true,
                      //                 width: 200,
                      //                 label: Container(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 8.0),
                      //                   alignment: Alignment.center,
                      //                   child: Text('Type of Activity',
                      //                       overflow: TextOverflow.values.first,
                      //                       style: TextStyle(
                      //                           fontWeight: FontWeight.bold,
                      //                           fontSize: 16,
                      //                           color: white)
                      //                       //    textAlign: TextAlign.center,
                      //                       ),
                      //                 ),
                      //               ),
                      //               GridColumn(
                      //                 columnName: 'ActivityDetails',
                      //                 autoFitPadding:
                      //                     const EdgeInsets.symmetric(
                      //                         horizontal: 16),
                      //                 allowEditing: true,
                      //                 width: 220,
                      //                 label: Container(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 8.0),
                      //                   alignment: Alignment.center,
                      //                   child: Text('Activity Details',
                      //                       overflow: TextOverflow.values.first,
                      //                       style: TextStyle(
                      //                           fontWeight: FontWeight.bold,
                      //                           fontSize: 16,
                      //                           color: white)
                      //                       //    textAlign: TextAlign.center,
                      //                       ),
                      //                 ),
                      //               ),
                      //               GridColumn(
                      //                 columnName: 'Progress',
                      //                 autoFitPadding:
                      //                     const EdgeInsets.symmetric(
                      //                         horizontal: 16),
                      //                 allowEditing: true,
                      //                 width: 320,
                      //                 label: Container(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 8.0),
                      //                   alignment: Alignment.center,
                      //                   child: Text('Progress',
                      //                       overflow: TextOverflow.values.first,
                      //                       style: TextStyle(
                      //                           fontWeight: FontWeight.bold,
                      //                           fontSize: 16,
                      //                           color: white)
                      //                       //    textAlign: TextAlign.center,
                      //                       ),
                      //                 ),
                      //               ),
                      //               GridColumn(
                      //                 columnName: 'Status',
                      //                 autoFitPadding:
                      //                     const EdgeInsets.symmetric(
                      //                         horizontal: 16),
                      //                 allowEditing: true,
                      //                 width: 320,
                      //                 label: Container(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 8.0),
                      //                   alignment: Alignment.center,
                      //                   child: Text('Remark / Status',
                      //                       overflow: TextOverflow.values.first,
                      //                       style: TextStyle(
                      //                           fontWeight: FontWeight.bold,
                      //                           fontSize: 16,
                      //                           color: white)
                      //                       //    textAlign: TextAlign.center,
                      //                       ),
                      //                 ),
                      //               ),
                      //             ]),
                      //       ),
                      //     ],
                      //   ),
                      // );
                    }
                  },
                ),
              )
            ]),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     onPressed: (() {
      //       DailyProject.add(DailyProjectModel(
      //           siNo: 1,
      //           // date: DateFormat().add_yMd().format(DateTime.now()),
      //           // state: "Maharashtra",
      //           // depotName: 'depotName',
      //           typeOfActivity: 'Electrical Infra',
      //           activityDetails: "Initial Survey of DEpot",
      //           progress: '',
      //           status: ''));
      //       _dailyDataSource.buildDataGridRows();
      //       _dailyDataSource.updateDatagridSource();
      //     })),
    );
  }

  void storeData() {
    Map<String, dynamic> table_data = Map();
    for (var i in _dailyDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button') {
          table_data[data.columnName] = data.value;
        }
      }

      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('DailyProject3')
        .doc('${widget.depoName}')
        .collection(DateFormat.yMMMMd().format(DateTime.now()))
        .doc(widget.userId)
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      tabledata2.clear();
      // Navigator.pop(context);
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

    for (int i = 0; i < snap!.docs.length; i++) {
      if (snap!.docs[i]['Employee Id'] == companyId &&
          snap!.docs[i]['CompanyName'] == 'TATA MOTOR') {
        setState(() {
          specificUser = false;
        });
      }
    }
  }

  Future getTableData() async {
    await FirebaseFirestore.instance
        .collection('DailyProject3')
        .doc(widget.depoName!)
        .collection(DateFormat.yMMMMd().format(DateTime.now()))
        .get()
        .then((value) {
      value.docs.forEach((element) {
        String documentId = element.id;
        id.add(documentId);
        // nestedTableData(docss);
      });
    });
  }

  Future<void> nestedTableData(docss, BuildContext pageContext) async {
    final pr = ProgressDialog(pageContext);
    pr.style(
        progressWidgetAlignment: Alignment.center,
        message: 'Loading Data....',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const LoadingPdf(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        maxProgress: 100.0,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600));

    await pr.show();

    for (int i = 0; i < docss.length; i++) {
      for (DateTime initialdate = startdate!;
          initialdate.isBefore(enddate!.add(const Duration(days: 1)));
          initialdate = initialdate.add(const Duration(days: 1))) {
        String temp = DateFormat.yMMMMd().format(initialdate);
        await FirebaseFirestore.instance
            .collection('DailyProject3')
            .doc(widget.depoName!)
            .collection(temp)
            .doc(docss[i])
            .get()
            .then((value) {
          if (value.data() != null) {
            for (int j = 0; j < value.data()!['data'].length; j++) {
              dailyProject.add(
                  DailyProjectModelAdmin.fromjson(value.data()!['data'][j]));
            }
          }
        });
      }
    }
    pr.hide();
  }
}
