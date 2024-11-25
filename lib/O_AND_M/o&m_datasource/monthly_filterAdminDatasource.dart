import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../o&m_model/monthly_filter.dart';
import '../../style.dart';

class MonthlyAdminFilterManagentDatasource extends DataGridSource {
  String cityName;
  String depoName;
  String userId;
  String selectedDate;
  BuildContext mainContext;

  List data = [];
  MonthlyAdminFilterManagentDatasource(this._dailyproject, this.mainContext,
      this.cityName, this.depoName, this.selectedDate, this.userId) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = _dailyproject
        .map<DataGridRow>((dataGridRow) => dataGridRow.dataGridRow())
        .toList();
  }

  @override
  List<MonthlyFilterModel> _dailyproject = [];

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
    DateTime? date;
    DateTime? rangeStartDate = DateTime.now();
    final int dataRowIndex = dataGridRows.indexOf(row);

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      void addRowAtIndex(int index, MonthlyFilterModel rowData) {
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
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child:
          //  (dataGridCell.columnName == 'date')
          //     ? Row(
          //         children: [
          //           IconButton(
          //             onPressed: () {
          //               showDialog(
          //                   context: mainContext,
          //                   builder: (context) => AlertDialog(
          //                         title: const Text('All Date'),
          //                         content: Container(
          //                             height: 400,
          //                             width: 500,
          //                             child: SfDateRangePicker(
          //                               view: DateRangePickerView.month,
          //                               showTodayButton: true,
          //                               onCancel: () {
          //                                 Navigator.pop(context);
          //                               },
          //                               onSelectionChanged:
          //                                   (DateRangePickerSelectionChangedArgs
          //                                       args) {
          //                                 if (args.value is PickerDateRange) {
          //                                   rangeStartDate =
          //                                       args.value.startDate;
          //                                 } else {
          //                                   final List<PickerDateRange>
          //                                       selectedRanges = args.value;
          //                                 }
          //                               },
          //                               selectionMode:
          //                                   DateRangePickerSelectionMode.single,
          //                               showActionButtons: true,
          //                               onSubmit: ((value) {
          //                                 date =
          //                                     DateTime.parse(value.toString());

          //                                 final int dataRowIndex =
          //                                     dataGridRows.indexOf(row);
          //                                 if (dataRowIndex != null) {
          //                                   final int dataRowIndex =
          //                                       dataGridRows.indexOf(row);
          //                                   dataGridRows[dataRowIndex]
          //                                           .getCells()[1] =
          //                                       DataGridCell<String>(
          //                                           columnName: 'date',
          //                                           value:
          //                                               DateFormat('dd-MM-yyyy')
          //                                                   .format(date!));
          //                                   _dailyproject[dataRowIndex].date =
          //                                       DateFormat('dd-MM-yyyy')
          //                                           .format(date!);
          //                                   notifyListeners();

          //                                   Navigator.pop(context);
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
          //     : (dataGridCell.columnName == 'Add')
          //         ? ElevatedButton(
          //             onPressed: () {
          //               // isShowPinIcon.add(false);
          //               addRowAtIndex(
          //                   dataRowIndex + 1,
          //                   MonthlyFilterModel(
          //                       cn: dataRowIndex + 2,
          //                       date:
          //                           DateFormat.yMMMMd().format(DateTime.now()),
          //                       fcd: '',
          //                       dgcd: ''));
          //             },
          //             child: Text('Add', style: tablefonttext))
          //         : (dataGridCell.columnName == 'Delete')
          //             ? IconButton(
          //                 onPressed: () async {
          //                   // FirebaseFirestore.instance
          //                   //     .collection('DailyProjectReport')
          //                   //     .doc(depoName)
          //                   //     .collection('Daily Data')
          //                   //     .doc(DateFormat.yMMMMd().format(DateTime.now()))
          //                   //     .update({
          //                   //   'data': FieldValue.arrayRemove([0])
          //                   // });
          //                   removeRowAtIndex(dataRowIndex);
          //                 },
          //                 icon: Icon(
          //                   Icons.delete,
          //                   color: red,
          //                   size: 15,
          //                 ))
          //             : 
                      Text(
                          dataGridCell.value.toString(),
                          textAlign: TextAlign.center,
                          style: tablefonttext,
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
    if (column.columnName == 'cn') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'cn', value: newCellValue);
      _dailyproject[dataRowIndex].cn = newCellValue;
    }
    if (column.columnName == 'date') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'date', value: newCellValue);
      _dailyproject[dataRowIndex].date = newCellValue;
    } else if (column.columnName == 'fcd') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'fcd', value: newCellValue);
      _dailyproject[dataRowIndex].fcd = newCellValue;
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'dgcd', value: newCellValue);
      _dailyproject[dataRowIndex].dgcd = newCellValue;
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

    final bool isNumericType = column.columnName == 'sfuNo';

    final bool isDateTimeType = column.columnName == 'StartDate' ||
        column.columnName == 'EndDate' ||
        column.columnName == 'ActualStart' ||
        column.columnName == 'ActualEnd';
    // Holds regular expression pattern based on the column type.
    final RegExp regExp =
        _getRegExp(isNumericType, isDateTimeType, column.columnName);

    return Container(
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        style: tablefonttext,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 5, right: 5),
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
            newCellValue;
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
