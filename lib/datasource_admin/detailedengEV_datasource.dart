import 'package:ev_pmis_app/model_admin/detailed_engModel.dart';
import 'package:ev_pmis_app/views/citiespage/depot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../style.dart';
import 'package:ev_pmis_app/widgets/upload.dart';
import '../views/overviewpage/view_AllFiles.dart';

class DetailedEngSourceEV extends DataGridSource {
  String cityName;
  String depoName;
  BuildContext mainContext;
  String? role;
  // String userId;
  DetailedEngSourceEV(this._detailedengev, this.mainContext, this.cityName,
      this.depoName, this.role) {
    buildDataGridRowsEV();
  }
  void buildDataGridRowsEV() {
    dataGridRows = _detailedengev
        .map<DataGridRow>((dataGridRow) => dataGridRow.dataGridRow())
        .toList();
  }

  @override
  List<DetailedEngModelAdmin> _detailedengev = [];
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

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        // color: getcolor(),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: (dataGridCell.columnName == 'Delete')
            ? IconButton(
                onPressed: () {
                  dataGridRows.remove(row);
                  notifyListeners();
                },
                icon: Icon(
                  Icons.delete,
                  color: red,
                ),
              )
            : dataGridCell.columnName == 'button'
                ? LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                    return SizedBox(
                      width: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: blue),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UploadDocument(
                                  title: '',
                                  cityName: cityName,
                                  depoName: depoName,
                                  fldrName: row.getCells()[1].value.toString(),
                                  userId: userId,
                                ),
                              ),
                            );
                          },
                          child: Text('Upload',
                          style: uploadViewStyle,),),
                    );
                  })
                : dataGridCell.columnName == 'ViewDrawing'
                    ? LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                        return ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: blue,
                              padding: const EdgeInsets.all(0.0)),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ViewAllPdf(
                                    role: role,
                                    title: 'DetailedEngEV',
                                    cityName: cityName,
                                    depoName: depoName,
                                    userId: userId,
                                    docId:
                                        '${row.getCells()[4].value.toString().trim()}/${row.getCells()[0].value.toString().trim()}')));
                          },
                          child: Text(
                            'View',
                            style: uploadViewStyle,
                          ),
                        );
                      })
                    : dataGridCell.columnName == 'Number' &&
                            dataGridCell.value == 0
                        ? const Text('')
                        : (dataGridCell.columnName == 'PreparationDate') &&
                                dataGridCell.value != ''
                            ? Text(
                                dataGridCell.value.toString(),
                                style: const TextStyle(fontSize: 12),
                              )
                            : (dataGridCell.columnName == 'SubmissionDate') &&
                                    dataGridCell.value != ''
                                ? Text(
                                    dataGridCell.value.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  )
                                : (dataGridCell.columnName == 'ApproveDate') &&
                                        dataGridCell.value != ''
                                    ? Text(
                                        dataGridCell.value.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      )
                                    : (dataGridCell.columnName ==
                                                'ReleaseDate') &&
                                            dataGridCell.value != ''
                                        ? Text(
                                            dataGridCell.value.toString(),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          )
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
          DataGridCell<int>(columnName: 'SiNo', value: newCellValue);
      _detailedengev[dataRowIndex].siNo = newCellValue;
    } else if (column.columnName == 'Number') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'Number', value: newCellValue);
      _detailedengev[dataRowIndex].number = newCellValue;
    } else if (column.columnName == 'Title') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Title', value: newCellValue);
      _detailedengev[dataRowIndex].title = newCellValue.toString();
    } else if (column.columnName == 'PreparationDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(
              columnName: 'PreparationDate', value: newCellValue as int);
      _detailedengev[dataRowIndex].preparationDate = newCellValue;
    } else if (column.columnName == 'SubmissionDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'SubmissioinDate', value: newCellValue);
      _detailedengev[dataRowIndex].submissionDate = newCellValue;
    } else if (column.columnName == 'ApproveDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'ApproveDate', value: newCellValue);
      _detailedengev[dataRowIndex].approveDate = newCellValue;
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'ReleaseDate', value: newCellValue);
      _detailedengev[dataRowIndex].releaseDate = newCellValue;
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

    final bool isNumericType =
        column.columnName == 'SiNo' || column.columnName == 'Number';
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
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        decoration: const InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
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
            : RegExp('[a-zA-Z ]');
  }
}
