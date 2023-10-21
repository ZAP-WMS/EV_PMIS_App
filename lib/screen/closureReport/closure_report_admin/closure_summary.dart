import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/widgets/admin_custom_appbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class ClosureSummary extends StatefulWidget {
  final String? userId;
  final String? cityName;
  final String? depoName;
  final String? id;
  final String? date;
  final String? user_id;

  const ClosureSummary(
      {super.key,
      this.userId,
      this.cityName,
      required this.depoName,
      this.id,
      this.date,
      this.user_id});

  @override
  State<ClosureSummary> createState() => _ClosureSummaryState();
}

class _ClosureSummaryState extends State<ClosureSummary> {
  List<List<String>> tableRows = [
    ['1. Introduction of Project'],
    ['2 .RFP for DTC Bus Project '],
    ['3 .Project Purchase Order or LOI or LOA '],
    ['4 .Project Governance Structure'],
    ['5 .Site Location Details'],
    ['6 .Final  Site Survey Report'],
    ['7 .BOQ (Bill of Quantity)']
  ];

  List<String> tableRows2 = [
    '1. Introduction of Project',
    '2 .RFP for DTC Bus Project ',
    '3 .Project Purchase Order or LOI or LOA ',
    '4 .Project Governance Structure',
    '5 .Site Location Details',
    '6 .Final  Site Survey Report',
    '7 .BOQ (Bill of Quantity)'
  ];

  List<TableRow> rowOfWidget = [
    TableRow(children: [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            color: Colors.blue[500],
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              'Sr No',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          )),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            color: Colors.blue[500],
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              'List of Rows',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18),
            ),
          )),
    ])
  ];

  Future<List<TableRow>> fetchData() async {
    await getRowsForFutureBuilder('${widget.user_id}');
    return rowOfWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            toClosure: true,
            showDepoBar: true,
            cityName: widget.cityName,
            depoName: widget.depoName,
            text: '${widget.depoName} / ${widget.id}',
            userId: widget.userId,
          )),
      body: FutureBuilder<List<TableRow>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingPage());
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
              children: [
                Container(
                    padding:
                        const EdgeInsets.only(bottom: 10.0, top: 10, left: 10),
                    color: Colors.blue[900],
                    child: Row(
                      children: const [
                        Text(
                          'Closure Report',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ],
                    )),
                Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: tableRows2.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.black, width: 1),
                                        bottom: BorderSide(
                                            color: Colors.black, width: 1))),
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, bottom: 10, top: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      tableRows2[index].toString(),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }))
              ],
            );

            // return SingleChildScrollView(
            //   padding: const EdgeInsets.only(left: 6.0, right: 6.0),
            //   child: AnimatedContainer(
            //     duration: const Duration(milliseconds: 300),
            //     child: Table(
            //         columnWidths: const {
            //           0: FixedColumnWidth(100),
            //           1: FlexColumnWidth()
            //         },
            //         border: TableBorder.all(color: Colors.black),
            //         children: rowOfWidget),
            //   ),
            // );
          }
          return Container();
        },
      ),
    );
  }

  Future<void> getRowsForFutureBuilder(String user_id) async {
    final pdfLogo = MemoryImage(
      (await rootBundle.load('assets/pdf_logo.jpeg')).buffer.asUint8List(),
    );

    for (int i = 0; i < tableRows.length; i++) {
      List<Widget> url = [];

      rowOfWidget.add(customTableTextRow(tableRows[i][0], tableRows[i][1]));

      final path =
          'ClosureReport/${widget.cityName}/${widget.depoName}/$user_id/${tableRows[i][0]}';

      ListResult result =
          await FirebaseStorage.instance.ref().child(path).listAll();

      if (result.items.isNotEmpty) {
        for (var img in result.items) {
          final downloadUrl = await img.getDownloadURL();
          if (img.name.endsWith('.pdf')) {
            url.add(IconButton(
              hoverColor: Colors.transparent,
              iconSize: 80,
              onPressed: () {
                // openPdf(downloadUrl);
              },
              icon: Image(
                image: pdfLogo,
              ),
            ));
          } else {
            url.add(IconButton(
              hoverColor: Colors.transparent,
              iconSize: 80,
              onPressed: () {
                // openPdf(downloadUrl);
              },
              icon: Image(
                image: NetworkImage(downloadUrl),
              ),
            ));
          }
        }
      }
      rowOfWidget.add(customTableImageRow(url));
    }
  }

  customTableTextRow(String srNo, String row) {
    return TableRow(children: [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              srNo,
              style: const TextStyle(fontSize: 16),
            ),
          )),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              row,
              style: const TextStyle(fontSize: 16),
            ),
          ))
    ]);
  }

  customTableImageRow(List<Widget> url) {
    return TableRow(children: [
      const TableCell(child: Text('')),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Row(children: url)),
    ]);
  }

  // openPdf(var url) {
  //   if (kIsWeb) {
  //     html.window.open(url, '_blank');
  //     final encodedUrl = Uri.encodeFull(url);
  //     html.Url.revokeObjectUrl(encodedUrl);
  //   } else {
  //     const Text('Sorry it is not ready for mobile platform');
  //   }
  // }
}
