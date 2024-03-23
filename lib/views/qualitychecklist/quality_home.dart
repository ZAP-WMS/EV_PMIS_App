import 'package:ev_pmis_app/screen/qualitychecklist/quality_user/civil/civil_field.dart';
import 'package:ev_pmis_app/screen/qualitychecklist/quality_user/electrical/electrical_field.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import '../../style.dart';

class QualityHome extends StatefulWidget {
  String? depoName;
  String? userId;
  String? role;
  QualityHome({super.key,this.userId,this.role, this.depoName});

  @override
  State<QualityHome> createState() => _QualityHomeState();
}

class _QualityHomeState extends State<QualityHome> {
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
    'Proofing',
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
    'EARTH PIT',
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
              backgroundColor: white,
              centerTitle: true,
              title: Column(
                children: [
                  const Text('Quality Checklist',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(widget.depoName ?? '',
                      style: const TextStyle(
                        fontSize: 11,
                      )),
                ],
              ),
              flexibleSpace: Container(
                height: 60,
                color: blue,
              ),
              actions: const [],
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
                      onTap: (value) {
                        _selectedIndex = value;
                        setState(() {});
                      },
                      indicator: BoxDecoration(
                        color:
                            blue, // Set the background color of the selected tab label
                      ),
                      tabs: const [
                        Tab(text: 'Civil Engineer'),
                        Tab(text: 'Electrical Engineer'),
                      ],
                      // onTap: (value) {
                      //   _selectedIndex = value;
                      //   setState(() {});
                      // },
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
                              role: widget.role,
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
                                role: widget.role,
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
