import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DailySfuAdminModel {
  DailySfuAdminModel(
      {required this.date,
      required this.sfuNo,
      required this.fuc,
      required this.icc,
      required this.ictc,
      required this.occ,
      required this.octc,
      required this.ec,
      required this.cg,
      required this.dl,
      required this.vi});
  String date;
  int? sfuNo;
  String? fuc;
  String? icc;
  dynamic ictc;
  String? occ;
  String? octc;
  String? ec;
  String? cg;
  String? dl;
  String? vi;

  factory DailySfuAdminModel.fromjson(Map<String, dynamic> json) {
    return DailySfuAdminModel(
        date: json['Date'],
        sfuNo: json['sfuNo'],
        fuc: json['fuc'],
        icc: json['icc'],
        ictc: json['ictc'],
        occ: json['occ'],
        octc: json['octc'],
        ec: json['ec'],
        cg: json['cg'],
        dl: json['dl'],
        vi: json['vi']);
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'Date', value: date),
      DataGridCell(columnName: 'sfuNo', value: sfuNo),
      DataGridCell(columnName: 'fuc', value: fuc),
      DataGridCell(columnName: 'icc', value: icc),
      DataGridCell(columnName: 'ictc', value: ictc),
      DataGridCell(columnName: 'occ', value: occ),
      DataGridCell(columnName: 'octc', value: octc),
      DataGridCell(columnName: 'ec', value: ec),
      DataGridCell(columnName: 'cg', value: cg),
      DataGridCell(columnName: 'dl', value: dl),
      DataGridCell(columnName: 'vi', value: vi),
    ]);
  }
}
