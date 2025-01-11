import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/PMIS/summary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../../../style.dart';
import '../../../../PMIS/widgets/progress_loading.dart';
import 'monthly_page.dart';

class MonthlyManagementHomePage extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? userId;
  String? role;
  MonthlyManagementHomePage(
      {super.key,
      required this.cityName,
      this.depoName,
      this.userId,
      this.role});

  @override
  State<MonthlyManagementHomePage> createState() =>
      _MonthlyManagementHomePageState();
}

class _MonthlyManagementHomePageState extends State<MonthlyManagementHomePage>
    with SingleTickerProviderStateMixin {
  String? _selectedDate = DateFormat.yMMM().format(DateTime.now());
  TabController? _tabController;
  int _selectedIndex = 0;
  dynamic userId;

  @override
  void initState() {
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: _selectedIndex);
    // getUserId().whenComplete(() {
    //   setState(() {
    //     _isloading = false;
    //   });
    // });
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  List<String> titleName = [
    'Charger Reading Format',
    'Charger Filter',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title: Text('Monthly Page ',
            style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  chooseDate(context);
                },
                child: Image.asset(
                  'assets/appbar/calender.jpeg',
                  height: 35,
                  width: 35,
                ),
              ),
              Text(
                _selectedDate!,
                style: TextStyle(color: white, fontSize: 10),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 0, right: 5),
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewSummary(
                              depoName: widget.depoName,
                              cityName: widget.cityName,
                              titleName: titleName[_selectedIndex],
                              tabIndex: _selectedIndex,
                              userId: widget.userId,
                              id: 'Monthly Management'),
                        ));
                  },
                  child: Image.asset(
                    'assets/appbar/summary.jpeg',
                    height: 35,
                    width: 35,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showProgressDilogue(context);
                    monthlyManagementStoreData(
                      context,
                      widget.userId!,
                      widget.depoName!,
                      titleName[_selectedIndex],
                      _selectedIndex,
                      _selectedDate!,
                    );
                  },
                  child: Image.asset(
                    'assets/appbar/sync.jpeg',
                    height: 35,
                    width: 35,
                  ),
                )
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 50),
          child: TabBar(
            labelColor: yellow,
            labelStyle: buttonWhite,
            controller: _tabController,
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
            unselectedLabelColor: white,
            indicator: MaterialIndicator(
                horizontalPadding: 24,
                bottomLeftRadius: 8,
                bottomRightRadius: 8,
                color: white,
                paintingStyle: PaintingStyle.fill),
            tabs: const [
              Tab(
                text: 'Charger Reading Format',
              ),
              Tab(
                text: 'Charger Filter/DC Connector Cleaning Format',
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MonthlyManagementPage(
            cityName: widget.cityName,
            depoName: widget.depoName,
            titleIndex: _selectedIndex,
            tabletitle: 'Charger Reading Format',
            userId: widget.userId!,
            date: _selectedDate,
          ),
          MonthlyManagementPage(
            cityName: widget.cityName,
            depoName: widget.depoName,
            titleIndex: _selectedIndex,
            tabletitle: 'Charger Filter',
            userId: widget.userId!,
            date: _selectedDate,
          )
        ],
      ),
    );
  }

  void chooseDate(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('All Date'),
              content: Container(
                  height: 400,
                  width: 500,
                  child: SfDateRangePicker(
                    view: DateRangePickerView.month,
                    showTodayButton: false,
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      // if (args.value is PickerDateRange) {
                      //   // rangeStartDate = args.value.startDate;
                      //   // rangeEndDate = args.value.endDate;
                      // } else {
                      //   final List<PickerDateRange> selectedRanges = args.value;
                      // }
                    },
                    selectionMode: DateRangePickerSelectionMode.single,
                    showActionButtons: true,
                    onSubmit: ((value) {
                      _selectedDate = DateFormat.yMMM()
                          .format(DateTime.parse(value.toString()));
                      Navigator.pop(context);
                      // Force rebuild even if the tab is the same
                      _tabController!.index = (_tabController!.index + 1) %
                          2; // Cycle to a different tab
                      Future.delayed(Duration(milliseconds: 50), () {
                        // Cycle back to the original tab after a short delay
                        _tabController!.index = (_tabController!.index + 1) % 2;
                        print(_tabController!
                            .index); // Output the current tab index after switching
                      });
                      setState(() {});
                    }),
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  )),
            ));
  }

  Future<List<dynamic>> getDepoList(String pattern) async {
    List<dynamic> depoList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('DepoName')
        .doc(widget.cityName)
        .collection('AllDepots')
        .get();

    depoList = querySnapshot.docs.map((deponame) => deponame.id).toList();

    if (pattern.isNotEmpty) {
      depoList = depoList
          .where((element) => element
              .toString()
              .toUpperCase()
              .startsWith(pattern.toUpperCase()))
          .toList();
    }

    return depoList;
  }
}
