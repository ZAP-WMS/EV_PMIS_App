import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/O_AND_M/admin/monthly_management_admin.dart';
import 'package:ev_pmis_app/PMIS/summary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../../../style.dart';
import '../../../../PMIS/widgets/progress_loading.dart';
import '../../../../PMIS/authentication/authservice.dart';
import '../user/management_screen/monthly_page/monthly_home.dart';

class MonthlyManagementAdminHomePage extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? userId;
  String? role;
  MonthlyManagementAdminHomePage(
      {super.key,
      required this.cityName,
      this.depoName,
      this.userId,
      this.role});

  @override
  State<MonthlyManagementAdminHomePage> createState() =>
      _MonthlyManagementAdminHomePageState();
}

class _MonthlyManagementAdminHomePageState
    extends State<MonthlyManagementAdminHomePage> {
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
              Container(
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                margin: const EdgeInsets.all(6.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MonthlyManagementHomePage(
                                // tabIndex: 0,
                                // tabletitle: 'Daily Progress Report',
                                cityName: widget.cityName,
                                depoName: widget.depoName,
                                userId: widget.userId,
                                role: widget.role!,
                              )),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: blue,
                  ),
                ),
              )
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
              MonthlyAdminManagementPage(
                tabIndex: 0,
                tabletitle: 'Charger Reading Format',
                cityName: widget.cityName,
                depoName: widget.depoName,
                userId: widget.userId!,
                role: widget.role!,
              ),
              MonthlyAdminManagementPage(
                tabIndex: 0,
                tabletitle: 'Charger Filter',
                cityName: widget.cityName,
                depoName: widget.depoName,
                userId: widget.userId!,
                role: widget.role!,
              )
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
