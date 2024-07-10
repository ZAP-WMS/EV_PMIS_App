import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ev_pmis_app/O_AND_M/o&m_model/chargerAvailability_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../style.dart';

class ChargerAvailabilityDataSource extends DataGridSource {
  String cityName;
  String depoName;
  String userId;
  String selectedDate;
  bool toShowTimeloss;
  int targetTime;
  Map<String, dynamic> mttrData;
  BuildContext mainContext;

  List data = [];
  ChargerAvailabilityDataSource(
      this._dailyproject,
      this.mainContext,
      this.cityName,
      this.depoName,
      this.selectedDate,
      this.userId,
      this.toShowTimeloss,
      this.mttrData,
      this.targetTime) {
    buildDataGridRows();
    setDropDownValue();
  }

  void buildDataGridRows() {
    dataGridRows = _dailyproject
        .map<DataGridRow>((dataGridRow) => dataGridRow.dataGridRow())
        .toList();
  }

  @override
  List<ChargerAvailabilityModel> _dailyproject = [];
  List<String?> charTransDropDownValue = [];
  final dropdownController = TextEditingController();
  List<String> chargersTranformersList = [
    'Charger No. 1',
    'Charger No. 2',
    'Charger No. 3',
    'Charger No. 4',
    'Charger No. 5',
    'Charger No. 6',
    'Charger No. 7',
    'Charger No. 8',
    'Charger No. 9',
    'Charger No. 10',
    'Charger No. 11',
    'Charger No. 12',
    'Charger No. 13',
    'Charger No. 14',
    'Charger No. 15',
    'Charger No. 16',
    'Charger No. 17',
    'Charger No. 18',
    'Charger No. 19',
    'Charger No. 20',
    'Charger No. 21',
    'Charger No. 22',
    'Charger No. 23',
    'Charger No. 24',
    'Charger No. 25',
    'Charger No. 26',
    'Charger No. 27',
    'Charger No. 28',
    'Charger No. 29',
    'Charger No. 30',
    'Charger No. 31',
    'Charger No. 32',
    'Charger No. 33',
    'Charger No. 34',
    'Charger No. 35',
    'Charger No. 36',
    'Charger No. 37',
    'Charger No. 38',
    'Charger No. 39',
    'Charger No. 40',
    'SFU Panel 1',
    'SFU Panel 2',
    'SFU Panel 3',
    'SFU Panel 4',
    'SFU Panel 5',
    'SFU Panel 6',
    'SFU Panel 7',
    'SFU Panel 8',
    'SFU Panel 9',
    'SFU Panel 10',
    'SFU Panel 11',
    'SFU Panel 12',
    'SFU Panel 13',
    'SFU Panel 14',
    'SFU Panel 15',
    'SFU Panel 16',
    'SFU Panel 17',
    'SFU Panel 18',
    'SFU Panel 19',
    'SFU Panel 20',
    'SFU Panel 21',
    'SFU Panel 22',
    'SFU Panel 23',
    'SFU Panel 24',
    'SFU Panel 25',
    'SFU Panel 26',
    'SFU Panel 27',
    'SFU Panel 28',
    'SFU Panel 29',
    'SFU Panel 30',
    'SFU Panel 31',
    'SFU Panel 32',
    'SFU Panel 33',
    'SFU Panel 34',
    'SFU Panel 35',
    'SFU Panel 36',
    'SFU Panel 37',
    'SFU Panel 38',
    'SFU Panel 39',
    'SFU Panel 40',
    'ACDB- MCCB-1',
    'ACDB- MCCB-2',
    'ACDB- MCCB-3',
    'ACDB- MCCB-4',
    'ACDB- MCCB-5',
    'ACDB- MCCB-6',
    'ACDB- MCCB-7',
    'ACDB- MCCB-8',
    'ACDB- MCCB-9',
    'ACDB- MCCB-10',
    'ACDB- MCCB-11',
    'ACDB- MCCB-12',
    'ACDB- MCCB-13',
    'ACDB- MCCB-14',
    'ACDB- MCCB-15',
    'ACDB- MCCB-16',
    'ACDB- MCCB-17',
    'ACDB- MCCB-18',
    'ACDB- MCCB-19',
    'ACDB- MCCB-20',
    'ACDB- MCCB-21',
    'ACDB- MCCB-22',
    'ACDB- MCCB-23',
    'ACDB- MCCB-24',
    'ACDB- MCCB-25',
    'ACDB- MCCB-26',
    'ACDB- MCCB-27',
    'ACDB- MCCB-28',
    'ACDB- MCCB-29',
    'ACDB- MCCB-30',
    'ACDB- MCCB-31',
    'ACDB- MCCB-32',
    'ACDB- MCCB-33',
    'ACDB- MCCB-34',
    'ACDB- MCCB-35',
    'ACDB- MCCB-36',
    'ACDB- MCCB-37',
    'ACDB- MCCB-38',
    'ACDB- MCCB-39',
    'ACDB- MCCB-40',
    'ACDB- MCCB-41',
    'ACDB- MCCB-42',
    'ACDB- MCCB-43',
    'ACDB- MCCB-44',
    'ACDB- MCCB-45',
    'ACDB- MCCB-46',
    'ACDB- MCCB-47',
    'ACDB- MCCB-48',
    'ACDB- MCCB-49',
    'ACDB- MCCB-50',
    'ACDB- MCCB-51',
    'ACDB- MCCB-52',
    'ACDB- MCCB-53',
    'ACDB- MCCB-54',
    'ACDB- MCCB-55',
    'ACDB- MCCB-56',
    'ACDB- MCCB-57',
    'ACDB- MCCB-58',
    'ACDB- MCCB-59',
    'ACDB- MCCB-60',
    'MCCB Panel 1',
    'MCCB Panel 2',
    'MCCB Panel 3',
    'MCCB Panel 4',
    'MCCB Panel 5',
    'MCCB Panel 6',
    'MCCB Panel 7',
    'MCCB Panel 8',
    'MCCB Panel 9',
    'MCCB Panel 10',
    'MCCB Panel 11',
    'MCCB Panel 12',
    'MCCB Panel 13',
    'MCCB Panel 14',
    'MCCB Panel 15',
    'MCCB Panel 16',
    'MCCB Panel 17',
    'MCCB Panel 18',
    'MCCB Panel 19',
    'MCCB Panel 20',
    'MCCB Panel 21',
    'MCCB Panel 22',
    'MCCB Panel 23',
    'MCCB Panel 24',
    'MCCB Panel 25',
    'MCCB Panel 26',
    'MCCB Panel 27',
    'MCCB Panel 28',
    'MCCB Panel 29',
    'MCCB Panel 30',
    'MCCB Panel 31',
    'MCCB Panel 32',
    'MCCB Panel 33',
    'MCCB Panel 34',
    'MCCB Panel 35',
    'MCCB Panel 36',
    'MCCB Panel 37',
    'MCCB Panel 38',
    'MCCB Panel 39',
    'MCCB Panel 40',
    'ACDB Panel Incomer 1',
    'ACDB Panel Incomer 2',
    'ACDB Panel Incomer 3',
    'ACDB Panel Incomer 4',
    'ACDB Panel Incomer 5',
    'ACDB Panel Incomer 6',
    'ACDB Panel Incomer 7',
    'ACDB Panel Incomer 8',
    'Transformer 1',
    'Transformer 2',
    'Transformer 3',
    'Transformer 4',
    'Transformer 5',
    'Transformer 6',
    'Transformer 7',
    'Transformer 8',
    '1Way  RMU 1',
    '1Way  RMU 2',
    '1Way  RMU 3',
    '3Way  RMU 1',
    '3Way  RMU 2',
    '3Way  RMU 3',
    '4Way  RMU 1',
    '4Way  RMU 2',
    '4Way  RMU 3',
    'CT PT Panel 1',
    'CT PT Panel 2',
    'CT PT Panel 3'
  ];

  void setDropDownValue() {
    charTransDropDownValue =
        List<String?>.generate(dataGridRows.length, (index) => null);
  }

  List<DataGridRow> dataGridRows = [];
  final _dateFormatter = DateFormat.yMd();

  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int dataRowIndex = dataGridRows.indexOf(row);
    if (charTransDropDownValue.length - 1 < dataRowIndex) {
      charTransDropDownValue.add(null);
    }
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      void removeRowAtIndex(int index) {
        _dailyproject.removeAt(index);
        buildDataGridRows();
        notifyListeners();
      }

      return dataGridCell.columnName == 'Delete'
          ? IconButton(
              padding: const EdgeInsets.all(0.0),
              onPressed: () async {
                removeRowAtIndex(dataRowIndex);
                dataGridRows.remove(row);
                notifyListeners();
              },
              icon: Icon(
                Icons.delete,
                color: red,
              ),
            )
          : dataGridCell.columnName == 'TimeLoss'
              ? Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: Text(
                    toShowTimeloss
                        ? mttrData[row.getCells()[3].value.toString()]
                            .toString()
                        : dataGridCell.value.toString(),
                    textAlign: TextAlign.center,
                    style: tablefonttext,
                  ),
                )
              : dataGridCell.columnName == 'Availability'
                  ? Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      child: Text(
                        toShowTimeloss
                            ? calculateAvailability(targetTime,
                                mttrData[row.getCells()[3].value.toString()])
                            : dataGridCell.value.toString(),
                        textAlign: TextAlign.center,
                        style: tablefonttext,
                      ),
                    )
                  : dataGridCell.columnName == "ChargerNo"
                      ? customDropdown(dataRowIndex, "ChargerNo",
                          dataGridCell.value.toString())
                      : Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: Text(
                            dataGridCell.value.toString(),
                            textAlign: TextAlign.center,
                            style: tablefonttext,
                          ),
                        );
    }).toList());
  }

  Widget customDropdown(int dataRowIndex, String columnName, String hintValue) {
    return Container(
      height: 30.0,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isDense: true,
          isExpanded: true,
          dropdownStyleData: DropdownStyleData(
            scrollbarTheme: ScrollbarThemeData(
              thumbVisibility: const MaterialStatePropertyAll(
                true,
              ),
              interactive: true,
              thumbColor: MaterialStatePropertyAll(
                blue,
              ),
            ),
            maxHeight: 300,
          ),
          dropdownSearchData: columnName == 'ChargerNo'
              ? DropdownSearchData(
                  searchController: dropdownController,
                  searchInnerWidget: Container(
                    margin:
                        const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Search...",
                          contentPadding: const EdgeInsets.only(left: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              5.0,
                            ),
                            borderSide: BorderSide(
                              color: blue,
                            ),
                          )),
                      controller: dropdownController,
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value.toString().toLowerCase().contains(
                          searchValue.toLowerCase(),
                        );
                  },
                  searchInnerWidgetHeight: 30,
                )
              : null,
          hint: Text(
            hintValue,
            style: TextStyle(color: blue),
          ),
          style: TextStyle(
            color: blue,
          ),
          value: columnName == 'ChargerNo'
              ? charTransDropDownValue[dataRowIndex]
              : null,
          items: List.generate(
              columnName == 'ChargerNo' ? chargersTranformersList.length : 2,
              (index) {
            return DropdownMenuItem(
              value: columnName == 'ChargerNo'
                  ? chargersTranformersList[index]
                  : null,
              child: Text(
                chargersTranformersList[index],
              ),
            );
          }),
          onChanged: (value) {
            switch (columnName) {
              case 'ChargerNo':
                charTransDropDownValue[dataRowIndex] = value.toString();
                _dailyproject[dataRowIndex].chargerNo = value.toString();
                break;
            }
            buildDataGridRows();
            notifyListeners();
          },
        ),
      ),
    );
  }

  String calculateAvailability(int targetTime, double timeLoss) {
    double availability = ((targetTime - timeLoss) / targetTime) * 100;

    return '${availability.toStringAsFixed(2)}%';
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
    if (column.columnName == 'Sr.No.') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'Sr.No.', value: newCellValue);
      _dailyproject[dataRowIndex].srNo = newCellValue;
    } else if (column.columnName == 'Location') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'Location', value: newCellValue);
      _dailyproject[dataRowIndex].location = newCellValue;
    } else if (column.columnName == 'Depot name') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'Depot name', value: newCellValue);
      _dailyproject[dataRowIndex].depotName = newCellValue;
    } else if (column.columnName == 'ChargerNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'ChargerNo', value: newCellValue);
      _dailyproject[dataRowIndex].chargerNo = newCellValue;
    } else if (column.columnName == 'ChargerSrNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'ChargerSrNo', value: newCellValue);
      _dailyproject[dataRowIndex].chargerSrNo = newCellValue;
    } else if (column.columnName == 'ChargerMake') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'ChargerMake', value: newCellValue);
      _dailyproject[dataRowIndex].chargerMake = newCellValue;
    } else if (column.columnName == 'TargetTime') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'TargetTime', value: newCellValue);
      _dailyproject[dataRowIndex].targetTime = newCellValue;
    } else if (column.columnName == 'TimeLoss') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'TimeLoss', value: newCellValue);
      _dailyproject[dataRowIndex].timeLoss = newCellValue;
    } else if (column.columnName == 'Availability') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<double>(
              columnName: 'Availability',
              value: double.parse(newCellValue.toString()));
      _dailyproject[dataRowIndex].availability = newCellValue;
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'Remarks', value: newCellValue);
      _dailyproject[dataRowIndex].remarks = newCellValue;
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

    final bool isNumericType = (column.columnName == 'Sr.No.' ||
        column.columnName == 'Availability' ||
        column.columnName == 'Sr.No.' ||
        column.columnName == 'TimeLoss' ||
        column.columnName == 'TargetTime');

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
}
