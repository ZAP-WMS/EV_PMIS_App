import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DailyTransformerAdminModel {
  DailyTransformerAdminModel({
    required this.date,
    required this.trNo,
    required this.pc,
    required this.ec,
    required this.ol,
    required this.oc,
    required this.wtiTemp,
    required this.otiTemp,
    required this.brk,
    required this.cta,
  });
  String date;
  int? trNo;
  String? pc;
  String? ec;
  dynamic ol;
  String? oc;
  String? wtiTemp;
  String? otiTemp;
  String? brk;
  String? cta;

  factory DailyTransformerAdminModel.fromjson(Map<String, dynamic> json) {
    return DailyTransformerAdminModel(
        date: json['Date'],
        trNo: json['trNo'],
        pc: json['pc'],
        ec: json['ec'],
        ol: json['ol'],
        oc: json['oc'],
        wtiTemp: json['wtiTemp'],
        otiTemp: json['otiTemp'],
        brk: json['brk'],
        cta: json['cta']);
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'Date', value: date),
      DataGridCell(columnName: 'trNo', value: trNo),
      DataGridCell(columnName: 'pc', value: pc),
      DataGridCell(columnName: 'ec', value: ec),
      DataGridCell(columnName: 'ol', value: ol),
      DataGridCell(columnName: 'oc', value: oc),
      DataGridCell(columnName: 'wtiTemp', value: wtiTemp),
      DataGridCell(columnName: 'otiTemp', value: otiTemp),
      DataGridCell(columnName: 'brk', value: brk),
      DataGridCell(columnName: 'cta', value: cta),
    ]);
  }
}
