import 'package:ev_pmis_app/views/dailyreport/daily_management.dart';
import 'package:flutter/material.dart';
import '../../style.dart';
import '../../PMIS/widgets/navbar.dart';

class DailyManagementHomePage extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? currentDate;
  DateTime? startDate;
  DateTime? endDate;
  bool? isHeader;
  String? role;
  String? userId;

  DailyManagementHomePage({
    super.key,
    required this.cityName,
    this.depoName,
    this.currentDate,
    this.isHeader = true,
    this.startDate,
    this.endDate,
    this.userId,
    this.role,
  });

  @override
  State<DailyManagementHomePage> createState() =>
      _DailyManagementHomePageState();
}

class _DailyManagementHomePageState extends State<DailyManagementHomePage> {
  List<String> titleName = [
    'Charger Checklist',
    'SFU Checklist',
    'PSS Checklist',
    'Transformer Checklist',
    'RMU Checklist',
    'ACDB Checklist',
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          centerTitle: true,
          title: Column(
            children: [
              const Text('Daily Report',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
          //  actions: const [],
          // leading:
          // bottom: PreferredSize(
          //   preferredSize: const Size(double.infinity, 50),
          //   child: Column(
          //     children: [
          //       TabBar(
          //         unselectedLabelColor: tabbarColor,
          //         labelColor: _selectedIndex == _selectedIndex
          //             ? white
          //             : tabbarColor,
          //         onTap: (value) {
          //           _selectedIndex = value;
          //           setState(() {});
          //         },
          //         indicator: BoxDecoration(
          //           color:
          //               blue, // Set the background color of the selected tab label
          //         ),
          //         tabs: const [
          //           Tab(text: 'Civil Engineer'),
          //           Tab(text: 'Electrical Engineer'),
          //         ],
          //         // onTap: (value) {
          //         //   _selectedIndex = value;
          //         //   setState(() {});
          //         // },
          //       ),
          //     ],
          //   ),
          // ),
        ),
        drawer: NavbarDrawer(
          role: 'widget.role',
        ),
        body: ListView.builder(
          itemCount: titleName.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DailyManagementPage(
                          cityName: widget.cityName,
                          depoName: widget.depoName,
                          tabIndex: index,
                          tabletitle: titleName[index],
                          userId: widget.userId))),
              child: tabbarlist(
                titleName,
                index,
              ),
            );
          },
        ),
      ),
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
