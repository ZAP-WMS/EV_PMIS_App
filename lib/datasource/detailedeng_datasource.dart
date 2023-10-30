import 'package:collection/collection.dart';
import 'package:ev_pmis_app/screen/qualitychecklist/quality_user/electrical/electrical_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../date_format.dart';
import '../model/detailed_engModel.dart';
import '../screen/overviewpage/view_AllFiles.dart';
import '../style.dart';
import '../widgets/upload.dart';

class DetailedEngSource extends DataGridSource {
  String cityName;
  String depoName;
  String userId;
  String role;
  BuildContext mainContext;
  DetailedEngSource(this._detailedeng, this.mainContext, this.cityName,
      this.depoName, this.userId, this.role) {
    buildDataGridRows();
  }
  void buildDataGridRows() {
    dataGridRows = _detailedeng
        .map<DataGridRow>((dataGridRow) => dataGridRow.dataGridRow())
        .toList();
  }

  @override
  List<DetailedEngModel> _detailedeng = [];
  // List<DetailedEngModel> _detailedeng = [];

  TextStyle textStyle = const TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Colors.black87);
  List<String> typeRiskMenuItems = [
    'EV Layout',
    'Layout & Foundation Details for EV charging Depot',
    'Structural Steel details of Charging Shed',
    'DTB Room',
    'Air Compressor Rooms ',
    'Lube Room ',
    'Scrap Yard',
    'Foundation Details of MCCB Panel',
    'Foundation Detail of Charger',
    'Admin Block - First Floor Civil Layout',
    'Admin Block - Ground Floor Civil Layout',
    'LT Panel room of washing Bay (Civil Layout)',
    'LT Panel room of work shop Buliding (Civil Layout)',
    'Civil Layoiut for Cable Tranch No 1',
    'Civil Layoiut for Cable Tranch No 2 & 3',
    'Layout and Cross Section of burried cable trench',
    'LT Cable Route',
    'EV Parking Layout Design',
  ];

  List<String> ElectricalActivities = [
    'Electrical Work',
    'Block Diagram  of Total Power supply at DTC Mundhela Kalan Depot',
    'Earthing Pit GA Drawing',
    'LA Arrangement on charging Shed',
    'Metering Of Control Room (Admin Building-Ground Floor)',
    'Metering Of Drivers Room 1 & Meeting Room (Admin Building-First Floor)',
    'Metering Of Drivers Room 2, 3, 4 (Admin Building-First Floor)',
    'Metering Of Canteen (Admin Building-Ground Floor)',
    'Connection Diagram of meters installed at workshop building',
    'Connection Diagram of meters installed at washing bay',
  ];
  List<String> Specification = [
    'Illumination Design',
    'Shed Lighting SLD',
    'Electrical Conduit Layout',
    'Distribution Box SLD (VTPN & SPN)',
    'Scarp Yard Lighting Layout',
    'DTB Room Lighting Layout',
    'Compresser Rooms & Lube room  Lighting Layout',
  ];
  List<DataGridRow> dataGridRows = [];
  final _dateFormatter = DateFormat.yMd();

  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    DateTime? rangeStartDate = DateTime.now();
    DateTime? rangeEndDate = DateTime.now();
    DateTime? date;
    DateTime? endDate;
    DateTime? rangeStartDate1 = DateTime.now();
    DateTime? rangeEndDate1 = DateTime.now();
    DateTime? date1;
    DateTime? date2;
    DateTime? endDate1;
    final int dataRowIndex = dataGridRows.indexOf(row);
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      void addRowAtIndex(int index, DetailedEngModel rowData) {
        _detailedeng.insert(index, rowData);
        buildDataGridRows();
        notifyListeners();
      }

      void removeRowAtIndex(int index) {
        _detailedeng.removeAt(index);
        buildDataGridRows();
        notifyListeners();
      }
      // Color getcolor() {
      //   if (dataGridCell.columnName == 'Title' &&
      //           dataGridCell.value == 'RFC Drawings of Civil Activities' ||
      //       dataGridCell.value ==
      //           'EV Layout Drawings of Electrical Activities' ||
      //       dataGridCell.value == 'Shed Lighting Drawings & Specification') {
      //     return green;
      //   }

      //   return Colors.transparent;
      // }

      return Container(
        // color: getcolor(),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: (dataGridCell.columnName == 'Add')
            ? ElevatedButton(
                onPressed: () {
                  addRowAtIndex(
                      dataRowIndex + 1,
                      DetailedEngModel(
                        siNo: dataRowIndex + 2,
                        title: '',
                        number: null,
                        preparationDate: dmy,
                        submissionDate: dmy,
                        approveDate: dmy,
                        releaseDate: dmy,
                      ));
                },
                child: const Text(
                  'Add',
                  style: TextStyle(fontSize: 12),
                ))
            : (dataGridCell.columnName == 'Delete')
                ? IconButton(
                    onPressed: () {
                      removeRowAtIndex(dataRowIndex);
                      print(dataRowIndex);
                      dataGridRows.remove(row);
                      notifyListeners();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: red,
                    ))
                : dataGridCell.columnName == 'button'
                    ? LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                        return ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(backgroundColor: blue),
                            onPressed: () {
                              String activitydata =
                                  row.getCells()[4].value.toString().trim();
                              if (activitydata == "null" ||
                                  activitydata.isEmpty) {
                                showDialog(
                                  context: mainContext,
                                  builder: (context) {
                                    return AlertDialog(
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      elevation: 10,
                                      backgroundColor: Colors.white,
                                      icon: const Icon(
                                        Icons.warning_amber,
                                        size: 45,
                                        color: Colors.red,
                                      ),
                                      title: const Text(
                                        'Drawing Number is Required',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 14,
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      actions: [
                                        TextButton(
                                          style: const ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.blue)),
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  },
                                );
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UploadDocument(
                                    pagetitle: 'DetailedEngRFC',
                                    cityName: cityName,
                                    depoName: depoName,
                                    userId: userId,
                                    date: activitydata,
                                    fldrName:
                                        row.getCells()[0].value.toString(),
                                  ),
                                ));
                              }

                              // showDialog(
                              //     context: context,
                              //     builder: (context) => AlertDialog(
                              //         content: SizedBox(
                              //             height: 100,
                              //             child: Column(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.spaceBetween,
                              //               children: [
                              //                 Text(
                              //                     'Employee ID: ${row.getCells()[0].value.toString()}'),
                              //                 Text(
                              //                     'Employee Name: ${row.getCells()[1].value.toString()}'),
                              //                 Text(
                              //                     'Employee Designation: ${row.getCells()[2].value.toString()}'),
                              //               ],
                              //             ))));
                            },
                            child: const Text(
                              'Upload',
                              style: TextStyle(fontSize: 12),
                            ));
                      })
                    : dataGridCell.columnName == 'ViewDrawing'
                        ? LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: blue),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ViewAllPdf(
                                            role: role,
                                            title: 'DetailedEngRFC',
                                            cityName: cityName,
                                            depoName: depoName,
                                            userId: userId,
                                            date: row
                                                .getCells()[4]
                                                .value
                                                .toString(),
                                            docId:
                                                '${row.getCells()[4].value.toString().trim()}/${row.getCells()[0].value.toString().trim()}',
                                          )
                                      // ViewFile()
                                      // UploadDocument(
                                      //     title: 'DetailedEngRFC',
                                      //     cityName: cityName,
                                      //     depoName: depoName,
                                      //     activity: '${row.getCells()[1].value.toString()}'),
                                      ));
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (context) => AlertDialog(
                                  //         content: SizedBox(
                                  //             height: 100,
                                  //             child: Column(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.spaceBetween,
                                  //               children: [
                                  //                 Text(
                                  //                     'Employee ID: ${row.getCells()[0].value.toString()}'),
                                  //                 Text(
                                  //                     'Employee Name: ${row.getCells()[1].value.toString()}'),
                                  //                 Text(
                                  //                     'Employee Designation: ${row.getCells()[2].value.toString()}'),
                                  //               ],
                                  //             ))));
                                },
                                child: const Text(
                                  'View',
                                  style: TextStyle(fontSize: 12),
                                ));
                          })
                        : (dataGridCell.columnName == 'PreparationDate') &&
                                dataGridCell.value != ''
                            ? Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: mainContext,
                                          builder: (context) => AlertDialog(
                                                insetPadding:
                                                    const EdgeInsets.all(0),
                                                title: const Text(
                                                  'All Date',
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                content: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: SfDateRangePicker(
                                                      headerHeight: 15,
                                                      viewSpacing: 20,
                                                      selectionShape:
                                                          DateRangePickerSelectionShape
                                                              .rectangle,
                                                      view: DateRangePickerView
                                                          .month,
                                                      showTodayButton: false,
                                                      onSelectionChanged:
                                                          (DateRangePickerSelectionChangedArgs
                                                              args) {
                                                        // if (args.value
                                                        //     is PickerDateRange) {
                                                        //   rangeStartDate =
                                                        //       args.value
                                                        //           .startDate;
                                                        //   rangeEndDate =
                                                        //       args.value
                                                        //           .endDate;
                                                        // } else {
                                                        //   final List<
                                                        //           PickerDateRange>
                                                        //       selectedRanges =
                                                        //       args.value;
                                                        // }
                                                      },
                                                      selectionMode:
                                                          DateRangePickerSelectionMode
                                                              .single,
                                                      showActionButtons: true,
                                                      onSubmit: ((value) {
                                                        date = DateTime.parse(
                                                            value.toString());
                                                        date1 = DateTime.parse(
                                                            value.toString());
                                                        date2 = DateTime.parse(
                                                            value.toString());

                                                        final int dataRowIndex =
                                                            dataGridRows
                                                                .indexOf(row);
                                                        if (dataRowIndex !=
                                                            null) {
                                                          final int
                                                              dataRowIndex =
                                                              dataGridRows
                                                                  .indexOf(row);
                                                          dataGridRows[
                                                                      dataRowIndex]
                                                                  .getCells()[
                                                              5] = DataGridCell<
                                                                  String>(
                                                              columnName:
                                                                  'PreparationDate',
                                                              value: DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .format(
                                                                      date!));
                                                          _detailedeng[
                                                                      dataRowIndex]
                                                                  .preparationDate =
                                                              DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .format(
                                                                      date!);
                                                          notifyListeners();

                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      }),
                                                    )),
                                              ));
                                    },
                                    icon: const Icon(Icons.calendar_today),
                                  ),
                                  Text(
                                    dataGridCell.value.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              )
                            : (dataGridCell.columnName == 'SubmissionDate') &&
                                    dataGridCell.value != ''
                                ? Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: mainContext,
                                              builder: (context) => AlertDialog(
                                                    title:
                                                        const Text('All Date'),
                                                    content: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child:
                                                            SfDateRangePicker(
                                                          selectionShape:
                                                              DateRangePickerSelectionShape
                                                                  .rectangle,
                                                          view:
                                                              DateRangePickerView
                                                                  .month,
                                                          showTodayButton:
                                                              false,
                                                          // onSelectionChanged:
                                                          //     (DateRangePickerSelectionChangedArgs
                                                          //         args) {
                                                          //   if (args.value
                                                          //       is PickerDateRange) {
                                                          //     rangeStartDate = args
                                                          //         .value
                                                          //         .startDate;
                                                          //     rangeEndDate = args
                                                          //         .value
                                                          //         .endDate;
                                                          //   } else {
                                                          //     final List<
                                                          //             PickerDateRange>
                                                          //         selectedRanges =
                                                          //         args.value;
                                                          //   }
                                                          // },
                                                          selectionMode:
                                                              DateRangePickerSelectionMode
                                                                  .single,
                                                          showActionButtons:
                                                              true,
                                                          onSubmit: ((value) {
                                                            date = DateTime
                                                                .parse(value
                                                                    .toString());
                                                            date1 = DateTime
                                                                .parse(value
                                                                    .toString());
                                                            date2 = DateTime
                                                                .parse(value
                                                                    .toString());

                                                            final int
                                                                dataRowIndex =
                                                                dataGridRows
                                                                    .indexOf(
                                                                        row);
                                                            if (dataRowIndex !=
                                                                null) {
                                                              final int
                                                                  dataRowIndex =
                                                                  dataGridRows
                                                                      .indexOf(
                                                                          row);
                                                              dataGridRows[
                                                                          dataRowIndex]
                                                                      .getCells()[
                                                                  6] = DataGridCell<
                                                                      String>(
                                                                  columnName:
                                                                      'SubmissionDate',
                                                                  value: DateFormat(
                                                                          'dd-MM-yyyy')
                                                                      .format(
                                                                          date!));
                                                              _detailedeng[
                                                                      dataRowIndex]
                                                                  .submissionDate = DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .format(
                                                                      date!);
                                                              notifyListeners();

                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          }),
                                                        )),
                                                  ));
                                        },
                                        icon: const Icon(Icons.calendar_today),
                                      ),
                                      Text(
                                        dataGridCell.value.toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  )
                                : (dataGridCell.columnName == 'ApproveDate') &&
                                        dataGridCell.value != ''
                                    ? Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: mainContext,
                                                  builder:
                                                      (context) => AlertDialog(
                                                            title: const Text(
                                                                'All Date'),
                                                            content: Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.8,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.8,
                                                                child:
                                                                    SfDateRangePicker(
                                                                  selectionShape:
                                                                      DateRangePickerSelectionShape
                                                                          .rectangle,
                                                                  view:
                                                                      DateRangePickerView
                                                                          .month,
                                                                  showTodayButton:
                                                                      false,
                                                                  // onSelectionChanged:
                                                                  //     (DateRangePickerSelectionChangedArgs args) {
                                                                  //   if (args.value
                                                                  //       is PickerDateRange) {
                                                                  //     rangeStartDate = args.value.startDate;
                                                                  //     rangeEndDate = args.value.endDate;
                                                                  //   } else {
                                                                  //     final List<PickerDateRange> selectedRanges = args.value;
                                                                  //   }
                                                                  // },
                                                                  selectionMode:
                                                                      DateRangePickerSelectionMode
                                                                          .single,
                                                                  showActionButtons:
                                                                      true,
                                                                  onSubmit:
                                                                      ((value) {
                                                                    date = DateTime
                                                                        .parse(value
                                                                            .toString());
                                                                    // date1 =
                                                                    //     DateTime.parse(value.toString());
                                                                    // date2 =
                                                                    //     DateTime.parse(value.toString());

                                                                    final int
                                                                        dataRowIndex =
                                                                        dataGridRows
                                                                            .indexOf(row);
                                                                    if (dataRowIndex !=
                                                                        null) {
                                                                      final int
                                                                          dataRowIndex =
                                                                          dataGridRows
                                                                              .indexOf(row);
                                                                      dataGridRows[dataRowIndex]
                                                                              .getCells()[
                                                                          7] = DataGridCell<
                                                                              String>(
                                                                          columnName:
                                                                              'ApproveDate',
                                                                          value:
                                                                              DateFormat('dd-MM-yyyy').format(date!));
                                                                      _detailedeng[
                                                                              dataRowIndex]
                                                                          .approveDate = DateFormat(
                                                                              'dd-MM-yyyy')
                                                                          .format(
                                                                              date!);
                                                                      notifyListeners();

                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  }),
                                                                )),
                                                          ));
                                            },
                                            icon: const Icon(
                                                Icons.calendar_today),
                                          ),
                                          Text(
                                            dataGridCell.value.toString(),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      )
                                    : (dataGridCell.columnName ==
                                                'ReleaseDate') &&
                                            dataGridCell.value != ''
                                        ? Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: mainContext,
                                                      builder:
                                                          (context) =>
                                                              AlertDialog(
                                                                title: const Text(
                                                                    'All Date'),
                                                                content:
                                                                    Container(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.8,
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.8,
                                                                        child:
                                                                            SfDateRangePicker(
                                                                          selectionShape:
                                                                              DateRangePickerSelectionShape.rectangle,
                                                                          view:
                                                                              DateRangePickerView.month,
                                                                          showTodayButton:
                                                                              false,
                                                                          // onSelectionChanged:
                                                                          //     (DateRangePickerSelectionChangedArgs args) {
                                                                          //   if (args.value
                                                                          //       is PickerDateRange) {
                                                                          //     rangeStartDate = args.value.startDate;
                                                                          //     rangeEndDate = args.value.endDate;
                                                                          //   } else {
                                                                          //     final List<PickerDateRange> selectedRanges = args.value;
                                                                          //   }
                                                                          // },
                                                                          selectionMode:
                                                                              DateRangePickerSelectionMode.single,
                                                                          showActionButtons:
                                                                              true,
                                                                          onSubmit:
                                                                              ((value) {
                                                                            date =
                                                                                DateTime.parse(value.toString());
                                                                            // date1 =
                                                                            //     DateTime.parse(value.toString());
                                                                            // date2 =
                                                                            //     DateTime.parse(value.toString());

                                                                            final int
                                                                                dataRowIndex =
                                                                                dataGridRows.indexOf(row);
                                                                            if (dataRowIndex !=
                                                                                null) {
                                                                              final int dataRowIndex = dataGridRows.indexOf(row);
                                                                              dataGridRows[dataRowIndex].getCells()[8] = DataGridCell<String>(columnName: 'ReleaseDate', value: DateFormat('dd-MM-yyyy').format(date!));
                                                                              _detailedeng[dataRowIndex].releaseDate = DateFormat('dd-MM-yyyy').format(date!);
                                                                              notifyListeners();

                                                                              Navigator.pop(context);
                                                                            }
                                                                          }),
                                                                        )),
                                                              ));
                                                },
                                                icon: const Icon(
                                                    Icons.calendar_today),
                                              ),
                                              Text(
                                                dataGridCell.value.toString(),
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          )
                                        // : dataGridCell.columnName == 'Title' &&
                                        //         dataGridCell.value !=
                                        //             'RFC Drawings of Civil Activities' &&
                                        //         dataGridCell.value == 'EV Layout'
                                        //     ? DropdownButton<String>(
                                        //         value: dataGridCell.value,
                                        //         autofocus: true,
                                        //         focusColor: Colors.transparent,
                                        //         underline: const SizedBox.shrink(),
                                        //         icon: const Icon(
                                        //             Icons.arrow_drop_down_sharp),
                                        //         isExpanded: true,
                                        //         style: textStyle,
                                        //         onChanged: (String? value) {
                                        //           final dynamic oldValue = row
                                        //                   .getCells()
                                        //                   .firstWhereOrNull(
                                        //                       (DataGridCell dataCell) =>
                                        //                           dataCell.columnName ==
                                        //                           dataGridCell
                                        //                               .columnName)
                                        //                   ?.value ??
                                        //               '';
                                        //           if (oldValue == value ||
                                        //               value == null) {
                                        //             return;
                                        //           }

                                        //           final int dataRowIndex =
                                        //               dataGridRows.indexOf(row);
                                        //           dataGridRows[dataRowIndex]
                                        //                   .getCells()[2] =
                                        //               DataGridCell<String>(
                                        //                   columnName: 'Title',
                                        //                   value: value);
                                        //           _detailedeng[dataRowIndex].title =
                                        //               value.toString();
                                        //           notifyListeners();
                                        //         },
                                        //         items: typeRiskMenuItems
                                        //             .map<DropdownMenuItem<String>>(
                                        //                 (String value) {
                                        //           return DropdownMenuItem<String>(
                                        //             value: value,
                                        //             child: Text(value),
                                        //           );
                                        //         }).toList())
                                        //     : dataGridCell.columnName == 'Title' &&
                                        //             dataGridCell.value !=
                                        //                 'EV Layout Drawings of Electrical Activities' &&
                                        //             dataGridCell.value ==
                                        //                 'Electrical Work'
                                        //         ? DropdownButton<String>(
                                        //             value: dataGridCell.value,
                                        //             autofocus: true,
                                        //             focusColor: Colors.transparent,
                                        //             underline: const SizedBox.shrink(),
                                        //             icon: const Icon(
                                        //                 Icons.arrow_drop_down_sharp),
                                        //             isExpanded: true,
                                        //             style: textStyle,
                                        //             onChanged: (String? value) {
                                        //               final dynamic oldValue = row
                                        //                       .getCells()
                                        //                       .firstWhereOrNull(
                                        //                           (DataGridCell
                                        //                                   dataCell) =>
                                        //                               dataCell
                                        //                                   .columnName ==
                                        //                               dataGridCell
                                        //                                   .columnName)
                                        //                       ?.value ??
                                        //                   '';
                                        //               if (oldValue == value ||
                                        //                   value == null) {
                                        //                 return;
                                        //               }

                                        //               final int dataRowIndex =
                                        //                   dataGridRows.indexOf(row);
                                        //               dataGridRows[dataRowIndex]
                                        //                       .getCells()[2] =
                                        //                   DataGridCell<String>(
                                        //                       columnName: 'Title',
                                        //                       value: value);
                                        //               _detailedeng[dataRowIndex].title =
                                        //                   value.toString();
                                        //               notifyListeners();
                                        //             },
                                        //             items: ElectricalActivities.map<
                                        //                     DropdownMenuItem<String>>(
                                        //                 (String value) {
                                        //               return DropdownMenuItem<String>(
                                        //                 value: value,
                                        //                 child: Text(value),
                                        //               );
                                        //             }).toList())
                                        //         : dataGridCell.columnName == 'Title' &&
                                        //                 dataGridCell.value !=
                                        //                     'Shed Lighting Drawings & Specification' &&
                                        //                 dataGridCell.value ==
                                        //                     'Illumination Design'
                                        //             ? DropdownButton<String>(
                                        //                 value: dataGridCell.value,
                                        //                 autofocus: true,
                                        //                 focusColor: Colors.transparent,
                                        //                 underline:
                                        //                     const SizedBox.shrink(),
                                        //                 icon:
                                        //                     const Icon(Icons.arrow_drop_down_sharp),
                                        //                 isExpanded: true,
                                        //                 style: textStyle,
                                        //                 onChanged: (String? value) {
                                        //                   final dynamic oldValue = row
                                        //                           .getCells()
                                        //                           .firstWhereOrNull(
                                        //                               (DataGridCell
                                        //                                       dataCell) =>
                                        //                                   dataCell
                                        //                                       .columnName ==
                                        //                                   dataGridCell
                                        //                                       .columnName)
                                        //                           ?.value ??
                                        //                       '';
                                        //                   if (oldValue == value ||
                                        //                       value == null) {
                                        //                     return;
                                        //                   }

                                        //                   final int dataRowIndex =
                                        //                       dataGridRows.indexOf(row);
                                        //                   dataGridRows[dataRowIndex]
                                        //                           .getCells()[2] =
                                        //                       DataGridCell<String>(
                                        //                           columnName: 'Title',
                                        //                           value: value);
                                        //                   _detailedeng[dataRowIndex]
                                        //                       .title = value.toString();
                                        //                   notifyListeners();
                                        //                 },
                                        //                 items: Specification.map<DropdownMenuItem<String>>((String value) {
                                        //                   return DropdownMenuItem<
                                        //                       String>(
                                        //                     value: value,
                                        //                     child: Text(value),
                                        //                   );
                                        //                 }).toList())
                                        : Text(
                                            dataGridCell.value.toString(),
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
      );
    }).toList());
  }

  void updateDatagridSource() {
    notifyListeners();
  }

  void updateDataGrid({required RowColumnIndex rowColumnIndex}) {
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }

  @override
  void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }
    if (column.columnName == 'SiNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'SiNo', value: newCellValue);
      _detailedeng[dataRowIndex].siNo = newCellValue;
    } else if (column.columnName == 'Number') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'Number', value: newCellValue);
      _detailedeng[dataRowIndex].number = newCellValue;
    } else if (column.columnName == 'Title') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Title', value: newCellValue);
      _detailedeng[dataRowIndex].title = newCellValue.toString();
    } else if (column.columnName == 'PreparationDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(
              columnName: 'PreparationDate', value: newCellValue as int);
      _detailedeng[dataRowIndex].preparationDate = newCellValue;
    } else if (column.columnName == 'SubmissionDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'SubmissioinDate', value: newCellValue);
      _detailedeng[dataRowIndex].submissionDate = newCellValue;
    } else if (column.columnName == 'ApproveDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'ApproveDate', value: newCellValue);
      _detailedeng[dataRowIndex].approveDate = newCellValue;
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'ReleaseDate', value: newCellValue);
      _detailedeng[dataRowIndex].releaseDate = newCellValue;
    }
  }

  @override
  bool canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    // Return false, to retain in edit mode.
    return true; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    final bool isNumericType = column.columnName == 'SiNo';
    // || column.columnName == 'Number';
    //  ||
    // column.columnName == 'StartDate' ||
    // column.columnName == 'EndDate' ||
    // column.columnName == 'ActualStart' ||
    // column.columnName == 'ActualEnd' ||
    // column.columnName == 'ActualDuration' ||
    // column.columnName == 'Delay' ||
    // column.columnName == 'Unit' ||
    // column.columnName == 'QtyScope' ||
    // column.columnName == 'QtyExecuted' ||
    // column.columnName == 'BalancedQty' ||
    // column.columnName == 'Progress' ||
    // column.columnName == 'Weightage';

    final bool isDateTimeType = column.columnName == 'StartDate' ||
        column.columnName == 'EndDate' ||
        column.columnName == 'ActualStart' ||
        column.columnName == 'ActualEnd';
    // Holds regular expression pattern based on the column type.
    final RegExp regExp =
        _getRegExp(isNumericType, isDateTimeType, column.columnName);

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        style: const TextStyle(fontSize: 12),
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp),
        ],
        keyboardType: isNumericType
            ? TextInputType.number
            : isDateTimeType
                ? TextInputType.datetime
                : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else if (isDateTimeType) {
              newCellValue = value;
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          /// Call [CellSubmit] callback to fire the canSubmitCell and
          /// onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
    );
  }

  RegExp _getRegExp(
      bool isNumericKeyBoard, bool isDateTimeBoard, String columnName) {
    return isNumericKeyBoard
        ? RegExp('[0-9]')
        : isDateTimeBoard
            ? RegExp('[0-9/]')
            : RegExp('[a-zA-Z0-9.@!#^&*(){+-}%|<>?_=+,/ )]');
  }
}
