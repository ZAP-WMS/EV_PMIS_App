import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/screen/planning/planning_admin/planning_page_admin.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/views/keyevents/key_events2.dart';
import 'package:ev_pmis_app/views/planning/project_planning.dart';
import 'package:ev_pmis_app/widgets/admin_custom_appbar.dart';
import 'package:ev_pmis_app/widgets/nodata_available.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PlanningTable extends StatefulWidget {
  final String? userId;
  final String? cityName;
  final String? depoName;
  final String? id;
  String role;
  PlanningTable(
      {super.key,
      this.userId,
      this.cityName,
      required this.depoName,
      this.id,
      required this.role});

  @override
  State<PlanningTable> createState() => _PlanningTableState();
}

class _PlanningTableState extends State<PlanningTable> {
  //Daily Project Row List for view summary
  List<List<dynamic>> rowList = [];
  bool enableLoading = false;

  Future<List<List<dynamic>>> fetchData() async {
    await getRowsForFutureBuilder();
    return rowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            isProjectManager: widget.role == "projectManager" ? true : false,
            makeAnEntryPage: KeyEvents2(
              role: widget.role,
              cityName: widget.cityName,
              depoName: widget.depoName,
            ),
            cityName: widget.cityName,
            showDepoBar: true,
            toPlanning: true,
            depoName: widget.depoName,
            text: 'Planning Page',
            userId: widget.userId,
          )),
      body: enableLoading
          ? const LoadingPage()
          : FutureBuilder<List<List<dynamic>>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingPage();
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error fetching data'),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;

                  if (data.isEmpty) {
                    return const NodataAvailable();
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5.0, bottom: 5.0),
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
                            columnSpacing: 40.0,
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue[800]!),
                            headingTextStyle:
                                const TextStyle(color: Colors.white),
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'User_ID',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              )),
                              DataColumn(
                                  label: Text('Planning\nReport',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ))),
                              DataColumn(
                                  label: Text('Percentage of\nProgress',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ))),
                            ],
                            rows: data.map(
                              (rowData) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(rowData[0])),
                                    DataCell(ElevatedButton(
                                      onPressed: () {
                                        // _generatePDF(rowData[0], rowData[2], 1);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PlanningPageAdmin(
                                                userId: rowData[0],
                                                role: widget.role,
                                                cityName: widget.cityName,
                                                depoName: widget.depoName,
                                              ),
                                            ));
                                      },
                                      child: const Text('View'),
                                    )),
                                    DataCell(SizedBox(
                                        height: 20,
                                        width: 120,
                                        child: LinearPercentIndicator(
                                          backgroundColor: red,
                                          animation: true,
                                          lineHeight: 20.0,
                                          animationDuration: 2000,
                                          center: Text("${rowData[1]}%"),
                                          progressColor: Colors.green,
                                        ))),
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
        .collection('KeyEventsTable')
        .doc('${widget.depoName}')
        .collection('KeyDataTable')
        .get();

    List<dynamic> userIdList = querySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < userIdList.length; i++) {
      dynamic weightage;

      dynamic qtyExecuted;
      double totalperc = 0.0;
      num percprogress = 0;
      await FirebaseFirestore.instance
          .collection('KeyEventsTable')
          .doc('${widget.depoName}')
          .collection('KeyDataTable')
          .doc(userIdList[i])
          .collection('KeyAllEvents')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          var alldata = element.data()['data'];
          List<int> indicesToSkip = [0, 2, 6, 13, 18, 28, 32, 38, 64, 76];
          for (int i = 0; i < alldata.length; i++) {
            print('skipe${indicesToSkip.contains(i)}');

            if (!indicesToSkip.contains(i)) {
              qtyExecuted = alldata[i]['QtyExecuted'];
              weightage = alldata[i]['Weightage'];
              int scope = alldata[i]['QtyScope'];

              dynamic perc = ((qtyExecuted / scope) * weightage);
              double value = perc.isNaN ? 0.0 : perc;
              totalperc = totalperc + value;
              print('perc progress${totalperc}');
            }
          }
        });
      });
      rowList.add([userIdList[i], double.parse(totalperc.toStringAsFixed(1))]);
      print(rowList);
    }
  }

}
