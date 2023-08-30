import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class ViewExcel extends StatefulWidget {
  String path;
  ViewExcel({super.key, required this.path});

  @override
  State<ViewExcel> createState() => _ViewExcelState();
}

class _ViewExcelState extends State<ViewExcel> {
  @override
  void initState() {
    var file = 'assets/sample_excel.xlsx';
    print(file);
    var bytes = File(file).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      print(table); //sheet Name
      print(excel.tables[table]!.maxCols);
      print(excel.tables[table]!.maxRows);
      for (var row in excel.tables[table]!.rows) {
        print('$row');
      }
    }
    super.initState();
    // getExcel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () async {
          String excelFilePath = '/assets/applogo/sample_excel.xlsx';
          await OpenFile.open(excelFilePath);
        },
        child: const Text('Open'),
      ),
    );
  }

  void getExcel() async {
    await OpenFile.open(widget.path);
  }
}
