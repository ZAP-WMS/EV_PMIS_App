import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MonthlyChargerModel {
  MonthlyChargerModel({
    required this.date,
    required this.cn,
    required this.gun1,
    required this.gun2,
  });
  String date;
  int? cn;
  String? gun1;
  dynamic gun2;

  factory MonthlyChargerModel.fromjson(Map<String, dynamic> json) {
    return MonthlyChargerModel(
      cn: json['cn'],
      date: json['date'],
      gun1: json['gun1'],
      gun2: json['gun2'],
    );
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'cn', value: cn),
      DataGridCell(columnName: 'date', value: date),
      DataGridCell(columnName: 'gun1', value: gun1),
      DataGridCell(columnName: 'gun2', value: gun2),
      const DataGridCell(columnName: 'Add', value: null),
      const DataGridCell(columnName: 'Delete', value: null)
    ]);
  }
}
