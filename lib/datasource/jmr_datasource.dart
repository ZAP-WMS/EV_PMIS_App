import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:ev_pmis_app/style.dart';

import '../models/jmr.dart';

class JmrDataSource extends DataGridSource {

  Function deleteRow;
  JmrDataSource(this._JMRModels, this.deleteRow) {
    buildDataGridRows();
  }
  
  void buildDataGridRows() {
    dataGridRows =
        _JMRModels.map<DataGridRow>((dataGridRow) => dataGridRow.dataGridRow())
            .toList();
  }

  @override
  List<JMRModel> _JMRModels = [];

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
    final int dataIndex = dataGridRows.indexOf(row);

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: (dataGridCell.columnName == 'Delete')
            ? IconButton(
                onPressed: () async {
                  dataGridRows.remove(row);
                  notifyListeners();
                  deleteRow(dataIndex);
                },
                icon: Icon(
                  Icons.delete,
                  color: red,
                ))
            : Text(
                dataGridCell.value.toString(),
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
    if (column.columnName == 'srNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(
              columnName: 'srNo', value: int.parse(newCellValue.toString()));
      _JMRModels[dataRowIndex].srNo = newCellValue as int;
    } else if (column.columnName == 'Description') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Description', value: newCellValue);
      _JMRModels[dataRowIndex].Description = newCellValue.toString();
    } else if (column.columnName == 'Activity') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Activity', value: newCellValue);
      _JMRModels[dataRowIndex].Activity = newCellValue.toString();
    } else if (column.columnName == 'RefNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(
              columnName: 'RefNo', value: newCellValue as int);
      _JMRModels[dataRowIndex].RefNo = newCellValue as dynamic;
    } else if (column.columnName == 'Abstract') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Abstract', value: newCellValue);
      _JMRModels[dataRowIndex].JmrAbstract = newCellValue;
    } else if (column.columnName == 'UOM') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'UOM', value: newCellValue);
      _JMRModels[dataRowIndex].Uom = newCellValue;
    } else if (column.columnName == 'Rate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<double>(
        columnName: 'Rate',
        value: double.parse(
          newCellValue.toString().isEmpty ? '0.0' : newCellValue.toString(),
        ),
      );
      _JMRModels[dataRowIndex].rate = newCellValue;
    } else if (column.columnName == 'TotalQty') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(
        columnName: 'TotalQty',
        value: int.parse(
          newCellValue.toString().isEmpty ? '0' : newCellValue.toString(),
        ),
      );
      _JMRModels[dataRowIndex].TotalQty = newCellValue;
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<double>(
              columnName: 'TotalAmount',
              value: double.parse(
                newCellValue.toString().isEmpty
                    ? '0.0'
                    : newCellValue.toString(),
              ));
      _JMRModels[dataRowIndex].TotalAmount = newCellValue;
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

    newCellValue = '';

    final bool isNumericType = column.columnName == 'srNo' ||
        column.columnName == 'Rate' ||
        column.columnName == 'TotalQty' ||
        column.columnName == 'TotalAmount' ||
        column.columnName == 'RefNo';

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
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp),
        ],
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 5.0,),),
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

  int getIndex(int rowIndex) {
    return rowIndex;
  }
}
