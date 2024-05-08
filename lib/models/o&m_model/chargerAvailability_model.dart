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
  int targetTime;
  int timeLoss;
  double availability;
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

      DataGridCell(columnName: 'Chargers affected', value: chargerMake),
      // DataGridCell(columnName: 'Fault Type', value: faultType),
      // DataGridCell(columnName: 'Fault', value: fault),
      // DataGridCell(columnName: 'Attribute to', value: attributeTo),
      // DataGridCell(columnName: 'Fault Occurrance', value: faultOccurance),
      // DataGridCell(columnName: 'Fault Resolving', value: faultResolving),
      // DataGridCell(columnName: 'Year', value: year),
      // DataGridCell(columnName: 'Month', value: month),
      // DataGridCell(columnName: 'Fault Resolve by', value: faultResolvedBy),
      // DataGridCell(columnName: 'Status', value: status),
      // DataGridCell(columnName: 'Pending', value: pending),
      // DataGridCell(columnName: 'MTTR', value: mttr),
      // DataGridCell(columnName: 'Remarks', value: remark)
    ]);
  }
}
