import 'package:ev_pmis_app/O_AND_M/o&m_model/oAndM_dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../style.dart';

class OAndMDashboardDatasource extends DataGridSource {
  String cityName;
  String depoName;
  String userId;
  String selectedDate;
  BuildContext mainContext;
  String selectedCity;
  List<String> depotList;
  List<int> numOfChargers;
  List<int> faultsOccuredList;
  List<int> totalFaultsResolvedList;
  List<int> totalFaultPendingList;
  bool isCitySelected;
  List<String> chargerAvailabilityList = [];
  List<double> mttrData = [];
  bool isDateRangeSelected;
  int totalChargers;
  int totalFaultOccured;
  int totalFaultsResolved;
  int totalFaultPending;
  List data = [];

  OAndMDashboardDatasource(
      this._dailyproject,
      this.mainContext,
      this.cityName,
      this.depoName,
      this.selectedDate,
      this.userId,
      this.selectedCity,
      this.depotList,
      this.isCitySelected,
      this.numOfChargers,
      this.faultsOccuredList,
      this.totalFaultPending,
      this.totalFaultsResolved,
      this.mttrData,
      this.chargerAvailabilityList,
      this.isDateRangeSelected,
      this.totalChargers,
      this.totalFaultOccured,
      this.totalFaultPendingList,
      this.totalFaultsResolvedList) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = _dailyproject
        .map<DataGridRow>((dataGridRow) => dataGridRow.dataGridRow())
        .toList();
  }

  @override
  List<OAndMDashboardModel> _dailyproject = [];
  double totalMttrForConclusion = 0.0;
  List<DataGridRow> dataGridRows = [];
  final _dateFormatter = DateFormat.yMd();
  bool isTotalMttrConcluded = true;

  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int dataRowIndex = dataGridRows.indexOf(row);
    print(dataRowIndex);
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return dataGridCell.columnName == 'Location'
          ? dataGridRows.length - 1 == dataRowIndex
              ? Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: Text(
                    "Total",
                    textAlign: TextAlign.center,
                    style: tablefonttext,
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: Text(
                    isCitySelected ? selectedCity : "",
                    textAlign: TextAlign.center,
                    style: tablefonttext,
                  ),
                )
          : dataGridCell.columnName == 'chargers'
              ? dataGridRows.length - 1 == dataRowIndex
                  ? Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      child: Text(
                        totalChargers.toString(),
                        textAlign: TextAlign.center,
                        style: tablefonttext,
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      child: Text(
                        isCitySelected ? '${numOfChargers[dataRowIndex]}' : "",
                        textAlign: TextAlign.center,
                        style: tablefonttext,
                      ),
                    )
              : dataGridCell.columnName == 'buses'
                  ? Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      child: Text(
                        "10",
                        textAlign: TextAlign.center,
                        style: tablefonttext,
                      ),
                    )
                  : dataGridCell.columnName == 'Depotname'
                      ? Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: Text(
                            isCitySelected ? depotList[dataRowIndex] : "",
                            textAlign: TextAlign.center,
                            style: tablefonttext,
                          ),
                        )
                      : dataGridCell.columnName == 'faultOccured'
                          ? dataGridRows.length - 1 == dataRowIndex
                              ? Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                  ),
                                  child: Text(
                                    totalFaultOccured.toString(),
                                    textAlign: TextAlign.center,
                                    style: tablefonttext,
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                  ),
                                  child: Text(
                                    isCitySelected
                                        ? faultsOccuredList[dataRowIndex]
                                            .toString()
                                        : "",
                                    textAlign: TextAlign.center,
                                    style: tablefonttext,
                                  ),
                                )
                          : dataGridCell.columnName == 'totalFaultsResolved'
                              ? dataGridRows.length - 1 == dataRowIndex
                                  ? Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                      ),
                                      child: Text(
                                        totalFaultsResolved.toString(),
                                        textAlign: TextAlign.center,
                                        style: tablefonttext,
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                      ),
                                      child: Text(
                                        isCitySelected
                                            ? totalFaultsResolvedList[
                                                    dataRowIndex]
                                                .toString()
                                            : "",
                                        textAlign: TextAlign.center,
                                        style: tablefonttext,
                                      ),
                                    )
                              : dataGridCell.columnName == 'totalFaultsPending'
                                  ? dataGridRows.length - 1 == dataRowIndex
                                      ? Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0,
                                          ),
                                          child: Text(
                                            totalFaultPending.toString(),
                                            textAlign: TextAlign.center,
                                            style: tablefonttext,
                                          ),
                                        )
                                      : Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0,
                                          ),
                                          child: Text(
                                            isCitySelected
                                                ? totalFaultPendingList[
                                                        dataRowIndex]
                                                    .toString()
                                                : "",
                                            textAlign: TextAlign.center,
                                            style: tablefonttext,
                                          ),
                                        )
                                  : dataGridCell.columnName ==
                                          'chargerAvailability'
                                      ? Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0,
                                          ),
                                          child: Text(
                                            isDateRangeSelected
                                                ? '${chargerAvailabilityList[dataRowIndex]}%'
                                                : "",
                                            textAlign: TextAlign.center,
                                            style: tablefonttext,
                                          ),
                                        )
                                      : dataGridCell.columnName == 'chargerMttr'
                                          ? dataGridRows.length - 1 ==
                                                  dataRowIndex
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 5.0,
                                                  ),
                                                  child: Text(
                                                    getTotalMttr(),
                                                    textAlign: TextAlign.center,
                                                    style: tablefonttext,
                                                  ),
                                                )
                                              : Container(
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 5.0,
                                                  ),
                                                  child: Text(
                                                    isDateRangeSelected
                                                        ? getAverageMttr(
                                                            dataRowIndex)
                                                        : "",
                                                    textAlign: TextAlign.center,
                                                    style: tablefonttext,
                                                  ),
                                                )
                                          : dataGridCell.columnName == 'Sr.No.'
                                              ? dataGridRows.length - 1 ==
                                                      dataRowIndex
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.all(
                                                        2.0,
                                                      ),
                                                      child: Text(
                                                        " ",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: tablefonttext,
                                                      ),
                                                    )
                                                  : Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.all(
                                                        2.0,
                                                      ),
                                                      child: Text(
                                                        dataGridCell.value
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: tablefonttext,
                                                      ))
                                              : dataGridCell.columnName ==
                                                      "electricalMttr"
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.all(
                                                        2.0,
                                                      ),
                                                      child: Text(
                                                        "25.0",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: tablefonttext,
                                                      ),
                                                    )
                                                  : Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.all(
                                                        2.0,
                                                      ),
                                                      child: Text(
                                                        dataGridCell.value
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: tablefonttext,
                                                      ),
                                                    );
    }).toList());
  }

  void updateDatagridSource() {
    notifyListeners();
  }

  String getAverageMttr(int dataRowIndex) {
    final calculaterMttr =
        mttrData[dataRowIndex] / faultsOccuredList[dataRowIndex];
    if (calculaterMttr.isNaN) {
      return '0.00';
    }
    return calculaterMttr.toStringAsFixed(2);
  }

  String getTotalMttr() {
    totalMttrForConclusion = 0.0;
    if (mttrData.isNotEmpty) {
      for (int i = 0; i < faultsOccuredList.length; i++) {
        final calculaterMttr = mttrData[i] / faultsOccuredList[i];
        if (!calculaterMttr.isNaN) {
          totalMttrForConclusion = totalMttrForConclusion + calculaterMttr;
        }
      }
    }

    return totalMttrForConclusion.toStringAsFixed(2);
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
    if (column.columnName == 'Sr.No.') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Sr.No.', value: newCellValue);
      _dailyproject[dataRowIndex].srNo = newCellValue;
    } else if (column.columnName == 'Location') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Location', value: newCellValue);
      _dailyproject[dataRowIndex].location = newCellValue;
    } else if (column.columnName == 'Depotname') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Depotname', value: newCellValue);
      _dailyproject[dataRowIndex].depotName = newCellValue;
    } else if (column.columnName == 'chargers') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'chargers', value: newCellValue);
      _dailyproject[dataRowIndex].noOfChargers = int.parse(newCellValue);
    } else if (column.columnName == 'buses') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'buses', value: newCellValue);
      _dailyproject[dataRowIndex].noOfBuses = newCellValue;
    } else if (column.columnName == 'chargerAvailability') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'chargerAvailability', value: newCellValue);
      _dailyproject[dataRowIndex].chargerAvailability = newCellValue;
    } else if (column.columnName == 'faultOccured') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'faultOccured', value: newCellValue);
      _dailyproject[dataRowIndex].noOfFaultOccured = newCellValue;
    } else if (column.columnName == 'totalFaultsResolved') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'totalFaultsResolved', value: newCellValue);
      _dailyproject[dataRowIndex].totalFaultsResolved = newCellValue;
    } else if (column.columnName == 'totalFaultsPending') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'totalFaultsPending', value: newCellValue);
      _dailyproject[dataRowIndex].totalFaultsPending = newCellValue;
    } else if (column.columnName == "electricalMttr") {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'electricalMttr', value: newCellValue);
      _dailyproject[dataRowIndex].chargersMttr = newCellValue;
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'chargerMttr', value: newCellValue);
      _dailyproject[dataRowIndex].chargersMttr = newCellValue;
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
          contentPadding: EdgeInsets.only(
            left: 5,
            right: 5,
          ),
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
