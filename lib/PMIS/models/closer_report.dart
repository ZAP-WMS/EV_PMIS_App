import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CloserReportModel {
  dynamic siNo;
  String? content;
  // String? attachment;

  CloserReportModel({
    required this.siNo,
    required this.content,
    // required this.attachment,
  });

  factory CloserReportModel.fromjson(Map<String, dynamic> json) {
    return CloserReportModel(
      siNo: json['SiNo'],
      content: json['Content'],
      // attachment: json['Attachment'],
    );
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'SiNo', value: siNo),
      DataGridCell(columnName: 'Content', value: content),
      const DataGridCell(columnName: 'Upload', value: null),
      const DataGridCell(columnName: 'View', value: null)
      // DataGridCell(columnName: 'Attachment', value: attachment),

      // const DataGridCell(columnName: 'Delete', value: null)
    ]);
  }
}
