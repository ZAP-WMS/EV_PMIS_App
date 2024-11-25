import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DailyRmuAdminModel {
  DailyRmuAdminModel({
    required this.date,
    required this.rmuNo,
    required this.sgp,
    required this.vpi,
    required this.crd,
    required this.rec,
    required this.arm,
    required this.cbts,
    required this.cra,
  });
  String date;
  int? rmuNo;
  String? sgp;
  String? vpi;
  String? crd;
  dynamic rec;
  String? arm;
  String? cbts;
  String? cra;

  factory DailyRmuAdminModel.fromjson(Map<String, dynamic> json) {
    return DailyRmuAdminModel(
      date: json['Date'],
      rmuNo: json['rmuNo'],
      sgp: json['sgp'],
      vpi: json['vpi'],
      crd: json['crd'],
      rec: json['rec'],
      arm: json['arm'],
      cbts: json['cbts'],
      cra: json['cra'],
    );
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'Date', value: date),
      DataGridCell(columnName: 'rmuNo', value: rmuNo),
      DataGridCell(columnName: 'sgp', value: sgp),
      DataGridCell(columnName: 'vpi', value: vpi),
      DataGridCell(columnName: 'crd', value: crd),
      DataGridCell(columnName: 'rec', value: rec),
      DataGridCell(columnName: 'arm', value: arm),
      DataGridCell(columnName: 'cbts', value: cbts),
      DataGridCell(columnName: 'cra', value: cra),
    ]);
  }
}
