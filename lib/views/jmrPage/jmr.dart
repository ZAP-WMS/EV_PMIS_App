import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../../components/Loading_page.dart';
import '../../../style.dart';
import '../authentication/authservice.dart';
import 'jmr_fields.dart';

class JmrUserPage extends StatefulWidget {
  String? cityName;
  String? depoName;
  JmrUserPage({super.key, this.cityName, this.depoName});

  @override
  State<JmrUserPage> createState() => _JmrUserPageState();
}

class _JmrUserPageState extends State<JmrUserPage> {
  List currentTabList = [];
  String selectedDepot = '';
  int _selectedIndex = 0;
  bool _isLoading = true;
  List tabsForJmr = ['Civil', 'Electrical'];

  dynamic userId;
  Widget selectedUI = Container();

  List<String> title = ['R1', 'R2', 'R3', 'R4', 'R5'];

  @override
  void initState() {
    getUserId().whenComplete(() => {
          getJmrLen(5),
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      animationDuration: const Duration(milliseconds: 200),
      initialIndex: 0,
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          bottom: TabBar(
              unselectedLabelColor: tabbarColor,
              labelColor:
                  _selectedIndex == _selectedIndex ? white : tabbarColor,
              //indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(color: blue),
              //  MaterialIndicator(
              //     horizontalPadding: 24,
              //     bottomLeftRadius: 8,
              //     bottomRightRadius: 8,
              //     color: white,
              //     paintingStyle: PaintingStyle.fill),
              onTap: (value) {
                _selectedIndex = value;
                getJmrLen(5);
                print(_selectedIndex);
              },
              tabs: const [
                Tab(
                  text: 'Civil Engineer',
                ),
                Tab(text: 'Electrical Engineer'),
              ]),
          centerTitle: true,
          title: Text(
            'JMR / ${widget.depoName}',
            style: const TextStyle(fontSize: 14),
          ),
          flexibleSpace: Container(
            height: 80,
            color: blue,
          ),
        ),
        body: _isLoading
            ? LoadingPage()
            : TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0),
                      child: GridView.builder(
                          itemCount: 5,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 200,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return cardlist(title[index], index, title[index],
                                'Civil', currentTabList[index]);
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, top: 5.0),
                      child: GridView.builder(
                          itemCount: 5,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 200,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return cardlist(title[index], index, title[index],
                                'Electrical', currentTabList[index]);
                          }),
                    ),
                  ]),
      )),
    );
  }

  Widget cardlist(String title, int index, String title2, String Designation,
      int jmrListIndex) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: black)),
      child: Column(
        children: [
          Container(
            decoration:
                const BoxDecoration(border: Border(bottom: BorderSide())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue,
                  ),
                  width: 40,
                  height: 30,
                  child: Text(
                    textAlign: TextAlign.center,
                    title,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    index != 0
                        ? currentTabList[index - 1] == 0
                            ? showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    icon: Icon(
                                      Icons.warning_amber,
                                      size: 40,
                                      color: Colors.blue[900],
                                    ),
                                    title: const Text(
                                      'Please Create Jmr Orderly',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 13,
                                      ),
                                    ),
                                    actions: [
                                      Center(
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK')),
                                      )
                                    ],
                                  );
                                },
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JmrFieldPage(
                                    showTable: false,
                                    title: '$Designation-$title',
                                    jmrTab: title,
                                    cityName: widget.cityName,
                                    depoName: widget.depoName,
                                    jmrIndex: index + 1,
                                    tabName: tabsForJmr[_selectedIndex],
                                  ),
                                ),
                              ).then((_) {
                                setState(() {
                                  currentTabList.clear();
                                  getJmrLen(5);
                                });
                              })
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JmrFieldPage(
                                showTable: false,
                                title: '$Designation-$title',
                                jmrTab: title,
                                cityName: widget.cityName,
                                depoName: widget.depoName,
                                jmrIndex: index + 1,
                                tabName: tabsForJmr[_selectedIndex],
                              ),
                            ),
                          ).then((_) {
                            setState(() {
                              currentTabList.clear();
                              getJmrLen(5);
                            });
                          });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: blue),
                  child: const Text(
                    'Create New JMR',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            height: 130,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: jmrListIndex,
              itemBuilder: (context, index) {
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'JMR${index + 1}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        height: 30,
                        width: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JmrFieldPage(
                                    title:
                                        '$Designation-$title-JMR${index + 1}',
                                    jmrTab: title,
                                    cityName: widget.cityName,
                                    depoName: widget.depoName,
                                    showTable: true,
                                    dataFetchingIndex: index + 1,
                                    tabName: tabsForJmr[_selectedIndex],
                                  ),
                                )).then((_) {
                              setState(() {
                                getJmrLen(5);
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text(
                            'View',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getJmrLen(int currentIndex) async {
    List<dynamic> eachTabJmrList = [];
    setState(() {
      _isLoading = true;
    });
    for (int i = 0; i < currentIndex; i++) {
      int tempNum = 0;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('JMRCollection')
          .doc(widget.depoName)
          .collection('Table')
          .doc('${tabsForJmr[_selectedIndex]}JmrTable')
          .collection('userId')
          .doc(userId)
          .collection('jmrTabName')
          .doc(title[i])
          .collection('jmrTabIndex')
          .get();
      tempNum = querySnapshot.docs.length;
      eachTabJmrList.add(tempNum);
    }
    currentTabList = eachTabJmrList;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }
}
