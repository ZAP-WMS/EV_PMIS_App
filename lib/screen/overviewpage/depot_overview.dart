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
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../datasource/depot_overviewdatasource.dart';
import '../../model/depot_overview.dart';
import '../../style.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/navbar.dart';
import 'depot_overviewtable.dart';

class DepotOverview extends StatefulWidget {
  String? cityName;
  String? depoName;
  DepotOverview({super.key, required this.depoName});

  @override
  State<DepotOverview> createState() => _DepotOverviewState();
}

class _DepotOverviewState extends State<DepotOverview> {
  FilePickerResult? res;
  FilePickerResult? result1;
  FilePickerResult? result2;
  Uint8List? bytes;
  Uint8List? fileBytes1;
  Uint8List? fileBytes2;
  String? cityName;
  bool _isloading = true;
  List<dynamic> tabledata2 = [];

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
  @override
  void initState() {
    super.initState();
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;

    initializeController();

    _fetchUserData();
    _isloading = false;
    setState(() {});

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    // ]);
  }

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

  // @override
  // void dispose() {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //     // DeviceOrientation.landscapeLeft,
  //   ]);
  //   super.dispose();
  // }

  final TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          isCentered: false,
          title: '$cityName/Depot Overview/${widget.depoName}',
          height: 50,
          isSync: true,
          store: () async {
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
          },
        ),
        drawer: const NavbarDrawer(),
        body: _isloading
            ? LoadingPage()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    overviewField(_addressController,
                        'Depot Location and Address ', 'Password is required'),
                    overviewField(_scopeController, 'No of Buses in Scope',
                        'Password is required'),
                    overviewField(_chargerController, 'No of Charger Required',
                        'Charger are required'),
                    overviewField(_ratingController, 'Rating of Charger',
                        'Rating of charger required'),
                    overviewField(_loadController, 'Required Sanctioned Load',
                        'Charger are required'),
                    overviewField(
                        _powersourceController,
                        'Existing Utility of PowerSource',
                        'Rating of charger required'),
                    overviewField(_electricalManagerNameController,
                        'Project Manager', 'Charger are required'),
                    overviewField(_electricalEngineerController,
                        'Electrical Engineer', 'Rating of charger required'),
                    overviewField(_electricalVendorController,
                        'Electrical Vendor', 'Charger are required'),
                    overviewField(_civilManagerNameController, 'Civil Manager',
                        'Rating of charger required'),
                    overviewField(_civilEngineerController, 'Civil Engineering',
                        'Charger are required'),
                    overviewField(_civilVendorController, 'Civil Vendor',
                        'Rating of charger required'),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 45,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Details of Survey Report',
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
                          ),
                          Row(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width /
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
                                      padding: const EdgeInsets.only(bottom: 5),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewAllPdf(
                                                        title: 'BOQSurvey',
                                                        cityName: cityName!,
                                                        depoName:
                                                            widget.depoName!,
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
                                        result1 =
                                            await FilePicker.platform.pickFiles(
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
                                      width: MediaQuery.of(context).size.width /
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
                                                        title: 'BOQElectrical',
                                                        cityName: cityName!,
                                                        depoName:
                                                            widget.depoName!,
                                                        userId: userId,
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
                                        result2 =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.any,
                                          withData: true,
                                        );

                                        fileBytes2 =
                                            result2!.files.first.bytes!;
                                        if (result2 == null) {
                                          print("No file selected");
                                        } else {
                                          setState(() {});
                                          result2!.files.forEach((element) {});
                                        }
                                      },
                                      child: const Text(
                                        'Pick file',
                                        textAlign: TextAlign.end,
                                      )),
                                  SizedBox(width: 10),
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
                                                        title: 'BOQCivil',
                                                        cityName: cityName!,
                                                        depoName:
                                                            widget.depoName!,
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
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton.extended(
            extendedPadding: const EdgeInsets.all(10),
            onPressed: () {
              Get.to(
                  () => OverviewTable(
                        depoName: widget.depoName,
                      ),
                  transition: Transition.rightToLeft);
            },
            label: const Text('Next Page')));
  }

  overviewField(TextEditingController controller, String title, String msg) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: CustomTextField(
          controller: controller,
          labeltext: title,
          validatortext: '$title is Required',
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
      });
    });

    checkFieldEmpty(String fieldContent, String title) {
      if (fieldContent.isEmpty) return title;
      return '';
    }
  }
}
