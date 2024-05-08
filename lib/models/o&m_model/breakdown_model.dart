import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BreakdownModel {
  BreakdownModel({
    required this.srNo,
    required this.location,
    required this.depotName,
    required this.equipmentName,
    required this.chargersAffected,
    required this.faultType,
    required this.fault,
    required this.attributeTo,
    required this.faultOccurance,
    required this.faultResolving,
    required this.year,
    required this.month,
    required this.agencyName,
    required this.faultResolvedBy,
    required this.status,
    required this.pending,
    required this.mttr,
    required this.remark,
  });

  int? srNo;
  String? location;
  String? depotName;
  String? equipmentName;
  String? chargersAffected;
  String? faultType;
  String? fault;
  String? attributeTo;
  String? faultOccurance;
  String? faultResolving;
  String? year;
  String? month;
  String? agencyName;
  String? faultResolvedBy;
  String? status;
  String? pending;
  String? mttr;
  String? remark;

  factory BreakdownModel.fromjson(Map<String, dynamic> json) {
    return BreakdownModel(
        srNo: json['Sr.No.'],
        location: json['Location'],
        depotName: json['Depot name'],
        equipmentName: json['Equipment Name'],
        chargersAffected: json['Chargers affected'],
        faultType: json['Fault Type'],
        fault: json['Fault'],
        attributeTo: json['Attribute to'],
        faultOccurance: json['Fault Occurrance'],
        faultResolving: json['Fault Resolving'],
        year: json['Year'],
        month: json['Month'],
        agencyName: json['AgencyName'],
        faultResolvedBy: json['Fault Resolve by'],
        status: json['Status'],
        pending: json['Pending'],
        mttr: json['MTTR'],
        remark: json['Remarks']);
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'Sr.No.', value: srNo),
      DataGridCell(columnName: 'Location', value: location),
      DataGridCell(columnName: 'Depot name', value: depotName),
      DataGridCell(columnName: 'Equipment Name', value: equipmentName),
      DataGridCell(columnName: 'Chargers affected', value: chargersAffected),
      DataGridCell(columnName: 'Fault Type', value: faultType),
      DataGridCell(columnName: 'Fault', value: fault),
      DataGridCell(columnName: 'Attribute to', value: attributeTo),
      DataGridCell(columnName: 'Fault Occurrance', value: faultOccurance),
      DataGridCell(columnName: 'Fault Resolving', value: faultResolving),
      DataGridCell(columnName: 'Year', value: year),
      DataGridCell(columnName: 'Month', value: month),
      DataGridCell(columnName: 'AgencyName', value: agencyName),
      DataGridCell(columnName: 'Fault Resolve by', value: faultResolvedBy),
      DataGridCell(columnName: 'Status', value: status),
      DataGridCell(columnName: 'Pending', value: pending),
      DataGridCell(columnName: 'MTTR', value: mttr),
      DataGridCell(columnName: 'Remarks', value: remark)
    ]);
  }
}
