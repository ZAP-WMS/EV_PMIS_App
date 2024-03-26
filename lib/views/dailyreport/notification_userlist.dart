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
  List<Map<String, dynamic>> userDepoList = [];

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
          ? const LoadingPage()
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
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    "Employees who have not uploaded today's work.",
                    style: normalboldtext,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  // height: 500,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(10),
                    itemCount: allDepots.length,
                    itemBuilder: (context, index) {
                      if (allDepots.isEmpty) {
                        return Text(
                          'All users are fill today DPR rrport',
                          style: TextStyle(color: blue),
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
                                return const LoadingPage();
                              }
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              // Iterate over the documents in the QuerySnapshot and print their IDs

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                List<Widget> columnwidgets = [];

                                for (int i = 0; i < userMapList.length; i++) {
                                  if (userMapList[i]['depots'] != null) {
                                    List depots = userMapList[i]['depots'];

                                    for (int j = 0; j < depots.length; j++) {
                                      if (depots[j] == depoName) {
                                        columnwidgets.add(
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(color: red),
                                            ),
                                            child: Text(
                                              userMapList[i]['name'],
                                              style: TextStyle(color: red),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );

                                        break; // Exit the inner loop once a match is found
                                      }
                                    }
                                  }
                                }

                                return Column(
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        decoration: BoxDecoration(
                                            color: lightblue,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: blue, width: 2)),
                                        child: Text(
                                          depoName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: white),
                                        )),
                                    Wrap(
                                        alignment: WrapAlignment.center,
                                        children: columnwidgets.isNotEmpty
                                            ? columnwidgets
                                            : [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border:
                                                        Border.all(color: red),
                                                  ),
                                                  child: const Text(
                                                      "User Not Assigned"),
                                                )
                                              ]),
                                  ],
                                );
                              }

                              for (int i = 0; i < userMapList.length; i++) {
                                if (userMapList[i]['depots'] != null) {
                                  List<String> userList = [];
                                  String? avlbId;
                                  List<String> docIds = [];
                                  List depots = userMapList[i]['depots'];
                                  String userId = userMapList[i]['userId'];
                                  String? userName;

                                  for (int j = 0; j < depots.length; j++) {
                                    // for (var doc in snapshot.data!.docs) {
                                    if (depots[j] == depoName) {
                                      for (Map<String, dynamic> userMap
                                          in userMapList) {
                                        // Check if the dictionary contains the value 'depoName'
                                        if (userMap['depots'] == depoName) {
                                          // If it does, add the dictionary to userList
                                          userList.add(userMap['userId']);
                                        }
                                      }

                                      for (var doc in snapshot.data!.docs) {
                                        docIds.add(doc.id);
                                      }
                                      for (int k = 0;
                                          k < userList.length;
                                          k++) {
                                        print('stored Id  :${userList[k]}');
                                        bool conditionNotSatisfied = false;

                                        for (String docId in userList) {
                                          if (!docIds.contains(docId)) {
                                            avlbId = docId;
                                            conditionNotSatisfied = true;

                                            for (var userMap in userMapList) {
                                              if (userMap['userId'] == avlbId) {
                                                userName = userMap['name'];
                                                break; // Break out of the loop once a match is found
                                              }
                                            }
                                            break;
                                          }
                                        }

                                        if (conditionNotSatisfied) {
                                          // Your code when doc.id does not contain userList[k]

                                          List<Widget> columnwidget = [];
                                          columnwidget.add(
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(color: red),
                                              ),
                                              child: Text(
                                                userName!,
                                                style: TextStyle(color: red),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );

                                          return Column(
                                            children: [
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  decoration: BoxDecoration(
                                                      color: lightblue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: blue,
                                                          width: 2)),
                                                  child: Text(
                                                    depoName,
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        TextStyle(color: white),
                                                  )),
                                              Wrap(
                                                children: columnwidget,
                                              ),
                                            ],
                                          );
                                        }
                                      }
                                      break;
                                    }
                                  }
                                }
                              }
                              return Column(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(5),
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      decoration: BoxDecoration(
                                          color: lightblue,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: blue, width: 2)),
                                      child: Text(
                                        depoName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: white),
                                      )),
                                  Wrap(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 5),
                                        margin: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(color: blue),
                                        ),
                                        child: Text(
                                          'Depots are updated',
                                          style: TextStyle(color: black),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              );
                            });
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
    userMapList.clear();
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
        String? userName = doc['allUserId'][0]['name'];
        // Extract the 'alluserId' array from each document data
        List<dynamic> allUserId = doc['allUserId'] ?? [];
        List<dynamic> allDepotsName = doc['depots'] ?? [];

        //  print(allUserId);
        if (allUserId != null) {
          // Iterate through each map in the array and add the user IDs to the list
          allUserId.forEach((userMap) async {
            if (userMap is Map<String, dynamic>) {
              userMapList.add(userMap);
            }
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
