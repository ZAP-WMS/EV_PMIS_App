import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/provider/cities_provider.dart';
import 'package:ev_pmis_app/screen/homepage/gallery.dart';
import 'package:ev_pmis_app/screen/overviewpage/view_AllFiles.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../datasource/depot_overviewdatasource.dart';
import '../../model/depot_overview.dart';
import '../../style.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/navbar.dart';

class DepotOverview extends StatefulWidget {
  String? cityName;
  String? depoName;
  DepotOverview({super.key, required this.depoName});

  @override
  State<DepotOverview> createState() => _DepotOverviewState();
}

class _DepotOverviewState extends State<DepotOverview> {
  String? cityName;
  bool isProjectManager = false;

  bool _isloading = true;
  List<dynamic> tabledata2 = [];
  late DepotOverviewDatasource _employeeDataSource;
  List<DepotOverviewModel> _employees = <DepotOverviewModel>[];
  late DataGridController _dataGridController;
  Stream? _stream;
  var alldata;

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
    super.initState();
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;
    initializeController();
    _employeeDataSource = DepotOverviewDatasource(_employees, context);
    _dataGridController = DataGridController();

    _stream = FirebaseFirestore.instance
        .collection('OverviewCollectionTable')
        .doc(widget.depoName)
        .collection("OverviewTabledData")
        .doc(userId)
        .snapshots();

    verifyProjectManager().whenComplete(() {
      setState(() {
        _isloading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          isCentered: true,
          title: '${widget.depoName}/Depot Overview',
          height: 50,
          isSync: isProjectManager ? true : false,
          store: () async {
            // overviewField(cityName!, widget.depoName!);
            overviewFieldstore(cityName!, widget.depoName!);
            storeData(widget.depoName!, context);
          },
        ),
        drawer: const NavbarDrawer(),
        body: _isloading
            ? LoadingPage()
            : isProjectManager == false
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.asset(
                            'assets/overview_image/depotOverview.webp',
                          )),
                      const Text(
                        'Only Project Manager Can Access This Page',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      )
                    ],
                  ))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        overviewField(
                            _addressController,
                            'Depot Location and Address ',
                            'Password is required'),
                        overviewField(_scopeController, 'No of Buses in Scope',
                            'Password is required'),
                        overviewField(_chargerController,
                            'No of Charger Required', 'Charger are required'),
                        overviewField(_ratingController, 'Rating of Charger',
                            'Rating of charger required'),
                        overviewField(_loadController,
                            'Required Sanctioned Load', 'Charger are required'),
                        overviewField(
                            _powersourceController,
                            'Existing Utility of PowerSource',
                            'Rating of charger required'),
                        overviewField(_electricalManagerNameController,
                            'Project Manager', 'Charger are required'),
                        overviewField(
                            _electricalEngineerController,
                            'Electrical Engineer',
                            'Rating of charger required'),
                        overviewField(_electricalVendorController,
                            'Electrical Vendor', 'Charger are required'),
                        overviewField(_civilManagerNameController,
                            'Civil Manager', 'Rating of charger required'),
                        overviewField(_civilEngineerController,
                            'Civil Engineering', 'Charger are required'),
                        overviewField(_civilVendorController, 'Civil Vendor',
                            'Rating of charger required'),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 35,
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
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                          onPressed: () async {
                                            res = await FilePicker.platform
                                                .pickFiles(
                                              type: FileType.any,
                                              withData: true,
                                            );

                                            bytes = res!.files.first.bytes!;
                                            if (res == null) {
                                              print("No file selected");
                                            } else {
                                              setState(() {});
                                              res!.files.forEach((element) {
                                                print(element.name);
                                                print(res!.files.first.name);
                                              });
                                            }
                                          },
                                          child: const Text(
                                            'Pick file',
                                            textAlign: TextAlign.end,
                                          )),
                                      const SizedBox(width: 10)
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
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              50,
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    res!.files.first.name,
                                                    //  textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: white),
                                                  ),
                                                )
                                            ],
                                          )),
                                      IconButton(
                                          alignment: Alignment.bottomRight,
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewAllPdf(
                                                            title: 'BOQSurvey',
                                                            cityName: cityName!,
                                                            depoName: widget
                                                                .depoName!,
                                                            userId: userId,
                                                            docId: 'survey')));
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
                                width: MediaQuery.of(context).size.width / 2,
                                height: 35,
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
                                          onPressed: () async {
                                            result1 = await FilePicker.platform
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
                                              result1!.files.forEach((element) {
                                                print(element.name);
                                              });
                                            }
                                          },
                                          child: const Text(
                                            'Pick file',
                                            textAlign: TextAlign.end,
                                          )),
                                      const SizedBox(width: 10),
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
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              50,
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    result1!.files.first.name,
                                                    //  textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: white),
                                                  ),
                                                )
                                            ],
                                          )),
                                      IconButton(
                                          alignment: Alignment.bottomRight,
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewAllPdf(
                                                            title:
                                                                'BOQElectrical',
                                                            cityName: cityName!,
                                                            depoName: widget
                                                                .depoName!,
                                                            userId: userId,
                                                            docId:
                                                                'electrical')));
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
                                width: MediaQuery.of(context).size.width / 2,
                                height: 35,
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
                                          onPressed: () async {
                                            result2 = await FilePicker.platform
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
                                          child: const Text(
                                            'Pick file',
                                            textAlign: TextAlign.end,
                                          )),
                                      const SizedBox(width: 10),
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
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              50,
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    //  textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: white),
                                                  ),
                                                )
                                            ],
                                          )),
                                      IconButton(
                                          alignment: Alignment.bottomRight,
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewAllPdf(
                                                            title: 'BOQCivil',
                                                            cityName: cityName!,
                                                            depoName: widget
                                                                .depoName!,
                                                            userId: userId,
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
                        SingleChildScrollView(
                          child: StreamBuilder(
                            stream: _stream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.data.exists == false) {
                                return SfDataGridTheme(
                                  data: SfDataGridThemeData(headerColor: blue),
                                  child: SfDataGrid(
                                    source: _employeeDataSource,
                                    allowEditing: true,
                                    frozenColumnsCount: 2,
                                    gridLinesVisibility:
                                        GridLinesVisibility.both,
                                    headerGridLinesVisibility:
                                        GridLinesVisibility.both,
                                    selectionMode: SelectionMode.multiple,
                                    navigationMode: GridNavigationMode.cell,
                                    columnWidthMode: ColumnWidthMode.auto,
                                    editingGestureType: EditingGestureType.tap,
                                    controller: _dataGridController,
                                    onQueryRowHeight: (details) {
                                      return details.getIntrinsicRowHeight(
                                          details.rowIndex);
                                    },
                                    columns: [
                                      GridColumn(
                                        visible: false,
                                        columnName: 'srNo',
                                        autoFitPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16),
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Sr No',
                                            style: tableheaderwhitecolor,
                                            softWrap: true,
                                            //   //  textAlign: TextAlign.center,
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
                                            // overflow: TextOverflow.values.first,
                                            style: tableheaderwhitecolor,
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'RiskDescription',
                                        width: 180,
                                        // autoFitPadding: tablepadding,
                                        allowEditing: true,
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: Text('Risk Description',
                                              //  textAlign: TextAlign.center,
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                              style: tableheaderwhitecolor),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'TypeRisk',
                                        width: 180,
                                        allowEditing: false,
                                        label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: Text('Type',
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
                                              // overflow: TextOverflow.values.first,
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
                                                  textAlign: TextAlign.center,
                                                  // overflow: TextOverflow.values.first,
                                                  style: tableheaderwhitecolor),
                                            ),
                                            Text(
                                                'Person Who will manage the risk',
                                                // overflow: TextOverflow.values.first,
                                                textAlign: TextAlign.center,
                                                style: tableheadersubtitle)
                                          ],
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'MigratingRisk',
                                        allowEditing: true,
                                        columnWidthMode:
                                            ColumnWidthMode.fitByCellValue,
                                        width: 150,
                                        label: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text('Mitigation Action',
                                                  // overflow: TextOverflow.values.first,
                                                  style: tableheaderwhitecolor),
                                            ),
                                            Text(
                                                'Action to Mitigate the risk e.g reduce the likelihood',
                                                // overflow: TextOverflow.values.first,
                                                textAlign: TextAlign.center,
                                                style: tableheadersubtitle),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: Text('Contigent Action',
                                                  // overflow: TextOverflow.values.first,
                                                  style: tableheaderwhitecolor),
                                            ),
                                            Text(
                                                'Action to be taken if the risk happens',
                                                // overflow: TextOverflow.values.first,
                                                textAlign: TextAlign.center,
                                                style: tableheadersubtitle)
                                          ],
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'ProgressionAction',
                                        allowEditing: true,
                                        width: 180,
                                        label: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          alignment: Alignment.center,
                                          child: Text('Progression Action',
                                              // overflow: TextOverflow.values.first,
                                              style: tableheaderwhitecolor),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Reason',
                                        allowEditing: true,
                                        width: 150,
                                        label: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          alignment: Alignment.center,
                                          child: Text('Remark',
                                              // overflow: TextOverflow.values.first,
                                              style: tableheaderwhitecolor),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'TargetDate',
                                        allowEditing: false,
                                        width: 160,
                                        label: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                              'Target Completion Date Of Risk',
                                              // overflow: TextOverflow.values.first,
                                              textAlign: TextAlign.center,
                                              style: tableheaderwhitecolor),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Status',
                                        allowEditing: false,
                                        width: 150,
                                        label: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          alignment: Alignment.center,
                                          child: Text('Status',
                                              // overflow: TextOverflow.values.first,
                                              style: tableheaderwhitecolor),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Add',
                                        autoFitPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16),
                                        allowEditing: false,
                                        width: 120,
                                        label: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          alignment: Alignment.center,
                                          child: Text('Add Row',
                                              // overflow: TextOverflow.values.first,
                                              style: tableheaderwhitecolor
                                              //   //  textAlign: TextAlign.center,
                                              ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Delete',
                                        autoFitPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16),
                                        allowEditing: false,
                                        width: 120,
                                        label: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          alignment: Alignment.center,
                                          child: Text('Delete Row',
                                              // overflow: TextOverflow.values.first,
                                              style: tableheaderwhitecolor
                                              //   //  textAlign: TextAlign.center,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                alldata = '';
                                alldata =
                                    snapshot.data['data'] as List<dynamic>;
                                _employees.clear();
                                alldata.forEach((element) {
                                  _employees.add(
                                      DepotOverviewModel.fromJson(element));
                                  _employeeDataSource = DepotOverviewDatasource(
                                      _employees, context);
                                  _dataGridController = DataGridController();
                                });
                                return SfDataGridTheme(
                                  data: SfDataGridThemeData(headerColor: blue),
                                  child: SfDataGrid(
                                    source: _employeeDataSource,
                                    allowEditing: true,
                                    frozenColumnsCount: 2,
                                    gridLinesVisibility:
                                        GridLinesVisibility.both,
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
                                            softWrap:
                                                true, // Allow text to wrap
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
                                            softWrap:
                                                true, // Allow text to wrap
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
                                              softWrap:
                                                  true, // Allow text to wrap
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
                                              softWrap:
                                                  true, // Allow text to wrap
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
                                            Text(
                                                'Person Who will manage the risk',
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
                                              softWrap:
                                                  true, // Allow text to wrap
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
                                              softWrap:
                                                  true, // Allow text to wrap
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
                                              softWrap:
                                                  true, // Allow text to wrap
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
                                              softWrap:
                                                  true, // Allow text to wrap
                                              overflow: TextOverflow.clip,
                                              style: tableheaderwhitecolor),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Add',
                                        allowEditing: false,
                                        width: 120,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Add Row',
                                              softWrap:
                                                  true, // Allow text to wrap
                                              overflow: TextOverflow.clip,
                                              style: tableheaderwhitecolor
                                              //   //  textAlign: TextAlign.center,
                                              ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Delete',
                                        allowEditing: false,
                                        width: 120,
                                        label: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          alignment: Alignment.center,
                                          child: Text('Delete Row',
                                              softWrap:
                                                  true, // Allow text to wrap
                                              overflow: TextOverflow.clip,
                                              style: tableheaderwhitecolor),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
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

  overviewField(TextEditingController controller, String title, String msg) {
    return Container(
      padding: const EdgeInsets.all(5),
      // width: MediaQuery.of(context).size.width,
      child: CustomTextField(
          controller: controller,
          labeltext: title,
          // validatortext: '$title is Required',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next),
    );
  }

  void _fetchUserData() async {
    await FirebaseFirestore.instance
        .collection('OverviewCollection')
        .doc(widget.depoName)
        .collection("OverviewFieldData")
        .doc(userId)
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

    checkFieldEmpty(String fieldContent, String title) {
      if (fieldContent.isEmpty) return title;
      return '';
    }
  }

  void storeField() async {
    FirebaseFirestore.instance
        .collection('OverviewCollection')
        .doc(widget.cityName)
        .collection("OverviewFieldData")
        .doc(userId)
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
              'BOQSurvey/$cityName/${widget.depoName}/$userId/survey/${res!.files.first.name}')
          .putData(
            bytes!,
            //  SettableMetadata(contentType: 'application/pdf')
          );
    } else if (fileBytes1 != null) {
      await FirebaseStorage.instance
          .ref(
              'BOQElectrical/$cityName/${widget.depoName}/$userId/electrical/${result1!.files.first.name}')
          .putData(
            fileBytes1!,
          );
    } else if (fileBytes2 != null) {
      await FirebaseStorage.instance
          .ref(
              'BOQCivil/$cityName/${widget.depoName}/$userId/civil/${result2!.files.first.name}')
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
        .doc(userId)
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
        .doc(userId)
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
          .ref(
              'BOQSurvey/$cityName/$depoName/$userId/survey/${res!.files.first.name}')
          .putData(
            bytes!,
            //  SettableMetadata(contentType: 'application/pdf')
          );
    }
    if (fileBytes1 != null) {
      await FirebaseStorage.instance
          .ref(
              'BOQElectrical/$cityName/$depoName/$userId/electrical/${result1!.files.first.name}')
          .putData(
            fileBytes1!,
          );
    }
    if (fileBytes2 != null) {
      await FirebaseStorage.instance
          .ref(
              'BOQCivil/$cityName/$depoName/$userId/civil/${result2!.files.first.name}')
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
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .where('roles', arrayContains: 'Project Manager')
        .get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.data()).toList();

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i]['userId'].toString() == userId.toString()) {
        for (int j = 0; j < tempList[i]['depots'].length; j++) {
          List<dynamic> depot = tempList[i]['depots'];

          if (depot[j].toString() == widget.depoName) {
            print(depot);
            isProjectManager = true;
            setState(() {});
          }
        }
      }
    }
    _fetchUserData();
  }
}
