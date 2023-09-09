import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../style.dart';
import '../dailyreport/summary.dart';

class QualityHome extends StatefulWidget {
  const QualityHome({super.key});

  @override
  State<QualityHome> createState() => _QualityHomeState();
}

class _QualityHomeState extends State<QualityHome> {
  int? _selectedIndex = 0;

  List<String> listdata = [
    'Exc',
    'B.F',
    'Mass',
    'D.W.G',
    'F.C',
    'F&T',
    'G.I',
    'I.F',
    'Painting',
    'Paving',
    'WC&R',
    'Proofing'
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            // key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: blue,
              title: const Text('Quality Checklist'),
              actions: [
                // Row(
                //   children: [
                //     Padding(
                //       padding:
                //           const EdgeInsets.only(right: 40, top: 10, bottom: 10),
                //       child: Container(
                //         height: 30,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10),
                //             color: Colors.blue),
                //         child: TextButton(
                //             onPressed: () {
                //               Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                     builder: (context) => ViewSummary(
                //                       depoName: widget.depoName,
                //                       cityName: widget.cityName,
                //                       id: 'Quality Checklist',
                //                       selectedtab: _selectedIndex.toString(),
                //                       isHeader: false,
                //                     ),
                //                   ));
                //             },
                //             child: Text(
                //               'View Summary',
                //               style: TextStyle(color: white, fontSize: 20),
                //             )),
                //       ),
                //     ),
                //     Padding(
                //       padding:
                //           const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                //       child: Container(
                //         height: 30,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10),
                //             color: lightblue),
                //         child: TextButton(
                //             onPressed: () {
                //               FirebaseFirestore.instance
                //                   .collection('QualityChecklistCollection')
                //                   .doc('${widget.depoName}')
                //                   .collection('ChecklistData')
                //                   .doc(widget.currentDate)
                //                   .set({
                //                 'EmployeeName':
                //                     empName ?? 'Enter Employee Name',
                //                 'Dist EV': distev ?? 'Enter Dist EV',
                //                 'VendorName': vendorname ?? 'Enter Vendor Name',
                //                 'Date': date ?? 'Enter Date',
                //                 'OlaNo': olano ?? 'Enter Ola No',
                //                 'PanelNo': panel ?? 'Enter Panel',
                //                 'DepotName':
                //                     depotname ?? 'Enter depot Name Name',
                //                 'CustomerName':
                //                     customername ?? 'Enter Customer Name'
                //               });
                //               _selectedIndex == 0
                //                   ? CivilstoreData(context, widget.depoName!,
                //                       widget.currentDate!)
                //                   : storeData(context, widget.depoName!,
                //                       widget.currentDate!);
                //             },
                //             child: Text(
                //               'Sync Data',
                //               style: TextStyle(color: white, fontSize: 20),
                //             )),
                //       ),
                //     ),
                //     Padding(
                //         padding: const EdgeInsets.only(right: 150),
                //         child: GestureDetector(
                //             onTap: () {
                //               // onWillPop(context);
                //             },
                //             child: Image.asset(
                //               'assets/logout.png',
                //               height: 20,
                //               width: 20,
                //             )))
                //   ],
                // )
              ],
              // leading:
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 50),
                child: Column(
                  children: [
                    TabBar(
                      labelColor: white,
                      labelStyle: buttonWhite,
                      unselectedLabelColor: Colors.black,
                      indicator: MaterialIndicator(
                          horizontalPadding: 24,
                          bottomLeftRadius: 8,
                          bottomRightRadius: 8,
                          color: white,
                          paintingStyle: PaintingStyle.fill),
                      tabs: const [
                        Tab(text: 'Civil Engineer'),
                        Tab(text: 'Electrical Engineer'),
                      ],
                      onTap: (value) {
                        _selectedIndex = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(children: [
              ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return _selectedIndex == 0 ? tabbarlist(index) : Text('dfd');
                },
              )
            ]),
          )),
    );
  }

  Widget tabbarlist(int index) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: blue,
        ),
        child: Text(
          listdata[index],
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: white),
        ),
      ),
    );
  }
}
