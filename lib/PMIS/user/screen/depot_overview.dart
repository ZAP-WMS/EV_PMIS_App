import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/PMIS/provider/cities_provider.dart';
import 'package:ev_pmis_app/PMIS/models/depot_overview.dart';
import 'package:ev_pmis_app/PMIS/authentication/authservice.dart';
import 'package:ev_pmis_app/PMIS/view_AllFiles.dart';
import 'package:ev_pmis_app/PMIS/widgets/custom_appbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../datasource/depot_overviewdatasource.dart';
import '../../../style.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/navbar.dart';

class DepotOverview extends StatefulWidget {
  String? role;
  String? cityName;
  String? depoName;
  String? userId;
  DepotOverview(
      {super.key,
      required this.depoName,
      this.role,
      this.userId,
      this.cityName});

  @override
  State<DepotOverview> createState() => _DepotOverviewState();
}

class _DepotOverviewState extends State<DepotOverview> {
  final AuthService authService = AuthService();
  List<String> assignedCities = [];
  bool isFieldEditable = false;
  bool isProjectManager = false;
  bool checkTable = true;
  bool isLoading = true;
  List<dynamic> tabledata2 = [];
  late DepotOverviewDatasource _employeeDataSource;
  List<DepotOverviewModel> _employees = <DepotOverviewModel>[];
  late DataGridController _dataGridController;
  Stream? _stream;
  var alldata;
  String? projectManagerId;

  late TextEditingController _addressController,
      _scopeController,
      _chargerController,
      _ratingController,
      _loadController,
      _powersourceController,
      _electricalManagerNameController,
      _electricalEngineerController,
      _electricalVendorController,
      _civilManagerNameController,
      _civilEngineerController,
      _civilVendorController;

  FilePickerResult? res;
  FilePickerResult? result1;
  FilePickerResult? result2;
  Uint8List? bytes;
  Uint8List? fileBytes1;
  Uint8List? fileBytes2;

  void initializeController() {
    _addressController = TextEditingController();
    _scopeController = TextEditingController();
    _chargerController = TextEditingController();
    _ratingController = TextEditingController();
    _loadController = TextEditingController();
    _powersourceController = TextEditingController();
    _electricalManagerNameController = TextEditingController();
    _electricalEngineerController = TextEditingController();
    _electricalVendorController = TextEditingController();
    _civilManagerNameController = TextEditingController();
    _civilEngineerController = TextEditingController();
    _civilVendorController = TextEditingController();
  }

  final TextEditingController passwordcontroller = TextEditingController();

  @override
  void initState() {
    getAssignedDepots().whenComplete(() {
      initializeController();
      verifyProjectManager().whenComplete(() {
        getTableData().whenComplete(() {
          _employeeDataSource = DepotOverviewDatasource(_employees, context);
          _dataGridController = DataGridController();
          isLoading = false;
          setState(() {});
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          depoName: widget.depoName ?? '',
          isCentered: true,
          title: 'Depot Overview',
          height: 50,
          isSync: isProjectManager ? true : false,
          store: () async {
            overviewFieldstore(widget.cityName!, widget.depoName!);
            storeData(widget.depoName!, context);
          },
        ),
        drawer: NavbarDrawer(role: widget.role),
        body: isLoading
            ? const LoadingPage()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    overviewField(
                        _addressController,
                        'Depot Location and Address ',
                        'Password is required',
                        isProjectManager),
                    overviewField(_scopeController, 'No of Buses in Scope',
                        'Password is required', isProjectManager),
                    overviewField(_chargerController, 'No of Charger Required',
                        'Charger are required', isProjectManager),
                    overviewField(_ratingController, 'Rating of Charger',
                        'Rating of charger required', isProjectManager),
                    overviewField(_loadController, 'Required Sanctioned Load',
                        'Charger are required', isProjectManager),
                    overviewField(
                        _powersourceController,
                        'Existing Utility of PowerSource',
                        'Rating of charger required',
                        isProjectManager),
                    overviewField(
                        _electricalManagerNameController,
                        'Project Manager',
                        'Charger are required',
                        isProjectManager),
                    overviewField(
                        _electricalEngineerController,
                        'Electrical Engineer',
                        'Rating of charger required',
                        isProjectManager),
                    overviewField(
                        _electricalVendorController,
                        'Electrical Vendor',
                        'Charger are required',
                        isProjectManager),
                    overviewField(_civilManagerNameController, 'Civil Manager',
                        'Rating of charger required', isProjectManager),
                    overviewField(_civilEngineerController, 'Civil Engineering',
                        'Charger are required', isProjectManager),
                    overviewField(_civilVendorController, 'Civil Vendor',
                        'Rating of charger required', isProjectManager),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.8,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Details of Survey',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: black),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  ElevatedButton(
                                      onPressed: isProjectManager == false
                                          ? null
                                          : () async {
                                              res = await FilePicker.platform
                                                  .pickFiles(
                                                type: FileType.any,
                                                withData: true,
                                              );

                                              bytes = res!.files.first.bytes!;
                                              if (res == null) {
                                              } else {
                                                setState(() {});
                                                res!.files
                                                    .forEach((element) {});
                                              }
                                            },
                                      child: Text(
                                        'Pick file',
                                        textAlign: TextAlign.end,
                                        style: appTextStyle,
                                      )),
                                  const SizedBox(width: 5)
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          70,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: lightblue,
                                          border: Border.all(color: grey),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        children: [
                                          if (res != null)
                                            Expanded(
                                              child: Text(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                res!.files.first.name,
                                                //  textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15, color: white),
                                              ),
                                            )
                                        ],
                                      )),
                                  IconButton(
                                      alignment: Alignment.bottomRight,
                                      padding: const EdgeInsets.only(
                                        bottom: 5,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ViewAllPdf(
                                              isOverview: true,
                                              title: '/BOQSurvey',
                                              cityName: widget.cityName!,
                                              depoName: widget.depoName!,
                                              userId: widget.userId,
                                              docId: 'survey',
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.folder,
                                        color: yellow,
                                        size: 35,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.8,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'BOQ Electrical',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: black),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                      onPressed: isProjectManager == false
                                          ? null
                                          : () async {
                                              result1 = await FilePicker
                                                  .platform
                                                  .pickFiles(
                                                type: FileType.any,
                                                withData: true,
                                              );

                                              fileBytes1 =
                                                  result1!.files.first.bytes!;
                                              if (result1 == null) {
                                                print("No file selected");
                                              } else {
                                                setState(() {});
                                                result1!.files
                                                    .forEach((element) {
                                                  print(element.name);
                                                });
                                              }
                                            },
                                      child: Text(
                                        'Pick file',
                                        textAlign: TextAlign.end,
                                        style: appTextStyle,
                                      )),
                                  const SizedBox(width: 5),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          70,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: lightblue,
                                          border: Border.all(color: grey),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        children: [
                                          if (result1 != null)
                                            Expanded(
                                              child: Text(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                result1!.files.first.name,
                                                //  textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15, color: white),
                                              ),
                                            )
                                        ],
                                      )),
                                  IconButton(
                                      alignment: Alignment.bottomRight,
                                      padding: const EdgeInsets.only(bottom: 5),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewAllPdf(
                                                        isOverview: true,
                                                        title: '/BOQElectrical',
                                                        cityName:
                                                            widget.cityName!,
                                                        depoName:
                                                            widget.depoName!,
                                                        userId: widget.userId,
                                                        docId: 'electrical')));
                                      },
                                      icon: Icon(
                                        Icons.folder,
                                        color: yellow,
                                        size: 35,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.8,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'BOQ Civil',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: black),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                      onPressed: isProjectManager == false
                                          ? null
                                          : () async {
                                              result2 = await FilePicker
                                                  .platform
                                                  .pickFiles(
                                                type: FileType.any,
                                                withData: true,
                                              );

                                              fileBytes2 =
                                                  result2!.files.first.bytes!;
                                              if (result2 == null) {
                                                print("No file selected");
                                              } else {
                                                setState(() {});
                                                result2!.files
                                                    .forEach((element) {});
                                              }
                                            },
                                      child: Text(
                                        'Pick file',
                                        textAlign: TextAlign.end,
                                        style: appTextStyle,
                                      )),
                                  const SizedBox(width: 5),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          70,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: lightblue,
                                          border: Border.all(color: grey),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        children: [
                                          if (result2 != null)
                                            Expanded(
                                              child: Text(
                                                result2!.files.first.name,
                                                overflow: TextOverflow.ellipsis,
                                                //  textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15, color: white),
                                              ),
                                            )
                                        ],
                                      )),
                                  IconButton(
                                      alignment: Alignment.bottomRight,
                                      padding: const EdgeInsets.only(bottom: 5),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewAllPdf(
                                                        isOverview: true,
                                                        title: '/BOQCivil',
                                                        cityName:
                                                            widget.cityName!,
                                                        depoName:
                                                            widget.depoName!,
                                                        userId: widget.userId,
                                                        docId: 'civil')));
                                      },
                                      icon: Icon(
                                        Icons.folder,
                                        color: yellow,
                                        size: 35,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ]),
                    const SizedBox(height: 15),
                    StreamBuilder(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data.exists == false) {
                          return SingleChildScrollView(
                            child: SfDataGridTheme(
                              data: SfDataGridThemeData(
                                  gridLineColor: blue,
                                  gridLineStrokeWidth: 2,
                                  frozenPaneLineWidth: 3,
                                  frozenPaneLineColor: blue),
                              child: SfDataGrid(
                                source: _employeeDataSource,
                                allowEditing:
                                    isProjectManager == false ? false : true,
                                frozenColumnsCount: 1,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                selectionMode: SelectionMode.multiple,
                                navigationMode: GridNavigationMode.cell,
                                columnWidthMode: ColumnWidthMode.auto,
                                editingGestureType: EditingGestureType.tap,
                                controller: _dataGridController,
                                onQueryRowHeight: (details) {
                                  return details
                                      .getIntrinsicRowHeight(details.rowIndex);
                                },
                                columns: [
                                  GridColumn(
                                    visible: false,
                                    width: 100,
                                    columnName: 'srNo',
                                    allowEditing: true,
                                    label: Container(
                                      child: Text(
                                        'Sr No',
                                        style: tableheaderwhitecolor,
                                        softWrap: true, // Allow text to wrap
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Date',
                                    width: 140,
                                    allowEditing: false,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Risk On Date',
                                        softWrap: true, // Allow text to wrap
                                        overflow: TextOverflow.clip,
                                        style: tableheaderwhitecolor,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'RiskDescription',
                                    width: 180,
                                    allowEditing: true,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Risk Description',
                                          overflow: TextOverflow.ellipsis,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'TypeRisk',
                                    width: 180,
                                    allowEditing: false,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Type',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'impactRisk',
                                    width: 150,
                                    allowEditing: false,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Impact Risk',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Owner',
                                    allowEditing: true,
                                    width: 150,
                                    label: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text('Owner',
                                              softWrap:
                                                  true, // Allow text to wrap
                                              overflow: TextOverflow.clip,
                                              style: tableheaderwhitecolor),
                                        ),
                                        Text('Person Who will manage the risk',
                                            softWrap:
                                                true, // Allow text to wrap
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                            style: tableheaderwhitecolor)
                                      ],
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'MigratingRisk',
                                    allowEditing: true,
                                    width: 150,
                                    label: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text('Mitigation Action',
                                              softWrap:
                                                  true, // Allow text to wrap
                                              overflow: TextOverflow.clip,
                                              style: tableheaderwhitecolor),
                                        ),
                                        Text(
                                            'Action to Mitigate the risk e.g reduce the likelihood',
                                            softWrap:
                                                true, // Allow text to wrap
                                            overflow: TextOverflow.clip,
                                            style: tableheadersubtitle)
                                      ],
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'ContigentAction',
                                    allowEditing: true,
                                    width: 180,
                                    label: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text('Contigent Action',
                                              softWrap:
                                                  true, // Allow text to wrap
                                              overflow: TextOverflow.clip,
                                              style: tableheaderwhitecolor),
                                        ),
                                        Text(
                                            'Action to be taken if the risk happens',
                                            softWrap:
                                                true, // Allow text to wrap
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,

                                            //  textAlign: TextAlign.center,
                                            style: tableheadersubtitle)
                                      ],
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'ProgressionAction',
                                    allowEditing: true,
                                    width: 180,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Progression Action',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          // overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Reason',
                                    allowEditing: true,
                                    width: 150,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Remark',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          // overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'TargetDate',
                                    allowEditing: false,
                                    width: 160,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                          'Target Completion Date Of Risk',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Status',
                                    allowEditing: false,
                                    width: 150,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Status',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Add',
                                    allowEditing: false,
                                    visible: false,
                                    width: 120,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Add Row',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Delete',
                                    allowEditing: false,
                                    visible: false,
                                    width: 120,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('Delete Row',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.65,
                            child: SfDataGridTheme(
                              data: SfDataGridThemeData(
                                  gridLineColor: blue,
                                  gridLineStrokeWidth: 2,
                                  frozenPaneLineWidth: 3,
                                  frozenPaneLineColor: blue),
                              child: SfDataGrid(
                                source: _employeeDataSource,
                                allowEditing: true,
                                frozenColumnsCount: 2,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                selectionMode: SelectionMode.single,
                                navigationMode: GridNavigationMode.cell,
                                columnWidthMode: ColumnWidthMode.fill,
                                editingGestureType: EditingGestureType.tap,
                                controller: _dataGridController,
                                onQueryRowHeight: (details) {
                                  return details.getIntrinsicRowHeight(
                                      details.rowIndex,
                                      canIncludeHiddenColumns: true);
                                },
                                columns: [
                                  GridColumn(
                                    visible: false,
                                    width: 100,
                                    columnName: 'srNo',
                                    allowEditing: true,
                                    label: Container(
                                      child: Text(
                                        'Sr No',
                                        style: tableheaderwhitecolor,
                                        softWrap: true, // Allow text to wrap
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Date',
                                    width: 130,
                                    allowEditing: false,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Risk On Date',
                                        softWrap: true, // Allow text to wrap
                                        overflow: TextOverflow.clip,
                                        style: tableheaderwhitecolor,
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'RiskDescription',
                                    width: 180,
                                    allowEditing: true,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Risk Description',
                                          overflow: TextOverflow.ellipsis,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'TypeRisk',
                                    width: 180,
                                    allowEditing: false,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Type',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'impactRisk',
                                    width: 150,
                                    allowEditing: false,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Impact Risk',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Owner',
                                    allowEditing: true,
                                    width: 150,
                                    label: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text('Owner',
                                              softWrap:
                                                  true, // Allow text to wrap
                                              overflow: TextOverflow.clip,
                                              style: tableheaderwhitecolor),
                                        ),
                                        Text('Person Who will manage the risk',
                                            softWrap:
                                                true, // Allow text to wrap
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                            style: tableheaderwhitecolor)
                                      ],
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'MigratingRisk',
                                    allowEditing: true,
                                    width: 150,
                                    label: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text('Mitigation Action',
                                              softWrap:
                                                  true, // Allow text to wrap
                                              overflow: TextOverflow.clip,
                                              style: tableheaderwhitecolor),
                                        ),
                                        Text(
                                            'Action to Mitigate the risk e.g reduce the likelihood',
                                            softWrap:
                                                true, // Allow text to wrap
                                            overflow: TextOverflow.clip,
                                            style: tableheadersubtitle)
                                      ],
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'ContigentAction',
                                    allowEditing: true,
                                    width: 180,
                                    label: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text('Contigent Action',
                                              softWrap:
                                                  true, // Allow text to wrap
                                              overflow: TextOverflow.clip,
                                              style: tableheaderwhitecolor),
                                        ),
                                        Text(
                                            'Action to be taken if the risk happens',
                                            softWrap:
                                                true, // Allow text to wrap
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,

                                            //  textAlign: TextAlign.center,
                                            style: tableheadersubtitle)
                                      ],
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'ProgressionAction',
                                    allowEditing: true,
                                    width: 180,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Progression Action',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          // overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Reason',
                                    allowEditing: true,
                                    width: 150,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Remark',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          // overflow: TextOverflow.values.first,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'TargetDate',
                                    allowEditing: false,
                                    width: 160,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                          'Target Completion Date Of Risk',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Status',
                                    allowEditing: false,
                                    width: 150,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Status',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Add',
                                    allowEditing: false,
                                    visible: false,
                                    width: 120,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Add Row',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          style: tableheaderwhitecolor
                                          //   //  textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Delete',
                                    allowEditing: false,
                                    visible: false,
                                    width: 120,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('Delete Row',
                                          softWrap: true, // Allow text to wrap
                                          overflow: TextOverflow.clip,
                                          style: tableheaderwhitecolor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
        floatingActionButton: isProjectManager == true
            ? FloatingActionButton(
                heroTag: 'add',
                onPressed: () {
                  _employees.add(
                    DepotOverviewModel(
                      srNo: 1,
                      date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                      riskDescription: '',
                      typeRisk: 'Material Supply',
                      impactRisk: 'High',
                      owner: '',
                      migrateAction: ' ',
                      contigentAction: '',
                      progressAction: '',
                      reason: '',
                      targetDate:
                          DateFormat('dd-MM-yyyy').format(DateTime.now()),
                      status: 'Close',
                    ),
                  );

                  _employeeDataSource.buildDataGridRows();
                  _employeeDataSource.updateDatagridSource();
                },
                child: const Icon(Icons.add),
              )
            : Container());
  }

  overviewField(TextEditingController controller, String title, String msg,
      bool isPManager) {
    return Container(
      padding: const EdgeInsets.all(5),
      // width: MediaQuery.of(context).size.width,
      child: CustomTextField(
        isFieldEditable: isFieldEditable,
        isProjectManager: isPManager,
        role: widget.role,
        controller: controller,
        labeltext: title,
        // validatortext: '$title is Required',
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  void _fetchUserData(String user_id) async {
    await FirebaseFirestore.instance
        .collection('OverviewCollection')
        .doc(widget.depoName)
        .collection("OverviewFieldData")
        .doc(user_id)
        .get()
        .then((ds) {
      setState(() {
        // managername = ds.data()!['ManagerName'];
        if (ds.exists) {
          _addressController.text = ds.data()!['address'];
          _scopeController.text = ds.data()!['scope'];
          _chargerController.text = ds.data()!['required'];
          _ratingController.text = ds.data()!['charger'];
          _loadController.text = ds.data()!['load'];
          _powersourceController.text = ds.data()!['powerSource'];
          _electricalManagerNameController.text =
              ds.data()!['ElectricalManagerName'];
          _electricalEngineerController.text = ds.data()!['ElectricalEng'];
          _electricalVendorController.text = ds.data()!['ElectricalVendor'];
          _civilManagerNameController.text = ds.data()!['CivilManagerName'];
          _civilEngineerController.text = ds.data()!['CivilEng'];
          _civilVendorController.text = ds.data()!['CivilVendor'];
        }
      });
    });
  }

  void storeField() async {
    FirebaseFirestore.instance
        .collection('OverviewCollection')
        .doc(widget.cityName)
        .collection("OverviewFieldData")
        .doc(widget.userId)
        .set({
      'address': _addressController.text,
      'scope': _scopeController.text,
      'required': _chargerController.text,
      'charger': _ratingController.text,
      'load': _loadController.text,
      'powerSource': _powersourceController.text,
      // 'ManagerName': managername ?? '',
      'CivilManagerName': _civilManagerNameController.text,
      'CivilEng': _civilEngineerController.text,
      'CivilVendor': _civilVendorController.text,
      'ElectricalManagerName': _electricalManagerNameController.text,
      'ElectricalEng': _electricalEngineerController.text,
      'ElectricalVendor': _electricalVendorController.text,
    }, SetOptions(merge: true));
    storeData(widget.depoName!, context);
    if (bytes != null) {
      await FirebaseStorage.instance
          .ref(
              'BOQSurvey/${widget.cityName}/${widget.depoName}/${widget.userId}/survey/${res!.files.first.name}')
          .putData(
            bytes!,
            //  SettableMetadata(contentType: 'application/pdf')
          );
    } else if (fileBytes1 != null) {
      await FirebaseStorage.instance
          .ref(
              'BOQElectrical/${widget.cityName}/${widget.depoName}/${widget.userId}/electrical/${result1!.files.first.name}')
          .putData(
            fileBytes1!,
          );
    } else if (fileBytes2 != null) {
      await FirebaseStorage.instance
          .ref(
              'BOQCivil/${widget.cityName}/${widget.depoName}/${widget.userId}/civil/${result2!.files.first.name}')
          .putData(
            fileBytes2!,
            //  SettableMetadata(contentType: 'application/pdf')
          );
    }
  }

  void storeData(String depoName, BuildContext context) {
    // _employeeDataSource = DepotOverviewDatasource(_employees, context);
    // _dataGridController = DataGridController();
    Map<String, dynamic> table_data = Map();
    for (var i in _employeeDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'Add' || data.columnName != 'Delete') {
          table_data[data.columnName] = data.value;
        }
      }
      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('OverviewCollectionTable')
        .doc(depoName)
        .collection("OverviewTabledData")
        .doc(widget.userId)
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      tabledata2.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }

  overviewFieldstore(String cityName, String depoName) async {
    FirebaseFirestore.instance
        .collection('OverviewCollection')
        .doc(depoName)
        .collection("OverviewFieldData")
        .doc(widget.userId)
        .set({
      'address': _addressController.text,
      'scope': _scopeController.text,
      'required': _chargerController.text,
      'charger': _ratingController.text,
      'load': _loadController.text,
      'powerSource': _powersourceController.text,
      'CivilManagerName': _civilManagerNameController.text,
      'CivilEng': _civilEngineerController.text,
      'CivilVendor': _civilVendorController.text,
      'ElectricalManagerName': _electricalManagerNameController.text,
      'ElectricalEng': _electricalEngineerController.text,
      'ElectricalVendor': _electricalVendorController.text,
    }, SetOptions(merge: true));
    if (bytes != null) {
      await FirebaseStorage.instance
          .ref('BOQSurvey/$cityName/$depoName/survey/${res!.files.first.name}')
          .putData(
            bytes!,
            //  SettableMetadata(contentType: 'application/pdf')
          );
    }
    if (fileBytes1 != null) {
      await FirebaseStorage.instance
          .ref(
              'BOQElectrical/$cityName/$depoName/electrical/${result1!.files.first.name}')
          .putData(
            fileBytes1!,
          );
    }
    if (fileBytes2 != null) {
      await FirebaseStorage.instance
          .ref(
              'BOQCivil/$cityName/$depoName/civil/${result2!.files.first.name}')
          .putData(
            fileBytes2!,
            //  SettableMetadata(contentType: 'application/pdf')
          );
    }
  }

  List<DepotOverviewModel> getEmployeeData() {
    return [
      DepotOverviewModel(
          srNo: 1,
          date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          riskDescription: '',
          typeRisk: 'Material Supply',
          impactRisk: 'High',
          owner: '',
          migrateAction: ' ',
          contigentAction: '',
          progressAction: '',
          reason: '',
          targetDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          status: 'Close')
    ];
  }

  Future<void> verifyProjectManager() async {
    isProjectManager = false;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .where('roles', arrayContains: 'Project Manager')
        .get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.data()).toList();

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i]['userId'].toString() == widget.userId) {
        for (int j = 0; j < tempList[i]['depots'].length; j++) {
          List<dynamic> depot = tempList[i]['depots'];

          if (depot[j].toString() == widget.depoName) {
            isProjectManager = true;
            projectManagerId = tempList[i]['userId'].toString();
            break;
          }
        }
      } else {
        for (int j = 0; j < tempList[i]['depots'].length; j++) {
          List<dynamic> depot = tempList[i]['depots'];
          if (depot[j].toString() == widget.depoName) {
            projectManagerId = tempList[i]['userId'].toString();
            break;
          }
        }
      }
    }
    _fetchUserData(projectManagerId.toString());
  }

  Future<void> getTableData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('OverviewCollectionTable')
        .doc(widget.depoName)
        .collection("OverviewTabledData")
        .doc(projectManagerId)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> tempData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapData = tempData['data'];

      _employees =
          mapData.map((map) => DepotOverviewModel.fromJson(map)).toList();
      checkTable = false;
    }
  }

  Future getAssignedDepots() async {
    assignedCities = await authService.getCityList();
    isFieldEditable = authService.verifyAssignedDepot(
      widget.cityName!,
      assignedCities,
    );
  }
}
