import 'package:ev_pmis_app/screen/materialprocurement/material_vendor.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/cities_provider.dart';
import '../../style.dart';

class OverviewPage extends StatefulWidget {
  String? depoName;
  OverviewPage({super.key, required this.depoName});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  String? cityName;
  List<String> screens = [
    '/depotOverview',
    '/depotOverview',
    '/material-page',
    '/depotOverview',
    '/depotOverview',
    '/depotOverview',
    '/depotOverview',
    '/depotOverview',
    '/depotOverview',
    '/depotOverview',
    '/depotOverview',
    '/depotOverview',
    '/depotOverview',
    '/depotOverview',
  ];
  List imagedata = [
    'assets/overview_image/overview.png',
    'assets/overview_image/project_planning.png',
    'assets/overview_image/resource.png',
    'assets/overview_image/daily_progress.png',
    'assets/overview_image/monthly.png',
    'assets/overview_image/detailed_engineering.png',
    'assets/overview_image/jmr.png',
    'assets/overview_image/safety.png',
    'assets/overview_image/quality.png',
    'assets/overview_image/testing_commissioning.png',
    'assets/overview_image/closure_report.png',
    'assets/overview_image/easy_monitoring.jpg',
  ];

  @override
  void initState() {
    super.initState();
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;
  }

  @override
  Widget build(BuildContext context) {
    List<String> desription = [
      'Overview of Project Progress Status of ${widget.depoName} Bus Charging Infra',
      'Project Planning & Scheduling Bus Depot Wise [Gant Chart] ',
      'Material Procurement & Vendor Finalization Status',
      'Submission of Daily Progress Report for Individual Project',
      'Monthly Project Monitoring & Review',
      'Detailed Engineering Of Project Documents like GTP, GA Drawing',
      'Online JMR verification for projects',
      'Safety check list & observation',
      'FQP Checklist for Civil,Electrical work & Quality Checklist',
      'Testing & Commissioning Reports of Equipment',
      'Closure Report',
      'Easy monitoring of O & M schedule for all the equipment of depots.',
    ];
    return Scaffold(
      drawer: const NavbarDrawer(),
      appBar: CustomAppBar(
        title: 'Overview Page',
        height: 55,
        isSync: false,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        children: List.generate(desription.length, (index) {
          return GestureDetector(
              onTap: () =>
                  // Navigator.push(
                  //   context,
                  // MaterialPageRoute(
                  //   builder: (context) => MaterialProcurement(
                  //       cityName: cityName, depoName: widget.depoName),
                  // )),
                  Navigator.pushNamed(
                    context,
                    screens[index],
                    arguments: widget.depoName,
                  ),
              child: cards(desription[index], imagedata[index], index));
        }),
      ),
    );
  }

  Widget cards(String desc, String image, int index) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        elevation: 10,
        shadowColor: blue,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: Image.asset(image, fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            Text(
              desc,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
