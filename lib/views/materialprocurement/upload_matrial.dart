import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/views/citiespage/depot.dart';
import 'package:ev_pmis_app/PMIS/widgets/custom_appbar.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../PMIS/user/datasource/materialprocurement_datasource.dart';
import '../../PMIS/provider/cities_provider.dart';
import '../../style.dart';
import '../../models/material_procurement.dart';
import '../../PMIS/widgets/navbar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../PMIS/user/screen/safetyfield.dart';

class UploadMaterial extends StatefulWidget {
  String? depoName;
  UploadMaterial({super.key, required this.depoName});

  @override
  State<UploadMaterial> createState() => _UploadMaterialState();
}

class _UploadMaterialState extends State<UploadMaterial> {
  List<MaterialProcurementModel> _materialprocurement = [];
  late MaterialDatasource _materialDatasource;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  List<List<dynamic>> data = [];
  Stream? _stream;
  bool _isloading = true;
  dynamic alldata;

  @override
  void initState() {
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;

    _materialprocurement = data.cast<MaterialProcurementModel>();
    _materialDatasource = MaterialDatasource(
        _materialprocurement, context, cityName, widget.depoName);
    _dataGridController = DataGridController();
    _stream = FirebaseFirestore.instance
        .collection('MaterialProcurement')
        .doc('${widget.depoName}')
        .collection('Material Data')
        .doc(userId)
        .snapshots();
    _isloading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer:  NavbarDrawer(role: widget.),
      appBar: CustomAppBar(
          depoName: widget.depoName ?? '',
          title: 'Material Procurement',
          height: 50,
          isSync: true,
          isCentered: true),
      body: SfDataGridTheme(
        data: SfDataGridThemeData(headerColor: blue),
        child: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.exists == false) {
              _materialprocurement = convertListTomaterialModel(data);
              _materialDatasource = MaterialDatasource(
                  _materialprocurement, context, cityName, widget.depoName);

              _dataGridController = DataGridController();
              return SfDataGrid(
                  source: _materialDatasource,
                  allowEditing: true,
                  frozenColumnsCount: 1,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  selectionMode: SelectionMode.single,
                  navigationMode: GridNavigationMode.cell,
                  columnWidthMode: ColumnWidthMode.auto,
                  editingGestureType: EditingGestureType.tap,
                  controller: _dataGridController,
                  columns: [
                    GridColumn(
                      columnName: 'cityName',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 100,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('City Name',
                            overflow: TextOverflow.values.first,
                            textAlign: TextAlign.center,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'details',
                      width: 250,
                      allowEditing: true,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('Details Item Description',
                            textAlign: TextAlign.center,
                            style: tableheaderwhitecolor),
                      ),
                    ),
                    GridColumn(
                      columnName: 'olaNo',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 130,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('OLA No',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor),
                      ),
                    ),
                    GridColumn(
                      columnName: 'vendorName',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 130,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Vendor Name',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'oemApproval',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 150,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('OEM Drawing Approval by Engg',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'oemClearance',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 250,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Manufacturing clearance Given to OEM',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'croPlacement',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 250,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Delivery time line after Placement of CRO',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'croVendor',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 250,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('CRO release to Vendor',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'croNumber',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 120,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('CRO Number ',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'unit',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 120,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Unit',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'qty',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 120,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Qty',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'materialSite',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 250,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Receipt of Material at site',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Add',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 120,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Add Row',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Delete',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 120,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Delete Row',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                  ]);
            } else {
              alldata = '';
              alldata = snapshot.data['data'] as List<dynamic>;
              _materialprocurement.clear();
              alldata.forEach((element) {
                _materialprocurement
                    .add(MaterialProcurementModel.fromjson(element));
                _materialDatasource = MaterialDatasource(
                    _materialprocurement, context, cityName, widget.depoName);
                _dataGridController = DataGridController();
              });
              return SfDataGrid(
                  source: _materialDatasource,
                  allowEditing: true,
                  frozenColumnsCount: 1,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  selectionMode: SelectionMode.single,
                  navigationMode: GridNavigationMode.cell,
                  columnWidthMode: ColumnWidthMode.auto,
                  editingGestureType: EditingGestureType.tap,
                  controller: _dataGridController,
                  columns: [
                    GridColumn(
                      columnName: 'cityName',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 100,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('City Name',
                            overflow: TextOverflow.values.first,
                            textAlign: TextAlign.center,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'details',
                      width: 250,
                      allowEditing: true,
                      label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('Details Item Description',
                            textAlign: TextAlign.center,
                            style: tableheaderwhitecolor),
                      ),
                    ),
                    GridColumn(
                      columnName: 'olaNo',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 130,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('OLA No',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor),
                      ),
                    ),
                    GridColumn(
                      columnName: 'vendorName',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 130,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Vendor Name',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'oemApproval',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 150,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('OEM Drawing Approval by Engg',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'oemClearance',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 250,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Manufacturing clearance Given to OEM',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'croPlacement',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 250,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Delivery time line after Placement of CRO',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'croVendor',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 250,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('CRO release to Vendor',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'croNumber',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 120,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('CRO Number ',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'unit',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 120,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Unit',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'qty',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: true,
                      width: 120,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Qty',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'materialSite',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 250,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Receipt of Material at site',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Add',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 120,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Add Row',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'Delete',
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      allowEditing: false,
                      width: 120,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        alignment: Alignment.center,
                        child: Text('Delete Row',
                            overflow: TextOverflow.values.first,
                            style: tableheaderwhitecolor
                            //    textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                  ]);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          selectExcelFile().then((value) {
            setState(() {});
          });
        },
        label: const Text('Upload Excel'),
      ),
    );
  }

  Future<List<List<dynamic>>> selectExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      String? filePath = result.files.single.path;
      // File file = File(result.files.single.path!);
      var bytes = File(filePath!).readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        final sheet = excel.tables[table];
        for (var rows in sheet!.rows.skip(1)) {
          List<dynamic> rowData = [];
          for (var cell in rows) {
            rowData.add(cell?.value.toString());
          }
          data.add(rowData);
        }
      }
    } else {
      print('File is Empty');
    }
    // final input = FileUploadInputElement()..accept = '.xlsx';
    // input.click();

    // await input.onChange.first;
    // final files = input.files;

    // if (files?.length == 1) {
    //   final file = files?[0];
    //   final reader = FileReader();

    // reader.readAsArrayBuffer(file!);

    // await reader.onLoadEnd.first;

    return data;
  }

  List<MaterialProcurementModel> convertListTomaterialModel(
      List<List<dynamic>> data) {
    return data.map((list) {
      return MaterialProcurementModel(
          cityName: 'cityName',
          details: 'efsf',
          olaNo: 'efsf',
          vendorName: 'efsf',
          oemApproval: 'efsf',
          oemClearance: 'efsf',
          croPlacement: 'efsf',
          croVendor: 'efsf',
          croNumber: 'efsf',
          unit: 'efsf',
          qty: 1,
          materialSite: 'efsf');
    }).toList();
  }
}
