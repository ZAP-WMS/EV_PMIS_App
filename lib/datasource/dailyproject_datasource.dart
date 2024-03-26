import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../style.dart';
import '../viewmodels/daily_projectModel.dart';
import '../views/overviewpage/view_AllFiles.dart';
import '../widgets/upload.dart';

class DailyDataSource extends DataGridSource {
  String cityName;
  String depoName;
  String userId;
  String selectedDate;
  BuildContext mainContext;
  List data = [];

  DailyDataSource(this._dailyproject, this.mainContext, this.cityName,
      this.depoName, this.userId, this.selectedDate) {
    buildDataGridRows();
  }
  void buildDataGridRows() {
    dataGridRows = _dailyproject
        .map<DataGridRow>((dataGridRow) => dataGridRow.dataGridRow())
        .toList();
  }

  @override
  List<DailyProjectModel> _dailyproject = [];

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
    DateTime? rangeEndDate = DateTime.now();
    DateTime? date;
    DateTime? endDate;
    DateTime? rangeStartDate1 = DateTime.now();
    DateTime? rangeEndDate1 = DateTime.now();
    DateTime? date1;
    DateTime? endDate1;
    final int dataRowIndex = dataGridRows.indexOf(row);
    String Pagetitle = 'Daily Report';

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      void addRowAtIndex(int index, DailyProjectModel rowData) {
        _dailyproject.insert(index, rowData);
        buildDataGridRows();
        notifyListeners();
        // notifyListeners(DataGridSourceChangeKind.rowAdd, rowIndexes: [index]);
      }

      void removeRowAtIndex(int index) {
        _dailyproject.removeAt(index);
        buildDataGridRows();
        notifyListeners();
      }

      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: (dataGridCell.columnName == 'view')
              ? ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        mainContext,
                        MaterialPageRoute(
                          builder: (context) => ViewAllPdf(
                            title: Pagetitle,
                            cityName: cityName,
                            depoName: depoName,
                            userId: userId,
                            date: row.getCells()[0].value.toString(),
                            docId: row.getCells()[1].value.toString(),
                          ),
                        ));
                  },
                  child: const Text(
                    'View',
                    style: TextStyle(fontSize: 12),
                  ))
              : (dataGridCell.columnName == 'upload')
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            mainContext,
                            MaterialPageRoute(
                              builder: (context) => UploadDocument(
                                pagetitle: Pagetitle,
                                cityName: cityName,
                                depoName: depoName,
                                userId: userId,
                                date: row.getCells()[0].value.toString(),
                                fldrName: row.getCells()[1].value.toString(),
                                // title: 'Data Image',
                                // fldrName: row.getCells()[1].value.toString(),
                                // userId: userId,
                                // cityName: cityName,
                                // depoName: depoName,
                              ),
                            ));
                      },
                      child: Text('Upload', style: TextStyle(fontSize: 12)))
                  : (dataGridCell.columnName == 'Add')
                      ? ElevatedButton(
                          onPressed: () {
                            addRowAtIndex(
                                dataRowIndex + 1,
                                DailyProjectModel(
                                    siNo: dataRowIndex + 2,
                                    typeOfActivity: '',
                                    activityDetails: '',
                                    progress: '',
                                    status: ''));
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(fontSize: 12),
                          ))
                      : (dataGridCell.columnName == 'Delete')
                          ? IconButton(
                              onPressed: () async {
                                removeRowAtIndex(dataRowIndex);
                                dataGridRows.remove(row);
                                notifyListeners();
                              },
                              icon: Icon(
                                Icons.delete,
                                color: red,
                              ))
                          // : (dataGridCell.columnName == 'Date')
                          //     ? Row(
                          //         children: [
                          //           IconButton(
                          //             onPressed: () {
                          //               showDialog(
                          //                   context: mainContext,
                          //                   builder: (context) => AlertDialog(
                          //                         title: const Text('All Date'),
                          //                         content: SizedBox(
                          //                             height: 400,
                          //                             width: 500,
                          //                             child: SfDateRangePicker(
                          //                               view:
                          //                                   DateRangePickerView
                          //                                       .month,
                          //                               showTodayButton: true,
                          //                               onSelectionChanged:
                          //                                   (DateRangePickerSelectionChangedArgs
                          //                                       args) {
                          //                                 if (args.value
                          //                                     is PickerDateRange) {
                          //                                   rangeEndDate = args
                          //                                       .value.endDate;
                          //                                 } else {
                          //                                   final List<
                          //                                           PickerDateRange>
                          //                                       selectedRanges =
                          //                                       args.value;
                          //                                 }
                          //                               },
                          //                               selectionMode:
                          //                                   DateRangePickerSelectionMode
                          //                                       .single,
                          //                               showActionButtons: true,
                          //                               onSubmit: ((value) {
                          //                                 date = DateTime.parse(
                          //                                     value.toString());

                          //                                 final int
                          //                                     dataRowIndex =
                          //                                     dataGridRows
                          //                                         .indexOf(row);
                          //                                 if (dataRowIndex !=
                          //                                     null) {
                          //                                   final int
                          //                                       dataRowIndex =
                          //                                       dataGridRows
                          //                                           .indexOf(
                          //                                               row);
                          //                                   dataGridRows[
                          //                                               dataRowIndex]
                          //                                           .getCells()[
                          //                                       1] = DataGridCell<
                          //                                           String>(
                          //                                       columnName:
                          //                                           'Date',
                          //                                       value: DateFormat(
                          //                                               'dd-MM-yyyy')
                          //                                           .format(
                          //                                               date!));
                          //                                   _dailyproject[
                          //                                           dataRowIndex]
                          //                                       .date = DateFormat(
                          //                                           'dd-MM-yyyy')
                          //                                       .format(date!);
                          //                                   notifyListeners();

                          //                                   Navigator.pop(
                          //                                       context);
                          //                                 }
                          //                               }),
                          //                             )),
                          //                       ));
                          //             },
                          //             icon: const Icon(Icons.calendar_today),
                          //           ),
                          //           Text(dataGridCell.value.toString()),
                          //         ],
                          //       )

                          : Text(
                              dataGridCell.value.toString(),
                              textAlign: TextAlign.center,
                              style: tablefontsize,
                            ));
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
    if (column.columnName == 'Date') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Date', value: newCellValue);
      _dailyproject[dataRowIndex].date = newCellValue;
    } else if (column.columnName == 'SiNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'SiNo', value: newCellValue);
      _dailyproject[dataRowIndex].siNo = newCellValue as int;
    } else if (column.columnName == 'TypeOfActivity') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'TypeOfActivity', value: newCellValue);
      _dailyproject[dataRowIndex].typeOfActivity = newCellValue;
    } else if (column.columnName == 'ActivityDetails') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'ActivityDetails', value: newCellValue);
      _dailyproject[dataRowIndex].activityDetails = newCellValue;
    } else if (column.columnName == 'Progress') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Progress', value: newCellValue);
      _dailyproject[dataRowIndex].progress = newCellValue;
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Status', value: newCellValue);
      _dailyproject[dataRowIndex].status = newCellValue;
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
    newCellValue = '';

    final bool isNumericType = column.columnName == 'SiNo';

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
            ? const TextInputType.numberWithOptions()
            : isDateTimeType
                ? TextInputType.datetime
                : TextInputType.text,
        onTapOutside: (event) {
          newCellValue = editingController.text;
        },
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else if (isDateTimeType) {
              newCellValue = value;
            } else {
              newCellValue = value;
            }
          }
        },
        onSubmitted: (String value) {
          newCellValue = value;

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
