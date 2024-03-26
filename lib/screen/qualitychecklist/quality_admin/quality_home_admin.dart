import 'package:ev_pmis_app/screen/qualitychecklist/quality_admin/civil/civil_admin.dart';
import 'package:ev_pmis_app/screen/qualitychecklist/quality_admin/electrical/electrical_admin.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/views/qualitychecklist/quality_home.dart';
import 'package:ev_pmis_app/views/safetyreport/safetyfield.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class QualityHomeAdmin extends StatefulWidget {
  String? depoName;
  String? cityName;
  String role;
  String? userId;
  QualityHomeAdmin(
      {super.key,
      this.depoName,
      this.cityName,
      required this.role,
      this.userId});

  @override
  State<QualityHomeAdmin> createState() => _QualityHomeAdminState();
}

class _QualityHomeAdminState extends State<QualityHomeAdmin> {
  int? _selectedIndex = 0;

  List<String> civilClnName = [
    'Exc',
    'BackFilling',
    'Massonary',
    'Glazzing',
    'Ceilling',
    'Flooring',
    'Inspection',
    'Ironite',
    'Painting',
    'Paving',
    'Roofing',
    'Proofing'
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
    'PSS',
    'RMU',
    'CT',
    'CMU',
    'ACDB',
    'CI',
    'CDI',
    'MSP',
    'CHARGER',
    'EARTH PIT'
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

  List<String> datasource = [
    '_qualityExcavationDataSource',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: white,
              title: Column(
                children: [
                  const Text(
                    'Quality Checklist',
                    // maxLines: 2,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.depoName ?? '',
                    style: const TextStyle(fontSize: 11),
                  )
                ],
              ),
              flexibleSpace: Container(
                height: 60,
                color: blue,
              ),
              actions: [
                widget.role == "projectManager"
                    ? Container(
                        margin: const EdgeInsets.all(8.0),
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QualityHome(
                                    depoName: widget.depoName,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add)),
                      )
                    : Container()
              ],
              // leading:
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 50),
                child: Column(
                  children: [
                    TabBar(
                      unselectedLabelColor: tabbarColor,
                      labelColor: _selectedIndex == _selectedIndex
                          ? white
                          : tabbarColor,
                      labelStyle: buttonWhite,
                      indicator: BoxDecoration(
                        color:
                            blue, // Set the background color of the selected tab label
                      ),
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
                            builder: (context) => CivilReportAdmin(
                              cityName: cityName,
                              userId: widget.userId,
                              selectedIndex: index,
                              depoName: widget.depoName,
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
                              builder: (context) => ElectricalReportAdmin(
                                userId: widget.userId,
                                cityName: cityName,
                                selectedIndex: index,
                                depoName: widget.depoName,
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
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: blue),
          borderRadius: BorderRadius.circular(10),
          color: white,
        ),
        child: Text(
          list[index],
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: blue),
        ),
      ),
    );
  }
}
