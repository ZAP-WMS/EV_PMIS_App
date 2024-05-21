import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/PMIS/user/screen/closurefield.dart';
import 'package:ev_pmis_app/PMIS/widgets/admin_custom_appbar.dart';
import 'package:flutter/material.dart';

import '../../widgets/navbar.dart';
import 'closure_summary.dart';

class ClosureSummaryTable extends StatefulWidget {
  final String? userId;
  final String? cityName;
  final String? depoName;
  final String? id;
  final String role;
  ClosureSummaryTable(
      {super.key,
      this.userId,
      this.cityName,
      required this.depoName,
      this.id,
      required this.role});

  @override
  State<ClosureSummaryTable> createState() => _ClosureSummaryTableState();
}

class _ClosureSummaryTableState extends State<ClosureSummaryTable> {
  //Daily Project Row List for view summary
  List<List<dynamic>> rowList = [];
  TextEditingController selectedDepoController = TextEditingController();
  TextEditingController selectedCityController = TextEditingController();
  Future<List<List<dynamic>>> fetchData() async {
    await getRowsForFutureBuilder();
    return rowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavbarDrawer(role: widget.role,),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            showDepoBar: true,
            isProjectManager: widget.role == "projectManager" ? true : false,
            makeAnEntryPage: ClosureField(
              depoName: widget.depoName,
              userId: widget.userId!,
            ),
            toClosure: true,
            depoName: widget.depoName,
            cityName: widget.cityName,
            text: 'Closure Report',
            userId: widget.userId,
          )),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingPage());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;

            if (data.isEmpty) {
              return const Center(
                child: Text(
                  'No Data Available for Selected Depo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  padding:
                      const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DataTable(
                      showBottomBorder: true,
                      sortAscending: true,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[600]!,
                          width: 1.0,
                        ),
                      ),
                      columnSpacing: 150.0,
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue[800]!),
                      headingTextStyle: const TextStyle(color: Colors.white),
                      columns: const [
                        DataColumn(
                            label: Text(
                          'User_ID',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )),
                        DataColumn(
                            label: Text('Closure\nReport',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ))),
                      ],
                      rows: data.map(
                        (rowData) {
                          return DataRow(
                            cells: [
                              DataCell(Text(rowData[0])),
                              DataCell(ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ClosureSummary(
                                        depoName: widget.depoName,
                                        role: widget.role,
                                        cityName: widget.cityName,
                                        id: 'Closure Summary',
                                        user_id: rowData[0],
                                        userId: widget.userId,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'View',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                ),
                              )),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }

  Future<void> getRowsForFutureBuilder() async {
    rowList.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ClosureReportTable')
        .doc('${widget.depoName}')
        .collection('userId')
        .get();

    List<dynamic> userIdList = querySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < userIdList.length; i++) {
      rowList.add([userIdList[i], 'PDF']);
    }
  }
}
