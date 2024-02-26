import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/date_format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../datasource/energymanagement_datasource.dart';
import '../../viewmodels/energy_management.dart';
import '../../views/authentication/authservice.dart';
import '../../components/Loading_page.dart';
import '../../datasource/dailyproject_datasource.dart';
import '../../datasource/monthlyproject_datasource.dart';
import '../../datasource/safetychecklist_datasource.dart';
import '../../viewmodels/daily_projectModel.dart';
import '../../viewmodels/monthly_projectModel.dart';
import '../../viewmodels/safety_checklistModel.dart';
import '../../provider/summary_provider.dart';
import '../../style.dart';
import '../../widgets/nodata_available.dart';
import '../qualitychecklist/quality_checklist.dart';

class ViewSummary extends StatefulWidget {
  String? depoName;
  String? cityName;
  String? id;
  String? selectedtab;
  bool isHeader;
  String? currentDate;
  dynamic userId;
  ViewSummary(
      {super.key,
      required this.depoName,
      required this.cityName,
      required this.id,
      this.userId,
      this.selectedtab,
      this.currentDate,
      this.isHeader = false});

  @override
  State<ViewSummary> createState() => _ViewSummaryState();
}

class _ViewSummaryState extends State<ViewSummary> {
  SummaryProvider? _summaryProvider;
  Future<List<DailyProjectModel>>? _dailydata;
  Future<List<EnergyManagementModel>>? _energydata;

  DateTime? startdate = DateTime.now();
  DateTime? enddate = DateTime.now();
  DateTime? rangestartDate;
  DateTime? rangeEndDate;

  List<MonthlyProjectModel> monthlyProject = <MonthlyProjectModel>[];
  List<SafetyChecklistModel> safetylisttable = <SafetyChecklistModel>[];
  late MonthlyDataSource monthlyDataSource;
  late SafetyChecklistDataSource _safetyChecklistDataSource;
  late DataGridController _dataGridController;
  List<DailyProjectModel> dailyproject = <DailyProjectModel>[];
  List<EnergyManagementModel> energymanagement = <EnergyManagementModel>[];
  late EnergyManagementDatasource _energyManagementDatasource;
  late DailyDataSource _dailyDataSource;
  List<dynamic> tabledata2 = [];
  var alldata;
  dynamic userId;

  @override
  void initState() {
    super.initState();
    _summaryProvider = Provider.of<SummaryProvider>(context, listen: false);

    getUserId().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    _summaryProvider!
        .fetchdailydata(widget.depoName!, widget.userId, startdate!, enddate!);
    _summaryProvider!.fetchEnergyData(widget.cityName!, widget.depoName!,
        widget.userId, startdate!, enddate!);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.depoName}/${widget.id}/View Summary',
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: blue,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: widget.id == 'Daily Report' ||
                      widget.id == 'Energy Management'
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                // width: 200,
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
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title:
                                                      const Text('Choose Date'),
                                                  content: SizedBox(
                                                    width: 400,
                                                    height: 500,
                                                    child: SfDateRangePicker(
                                                      view: DateRangePickerView
                                                          .year,
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
                                                          rangestartDate = args
                                                              .value.startDate;
                                                          rangeEndDate = args
                                                              .value.endDate;
                                                        }
                                                      },
                                                      onSubmit: (value) {
                                                        dailyproject.clear();
                                                        setState(() {
                                                          startdate =
                                                              DateTime.parse(
                                                                  rangestartDate
                                                                      .toString());
                                                          enddate = DateTime
                                                              .parse(rangeEndDate
                                                                  .toString());
                                                        });
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
                                        Text(widget.id == 'Monthly Report'
                                            ? DateFormat.yMMMM()
                                                .format(startdate!)
                                            : DateFormat.yMMMMd()
                                                .format(startdate!))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                // width: 180,
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
                          )
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 250,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: blue)),
                          child: Row(
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
                                                    .single,
                                            onSelectionChanged:
                                                (DateRangePickerSelectionChangedArgs
                                                    args) {
                                              if (args.value
                                                  is PickerDateRange) {
                                                rangestartDate =
                                                    args.value.startDate;
                                              }
                                            },
                                            onSubmit: (value) {
                                              setState(() {
                                                startdate = DateTime.parse(
                                                    value.toString());
                                              });
                                              Navigator.pop(context);
                                            },
                                            onCancel: () {},
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.today)),
                              Text(widget.id == 'Monthly Report'
                                  ? DateFormat.yMMMM().format(startdate!)
                                  : DateFormat.yMMMMd().format(startdate!))
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            widget.id == 'Monthly Report'
                ? Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('MonthlyProjectReport2')
                            .doc('${widget.depoName}')
                            // .collection('AllMonthData')
                            .collection('userId')
                            .doc(widget.userId)
                            .collection('Monthly Data')
                            // .collection('MonthData')
                            .doc(DateFormat.yMMM().format(startdate!))
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingPage();
                          } else if (!snapshot.hasData ||
                              snapshot.data!.exists == false) {
                            return const NodataAvailable();
                          } else {
                            alldata = snapshot.data!['data'] as List<dynamic>;
                            monthlyProject.clear();
                            alldata.forEach((element) {
                              monthlyProject
                                  .add(MonthlyProjectModel.fromjson(element));
                              monthlyDataSource =
                                  MonthlyDataSource(monthlyProject, context);
                              _dataGridController = DataGridController();
                            });
                            return Column(
                              children: [
                                Expanded(
                                    child: SfDataGridTheme(
                                  data: SfDataGridThemeData(headerColor: blue),
                                  child: SfDataGrid(
                                      source: monthlyDataSource,
                                      allowEditing: true,
                                      frozenColumnsCount: 1,
                                      gridLinesVisibility:
                                          GridLinesVisibility.both,
                                      headerGridLinesVisibility:
                                          GridLinesVisibility.both,
                                      selectionMode: SelectionMode.single,
                                      navigationMode: GridNavigationMode.cell,
                                      columnWidthMode: ColumnWidthMode.auto,
                                      editingGestureType:
                                          EditingGestureType.tap,
                                      controller: _dataGridController,
                                      onQueryRowHeight: (details) {
                                        return details.getIntrinsicRowHeight(
                                            details.rowIndex);
                                      },
                                      columns: [
                                        GridColumn(
                                          columnName: 'ActivityNo',
                                          autoFitPadding: tablepadding,
                                          allowEditing: true,
                                          width: 160,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Activities SI. No as per Gant Chart',
                                              overflow:
                                                  TextOverflow.values.first,
                                              textAlign: TextAlign.center,
                                              style: tableheaderwhitecolor,
                                            ),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'ActivityDetails',
                                          autoFitPadding: tablepadding,
                                          allowEditing: true,
                                          width: 240,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('Activities Details',
                                                textAlign: TextAlign.center,
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: tableheaderwhitecolor),
                                          ),
                                        ),
                                        // GridColumn(
                                        //   columnName: 'Months',
                                        //   auets.symmetric(
                                        //       tablepadding),                                        //   allowEditing: false,
                                        //   width: 200,
                                        //   label: Container(
                                        //     padding: const EdgeInsets.symmetric(
                                        //         horizontal: 8.0),
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
                                        //                       //       const EdgeInsets.symmetric(tablepadding),
                                        //   allowEditing: false,
                                        //   width: 120,
                                        //   label: Container(
                                        //     padding:
                                        //         const EdgeInsets.symmetric(horizontal: 8.0),
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
                                        //                       //       const EdgeInsets.symmetric(tablepadding),
                                        //   allowEditing: false,
                                        //   width: 160,
                                        //   label: Container(
                                        //     padding:
                                        //         const EdgeInsets.symmetric(horizontal: 8.0),
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
                                        //                       //       const EdgeInsets.symmetric(tablepadding),
                                        //   allowEditing: false,
                                        //   width: 120,
                                        //   label: Container(
                                        //     padding:
                                        //         const EdgeInsets.symmetric(horizontal: 8.0),
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('Progress',
                                                overflow:
                                                    TextOverflow.values.first,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('Remark/Status',
                                                overflow:
                                                    TextOverflow.values.first,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                                'Next Month Action Plan',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: tableheaderwhitecolor
                                                //    textAlign: TextAlign.center,
                                                ),
                                          ),
                                        ),
                                      ]),
                                )),
                              ],
                            );
                          }
                        }),
                  )
                : widget.id == 'Daily Report'
                    ? Expanded(
                        child: Consumer<SummaryProvider>(
                          builder: (context, value, child) {
                            return FutureBuilder(
                                future: _dailydata,
                                builder: (context, snapshot) {
                                  if (value.dailydata.length != 0) {
                                    // if (snapshot.hasData) {
                                    //   if (snapshot.data == null ||
                                    //       snapshot.data!.length == 0) {
                                    //     return const Center(
                                    //       child: Text(
                                    //         "No Data Found!",
                                    //         style: TextStyle(fontSize: 25.0),
                                    //       ),
                                    //     );
                                    //   } else {
                                    //     return LoadingPage();
                                    //   }
                                    // } else {
                                    dailyproject = value.dailydata;
                                    _dailyDataSource = DailyDataSource(
                                        dailyproject,
                                        context,
                                        widget.cityName!,
                                        widget.depoName!,
                                        widget.userId,
                                        selecteddate.toString());
                                    _dataGridController = DataGridController();

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
                                          gridLinesVisibility:
                                              GridLinesVisibility.both,
                                          headerGridLinesVisibility:
                                              GridLinesVisibility.both,
                                          selectionMode: SelectionMode.single,
                                          navigationMode:
                                              GridNavigationMode.cell,
                                          columnWidthMode: ColumnWidthMode.auto,
                                          editingGestureType:
                                              EditingGestureType.tap,
                                          controller: _dataGridController,
                                          onQueryRowHeight: (details) {
                                            return details
                                                .getIntrinsicRowHeight(
                                                    details.rowIndex);
                                          },
                                          columns: [
                                            GridColumn(
                                              columnName: 'Date',
                                              visible: true,
                                              autoFitPadding: tablepadding,
                                              allowEditing: true,
                                              width: 150,
                                              label: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text('Date',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    textAlign: TextAlign.center,
                                                    style: tableheaderwhitecolor
                                                    //    textAlign: TextAlign.center,
                                                    ),
                                              ),
                                            ),
                                            GridColumn(
                                              visible: false,
                                              columnName: 'SiNo',
                                              autoFitPadding: tablepadding,
                                              allowEditing: true,
                                              width: 70,
                                              label: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text('SI No.',
                                                    overflow: TextOverflow
                                                        .values.first,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text('Type of Activity',
                                                    overflow: TextOverflow
                                                        .values.first,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text('Activity Details',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    style: tableheaderwhitecolor
                                                    //    textAlign: TextAlign.center,
                                                    ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: 'Progress',
                                              autoFitPadding: tablepadding,
                                              allowEditing: true,
                                              width: 320,
                                              label: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text('Progress',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    style: tableheaderwhitecolor
                                                    //    textAlign: TextAlign.center,
                                                    ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: 'Status',
                                              autoFitPadding: tablepadding,
                                              allowEditing: true,
                                              width: 320,
                                              label: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text('Remark / Status',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    style: tableheaderwhitecolor
                                                    //    textAlign: TextAlign.center,
                                                    ),
                                              ),
                                            ),
                                            GridColumn(
                                              visible: false,
                                              columnName: 'upload',
                                              autoFitPadding: tablepadding,
                                              allowEditing: false,
                                              width: 150,
                                              label: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text('Upload Image',
                                                    overflow: TextOverflow
                                                        .values.first,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text('View Image',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    style: tableheaderwhitecolor
                                                    //    textAlign: TextAlign.center,
                                                    ),
                                              ),
                                            ),
                                            GridColumn(
                                              visible: false,
                                              columnName: 'Add',
                                              autoFitPadding: tablepadding,
                                              allowEditing: false,
                                              width: 120,
                                              label: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text('Add Row',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    style: tableheaderwhitecolor
                                                    //    textAlign: TextAlign.center,
                                                    ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: 'Delete',
                                              autoFitPadding: tablepadding,
                                              allowEditing: true,
                                              visible: false,
                                              width: 120,
                                              label: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text('Delete Row',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    style: tableheaderwhitecolor
                                                    //    textAlign: TextAlign.center,
                                                    ),
                                              ),
                                            ),
                                          ]),
                                    );
                                  } else {
                                    return const Center(
                                      child: Text(
                                          'No Data Available For Selected Date'),
                                    );
                                  }
                                }

                                //1              },
                                );
                          },
                        ),
                      )
                    : widget.id == 'Quality Checklist'
                        ? Expanded(
                            child: QualityChecklist(
                                currentDate:
                                    DateFormat.yMMMMd().format(startdate!),
                                isHeader: widget.isHeader,
                                cityName: widget.cityName,
                                depoName: widget.depoName))
                        : widget.id == 'Energy Management'
                            ? Expanded(
                                child: Consumer<SummaryProvider>(
                                  builder: (context, value, child) {
                                    return FutureBuilder(
                                      future: _energydata,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.data == null ||
                                              snapshot.data!.length == 0) {
                                            return const Center(
                                              child: Text(
                                                "No Data Found!!",
                                                style:
                                                    TextStyle(fontSize: 25.0),
                                              ),
                                            );
                                          } else {
                                            return const LoadingPage();
                                          }
                                        } else {
                                          energymanagement = value.energyData;

                                          _energyManagementDatasource =
                                              EnergyManagementDatasource(
                                                  energymanagement,
                                                  context,
                                                  widget.userId,
                                                  widget.cityName,
                                                  widget.depoName);

                                          _dataGridController =
                                              DataGridController();

                                          return Column(
                                            children: [
                                              SfDataGridTheme(
                                                  data: SfDataGridThemeData(
                                                      gridLineColor: blue,
                                                      gridLineStrokeWidth: 2,
                                                      frozenPaneLineColor: blue,
                                                      frozenPaneLineWidth: 3),
                                                  child: SfDataGrid(
                                                    source:
                                                        _energyManagementDatasource,
                                                    allowEditing: false,
                                                    frozenColumnsCount: 1,
                                                    gridLinesVisibility:
                                                        GridLinesVisibility
                                                            .both,
                                                    headerGridLinesVisibility:
                                                        GridLinesVisibility
                                                            .both,
                                                    headerRowHeight: 40,

                                                    selectionMode:
                                                        SelectionMode.single,
                                                    navigationMode:
                                                        GridNavigationMode.cell,
                                                    columnWidthMode:
                                                        ColumnWidthMode.auto,
                                                    editingGestureType:
                                                        EditingGestureType.tap,
                                                    controller:
                                                        _dataGridController,
                                                    // onQueryRowHeight:
                                                    //     (details) {
                                                    //   return details
                                                    //       .getIntrinsicRowHeight(
                                                    //           details
                                                    //               .rowIndex);
                                                    // },
                                                    columns: [
                                                      GridColumn(
                                                        visible: true,
                                                        columnName: 'srNo',
                                                        allowEditing: false,
                                                        label: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text('Sr No',
                                                              overflow:
                                                                  TextOverflow
                                                                      .values
                                                                      .first,
                                                              style:
                                                                  tableheaderwhitecolor
                                                              //    textAlign: TextAlign.center,
                                                              ),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'DepotName',
                                                        width: 180,
                                                        allowEditing: false,
                                                        label: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              'Depot Name',
                                                              overflow:
                                                                  TextOverflow
                                                                      .values
                                                                      .first,
                                                              style:
                                                                  tableheaderwhitecolor),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'VehicleNo',
                                                        width: 180,
                                                        allowEditing: true,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              'Veghicle No',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  tableheaderwhitecolor),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'pssNo',
                                                        width: 80,
                                                        allowEditing: true,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text('PSS No',
                                                              style:
                                                                  tableheaderwhitecolor),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'chargerId',
                                                        width: 80,
                                                        allowEditing: true,
                                                        label: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              'Charger ID',
                                                              overflow:
                                                                  TextOverflow
                                                                      .values
                                                                      .first,
                                                              style:
                                                                  tableheaderwhitecolor),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'startSoc',
                                                        allowEditing: true,
                                                        width: 80,
                                                        label: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              'Start SOC',
                                                              overflow:
                                                                  TextOverflow
                                                                      .values
                                                                      .first,
                                                              style:
                                                                  tableheaderwhitecolor),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'endSoc',
                                                        allowEditing: true,
                                                        columnWidthMode:
                                                            ColumnWidthMode
                                                                .fitByCellValue,
                                                        width: 80,
                                                        label: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text('End SOC',
                                                              overflow:
                                                                  TextOverflow
                                                                      .values
                                                                      .first,
                                                              style:
                                                                  tableheaderwhitecolor),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'startDate',
                                                        allowEditing: false,
                                                        width: 230,
                                                        label: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              'Start Date & Time',
                                                              overflow:
                                                                  TextOverflow
                                                                      .values
                                                                      .first,
                                                              style:
                                                                  tableheaderwhitecolor),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'endDate',
                                                        allowEditing: false,
                                                        width: 230,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                                'End Date & Time',
                                                                overflow:
                                                                    TextOverflow
                                                                        .values
                                                                        .first,
                                                                style:
                                                                    tableheaderwhitecolor),
                                                          ),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'totalTime',
                                                        allowEditing: false,
                                                        width: 180,
                                                        label: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              'Total time of Charging',
                                                              overflow:
                                                                  TextOverflow
                                                                      .values
                                                                      .first,
                                                              style:
                                                                  tableheaderwhitecolor),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName:
                                                            'energyConsumed',
                                                        allowEditing: true,
                                                        width: 160,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              'Engery Consumed (inkW)',
                                                              overflow:
                                                                  TextOverflow
                                                                      .values
                                                                      .first,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  tableheaderwhitecolor),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName:
                                                            'timeInterval',
                                                        allowEditing: false,
                                                        width: 150,
                                                        label: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              'Interval',
                                                              overflow:
                                                                  TextOverflow
                                                                      .values
                                                                      .first,
                                                              style:
                                                                  tableheaderwhitecolor),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'Add',
                                                        visible: false,
                                                        autoFitPadding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        allowEditing: false,
                                                        width: 120,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text('Add Row',
                                                              overflow:
                                                                  TextOverflow
                                                                      .values
                                                                      .first,
                                                              style:
                                                                  tableheaderwhitecolor
                                                              //    textAlign: TextAlign.center,
                                                              ),
                                                        ),
                                                      ),
                                                      GridColumn(
                                                        columnName: 'Delete',
                                                        visible: false,
                                                        autoFitPadding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        allowEditing: false,
                                                        width: 120,
                                                        label: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              'Delete Row',
                                                              overflow:
                                                                  TextOverflow
                                                                      .values
                                                                      .first,
                                                              style:
                                                                  tableheaderwhitecolor),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Consumer<SummaryProvider>(builder:
                                                  (context, value, child) {
                                                return Flexible(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 25),
                                                  child: BarChart(
                                                    swapAnimationCurve:
                                                        Curves.linear,
                                                    swapAnimationDuration:
                                                        const Duration(
                                                            milliseconds: 1000),
                                                    BarChartData(
                                                      backgroundColor: white,
                                                      barTouchData:
                                                          BarTouchData(
                                                        enabled: true,
                                                        allowTouchBarBackDraw:
                                                            true,
                                                        touchTooltipData:
                                                            BarTouchTooltipData(
                                                          tooltipRoundedRadius:
                                                              5,
                                                          tooltipBgColor: Colors
                                                              .transparent,
                                                          tooltipMargin: 5,
                                                        ),
                                                      ),
                                                      minY: 0,
                                                      titlesData: FlTitlesData(
                                                        bottomTitles:
                                                            AxisTitles(
                                                          sideTitles:
                                                              SideTitles(
                                                            showTitles: true,
                                                            getTitlesWidget:
                                                                (data1, meta) {
                                                              return Text(
                                                                value.intervalData[
                                                                    data1
                                                                        .toInt()],
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        rightTitles: AxisTitles(
                                                          sideTitles:
                                                              SideTitles(
                                                                  showTitles:
                                                                      false),
                                                        ),
                                                        topTitles: AxisTitles(
                                                          sideTitles:
                                                              SideTitles(
                                                            showTitles: false,
                                                            getTitlesWidget:
                                                                (data2, meta) {
                                                              return Text(
                                                                value.energyConsumedData[
                                                                    data2
                                                                        .toInt()],
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      gridData: FlGridData(
                                                        drawHorizontalLine:
                                                            true,
                                                        drawVerticalLine: true,
                                                      ),
                                                      borderData: FlBorderData(
                                                        border: const Border(
                                                          left: BorderSide(),
                                                          bottom: BorderSide(),
                                                        ),
                                                      ),
                                                      maxY: (value.intervalData
                                                                  .isEmpty &&
                                                              value
                                                                  .energyConsumedData
                                                                  .isEmpty)
                                                          ? 50000
                                                          : value
                                                              .energyConsumedData
                                                              .reduce((max,
                                                                      current) =>
                                                                  max > current
                                                                      ? max
                                                                      : current),
                                                      barGroups:
                                                          barChartGroupData(value
                                                              .energyConsumedData),
                                                    ),
                                                  ),
                                                ));
                                              })
                                            ],
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              )
                            : Expanded(
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('SafetyChecklistTable2')
                                      .doc(widget.depoName!)
                                      .collection('userId')
                                      .doc(userId)
                                      .collection('date')
                                      .doc(DateFormat.yMMMMd()
                                          .format(startdate!))
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return LoadingPage();
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.exists == false) {
                                      return const NodataAvailable();
                                    } else {
                                      alldata = '';
                                      alldata = snapshot.data!['data']
                                          as List<dynamic>;
                                      safetylisttable.clear();
                                      alldata.forEach((element) {
                                        safetylisttable.add(
                                            SafetyChecklistModel.fromJson(
                                                element));
                                        _safetyChecklistDataSource =
                                            SafetyChecklistDataSource(
                                                safetylisttable,
                                                widget.cityName!,
                                                widget.depoName!,
                                                userId,
                                                selecteddate.toString());
                                        _dataGridController =
                                            DataGridController();
                                      });
                                      return SfDataGridTheme(
                                        data: SfDataGridThemeData(
                                            gridLineColor: blue,
                                            gridLineStrokeWidth: 2,
                                            frozenPaneLineColor: blue,
                                            frozenPaneLineWidth: 3),
                                        child: SfDataGrid(
                                          source: _safetyChecklistDataSource,
                                          //key: key,

                                          allowEditing: true,
                                          frozenColumnsCount: 2,
                                          gridLinesVisibility:
                                              GridLinesVisibility.both,
                                          headerGridLinesVisibility:
                                              GridLinesVisibility.both,
                                          selectionMode: SelectionMode.single,
                                          navigationMode:
                                              GridNavigationMode.cell,
                                          columnWidthMode: ColumnWidthMode.auto,
                                          editingGestureType:
                                              EditingGestureType.tap,
                                          controller: _dataGridController,
                                          onQueryRowHeight: (details) {
                                            return details
                                                .getIntrinsicRowHeight(
                                                    details.rowIndex);
                                          },
                                          columns: [
                                            GridColumn(
                                              columnName: 'srNo',
                                              autoFitPadding: tablepadding,
                                              allowEditing: true,
                                              width: 80,
                                              label: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text('Sr No',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    style:
                                                        tableheaderwhitecolor),
                                              ),
                                            ),
                                            GridColumn(
                                              width: 550,
                                              columnName: 'Details',
                                              allowEditing: true,
                                              label: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text(
                                                    'Details of Enclosure ',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    style:
                                                        tableheaderwhitecolor),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: 'Status',
                                              allowEditing: true,
                                              width: 230,
                                              label: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                alignment: Alignment.center,
                                                child: Text(
                                                    'Status of Submission of information/ documents ',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: white,
                                                    )),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: 'Remark',
                                              allowEditing: true,
                                              width: 230,
                                              label: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text('Remarks',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    style:
                                                        tableheaderwhitecolor),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: 'Photo',
                                              allowEditing: false,
                                              visible: false,
                                              width: 160,
                                              label: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text('Upload Photo',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    style:
                                                        tableheaderwhitecolor),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: 'ViewPhoto',
                                              allowEditing: false,
                                              width: 180,
                                              label: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                alignment: Alignment.center,
                                                child: Text('View Photo',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    style:
                                                        tableheaderwhitecolor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              )
          ],
        ));
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }
}

List<BarChartGroupData> barChartGroupData(List<dynamic> data) {
  return List.generate(data.length, ((index) {
    print('$index${data[index]}');
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
            borderSide: BorderSide(color: white),
            backDrawRodData: BackgroundBarChartRodData(
              toY: 0,
              fromY: 0,
              show: true,
            ),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 16, 81, 231),
                Color.fromARGB(255, 190, 207, 252)
              ],
            ),
            width: 20,
            borderRadius: BorderRadius.circular(2),
            toY: data[index]),
      ],
    );
  }));
}
