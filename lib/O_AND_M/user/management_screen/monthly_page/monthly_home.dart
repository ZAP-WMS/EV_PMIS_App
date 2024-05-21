import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/date_format.dart';
import 'package:ev_pmis_app/PMIS/summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../../../style.dart';
import '../../../../PMIS/widgets/progress_loading.dart';
import '../../../../PMIS/authentication/authservice.dart';
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

class _MonthlyManagementHomePageState extends State<MonthlyManagementHomePage> {
  String? _selectedDate = DateFormat.yMMM().format(DateTime.now());
  int _selectedIndex = 0;
  dynamic userId;
  bool _isloading = true;

  @override
  void initState() {
    getUserId().whenComplete(() {
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  List<String> titleName = [
    'Charger Reading Format',
    'Charger Filter',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: _selectedIndex,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: blue,
              title: Text(
                'Monthly Page ',
                style: TextStyle(color: white, fontWeight: FontWeight.bold),
              ),
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
                            userId,
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

                // Padding(
                //   padding:
                //       const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                //   child: Container(
                //     height: 30,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         color: lightblue),
                //     child: TextButton(
                //         onPressed: () {
                //           monthlyManagementStoreData(
                //               context,
                //               userId,
                //               widget.depoName!,
                //               titleName[_selectedIndex],
                //               _selectedIndex,
                //               _selectedDate!);
                //         },
                //         child: Text(
                //           'Sync Data',
                //           style: TextStyle(color: white, fontSize: 20),
                //         )),
                //   ),
                // )
              ],
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 50),
                child: TabBar(
                  labelColor: yellow,
                  labelStyle: buttonWhite,
                  unselectedLabelColor: white,
                  indicator: MaterialIndicator(
                      horizontalPadding: 24,
                      bottomLeftRadius: 8,
                      bottomRightRadius: 8,
                      color: white,
                      paintingStyle: PaintingStyle.fill,
                      ),
                  tabs: const [
                        Tab(
                          text: 'Charger Reading Format',
                        ),
                      Tab(
                        text: 'Charger Filter/DC Connector Cleaning Format',
                    ),
                  ],
                  onTap: (value) {
                    _selectedIndex = value;
                  },
                ),
              ),
            ),
          body: TabBarView(
            children: [
              MonthlyManagementPage(
                  cityName: widget.cityName,
                  depoName: widget.depoName,
                  tabIndex: _selectedIndex,
                  tabletitle: 'Charger Reading Format',
                  ),
              MonthlyManagementPage(
                  cityName: widget.cityName,
                  depoName: widget.depoName,
                  tabIndex: _selectedIndex,
                  tabletitle: 'Charger Filter',
                  ),
            ],
          ),
        ));
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

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
      setState(() {});
    });
  }
}
