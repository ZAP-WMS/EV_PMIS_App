import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/PMIS/widgets/admin_custom_appbar.dart';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:flutter/material.dart';

import '../../../style.dart';
import '../dailyreport/daily_management.dart';
import 'monthly_page/monthly_home.dart';

class UserList extends StatefulWidget {
  String? cityName;
  String? role;
  String? depoName;
  String? userId;
  int? tabIndex;
  String? tabletitle;
  UserList({
    super.key,
    required this.cityName,
    required this.role,
    required this.depoName,
    required this.tabIndex,
    required this.tabletitle,
    required this.userId,
  });

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          text: 'User List',
          userId: widget.userId,
          cityName: widget.cityName,
          depoName: '${widget.depoName} / ${widget.tabletitle.toString()}',
          isProjectManager: false,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('AssignedRole')
            .where('depots', arrayContains: widget.depoName)
            .snapshots(),
        builder: (context, snapshot) {
          // Check if the snapshot has data or is still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage(); // Show a loading indicator
          }
          if (snapshot.hasError) {
            return Center(
                child:
                    Text('Error: ${snapshot.error}')); // Show an error message
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            // Loop through each document and print its ID
            for (var doc in snapshot.data!.docs) {
              print('Document ID: ${doc.id}');
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        print(doc['userId']);
                        return widget.tabletitle == 'Monthly Progress Report'
                            ? MonthlyManagementHomePage(
                                cityName: widget.cityName,
                                depoName: widget.depoName,
                                userId: doc['userId'],
                                role: widget.role!,
                              )
                            : DailyManagementPage(
                                cityName: widget.cityName,
                                role: widget.role!,
                                depoName: widget.depoName,
                                tabIndex: widget.tabIndex!,
                                tabletitle: widget.tabletitle,
                                userId: doc['userId']);
                      },
                    ));
                  },
                  child: ListTile(
                    title: Container(
                        height: 50,
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: blue, width: 2.0)),
                        child: Text('${doc['userId']}    ${doc.id}')),
                  ),
                );
              },
            );
          } else {
            // Handle case where there are no documents found
            return Center(child: Text('No documents found'));
          }
        },
      ),
    );
  }
}
