import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../style.dart';
import '../views/authentication/login_register.dart';

class CustomAppBar extends StatefulWidget {
  final String? text;
  String? userId;
  // final IconData? icon;
  final bool haveSynced;
  final bool haveSummary;
  final void Function()? store;
  VoidCallback? downloadFun;
  VoidCallback? onTap;
  bool havebottom;
  bool isdetailedTab;
  bool isdownload;
  TabBar? tabBar;
  String? cityName;
  String? depoName;
  bool showDepoBar;
  bool toMainOverview;
  bool toOverview;
  bool toPlanning;
  bool toMaterial;
  bool toSubmission;
  bool toMonthly;
  bool toDetailEngineering;
  bool toJmr;
  bool toSafety;
  bool toChecklist;
  bool toTesting;
  bool toClosure;
  bool toEasyMonitoring;
  bool toDaily;
  bool? isProjectManager;
  Widget? makeAnEntryPage;

  CustomAppBar(
      {super.key,
      required this.text,
      required this.userId,
      this.haveSynced = false,
      this.haveSummary = false,
      this.store,
      this.onTap,
      this.havebottom = false,
      this.isdownload = false,
      this.isdetailedTab = false,
      this.tabBar,
      this.cityName,
      this.showDepoBar = false,
      this.toOverview = false,
      this.toPlanning = false,
      this.toMaterial = false,
      this.toSubmission = false,
      this.toMonthly = false,
      this.toDetailEngineering = false,
      this.toJmr = false,
      this.toSafety = false,
      this.toChecklist = false,
      this.toTesting = false,
      this.toClosure = false,
      this.toEasyMonitoring = false,
      this.toDaily = false,
      this.toMainOverview = false,
      required this.depoName,
      this.isProjectManager,
      this.makeAnEntryPage,
      this.downloadFun});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  TextEditingController selectedDepoController = TextEditingController();
  TextEditingController selectedCityController = TextEditingController();

  @override
  void initState() {
    selectedCityController.text = widget.cityName.toString();
    selectedDepoController.text = widget.depoName.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        backgroundColor: blue,
        title: Column(
          children: [
            Text(
              widget.text ?? '',
              // maxLines: 2,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.depoName ?? '',
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            )
          ],
        ),
        actions: [
          widget.isProjectManager!
              ? Container(
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
                            builder: (context) => widget.makeAnEntryPage!),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: blue,
                    ),
                  ),
                )
              : Container(),
          widget.toMainOverview
              ? Container(
                  padding: const EdgeInsets.all(5.0),
                  width: 200,
                  height: 30,
                  child: TypeAheadField(
                      animationStart: BorderSide.strokeAlignCenter,
                      suggestionsCallback: (pattern) async {
                        return await getCityList(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(
                            suggestion.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        selectedCityController.text = suggestion.toString();
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.all(5.0),
                          hintText: widget.cityName,
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                        controller: selectedCityController,
                      )),
                )
              : Container(),
          widget.isdownload
              ? Container(
                  margin: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: widget.downloadFun,
                    icon: const Icon(
                      Icons.download,
                    ),
                  ),
                )
              : widget.haveSummary
                  ? Padding(
                      padding:
                          const EdgeInsets.only(right: 40, top: 10, bottom: 10),
                      child: Container(
                        height: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),
                        child: TextButton(
                          onPressed: widget.onTap,
                          child: Text(
                            'View Summary',
                            style: TextStyle(
                              color: white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
          widget.haveSynced
              ? Padding(
                  padding:
                      const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue),
                    child: TextButton(
                        onPressed: () {
                          widget.store!();
                        },
                        child: Text(
                          'Sync Data',
                          style: TextStyle(color: white, fontSize: 20),
                        )),
                  ),
                )
              : Container(),
        ],
        bottom: widget.havebottom
            ? TabBar(
                labelColor: Colors.yellow,
                labelStyle: buttonWhite,
                unselectedLabelColor: white,

                //indicatorSize: TabBarIndicatorSize.label,
                indicator: MaterialIndicator(
                  horizontalPadding: 24,
                  bottomLeftRadius: 8,
                  bottomRightRadius: 8,
                  color: Colors.black,
                  paintingStyle: PaintingStyle.fill,
                ),

                tabs: const [
                  Tab(text: "PSS"),
                  Tab(text: "RMU"),
                  Tab(text: "PSS"),
                  Tab(text: "RMU"),
                  Tab(text: "PSS"),
                  Tab(text: "RMU"),
                  Tab(text: "PSS"),
                  Tab(text: "RMU"),
                  Tab(text: "PSS"),
                ],
              )
            : widget.isdetailedTab
                ? TabBar(
                    labelColor: Colors.yellow,
                    labelStyle: buttonWhite,
                    unselectedLabelColor: white,

                    //indicatorSize: TabBarIndicatorSize.label,
                    indicator: MaterialIndicator(
                      horizontalPadding: 24,
                      bottomLeftRadius: 8,
                      bottomRightRadius: 8,
                      color: Colors.black,
                      paintingStyle: PaintingStyle.fill,
                    ),

                    tabs: const [
                      Tab(text: "RFC Drawings of Civil Activities"),
                      Tab(text: "EV Layout Drawings of Electrical Activities"),
                      Tab(text: "Shed Lighting Drawings & Specification"),
                    ],
                  )
                : widget.tabBar);
  }

  Future<List<dynamic>> getDepoList(String pattern) async {
    List<dynamic> depoList = [];

    if (selectedCityController.text.isNotEmpty) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('DepoName')
          .doc(selectedCityController.text)
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
    } else {
      depoList.add('Please Select a City');
    }

    return depoList;
  }

  Future<List<dynamic>> getCityList(String pattern) async {
    List<dynamic> cityList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('DepoName').get();

    cityList = querySnapshot.docs.map((deponame) => deponame.id).toList();

    if (pattern.isNotEmpty) {
      cityList = cityList
          .where((element) => element
              .toString()
              .toUpperCase()
              .startsWith(pattern.toUpperCase()))
          .toList();
    }

    return cityList;
  }
}
