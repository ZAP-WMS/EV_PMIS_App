import 'package:ev_pmis_app/screen/qualitychecklist/quality_admin/civil/civil_admin.dart';
import 'package:ev_pmis_app/screen/qualitychecklist/quality_admin/electrical/electrical_admin.dart';
import 'package:ev_pmis_app/screen/safetyreport/safetyfield.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class QualityHomeAdmin extends StatefulWidget {
  String? depoName;
  String? cityName;
  QualityHomeAdmin({super.key, this.depoName, this.cityName});

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
            // key: scaffoldKey,

            appBar: AppBar(
              backgroundColor: blue,
              title: Text(
                '${widget.depoName}/Quality Checklist',
                style: const TextStyle(fontSize: 14),
              ),
              actions: const [],
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
                            builder: (context) => CivilReportAdmin(
                              cityName: cityName,
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
