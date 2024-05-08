import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../style.dart';
import '../models/energy_management.dart';

class EnergyManagementDatasource extends DataGridSource {
  BuildContext mainContext;
  String? userId;
  String? cityName;
  String? depoName;

  EnergyManagementDatasource(this._energyManagement, this.mainContext,
      this.userId, this.cityName, this.depoName) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = _energyManagement
        .map<DataGridRow>((dataGridRow) => dataGridRow.getDataGridRow())
        .toList();
  }

  @override
  List<EnergyManagementModel> _energyManagement = [];

  List<DataGridRow> dataGridRows = [];

  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();

  @override
  List<DataGridRow> get rows => dataGridRows;

  int? balnceQtyValue;
  double? perc;
  // String? startformattedTime = '12:30';
  // String? endformattedTime = '15:45';

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    void addRowAtIndex(int index, EnergyManagementModel rowData) {
      _energyManagement.insert(index, rowData);
      buildDataGridRows();
      notifyListeners();
      // notifyListeners(DataGridSourceChangeKind.rowAdd, rowIndexes: [index]);
    }

    void removeRowAtIndex(int index) {
      _energyManagement.removeAt(index);
      buildDataGridRows();
      notifyListeners();
    }

    DateTime? rangeStartDate = DateTime.now();
    DateTime? date;
    Duration difference;

    DateTime selectedDateTime = DateTime.now();

    Future<void> _selectDateTime(BuildContext context) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (pickedDate != null) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          selectedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
              pickedTime.minute % 60);
        }
      }
    }

    final int rowIndex = dataGridRows.indexOf(row);
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      DateTime startDate = DateFormat('dd-MM-yyyy HH:mm')
          .parse(_energyManagement[rowIndex].startDate);
      DateTime endDate = DateFormat('dd-MM-yyyy HH:mm')
          .parse(_energyManagement[rowIndex].endDate);

      difference = endDate.difference(startDate);

      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: (dataGridCell.columnName == 'startDate')
            ? Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      _selectDateTime(mainContext).whenComplete(() {
                        _energyManagement[rowIndex].startDate =
                            DateFormat('dd-MM-yyyy HH:mm')
                                .format(selectedDateTime);
                        //   // print(startformattedTime); //output 14:59:00
                        // print(selectedDateTime);
                        _energyManagement[rowIndex].timeInterval =
                            '${selectedDateTime.hour}:${selectedDateTime.minute} - ${selectedDateTime.add(const Duration(hours: 6)).hour}:${selectedDateTime.add(const Duration(hours: 6)).minute}';
                        buildDataGridRows();
                        notifyListeners();
                      });

                      // }
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                  Text(dataGridCell.value.toString()),
                ],
              )
            : (dataGridCell.columnName == 'endDate')
                ? Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          _selectDateTime(mainContext).whenComplete(() {
                            _energyManagement[rowIndex].endDate =
                                DateFormat('dd-MM-yyyy HH:mm')
                                    .format(selectedDateTime);
                            buildDataGridRows();
                            notifyListeners();
                          });
                        },
                        icon: const Icon(Icons.calendar_today),
                      ),
                      Text(dataGridCell.value.toString()),
                    ],
                  )
                : (dataGridCell.columnName == 'totalTime')
                    ? Text(
                        '${difference.inHours}:${difference.inMinutes % 60}:${difference.inSeconds % 60}')
                    : (dataGridCell.columnName == 'Add')
                        ? SizedBox(
                            width: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(blue),
                                  padding: const MaterialStatePropertyAll(
                                      EdgeInsets.zero)),
                              onPressed: () {
                                addRowAtIndex(
                                    rowIndex + 1,
                                    EnergyManagementModel(
                                        srNo: rowIndex + 2,
                                        depotName: depoName!,
                                        vehicleNo: 'vehicleNo',
                                        pssNo: 1,
                                        chargerId: 1,
                                        startSoc: 1,
                                        endSoc: 1,
                                        startDate:
                                            DateFormat('dd-MM-yyyy HH:mm')
                                                .format(DateTime.now()),
                                        endDate: DateFormat('dd-MM-yyyy HH:mm')
                                            .format(DateTime.now()),
                                        totalTime:
                                            DateFormat('dd-MM-yyyy HH:mm')
                                                .format(DateTime.now()),
                                        energyConsumed: 0.0,
                                        timeInterval:
                                            '${DateTime.now().hour}:${DateTime.now().minute} - ${DateTime.now().add(const Duration(hours: 6)).hour}:${DateTime.now().add(const Duration(hours: 6)).minute}'));
                              },
                              child: Text(
                                'Add',
                                style: uploadViewStyle,
                              ),
                            ),
                          )
                        : (dataGridCell.columnName == 'Delete')
                            ? IconButton(
                                onPressed: () {
                                  removeRowAtIndex(rowIndex);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: red,
                                ),
                              )
                            : Text(
                                dataGridCell.value.toString(),
                                textAlign: TextAlign.center,
                                style: tablefontsize,
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
          DataGridCell<dynamic>(columnName: 'srNo', value: newCellValue);
      _energyManagement[dataRowIndex].srNo = newCellValue;
    } else if (column.columnName == 'DepotName') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'DepotName', value: newCellValue);
      _energyManagement[dataRowIndex].depotName = newCellValue.toString();
    } else if (column.columnName == 'VehicleNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'VehicleNo', value: newCellValue);
      _energyManagement[dataRowIndex].vehicleNo = newCellValue;
    } else if (column.columnName == 'pssNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(
              columnName: 'pssNo', value: int.parse(newCellValue.toString()));
      _energyManagement[dataRowIndex].pssNo =
          int.parse(newCellValue.toString());
    } else if (column.columnName == 'chargerId') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(
              columnName: 'chargerId',
              value: int.parse(newCellValue.toString()));
      _energyManagement[dataRowIndex].chargerId =
          int.parse(newCellValue.toString());
    } else if (column.columnName == 'startSoc') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(
              columnName: 'startSoc',
              value: int.parse(newCellValue.toString()));
      _energyManagement[dataRowIndex].startSoc =
          int.parse(newCellValue.toString());
    } else if (column.columnName == 'endSoc') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(
              columnName: 'endSoc', value: int.parse(newCellValue.toString()));
      _energyManagement[dataRowIndex].endSoc =
          int.parse(newCellValue.toString());
    } else if (column.columnName == 'startDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<DateTime>(columnName: 'startDate', value: newCellValue);
      _energyManagement[dataRowIndex].startDate = newCellValue;
    } else if (column.columnName == 'EndDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'EndDate', value: newCellValue);
      _energyManagement[dataRowIndex].endDate = newCellValue;
    } else if (column.columnName == 'totalTime') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<DateTime>(columnName: 'totalTime', value: newCellValue);
      _energyManagement[dataRowIndex].totalTime = newCellValue;
    } else if (column.columnName == 'energyConsumed') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<double>(
              columnName: 'energyConsumed', value: newCellValue);
      _energyManagement[dataRowIndex].energyConsumed = newCellValue as double;
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(
              columnName: 'timeInterval', value: newCellValue);
      _energyManagement[dataRowIndex].timeInterval = newCellValue;
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

    final bool isNumericType = column.columnName == 'pssNo' ||
        column.columnName == 'chargerId' ||
        column.columnName == 'energyConsumed' ||
        column.columnName == 'endSoc' ||
        column.columnName == 'startSoc';

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
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(
            5.0,
          ),
        ),
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp),
        ],
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
            // if (column.columnName == 'energyConsumed') {
            //   newCellValue = double.parse(value);
            // }
            if (isNumericType) {
              newCellValue = double.parse(value);
            } else if (isDateTimeType) {
              newCellValue = value;
            } else {
              newCellValue = value;
            }
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
        ? RegExp('[0-9.]')
        : isDateTimeBoard
            ? RegExp('[0-9-]')
            : RegExp('[a-zA-Z0-9.@!#^&*(){+-}%|<>?_=+,/ )]');
  }
}
