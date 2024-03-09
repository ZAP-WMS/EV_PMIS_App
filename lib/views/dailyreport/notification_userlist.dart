import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class userList extends StatefulWidget {
  // List<String> citiesList = [];
  userList({
    super.key,
  });

  @override
  State<userList> createState() => _userListState();
}

class _userListState extends State<userList> {
  String? selectedData;
  bool _isLoading = true;
  List<String>? citiesList = [];
  List<String> allDepots = [];
  List<Map<String, dynamic>> userMapList = [];

  @override
  void initState() {
    _loadCities().whenComplete(() {
      if (citiesList!.isEmpty) {
        // Handle the case when the list is empty
        selectedData = ''; // Or provide a default value
      } else {
        selectedData = citiesList![0];
      }
      fetchAllUserIds().whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: blue,
        title: Text(
          'UserList',
          style: TextStyle(fontSize: 15, color: white),
        ),
      ),
      body: _isLoading
          ? LoadingPage()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    height: 50,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: blue, width: 2.0)),
                    child: DropdownButton(
                      items: citiesList!
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          // value: selectedData,
                          value: value,
                          child: Text(value,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: black,
                                  fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                      value: selectedData,
                      onChanged: (value) {
                        selectedData = value!;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Employees who have not uploaded today's work.",
                    style: normalboldtext,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  // height: 500,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: allDepots.length,
                    itemBuilder: (context, index) {
                      if (allDepots.isEmpty) {
                        return Text(
                          'All users are fill today DPR rrport',
                          style: TextStyle(color: red),
                        );
                      } else {
                        String depoName = allDepots[index];
                        String? selectedDate =
                            DateFormat.yMMMMd().format(DateTime.now());
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('DailyProject3')
                              .doc(depoName)
                              .collection(selectedDate)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LoadingPage();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              List<Widget> columnwidgets = [];
                              for (int i = 0; i < userMapList.length; i++) {
                                columnwidgets.add(Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: blue,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: blue)),
                                    child: Text(
                                      userMapList[i]['name'],
                                      style: captionWhite,
                                      textAlign: TextAlign.center,
                                    )));
                              }
                              return Wrap(
                                alignment: WrapAlignment.center,
                                children: columnwidgets,
                              );
                            } else {
                              List<DocumentSnapshot<Map<String, dynamic>>>
                                  depoData = snapshot.data!.docs;

                              List<Widget> widgets = [];
                              for (int i = 0; i < userMapList.length; i++) {
                                // Comparing userId from userMapList with the ID of the first document in depoData
                                if (userMapList[i]['userId'] !=
                                    depoData.first.id) {
                                  widgets.add(Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: blue,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(color: blue)),
                                      child: Text(
                                        userMapList[i]['name'],
                                        style: captionWhite,
                                        textAlign: TextAlign.center,
                                      )));
                                }
                              }
                              return Wrap(
                                alignment: WrapAlignment.center,
                                children: widgets,
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
    );
  }

  Future<void> _loadCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? citiesString = prefs.getStringList('cities');
    if (citiesString != null) {
      citiesList = citiesString;

      // Wrap the citiesString with square brackets to form a valid JSON array
      // String jsonArrayString = '[$citiesString]';
      // List<dynamic> decoded = jsonDecode(jsonArrayString);
      // List<String> decodedStrings =
      //     decoded.map((dynamic item) => item.toString()).toList();
      // setState(() {
      //   citiesList = decodedStrings;
      // });
    }
  }

  Future<void> fetchAllUserIds() async {
    // Reference to the subcollection
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('roleManagement')
        .doc(selectedData)
        .collection('projectManager');

    try {
      // Fetch all documents from the subcollection
      QuerySnapshot querySnapshot = await collectionRef.get();
      List<dynamic> allUserIds = [];

      // Iterate through each document
      querySnapshot.docs.forEach((doc) {
        print(doc['allUserId'][0]['name']);
        // Extract the 'alluserId' array from each document data
        List<dynamic> allUserId = doc['allUserId'] ?? [];
        List<dynamic> allDepotsName = doc['depots'] ?? [];

        //  print(allUserId);
        if (allUserId != null) {
          // Iterate through each map in the array and add the user IDs to the list
          allUserId.forEach((userMap) {
            if (userMap is Map<String, dynamic>) {
              userMapList.add(userMap);
            }
            //    print('fetched all userId ${userMapList}');
          });
        }
        if (allDepotsName != null) {
          allDepotsName.forEach((element) {
            allDepots.add(element);
          });
        }
        // setState(() {
        //   _isLoading = false;
        // });
        print(allDepots);
      });
    } catch (e) {
      print('Error fetching documents: $e');
    }
  }
}
