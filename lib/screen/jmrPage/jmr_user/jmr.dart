import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:ev_pmis_app/views/overviewpage/view_AllFiles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../components/Loading_page.dart';
import '../../../style.dart';
import 'jmr_fields.dart';

class JmrUserPage extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? userId;
  String? role;

  JmrUserPage(
      {super.key, this.cityName, this.role, this.depoName, this.userId});

  @override
  State<JmrUserPage> createState() => _JmrUserPageState();
}

class _JmrUserPageState extends State<JmrUserPage> {
  final AuthService authService = AuthService();
  List<String> assignedCities = [];
  bool isFieldEditable = false;
  String fileName = '';
  List currentTabList = [];
  String selectedDepot = '';
  int _selectedIndex = 0;
  bool _isLoading = true;
  
  List tabsForJmr = ['Civil', 'Electrical'];
  Widget selectedUI = Container();

  List<String> title = ['R1', 'R2', 'R3', 'R4', 'R5'];

  @override
  void initState() {
    getAssignedDepots().whenComplete(() {
      getJmrLen(5);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      animationDuration: const Duration(
        milliseconds: 200,
      ),
      initialIndex: 0,
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          bottom: TabBar(
              labelColor: white,
              labelStyle: buttonWhite,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(color: blue),
              onTap: (value) {
                _selectedIndex = value;
                getJmrLen(5);
              },
              tabs: const [
                Tab(
                  text: 'Civil Engineer',
                ),
                Tab(text: 'Electrical Engineer'),
              ]),
          centerTitle: true,
          title: Column(
            children: [
              const Text(
                'JMR',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.depoName ?? '',
                style: const TextStyle(
                  fontSize: 11,
                ),
              ),
            ],
          ),
          flexibleSpace: Container(
            height: 60,
            color: blue,
          ),
        ),
        body: _isLoading
            ? const LoadingPage()
            : TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                        top: 10.0,
                      ),
                      child: GridView.builder(
                          itemCount: 5,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 200,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                cardlist(title[index], index, title[index],
                                    'Civil', currentTabList[index]),
                                Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.035,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Colors.blue,
                                            ),
                                          ),
                                          onPressed: isFieldEditable == false
                                              ? null
                                              : () async {
                                                  FilePickerResult? result =
                                                      await FilePicker.platform
                                                          .pickFiles(
                                                    withData: true,
                                                    type: FileType.any,
                                                    allowMultiple: false,
                                                    // allowedExtensions: ['pdf']
                                                  );

                                                  if (result != null) {
                                                    Uint8List? fileBytes =
                                                        result
                                                            .files.first.bytes;
                                                    fileName = result
                                                        .files.single.name;
                                                    final storage =
                                                        FirebaseStorage
                                                            .instance;
                                                    await storage
                                                        .ref()
                                                        .child(
                                                            'jmrFiles/${tabsForJmr[_selectedIndex]}/${widget.cityName}/${widget.depoName}/${widget.userId}/${index + 1}/$fileName')
                                                        .putData(fileBytes!);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor:
                                                            Colors.green,
                                                        content: Text(
                                                          'File Uploaded',
                                                          style: TextStyle(
                                                              color: white),
                                                        ),
                                                      ),
                                                    );

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'JMRCollection')
                                                        .doc(widget.depoName)
                                                        .collection('Table')
                                                        .doc(
                                                            '${tabsForJmr[_selectedIndex]}JmrTable')
                                                        .collection('userId')
                                                        .doc(widget.userId)
                                                        .set({
                                                      "isFileUploaded": true
                                                    });
                                                  } else {
                                                    // User canceled the picker
                                                  }
                                                },
                                          child: Text(
                                            'Upload',
                                            style: TextStyle(
                                                color: white, fontSize: 8),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ViewAllPdf(
                                                cityName: widget.cityName,
                                                depoName: widget.depoName,
                                                title: 'jmr',
                                                userId: widget.userId,
                                                fldrName:
                                                    'jmrFiles/${tabsForJmr[_selectedIndex]}/${widget.cityName}/${widget.depoName}/${widget.userId}/${index + 1}',
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.035,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          margin:
                                              const EdgeInsets.only(left: 5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border:
                                                Border.all(color: Colors.blue),
                                          ),
                                          child: const Text(
                                            'View',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 8),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, top: 5.0),
                      child: GridView.builder(
                          itemCount: 5,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 200,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return Column(children: [
                              cardlist(title[index], index, title[index],
                                  'Electrical', currentTabList[index]),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.035,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.blue,
                                          ),
                                        ),
                                        onPressed: isFieldEditable == false
                                            ? null
                                            : () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                  withData: true,
                                                  type: FileType.any,
                                                  allowMultiple: false,
                                                  // allowedExtensions: ['pdf']
                                                );

                                                if (result != null) {
                                                  Uint8List? fileBytes =
                                                      result.files.first.bytes;
                                                  fileName =
                                                      result.files.single.name;
                                                  final storage =
                                                      FirebaseStorage.instance;
                                                  await storage
                                                      .ref()
                                                      .child(
                                                          'jmrFiles/${tabsForJmr[_selectedIndex]}/${widget.cityName}/${widget.depoName}/${widget.userId}/${index + 1}/$fileName')
                                                      .putData(fileBytes!);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      backgroundColor:
                                                          Colors.green,
                                                      content: Text(
                                                        'File Uploaded',
                                                        style: TextStyle(
                                                            color: white),
                                                      ),
                                                    ),
                                                  );

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'JMRCollection')
                                                      .doc(widget.depoName)
                                                      .collection('Table')
                                                      .doc(
                                                          '${tabsForJmr[_selectedIndex]}JmrTable')
                                                      .collection('userId')
                                                      .doc(widget.userId)
                                                      .set({
                                                    "isFileUploaded": true
                                                  });
                                                } else {
                                                  // User canceled the picker
                                                }
                                              },
                                        child: Text(
                                          'Upload',
                                          style: TextStyle(
                                              color: white, fontSize: 8),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ViewAllPdf(
                                              cityName: widget.cityName,
                                              depoName: widget.depoName,
                                              title: 'jmr',
                                              userId: widget.userId,
                                              fldrName:
                                                  'jmrFiles/${tabsForJmr[_selectedIndex]}/${widget.cityName}/${widget.depoName}/${widget.userId}/${index + 1}',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.035,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        margin:
                                            const EdgeInsets.only(left: 5.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border:
                                              Border.all(color: Colors.blue),
                                        ),
                                        child: const Text(
                                          'View',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 8),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ]);
                          }),
                    ),
                  ]),
      )),
    );
  }

  Widget cardlist(String title, int index, String title2, String Designation,
      int jmrListIndex) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: black)),
      child: Column(
        children: [
          Container(
            decoration:
                const BoxDecoration(border: Border(bottom: BorderSide())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: blue),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 40,
                  height: 30,
                  child: Text(
                    textAlign: TextAlign.center,
                    title,
                    style: TextStyle(
                        color: blue, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: isFieldEditable == false
                        ? null
                        : () {
                            index != 0
                                ? currentTabList[index - 1] == 0
                                    ? showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            icon: Icon(
                                              Icons.warning_amber,
                                              size: 40,
                                              color: Colors.blue[900],
                                            ),
                                            title: const Text(
                                              'Please Create Jmr Orderly',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 13,
                                              ),
                                            ),
                                            actions: [
                                              Center(
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('OK')),
                                              )
                                            ],
                                          );
                                        },
                                      )
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => JmrFieldPage(
                                            showTable: false,
                                            title: '$Designation-$title',
                                            jmrTab: title,
                                            cityName: widget.cityName,
                                            depoName: widget.depoName,
                                            jmrIndex: index + 1,
                                            tabName: tabsForJmr[_selectedIndex],
                                            userId: widget.userId!,
                                          ),
                                        ),
                                      ).then((_) {
                                        setState(() {
                                          currentTabList.clear();
                                          getJmrLen(5);
                                        });
                                      })
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JmrFieldPage(
                                        showTable: false,
                                        userId: widget.userId!,
                                        title: '$Designation-$title',
                                        jmrTab: title,
                                        cityName: widget.cityName,
                                        depoName: widget.depoName,
                                        jmrIndex: index + 1,
                                        tabName: tabsForJmr[_selectedIndex],
                                      ),
                                    ),
                                  ).then((_) {
                                    setState(() {
                                      currentTabList.clear();
                                      getJmrLen(5);
                                    });
                                  });
                          },
                    style: ElevatedButton.styleFrom(backgroundColor: blue),
                    child: const Text(
                      'Create New',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            height: MediaQuery.of(context).size.height * 0.13,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: jmrListIndex,
              itemBuilder: (context, index) {
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'JMR${index + 1}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.18,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JmrFieldPage(
                                    userId: widget.userId!,
                                    title:
                                        '$Designation-$title-JMR${index + 1}',
                                    jmrTab: title,
                                    cityName: widget.cityName,
                                    depoName: widget.depoName,
                                    showTable: true,
                                    dataFetchingIndex: index + 1,
                                    tabName: tabsForJmr[_selectedIndex],
                                  ),
                                )).then((_) {
                              setState(() {
                                getJmrLen(5);
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text(
                            'View',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getJmrLen(int currentIndex) async {
    List<dynamic> eachTabJmrList = [];
    setState(() {
      _isLoading = true;
    });
    for (int i = 0; i < currentIndex; i++) {
      int tempNum = 0;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('JMRCollection')
          .doc(widget.depoName)
          .collection('Table')
          .doc('${tabsForJmr[_selectedIndex]}JmrTable')
          .collection('userId')
          .doc(widget.userId)
          .collection('jmrTabName')
          .doc(title[i])
          .collection('jmrTabIndex')
          .get();
      tempNum = querySnapshot.docs.length;
      eachTabJmrList.add(tempNum);
    }
    currentTabList = eachTabJmrList;
    setState(() {
      _isLoading = false;
    });
  }

  Future getAssignedDepots() async {
    assignedCities = await authService.getCityList();
    isFieldEditable =
        authService.verifyAssignedDepot(
          widget.cityName!, assignedCities,
        );
  }
}
