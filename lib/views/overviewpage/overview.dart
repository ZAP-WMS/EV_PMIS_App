import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/cities_provider.dart';
import '../../shared_preferences/shared_preferences.dart';
import '../../style.dart';

class OverviewPage extends StatefulWidget {
  String? depoName;
  String? role;
  String? userId;
  OverviewPage({super.key, required this.depoName, this.role, this.userId});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  String? cityName;
  String roles = '';
  List<String> screens = [
    '/depotOverview',
    '/planning-page',
    '/material-page',
    '/daily-report',
    '/monthly-report',
    '/detailed-page',
    '/jmrPage',
    '/safety-page',
    '/quality-page',
    '/depot-inside-page',
    // '/depotOverview',
    '/closure-page',
    // '/closure-page',
    '/depot-energy',
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
    print('userId - ${widget.userId}');
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;
    print('Overview page - ${widget.role}');
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> description = [
      'Overview of Project Progress Status',
      'Project Planning',
      'Material Procurement',
      'Daily Progress Report',
      'Monthly Project Monitoring',
      'Detailed Engineering',
      'Online JMR',
      'Safety Check List',
      'FQP Checklist',
      'Depot Insides',
      'Closure Report',
      'Depot Demand Energy Management',
    ];
    // List<String> desription = [
    //   'Overview of Project Progress Status of ${widget.depoName} Bus Charging Infra',
    //   'Project Planning & Scheduling Bus Depot Wise [Gant Chart] ',
    //   'Material Procurement & Vendor Finalization Status',
    //   'Submission of Daily Progress Report for Individual Project',
    //   'Monthly Project Monitoring & Review',
    //   'Detailed Engineering Of Project Documents like GTP, GA Drawing',
    //   'Online JMR verification for projects',
    //   'Safety check list & observation',
    //   'FQP Checklist for Civil,Electrical work & Quality Checklist',
    //   'Depot Insides',
    //   'Closure Report',
    //   'Depot Demand Energy Management',
    // ];
    return Scaffold(
        drawer: const NavbarDrawer(),
        appBar: CustomAppBar(
          isCentered: true,
          title: 'Overview Page',
          height: 55,
          depoName: widget.depoName ?? '',
          isSync: false,
        ),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          child: GridView.builder(
              shrinkWrap: true,
              itemCount: description.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  // shadowColor: blue,
                  // borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: blue,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                      onTap: () => Navigator.pushNamed(context, screens[index],
                              arguments: {
                                'depoName': widget.depoName,
                                'role': roles,
                                'cityName': cityName,
                                'userId': widget.userId
                              }),
                      child:
                          cards(description[index], imagedata[index], index)),
                );
              }),
        )

        //  GridView.count(
        //   crossAxisCount: 2,
        //   mainAxisSpacing: 2,
        //   children: List.generate(description.length, (index) {
        //     return
        //   }),
        // ),
        );
  }

  Widget cards(String desc, String image, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          minRadius: 20,
          maxRadius: 27,
          backgroundColor: blue,
          child: CircleAvatar(
            minRadius: 20,
            maxRadius: 25,
            backgroundColor: white,
            child: SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.all(2),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 110),
            child: Text(
              desc,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  void getData() async {
    roles = await StoredDataPreferences.getSharedPreferences('role');
    print('Overview - $roles');
  }
}
