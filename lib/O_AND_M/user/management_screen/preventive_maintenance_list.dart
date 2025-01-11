import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';

class PreventiveMaintenanceList extends StatefulWidget {
  String? depoName;

  PreventiveMaintenanceList(
      {super.key, required this.depoName, });

  @override
  State<PreventiveMaintenanceList> createState() =>
      _PreventiveMaintenanceListState();
}

class _PreventiveMaintenanceListState extends State<PreventiveMaintenanceList> {
  List<String> yearOption = ['Yearly', 'Half Yearly', 'Quarterly', 'Monthly'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: blue,
          title: const Text('Preventive Maintainance List'),
        ),
        body: Center(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 20, // Horizontal space between grid items
              mainAxisSpacing: 20, // Vertical space between grid items
            ),
            itemCount: yearOption.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/preventiveScreen',
                          arguments: {
                            'depoName': widget.depoName,
                            'indexValue': index
                            // 'role': roles,
                            // 'cityName': widget.cityName,
                            // 'userId': widget.userId,
                            // 'roleCentre': widget.roleCentre
                          });
                    },
                    child: Text(yearOption[index])),
              );
            },
          ),
        )
        //  ListView.builder(
        //   itemCount: yearOption.length,
        //   itemBuilder: (context, index) {
        //     return Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: ElevatedButton(
        //           onPressed: () {
        //             Navigator.pushNamed(context, '/preventiveScreen', arguments: {
        //               'depoName': widget.depoName,
        //               // 'role': roles,
        //               // 'cityName': widget.cityName,
        //               // 'userId': widget.userId,
        //               // 'roleCentre': widget.roleCentre
        //             });
        //           },
        //           child: Text(yearOption[index])),
        //     );
        //   },
        // ),
        );
  }
}
