import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/PMIS/user/screen/jmr.dart';
import 'package:ev_pmis_app/PMIS/view_AllFiles.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../../components/Loading_page.dart';
import '../../../style.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/navbar.dart';
import 'jmr_field_admin.dart';

class Jmr extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? userId;
  String role;
  Jmr(
      {super.key,
      this.cityName,
      this.depoName,
      this.userId,
      required this.role});

  @override
  State<Jmr> createState() => _JmrState();
}

class _JmrState extends State<Jmr> {
  List<List<int>> jmrCivilTabLen = [];
  List<List<int>> jmrElectricalTabLen = [];

  int _selectedIndex = 0;
  bool isConnected = false;

  bool isLoading = true;
  List<String> title = ['R1', 'R2', 'R3', 'R4', 'R5'];
  List<String> tabName = ['Civil', 'Electrical'];
  TextEditingController selectedDepoController = TextEditingController();

  @override
  void initState() {
    generateAllJmrList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: NavbarDrawer(
            role: widget.role,
          ),
          appBar: AppBar(
            centerTitle: true,
            title: Column(
              children: [
                const Text(
                  'JMR',
                  // maxLines: 2,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.depoName ?? '',
                  style: const TextStyle(fontSize: 11),
                )
              ],
            ),
            backgroundColor: blue,
            actions: [
              widget.role == "projectManager"
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
                              builder: (context) => JmrUserPage(
                                cityName: widget.cityName,
                                depoName: widget.depoName,
                                userId: widget.userId,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: blue,
                        ),
                      ),
                    )
                  : Container(),
            ],
            bottom: TabBar(
              onTap: (value) {
                _selectedIndex = value;
                generateAllJmrList();
              },
              labelColor: white,
              labelStyle: buttonWhite,
              unselectedLabelColor: Colors.black,

              //indicatorSize: TabBarIndicatorSize.label,
              indicator: MaterialIndicator(
                  horizontalPadding: 24,
                  bottomLeftRadius: 8,
                  bottomRightRadius: 8,
                  color: white,
                  paintingStyle: PaintingStyle.fill),
              tabs: const [
                Tab(text: 'Civil Engineer'),
                Tab(text: 'Electrical Engineer'),
              ],
            ),
          ),
          body: isLoading
              ? const LoadingPage()
              : TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                      customRowList('Civil'),
                      customRowList('Electrical')
                    ]),
        ));
  }

  Widget customRowList(String nameOfTab) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('JMRCollection')
          .doc(widget.depoName)
          .collection('Table')
          .doc('${tabName[_selectedIndex]}JmrTable')
          .collection('userId')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else if (!snapshot.hasData) {
          return const Center(
              child: Text(
            'No Data Available',
          ));
        } else if (snapshot.hasError) {
          return const Center(
              child: Text(
            'Error fetching data',
          ));
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          List<dynamic> userList = data.docs.map((e) => e.id).toList();

          return isLoading
              ? const LoadingPage()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: userList.length, //Length of user ID
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(
                          left: 5.0, right: 5.0, top: 5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: blue),
                      ),
                      child: ExpansionTile(
                        // backgroundColor: Colors.blue[500],
                        trailing: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        collapsedBackgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        title: Text(
                          'UserID - ${userList[index]}',
                          style: TextStyle(
                              color: blue, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index2) {
                                return Container(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 0.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 35,
                                        width: 40,
                                        child: TextButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blue[900])),
                                            child: Text(
                                              title[index2],
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: jmrTabList(
                                            userList[index],
                                            index2,
                                            index,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              })
                        ],
                      ),
                    );
                  },
                );
        }
        return Container();
      },
    );
  }

  jmrTabList(String currentUserId, int secondIndex, int firstIndex) {
    List<int> currentTabList = tabName[_selectedIndex] == "Civil"
        ? jmrCivilTabLen[firstIndex]
        : jmrElectricalTabLen[firstIndex];

    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width * 0.6,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: currentTabList[
                      secondIndex], // Length from list of jmr items
                  shrinkWrap: true,
                  itemBuilder: (context, index3) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: blue),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: 70,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.white)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JmrFieldPageAdmin(
                                    userId: currentUserId,
                                    showTable: true,
                                    dataFetchingIndex: index3 + 1,
                                    cityName: widget.cityName,
                                    title:
                                        '${tabName[_selectedIndex]}-${title[firstIndex]}',
                                    jmrTab: title[secondIndex],
                                    depoName: widget.depoName,
                                    jmrIndex: firstIndex + 1,
                                    tabName: tabName[_selectedIndex],
                                  ),
                                ));
                          },
                          child: Text(
                            'JMR${index3 + 1}',
                            style: TextStyle(
                                color: Colors.blue[900], fontSize: 11),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewAllPdf(
                      userId: currentUserId,
                      title: 'jmr',
                      cityName: widget.cityName!,
                      depoName: widget.depoName!,
                      fldrName:
                          '/jmrFiles/${tabName[_selectedIndex]}/${widget.cityName}/${widget.depoName}/$currentUserId/${secondIndex + 1}'),
                ),
              );
            },
            child: const Text('View'),
          )
        ],
      ),
    );
  }

  // Function to calculate Length of JMR all components with ID

  Future<List<dynamic>> generateAllJmrList() async {
    if (isLoading == false) {
      setState(() {
        isLoading = true;
      });
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('JMRCollection')
        .doc(widget.depoName)
        .collection('Table')
        .doc('${tabName[_selectedIndex]}JmrTable')
        .collection('userId')
        .get();

    List<dynamic> userListId =
        querySnapshot.docs.map((data) => data.id).toList();

    for (int i = 0; i < userListId.length; i++) {
      List<int> tempList = [];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('JMRCollection')
          .doc(widget.depoName)
          .collection('Table')
          .doc('${tabName[_selectedIndex]}JmrTable')
          .collection('userId')
          .doc(userListId[i])
          .collection('jmrTabName')
          .get();

      List<dynamic> jmrTabList =
          querySnapshot.docs.map((data) => data.id).toList();

      for (int j = 0; j < jmrTabList.length; j++) {
        QuerySnapshot jmrLen = await FirebaseFirestore.instance
            .collection('JMRCollection')
            .doc(widget.depoName)
            .collection('Table')
            .doc('${tabName[_selectedIndex]}JmrTable')
            .collection('userId')
            .doc(userListId[i])
            .collection('jmrTabName')
            .doc(jmrTabList[j])
            .collection('jmrTabIndex')
            .get();

        int jmrLength = jmrLen.docs.length;

        tempList.add(jmrLength);
      }
      if (tempList.length < 5) {
        int tempJmrLen = tempList.length;
        int loop = 5 - tempJmrLen;
        for (int k = 0; k < loop; k++) {
          tempList.add(0);
        }
      }
      if (tabName[_selectedIndex] == 'Civil') {
        jmrCivilTabLen.add(tempList);
      } else {
        jmrElectricalTabLen.add(tempList);
      }
    }

    setState(() {
      isLoading = false;
    });

    return tabName[_selectedIndex] == "Civil"
        ? jmrCivilTabLen
        : jmrElectricalTabLen;
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
