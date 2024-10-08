import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ev_pmis_app/O_AND_M/controller/OAndM_Controller.dart';
import 'package:ev_pmis_app/O_AND_M/o&m_datasource/oAndM_dashboard_datasource.dart';
import 'package:ev_pmis_app/O_AND_M/o&m_model/oAndM_dashboard_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../components/Loading_page.dart';
import '../../../components/loading_pdf.dart';
import '../../../style.dart';
import '../../../PMIS/widgets/appbar_back_date.dart';
import '../../../PMIS/widgets/management_screen.dart';
import '../../../PMIS/widgets/progress_loading.dart';
import 'package:pdf/widgets.dart' as pw;

class OAndMDashboardScreen extends StatefulWidget {
  final String? cityName;
  final String? depoName;
  final String? userId;
  final String? role;
  final String? roleCentre;

  const OAndMDashboardScreen(
      {super.key,
      required this.cityName,
      this.depoName,
      this.userId,
      this.role,
      this.roleCentre});

  @override
  State<OAndMDashboardScreen> createState() => _OAndMDashboardScreenState();
}

class _OAndMDashboardScreenState extends State<OAndMDashboardScreen> {
  List<String> cityNames = [];
  String startDate = DateFormat.yMMMd().format(DateTime.now());
  String endDate = DateFormat.yMMMd().format(DateTime.now());
  String? selectedCity;
  bool isFieldEditable = true;
  String? visDate = DateFormat.yMMMd().format(DateTime.now());
  String? selectedDate = DateFormat.yMMM().format(DateTime.now());
  List<GridColumn> columns = [];
  late DataGridController _dataGridController;
  final OAndMController oAndMController = OAndMController();
  Stream? _stream;
  List<dynamic> tabledata2 = [];
  bool isLoading = true;
  bool checkTable = true;
  List<int> faultsOccuredList = [];
  List<int> totalFaultsResolved = [];
  List<int> totalPendingFaults = [];
  List<int> numOfChargersList = [];
  ProgressDialog? pr;
  Uint8List? pdfData;
  String? pdfPath;
  DateTime? startdate = DateTime.now();
  DateTime? enddate = DateTime.now();
  List<OAndMDashboardModel> dashboardProject = <OAndMDashboardModel>[];
  late OAndMDashboardDatasource _oAndMDashboardDatasource;
  String pathToOpenFile = '';
  List<DataGridRow> tabledata = [];

  @override
  void initState() {
    _oAndMDashboardDatasource = OAndMDashboardDatasource(
        oAndMController.oAndMModel,
        context,
        widget.cityName!,
        widget.depoName!,
        selectedDate!,
        widget.userId!,
        selectedCity ?? '',
        oAndMController.depotList,
        oAndMController.isCitySelected,
        numOfChargersList,
        faultsOccuredList,
        oAndMController.totalFaultPending,
        oAndMController.totalFaultResolved,
        oAndMController.mttrData,
        oAndMController.chargerAvailabilityList,
        oAndMController.dateRangeSelected,
        oAndMController.totalChargers,
        oAndMController.totalFaultOccured,
        totalPendingFaults,
        totalFaultsResolved);

    _dataGridController = DataGridController();

    getCityNames().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });

    oAndMController.oAndMDashboardDatasource = OAndMDashboardDatasource(
        oAndMController.oAndMModel,
        context,
        widget.cityName!,
        widget.depoName!,
        selectedDate!,
        widget.userId!,
        selectedCity ?? '',
        oAndMController.depotList,
        oAndMController.isCitySelected,
        numOfChargersList,
        faultsOccuredList,
        oAndMController.totalFaultPending,
        oAndMController.totalFaultResolved,
        oAndMController.mttrData,
        oAndMController.chargerAvailabilityList,
        oAndMController.dateRangeSelected,
        oAndMController.totalChargers,
        oAndMController.totalFaultOccured,
        totalPendingFaults,
        totalFaultsResolved);

    _dataGridController = DataGridController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _oAndMDashboardDatasource.buildDataGridRows();
    tabledata = _oAndMDashboardDatasource.dataGridRows.toList();
    print(tabledata);
    List<String> currentColumnLabels = oAndMDashboardClnName;

    columns.clear();
    for (int i = 0; i < currentColumnLabels.length; i++) {
      columns.add(
        GridColumn(
          autoFitPadding: const EdgeInsets.all(
            8.0,
          ),
          columnName: currentColumnLabels[i],
          visible: true,
          allowEditing: false,
          // currentColumnLabels[i] == 'Sr.No.' ||
          //         currentColumnLabels[i] == 'Location' ||
          //         currentColumnLabels[i] == "Depotname"
          //     ? false
          //     : true,
          width: currentColumnLabels[i] == 'Sr.No.'
              ? MediaQuery.of(context).size.width * 0.1
              : MediaQuery.of(context).size.width *
                  0.3, // You can adjust this width as needed
          label: createColumnLabel(
            oAndMDashboardTableClnName[i],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBarBackDate(
            depoName: widget.depoName ?? '',
            text: 'O & M Dashboard',
            haveSynced: false,
            haveSummary: false,
            isDownload: true,
            downloadFun: downloadPDF,
            haveCalender: false,
            store: () async {
              showProgressDilogue(context);
            },
            showDate: visDate,
            choosedate: () {
              //chooseDate(context);
            },
          )),
      body: isLoading
          ? const LoadingPage()
          : Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(
                        5.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: blue,
                        ),
                      ),
                      height: 40,
                      width: 150,
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                        style: TextStyle(
                          color: blue,
                        ),
                        hint: const Text(
                          "Choose City",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onChanged: (value) {
                          faultsOccuredList.clear();
                          totalFaultsResolved.clear();
                          totalPendingFaults.clear();
                          numOfChargersList.clear();
                          oAndMController.dateRangeSelected = false;
                          selectedCity = value;
                          getDepots(selectedCity!);
                        },
                        value: selectedCity,
                        items: List.generate(
                            cityNames.length,
                            (index) => DropdownMenuItem(
                                  value: cityNames[index],
                                  child: Text(
                                    cityNames[index],
                                    style: TextStyle(
                                      color: blue,
                                    ),
                                  ),
                                )).toList(),
                      )),
                    ),
                  ],
                ),
                Expanded(
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                        headerColor: white, gridLineColor: blue),
                    child: StreamBuilder(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LoadingPage();
                        } else if (!snapshot.hasData ||
                            snapshot.data.exists == false) {
                          return SfDataGrid(
                              source: oAndMController.oAndMDashboardDatasource,
                              allowEditing: true,
                              frozenColumnsCount: 1,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              selectionMode: SelectionMode.single,
                              navigationMode: GridNavigationMode.cell,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              editingGestureType: EditingGestureType.tap,
                              headerRowHeight: 30,
                              controller: _dataGridController,
                              onQueryRowHeight: (details) {
                                return details
                                    .getIntrinsicRowHeight(details.rowIndex);
                              },
                              columns: columns);
                        } else {
                          return SfDataGrid(
                              source: oAndMController.oAndMDashboardDatasource,
                              allowEditing: true,
                              frozenColumnsCount: 2,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              selectionMode: SelectionMode.single,
                              navigationMode: GridNavigationMode.cell,
                              editingGestureType: EditingGestureType.tap,
                              headerRowHeight: 30,
                              controller: _dataGridController,
                              onQueryRowHeight: (details) {
                                return details
                                    .getIntrinsicRowHeight(details.rowIndex);
                              },
                              columns: columns);
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (selectedCity != null) {
                            dateRange(
                                context,
                                widget.cityName!,
                                widget.depoName!,
                                widget.userId!,
                                oAndMController.depotList,
                                selectedCity!,
                                numOfChargersList,
                                faultsOccuredList,
                                totalPendingFaults,
                                totalFaultsResolved);
                          } else {
                            showCustomAlert();
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            border: Border.all(
                              color: blue,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: blue,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Text(startDate)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          if (selectedCity != null) {
                            dateRange(
                                context,
                                widget.cityName!,
                                widget.depoName!,
                                widget.userId!,
                                oAndMController.depotList,
                                selectedCity!,
                                numOfChargersList,
                                faultsOccuredList,
                                totalPendingFaults,
                                totalFaultsResolved);
                          } else {
                            showCustomAlert();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              3.0,
                            ),
                            border: Border.all(
                              color: blue,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: blue,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Text(endDate)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> downloadPDF() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      final pr = ProgressDialog(context);

      pr.style(
        progressWidgetAlignment: Alignment.center,
        message: 'Downloading file...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const LoadingPdf(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        maxProgress: 100.0,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
      );

      await pr.show();

      final pdfData = await _generateDailyPDF();

      String fileName = 'O&M Dashboard.pdf';

      final savedPDFFile = await savePDFToFile(pdfData, fileName);

      await pr.hide();

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
              'repeating channel id', 'repeating channel name',
              channelDescription: 'repeating description');
      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await FlutterLocalNotificationsPlugin().show(
          0, '$fileName ', 'Tap to open', notificationDetails,
          payload: savedPDFFile.path);
    }
  }

  Future<Uint8List> _generateDailyPDF() async {
    // print('generating daily pdf');
    // pr!.style(
    //   progressWidgetAlignment: Alignment.center,
    //   // message: 'Loading Data....',
    //   borderRadius: 10.0,
    //   backgroundColor: Colors.white,
    //   progressWidget: const LoadingPdf(),
    //   elevation: 10.0,
    //   insetAnimCurve: Curves.easeInOut,
    //   maxProgress: 100.0,
    //   progressTextStyle: const TextStyle(
    //       color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
    //   messageTextStyle: const TextStyle(
    //       color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
    // );

    // print(data);
    // summaryProvider.dailydata;

    final headerStyle =
        pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);

    final fontData1 =
        await rootBundle.load('assets/fonts/Montserrat-Medium.ttf');
    final fontData2 = await rootBundle.load('assets/fonts/Montserrat-Bold.ttf');

    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
    );

    List<pw.TableRow> rows = [];

    rows.add(pw.TableRow(children: [
      pw.Container(
        padding: const pw.EdgeInsets.all(2.0),
        child: pw.Center(
          child: pw.Text(
            'Sr No',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ),
      pw.Container(
        padding: const pw.EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
        child: pw.Center(
          child: pw.Text(
            'Location',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ),
      pw.Container(
        padding: const pw.EdgeInsets.all(2.0),
        child: pw.Center(
          child: pw.Text(
            'Depot Name',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ),
      pw.Container(
        padding: const pw.EdgeInsets.all(2.0),
        child: pw.Center(
          child: pw.Text(
            'chargers',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ),
      pw.Container(
        padding: const pw.EdgeInsets.all(2.0),
        child: pw.Center(
          child: pw.Text(
            'No. of Buses ',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ),
      pw.Container(
        padding: const pw.EdgeInsets.all(2.0),
        child: pw.Center(
          child: pw.Text(
            'Charger Availability',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
            child: pw.Text(
              'No. of Fault Occured',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          )),
      pw.Container(
        padding: const pw.EdgeInsets.all(2.0),
        child: pw.Center(
          child: pw.Text(
            'Total No. of Faults Resolved ',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ),
      pw.Container(
        padding: const pw.EdgeInsets.all(2.0),
        child: pw.Center(
          child: pw.Text(
            'Total No. of Faults Pending with OEM',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ),
      pw.Container(
        padding: const pw.EdgeInsets.all(2.0),
        child: pw.Center(
          child: pw.Text(
            'Mttr in Chargers infra',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ),
    ]));

    // for (var row in _oAndMDashboardDatasource.dataGridRows) {
    //   final int dataRowIndex =
    //       _oAndMDashboardDatasource.dataGridRows.indexOf(row);
    //   bool isLastRow =
    //       _oAndMDashboardDatasource.dataGridRows.length - 1 == dataRowIndex;

    //   List<pw.Widget> cells = [];

    Map<String, dynamic> tableData = Map();
    for (var i in _oAndMDashboardDatasource.dataGridRows) {
      final int dataRowIndex =
          _oAndMDashboardDatasource.dataGridRows.indexOf(i);
      for (var data in i.getCells()) {
        if (data.columnName == 'chargers') {
          _oAndMDashboardDatasource.dataGridRows.length - 1 == dataRowIndex
              ? tableData[data.columnName] = oAndMController.isCitySelected
                  ? oAndMController.totalChargers.toString()
                  : ""
              : tableData[data.columnName] = oAndMController.isCitySelected
                  ? '${numOfChargersList[dataRowIndex]}'
                  : "";
        } else if (data.columnName == 'Depotname') {
          tableData[data.columnName] = oAndMController.isCitySelected
              ? oAndMController.depotList[dataRowIndex]
              : "";
        } else if (data.columnName == 'buses') {
          tableData[data.columnName] = '10';
        } else if (data.columnName == 'faultOccured') {
          _oAndMDashboardDatasource.dataGridRows.length - 1 == dataRowIndex
              ? tableData[data.columnName] = oAndMController.isCitySelected
                  ? oAndMController.totalFaultOccured.toString()
                  : ""
              : tableData[data.columnName] = oAndMController.isCitySelected
                  ? faultsOccuredList[dataRowIndex].toString()
                  : "";
        } else if (data.columnName == 'totalFaultsResolved') {
          _oAndMDashboardDatasource.dataGridRows.length - 1 == dataRowIndex
              ? tableData[data.columnName] = oAndMController.isCitySelected
                  ? _oAndMDashboardDatasource.totalFaultsResolved.toString()
                  : ""
              : tableData[data.columnName] = oAndMController.isCitySelected
                  ? faultsOccuredList[dataRowIndex].toString()
                  : "";
        } else if (data.columnName == 'totalFaultsPending') {
          _oAndMDashboardDatasource.dataGridRows.length - 1 == dataRowIndex
              ? tableData[data.columnName] = oAndMController.isCitySelected
                  ? _oAndMDashboardDatasource.totalFaultPending.toString()
                  : ""
              : tableData[data.columnName] = oAndMController.isCitySelected
                  ? _oAndMDashboardDatasource
                      .totalFaultPendingList[dataRowIndex]
                      .toString()
                  : "";
        } else if (data.columnName == 'chargerAvailability') {
          _oAndMDashboardDatasource.isDateRangeSelected
              ? '${_oAndMDashboardDatasource.chargerAvailabilityList[dataRowIndex]}%'
              : "";
        } else if (data.columnName == 'chargerMttr') {
          _oAndMDashboardDatasource.dataGridRows.length - 1 == dataRowIndex
              ? tableData[data.columnName] =
                  _oAndMDashboardDatasource.getTotalMttr()
              : tableData[data.columnName] =
                  _oAndMDashboardDatasource.isDateRangeSelected
                      ? _oAndMDashboardDatasource.getAverageMttr(dataRowIndex)
                      : "";
        } else if (data.columnName == 'Sr.No.') {
          _oAndMDashboardDatasource.dataGridRows.length - 1 == dataRowIndex
              ? tableData[data.columnName] = ''
              : tableData[data.columnName] = data.value;
        } else if (data.columnName == 'electricalMttr') {
          tableData[data.columnName] = '25.0';
        } else {
          tableData[data.columnName] = data.value;
        }
      }
      tabledata2.add(tableData);
      tableData = {};
    }
    //}

    for (int i = 0; i < tabledata2.length; i++) {
      rows.add(pw.TableRow(children: [
        pw.Container(
            padding: const pw.EdgeInsets.all(3.0),
            child: pw.Center(
                child: pw.Text((tabledata2[i]['Sr.No.']).toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(3.0),
            child: pw.Center(
                child: pw.Text((tabledata2[i]['Location']).toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(3.0),
            child: pw.Center(
                child: pw.Text((tabledata2[i]['Depotname']).toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(3.0),
            child: pw.Center(
                child: pw.Text((tabledata2[i]['chargers']).toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(3.0),
            child: pw.Center(
                child: pw.Text((tabledata2[i]['buses']).toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(3.0),
            child: pw.Center(
                child: pw.Text((tabledata2[i]['faultOccured']).toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(3.0),
            child: pw.Center(
                child: pw.Text(
                    (tabledata2[i]['totalFaultsResolved']).toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(3.0),
            child: pw.Center(
                child: pw.Text((tabledata2[i]['totalFaultsPending']).toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(3.0),
            child: pw.Center(
                child: pw.Text((tabledata2[i]['chargerMttr']).toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(3.0),
            child: pw.Center(
                child: pw.Text((tabledata2[i]['electricalMttr']).toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
      ]));
    }
    tabledata2.clear();

    final pdf = pw.Document(
      pageMode: PdfPageMode.outlines,
    );

    //First Half Page

    pdf.addPage(
      pw.MultiPage(
        maxPages: 100,
        theme: pw.ThemeData.withFont(
            base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
        pageFormat: const PdfPageFormat(1300, 900,
            marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
        orientation: pw.PageOrientation.natural,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child: pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('O & M Dashboard Table',
                          textScaleFactor: 2,
                          style: const pw.TextStyle(color: PdfColors.blue700)),
                      pw.Container(
                        width: 120,
                        height: 120,
                        child: pw.Image(profileImage),
                      ),
                    ]),
              ]));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text('User ID - ${widget.userId}',
                  // 'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.black)));
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    const pw.TextSpan(
                        text: 'Place : ',
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 17)),
                    pw.TextSpan(
                        text: selectedCity,
                        //'${widget.cityName} / ${widget.depoName}',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    const pw.TextSpan(
                        text: 'Date : ',
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 17)),
                    pw.TextSpan(
                        text:
                            '${startdate!.day}-${startdate!.month}-${startdate!.year} to ${enddate!.day}-${enddate!.month}-${enddate!.year}',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    pw.TextSpan(
                        text: 'UserID : ${widget.userId}',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15)),
                  ])),
                ]),
            pw.SizedBox(height: 20)
          ]),
          pw.SizedBox(height: 10),
          pw.Table(
            columnWidths: {
              0: const pw.FixedColumnWidth(30),
              1: const pw.FixedColumnWidth(160),
              2: const pw.FixedColumnWidth(70),
              3: const pw.FixedColumnWidth(70),
              4: const pw.FixedColumnWidth(70),
              5: const pw.FixedColumnWidth(70),
              6: const pw.FixedColumnWidth(70),
              7: const pw.FixedColumnWidth(70),
              8: const pw.FixedColumnWidth(70),
              // 9: const pw.FixedColumnWidth(70),
              // 10: const pw.FixedColumnWidth(70),
            },
            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
            tableWidth: pw.TableWidth.max,
            border: pw.TableBorder.all(),
            children: rows,
          )
        ],
      ),
    );

    pdfData = await pdf.save();
    pdfPath = 'O&M Dashboard.pdf';

    return pdfData!;
  }

  Future<void> dateRange(
      BuildContext context,
      String cityName,
      String depotName,
      String userId,
      List<String> depotList,
      String selectedCity,
      List<int> numOfChargersList,
      List<int> faultsOccuredList,
      List<int> totalPendingFaults,
      List<int> totalFaultsResolved) async {
    if (isLoading == false) {
      setState(() {
        isLoading = true;
      });
    }
    DateTimeRange? selectedDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(
        2100,
      ),
      currentDate: DateTime.now(),
      helpText: "Choose Start And End Date",
    );

    if (selectedDate != null) {
      startDate = DateFormat.yMMMd().format(selectedDate.start);
      endDate = DateFormat.yMMMd().format(selectedDate.end);
      print("startDate - $startDate");
      print("endDate - $endDate");
      oAndMController.targetTime =
          (selectedDate.end.difference(selectedDate.start).inDays + 1) * 24;
      // print("Charger Availability - ${targetTime * 24}");
      oAndMController
          .getTimeLossData(depotList, numOfChargersList.length)
          .whenComplete(() {
        oAndMController.dateRangeSelected = true;
        oAndMController.oAndMDashboardDatasource = OAndMDashboardDatasource(
          oAndMController.oAndMModel,
          context,
          widget.cityName!,
          widget.depoName!,
          selectedDate.toString(),
          widget.userId!,
          selectedCity,
          oAndMController.depotList,
          oAndMController.isCitySelected,
          numOfChargersList,
          faultsOccuredList,
          oAndMController.totalFaultPending,
          oAndMController.totalFaultResolved,
          oAndMController.mttrData,
          oAndMController.chargerAvailabilityList,
          oAndMController.dateRangeSelected,
          oAndMController.totalChargers,
          oAndMController.totalFaultOccured,
          totalPendingFaults,
          totalFaultsResolved,
        );
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future getCityNames() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("DepoName").get();
    cityNames = querySnapshot.docs.map((e) => e.id).toList();
  }

  Future getDepots(String selectedCity) async {
    oAndMController.oAndMModel.clear();
    oAndMController.depotList.clear();
    oAndMController.totalChargers = 0;
    oAndMController.totalMttrForConclusion = 0;
    oAndMController.totalFaultOccured = 0;
    oAndMController.totalFaultResolved = 0;
    oAndMController.totalFaultPending = 0;
    oAndMController.isCitySelected = true;
    if (isLoading == false) {
      setState(() {
        isLoading = true;
      });
    }
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("DepoName")
        .doc(selectedCity)
        .collection("AllDepots")
        .get();

    oAndMController.depotList = querySnapshot.docs.map((e) => e.id).toList();
    for (int i = 0; i < oAndMController.depotList.length; i++) {
      oAndMController.oAndMModel.add(
        OAndMDashboardModel(
            srNo: i + 1,
            location: selectedCity,
            depotName: oAndMController.depotList[i],
            noOfChargers: 0,
            noOfBuses: 0,
            chargerAvailability: "",
            noOfFaultOccured: 0,
            totalFaultsResolved: 0,
            totalFaultsPending: 0,
            chargersMttr: 0.0,
            electricalMttr: 0.0),
      );
    }
    oAndMController.oAndMModel.add(
      OAndMDashboardModel(
          srNo: oAndMController.oAndMModel.length + 1,
          location: selectedCity,
          depotName: '',
          noOfChargers: 0,
          noOfBuses: 0,
          chargerAvailability: "",
          noOfFaultOccured: 0,
          totalFaultsResolved: 0,
          totalFaultsPending: 0,
          chargersMttr: 0.0,
          electricalMttr: 0.0),
    );

    oAndMController.depotList
        .add((oAndMController.oAndMModel.length - 1).toString());

    await getTotalChargers();
    await getFaultsOccured();

    oAndMController.oAndMDashboardDatasource = OAndMDashboardDatasource(
      oAndMController.oAndMModel,
      context,
      widget.cityName!,
      widget.depoName!,
      selectedDate!,
      widget.userId!,
      selectedCity ?? '',
      oAndMController.depotList,
      oAndMController.isCitySelected,
      numOfChargersList,
      faultsOccuredList,
      oAndMController.totalFaultPending,
      oAndMController.totalFaultResolved,
      oAndMController.mttrData,
      oAndMController.chargerAvailabilityList,
      oAndMController.dateRangeSelected,
      oAndMController.totalChargers,
      oAndMController.totalFaultOccured,
      totalPendingFaults,
      totalFaultsResolved,
    );

    print(oAndMController.oAndMDashboardDatasource);

    setState(() {
      isLoading = false;
    });
  }

  Future getFaultsOccured() async {
    for (int i = 0; i < oAndMController.depotList.length; i++) {
      DocumentSnapshot faultsQuery = await FirebaseFirestore.instance
          .collection("BreakDownData")
          .doc(oAndMController.depotList[i])
          .get();

      if (faultsQuery.exists) {
        Map<String, dynamic> mapData =
            faultsQuery.data() as Map<String, dynamic>;
        List<dynamic> data = mapData['data'];
        List<String> sortChargerList = [];
        for (Map<String, dynamic> map in data) {
          if (sortChargerList.contains(map['Equipment Name']) == false) {
            sortChargerList.add(map['Equipment Name']);
          }
        }
        print("breakdownData - $sortChargerList");
        faultsOccuredList.add(sortChargerList.length);
        oAndMController.totalFaultOccured =
            oAndMController.totalFaultOccured + sortChargerList.length;
        getFaultsResolved(data, sortChargerList, sortChargerList.length);
      } else {
        faultsOccuredList.add(0);
        totalFaultsResolved.add(0);
        totalPendingFaults.add(0);
      }
    }
  }

  void getFaultsResolved(List<dynamic> breakdownData,
      List<String> sortedChargers, int totalNumFaults) {
    int value = 0;
    breakdownData.every((element) {
      if (sortedChargers.contains(element["Equipment Name"]) == true) {
        value++;
        sortedChargers.remove(element["Equipment Name"]);
      }
      return true;
    });

    totalFaultsResolved.add(value);
    oAndMController.totalFaultResolved =
        oAndMController.totalFaultResolved + value;
    oAndMController.totalFaultPending =
        oAndMController.totalFaultPending + (totalNumFaults - value);
    totalPendingFaults.add(totalNumFaults - value);
  }

  Future getTotalChargers() async {
    for (int i = 0; i < oAndMController.depotList.length; i++) {
      DocumentSnapshot chargersQuery = await FirebaseFirestore.instance
          .collection("ChargerAvailability")
          .doc(oAndMController.depotList[i])
          .get();
      if (chargersQuery.exists) {
        Map<String, dynamic> mapData =
            chargersQuery.data() as Map<String, dynamic>;
        List<dynamic> data = mapData['data'];
        numOfChargersList.add(data.length);
        oAndMController.totalChargers =
            oAndMController.totalChargers + data.length;
        print('Total Charger - ${oAndMController.totalChargers}');
      } else {
        numOfChargersList.add(0);
      }
    }
    print("numOfChargerList - $numOfChargersList");
  }

  Widget createColumnLabel(String labelText) {
    return Container(
      alignment: Alignment.center,
      child: Text(labelText,
          overflow: TextOverflow.values.first,
          textAlign: TextAlign.center,
          style: tableheader),
    );
  }

  showCustomAlert() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(
            Icons.warning,
            color: blue,
            size: 60,
          ),
          title: const Text(
            "Please Select City!",
          ),
          actions: [
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "OK",
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<File> savePDFToFile(Uint8List pdfData, String fileName) async {
    final documentDirectory = (await DownloadsPath.downloadsDirectory())?.path;
    File file = File('$documentDirectory/$fileName');

    int counter = 1;
    String newFilePath = file.path;
    pathToOpenFile = newFilePath;

    while (await file.exists()) {
      String newName =
          '${fileName.substring(0, fileName.lastIndexOf('.'))}-$counter${fileName.substring(fileName.lastIndexOf('.'))}';
      file = File('$documentDirectory/$newName');
      pathToOpenFile = file.path;
      counter++;
    }
    await file.writeAsBytes(pdfData);
    return file;
  }
}
