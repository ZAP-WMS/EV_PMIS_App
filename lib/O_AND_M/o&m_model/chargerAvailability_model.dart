import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ChargerAvailabilityModel {
  ChargerAvailabilityModel({
    required this.srNo,
    required this.location,
    required this.depotName,
    required this.chargerNo,
    required this.chargerSrNo,
    required this.chargerMake,
    required this.targetTime,
    required this.timeLoss,
    required this.availability,
    required this.remarks,
  });

  int? srNo;
  String? location;
  String? depotName;
  String chargerNo;
  String chargerSrNo;
  String chargerMake;
  dynamic targetTime;
  dynamic timeLoss;
  dynamic availability;
  String remarks;

  factory ChargerAvailabilityModel.fromjson(Map<String, dynamic> json) {
    return ChargerAvailabilityModel(
      srNo: json['Sr.No.'],
      location: json['Location'],
      depotName: json['Depot name'],
      chargerNo: json['ChargerNo'],
      chargerSrNo: json['ChargerSrNo'],
      chargerMake: json['ChargerMake'],
      targetTime: json['TargetTime'],
      timeLoss: json['TimeLoss'],
      availability: json['Availability'],
      remarks: json['Remarks'],
    );
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'Sr.No.', value: srNo),
      DataGridCell(columnName: 'Location', value: location),
      DataGridCell(columnName: 'Depot name', value: depotName),
      DataGridCell(columnName: 'ChargerNo', value: chargerNo),
      DataGridCell(columnName: 'ChargerSrNo', value: chargerSrNo),
      DataGridCell(columnName: 'ChargerMake', value: chargerMake),
      DataGridCell(columnName: 'TargetTime', value: targetTime),
      DataGridCell(columnName: 'TimeLoss', value: timeLoss),
      DataGridCell(columnName: 'Availability', value: availability),
      DataGridCell(columnName: 'Remarks', value: remarks),
      const DataGridCell(columnName: 'Delete', value: null),
    ]);
  }

  factory ChargerAvailabilityModel.fromExcelRow(List<dynamic> row) {
    return ChargerAvailabilityModel(
        srNo: row[0],
        location: row[1],
        depotName: row[2],
        chargerNo: row[3],
        chargerSrNo: row[4],
        chargerMake: row[5],
        targetTime: row[6] ?? '',
        timeLoss: row[7] ?? '',
        availability: row[8] ?? '',
        remarks: row[9] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'srNo': srNo,
      'location': location,
      'depotName': depotName,
      'chargerNo': chargerNo,
      'chargerSerialNo': chargerNo,
      'chargerMake': chargerMake,
      'targetTimeInHrs': targetTime,
      'totalTimeLoss': timeLoss,
      'availability': availability,
      'remarks': remarks,
    };
  }
}
