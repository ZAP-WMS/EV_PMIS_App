import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/screen/qualitychecklist/civil/civil_field.dart';
import 'package:ev_pmis_app/screen/qualitychecklist/electrical/electrical_field.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../style.dart';
import '../dailyreport/summary.dart';

class QualityHome extends StatefulWidget {
  String? depoName;
  QualityHome({super.key, this.depoName});

  @override
  State<QualityHome> createState() => _QualityHomeState();
}

class _QualityHomeState extends State<QualityHome> {
  int? _selectedIndex = 0;

  List<String> civilClnName = [
    'Exc TABLE',
    'BF TABLE',
    'MASS TABLE',
    'GLAZZING TABLE',
    'CEILING TABLE',
    'FLOORING TABLE',
    'INSPECTION TABLE',
    'IRONITE TABLE',
    'PAINTING TABLE',
    'PAVING TABLE',
    'ROOFING TABLE',
    'PROOFING TABLE'
  ];

  List<String> civillist = [
    'Excavation Work',
    'EARTH WORK - BACKFILLING',
    'CHECKLIST FOR BRICK / BLOCK MASSONARY',
    'CHECKLIST FOR BUILDING DOORS, WINDOWS, HARDWARE, GLAZING',
    'CHECKLIST FOR FALSE CEILING',
    'CHECKLIST FOR FLOORING & TILING',
    'GROUTING INSPECTION',
    'CHECKLIST FOR IRONITE/ IPS FLOORING ',
    'CHECKLIST FOR PAINTING WORK',
    'CHECKLIST FOR INTERLOCK PAVING WORK',
    'CHECKLIST FOR WALL CLADDING & ROOFING',
    'CHECKLIST FOR WATER PROOFING'
  ];

  List<String> eleClnName = [
    'PSS TABLE',
    'RMU TABLE',
    'CT TABLE',
    'CMU TABLE',
    'ACDB TABLE',
    'CI TABLE',
    'CDI TABLE',
    'MCCB TABLE',
    'CHARGER TABLE',
    'EARTH TABLE'
  ];
  List<String> electricallist = [
    'CHECKLIST FOR INSTALLATION OF PSS',
    'CHECKLIST FOR INSTALLATION OF RMU',
    'COVENTIONAL TRANSFORMER',
    'CTPT METERING UNIT',
    'CHECKLIST FOR INSTALLATION OF ACDB',
    'CHECKLIST FOR  CABLE INSTALLATION ',
    'CHECKLIST FOR CABLE DRUM / ROLL INSPECTION',
    'CHECKLIST FOR MCCB PANEL',
    'CHECKLIST FOR CHARGER PANEL',
    'CHECKLIST FOR INSTALLATION OF  EARTH PIT',
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
              actions: const [
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
            drawer: const NavbarDrawer(),
            body: TabBarView(children: [
              ListView.builder(
                itemCount: civillist.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CivilField(
                              depoName: widget.depoName,
                              title: civillist[index],
                              fieldclnName: civilClnName[index],
                              index: index,
                            ),
                          )),
                      child: tabbarlist(civillist, index));
                },
              ),
              ListView.builder(
                  itemCount: electricallist.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ElectricalField(
                                depoName: widget.depoName,
                                title: electricallist[index],
                                fielClnName: eleClnName[index],
                                titleIndex: index,
                              ),
                            )),
                        child: tabbarlist(electricallist, index));
                  })
            ]),
          )),
    );
  }

  Widget tabbarlist(List<String> list, int index) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: blue,
        ),
        child: Text(
          list[index],
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: white),
        ),
      ),
    );
  }
}
