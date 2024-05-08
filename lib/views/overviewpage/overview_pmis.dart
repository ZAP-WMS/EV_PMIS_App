import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/cities_provider.dart';
import '../../shared_preferences/shared_preferences.dart';
import '../../style.dart';

class OverviewPmis extends StatefulWidget {
  final String? depoName;
  final String? role;
  final String? userId;
  final String? roleCentre;
  final String? cityName;
  const OverviewPmis(
      {super.key,
      required this.depoName,
      this.role,
      this.userId,
      this.roleCentre,
      this.cityName});

  @override
  State<OverviewPmis> createState() => _OverviewPmisState();
}

class _OverviewPmisState extends State<OverviewPmis> {
  String? cityName;

  String roles = '';

  List<String> screens = [
    '/depotOverview',
    '/planning-page',
    '/material-page',
    '/daily-report',
    //  '/daily-report',
    '/monthly-report',
    //'/monthly-report',
    '/detailed-page',
    '/jmrPage',
    '/safety-page',
    '/quality-page',
    '/depot-inside-page',
    '/closure-page',
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
    // createUserCollection();
    cityName = Provider.of<CitiesProvider>(context, listen: false).getName;
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

    return Scaffold(
      drawer: NavbarDrawer(
        role: widget.role,
      ),
      appBar: CustomAppBar(
        isCentered: true,
        title: 'Overview Page',
        height: 55,
        depoName: widget.depoName ?? '',
        isSync: false,
      ),
      body: Container(
        margin: const EdgeInsets.all(
          10.0,
        ),
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: description.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2),
            itemBuilder: (context, index) {
              return Card(
                color: grey,
                elevation: 20,

                // shadowColor: blue,
                // borderOnForeground: true,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: blue, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, screens[index], arguments: {
                    'depoName': widget.depoName,
                    'role': roles,
                    'cityName': cityName,
                    'userId': widget.userId,
                    'roleCentre': widget.roleCentre
                  }),
                  child: cards(
                    description[index],
                    imagedata[index],
                    index,
                  ),
                ),
              );
            }),
      ),
      //  GridView.count(
      //   crossAxisCount: 2,
      //   mainAxisSpacing: 2,
      //   children: List.generate(description.length, (index) {
      //     return
      //   }),
      // ),
      floatingActionButton:
          (widget.role == "projectManager" || widget.role == "admin")
              ? FloatingActionButton(
                  backgroundColor: blue,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/main_screen',
                      arguments: {
                        "roleCentre": widget.roleCentre,
                        'userId': widget.userId,
                        "role": widget.role
                      },
                      (route) => false,
                    );
                  },
                  child: const Icon(
                    Icons.splitscreen,
                  ),
                )
              : Container(),
    );
  }

  Widget cards(String desc, String image, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          minRadius: 30,
          maxRadius: 30,
          backgroundColor: grey,
          child: CircleAvatar(
            minRadius: 30,
            maxRadius: 30,
            backgroundColor: grey,
            child: SizedBox(
              height: 50,
              width: 50,
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

  Future createUserCollection() async {
    QuerySnapshot usersQuery =
        await FirebaseFirestore.instance.collection('User').get();

    List<dynamic> userNames = usersQuery.docs.map((e) => e.id).toList();

    QuerySnapshot totalQuery =
        await FirebaseFirestore.instance.collection("TotalUsers").get();

    List<dynamic> totalUserNames = totalQuery.docs.map((e) => e.id).toList();

    totalUserNames.every((element) {
      if (!userNames.contains(element)) {
        print("Missing Users - $element");
      }
      return true;
    });
  }
}
