import 'package:collection/collection.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../models/safety_checklistModel.dart';
import '../../view_AllFiles.dart';
import '../screen/upload.dart';

class SafetyChecklistDataSource extends DataGridSource {
  // BuildContext mainContext;
  String cityName;
  String depoName;
  dynamic userId;
  String selectedDate;
  SafetyChecklistDataSource(this._checklistModel, this.cityName, this.depoName,
      this.userId, this.selectedDate) {
    buildDataGridRows();
  }
  void buildDataGridRows() {
    dataGridRows = _checklistModel
        .map<DataGridRow>((dataGridRow) => dataGridRow.getDataGridRow())
        .toList();
  }

  @override
  List<SafetyChecklistModel> _checklistModel = [];

  List<DataGridRow> dataGridRows = [];
  final _dateFormatter = DateFormat.yMd();

  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();
  final DateRangePickerController _controller = DateRangePickerController();
  TextStyle textStyle = const TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Colors.black87);
  List<String> statusMenuItems = [
    'Yes',
    'No',
    'Not Applicable',
  ];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: dataGridCell.columnName == 'Photo'
              ? LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SizedBox(
                      width: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(blue),
                            padding: const MaterialStatePropertyAll(
                                EdgeInsets.zero)),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UploadDocument(
                              title: 'SafetyChecklist',
                              cityName: cityName,
                              depoName: depoName,
                              fldrName: row.getCells()[0].value.toString(),
                              userId: userId,
                              date: selectedDate,
                            ),
                          ));
                        },
                        child: Text(
                          'Upload',
                          style: uploadViewStyle,
                        ),
                      ),
                    );
                  },
                )
              : dataGridCell.columnName == 'ViewPhoto'
                  ? LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return SizedBox(
                          width: 50,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(blue),
                                  padding: const MaterialStatePropertyAll(
                                      EdgeInsets.zero)),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ViewAllPdf(
                                      title: 'SafetyChecklist',
                                      cityName: cityName,
                                      depoName: depoName,
                                      userId: userId,
                                      date: selectedDate,
                                      docId: row.getCells()[0].value.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'View',
                                style: uploadViewStyle,
                              )),
                        );
                      },
                    )
                  : dataGridCell.columnName == 'Status'
                      ? DropdownButton<String>(
                          value: dataGridCell.value,
                          focusColor: Colors.transparent,
                          underline: const SizedBox.shrink(),
                          icon: const Icon(Icons.arrow_drop_down_sharp),
                          isExpanded: true,
                          style: textStyle,
                          onChanged: (String? value) {
                            final dynamic oldValue = row
                                    .getCells()
                                    .firstWhereOrNull((DataGridCell dataCell) =>
                                        dataCell.columnName ==
                                        dataGridCell.columnName)
                                    ?.value ??
                                '';
                            if (oldValue == value || value == null) {
                              return;
                            }

                            final int dataRowIndex = dataGridRows.indexOf(row);
                            dataGridRows[dataRowIndex].getCells()[2] =
                                DataGridCell<String>(
                                    columnName: 'Status', value: value);
                            _checklistModel[dataRowIndex].status =
                                value.toString();
                            notifyListeners();
                          },
                          items: statusMenuItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList())
                      : Text(dataGridCell.value.toString(),
                          style: const TextStyle(fontSize: 12)));
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
    if (column.columnName == 'srNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'srNo', value: newCellValue);
      _checklistModel[dataRowIndex].srNo = newCellValue;
    } else if (column.columnName == 'Details') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Details', value: newCellValue);
      _checklistModel[dataRowIndex].details = newCellValue.toString();
    } else if (column.columnName == 'Status') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Status', value: newCellValue);
      _checklistModel[dataRowIndex].status = newCellValue.toString();
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Remark', value: newCellValue);
      _checklistModel[dataRowIndex].remark = newCellValue as dynamic;
    }
    //  else {
    //   dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
    //       DataGridCell<double>(columnName: 'photoNo', value: newCellValue);
    //   _checklistModel[dataRowIndex].photo = newCellValue;
    // }
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
    newCellValue;

    final bool isNumericType = column.columnName == 'srNo';

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
        style: const TextStyle(fontSize: 12),
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp),
        ],
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(
            5.0,
          ),
        ),
        keyboardType: isNumericType
            ? TextInputType.number
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
