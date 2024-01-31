import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/provider/All_Depo_Select_Provider.dart';
import 'package:ev_pmis_app/provider/demandEnergyProvider.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class DemandTable extends StatefulWidget {
  final Future<dynamic> Function() getDailyData;
  final Future<dynamic> Function() getMonthlyData;
  final Future<dynamic> Function() getQuaterlyData;
  final Future<dynamic> Function() getYearlyData;
  final List<dynamic> columns;
  final List<dynamic> rows;

  DemandTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.getDailyData,
    required this.getMonthlyData,
    required this.getQuaterlyData,
    required this.getYearlyData,
  });

  @override
  State<DemandTable> createState() => _DemandTableState();
}

class _DemandTableState extends State<DemandTable>
    with SingleTickerProviderStateMixin {
  List<dynamic> depoList = [];
  List<String> citiesList = [];
  List<dynamic> searchedList = [];
  List<dynamic> searchedDepoList = [];
  TextEditingController cityController = TextEditingController();
  TextEditingController selectedDepo = TextEditingController();
  final tableHeadingColor = Colors.blue;
  final tableRowColor = Colors.white;
  bool isDepoSelected = false;
  bool isCitySelected = false;

  @override
  void initState() {
    super.initState();
    getCityList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size.width;
    final demandEnergyProvider =
        Provider.of<DemandEnergyProvider>(context, listen: false);
    final allDepoProvider =
        Provider.of<AllDepoSelectProvider>(context, listen: false);
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 234, 243, 250),
              borderRadius: BorderRadius.circular(
                5,
              ),
            ),
            margin: const EdgeInsets.only(top: 5),
            child: const Text(
              'Demand Energy Management Table',
              style: TextStyle(
                fontSize: 11,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              //Type head for city name
              Container(
                margin: const EdgeInsets.only(left: 5),
                height: 30,
                width: mediaQuery * 0.215,
                child: TypeAheadField(
                  debounceDuration: const Duration(seconds: 1),
                  noItemsFoundBuilder: (context) {
                    return const ListTile(
                      title: Text(
                        'No City Found',
                        style: TextStyle(fontSize: 13),
                      ),
                    );
                  },
                  hideOnLoading: false,
                  animationDuration: const Duration(milliseconds: 1000),
                  animationStart: 0,
                  textFieldConfiguration: TextFieldConfiguration(
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                    controller: cityController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 5),
                      labelText: 'Select a City',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 13),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(
                        suggestion.toString(),
                        style: const TextStyle(fontSize: 9),
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) async {
                    isCitySelected = true;
                    cityController.text = suggestion.toString();
                    demandEnergyProvider.setCityName(suggestion.toString());
                    await getCityData(suggestion.toString());
                    demandEnergyProvider.setDepoList(depoList);
                  },
                  suggestionsCallback: (String pattern) async {
                    return await getUserdata(pattern);
                  },
                ),
              ),

              //Type head for depo name

              Container(
                margin: const EdgeInsets.all(5),
                height: 30,
                width: mediaQuery * 0.35,
                child: TypeAheadField(
                  noItemsFoundBuilder: (context) {
                    return const ListTile(
                      title: Text(
                        'No Depot Found',
                        style: TextStyle(fontSize: 13),
                      ),
                    );
                  },
                  debounceDuration: const Duration(seconds: 2),
                  hideOnLoading: true,
                  animationDuration: const Duration(milliseconds: 1000),
                  animationStart: 0.25,
                  textFieldConfiguration: TextFieldConfiguration(
                    cursorColor: blue,
                    style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: selectedDepo,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 5),
                      labelText: 'Select a Depot',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(
                        suggestion.toString(),
                        style: const TextStyle(fontSize: 9),
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) async {
                    isDepoSelected = true;
                    allDepoProvider.setCheckedBool(false);
                    selectedDepo.text = suggestion.toString();
                    demandEnergyProvider.setDepoName(suggestion.toString());
                    await widget.getDailyData();
                    demandEnergyProvider.reloadWidget(true);
                  },
                  suggestionsCallback: (String pattern) async {
                    return await getDepoData(pattern);
                  },
                ),
              ),
              Consumer<AllDepoSelectProvider>(
                builder: (context, providerValue, child) {
                  return Container(
                      margin: EdgeInsets.only(bottom: 5),
                      // color: blue,
                      height: 40,
                      width: 120,
                      child: CheckboxListTile(
                        selectedTileColor: white,
                        contentPadding: EdgeInsets.only(left: 5),
                        checkColor: Colors.greenAccent,
                        title: const Text(
                          'All Depots',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        value: providerValue.isChecked,
                        onChanged: demandEnergyProvider.isLoadingBarCandle
                            ? null
                            : (value) async {
                                if (selectedDepo.text.isNotEmpty) {
                                  showCustomAlert('Already Selected A Depot !');
                                } else if (providerValue.isChecked == false &&
                                    isCitySelected == true) {
                                  providerValue.setCheckedBool(value ?? false);
                                  demandEnergyProvider.setLoadingBarCandle(
                                      true); //Show loading bar
                                  providerValue.reloadCheckbox();
                                  // demandEnergyProvider
                                  //     .setDepoList(depoList);
                                  await demandEnergyProvider
                                      .getAllDepoDailyData!();
                                  demandEnergyProvider.setLoadingBarCandle(
                                      false); //Stop loading bar
                                  providerValue.reloadCheckbox();
                                  demandEnergyProvider.reloadWidget(true);
                                } else if (isCitySelected == false) {
                                  showCustomAlert(
                                      'Please select a city first !');
                                } else {
                                  providerValue.setCheckedBool(value ?? false);
                                }
                              },
                      ));
                },
              )
            ],
          ),
          Flexible(
            child: Container(
              // color: blue,
              margin: const EdgeInsets.all(5),
              height: 110,
              child: Consumer<AllDepoSelectProvider>(
                builder: (context, value, child) {
                  return Consumer<DemandEnergyProvider>(
                    builder: (context, providerValue, child) {
                      return demandEnergyProvider.isLoadingBarCandle
                          ? const LoadingPage()
                          : DataTable2(
                              columnSpacing: 10,
                              headingRowColor:
                                  MaterialStatePropertyAll(tableHeadingColor),
                              dataRowColor:
                                  MaterialStatePropertyAll(tableRowColor),
                              border: TableBorder.all(),
                              dividerThickness: 0,
                              dataRowHeight: 25,
                              headingRowHeight: 30,
                              headingTextStyle: TextStyle(
                                  color: white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500),
                              dataTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: black,
                                fontSize: 11,
                              ),
                              columns: List.generate(
                                widget.columns.length,
                                (index) => DataColumn2(
                                  fixedWidth: index == 0
                                      ? mediaQuery * 0.1
                                      : index == 1
                                          ? mediaQuery * 0.22
                                          : index == 3
                                              ? mediaQuery * 0.23
                                              : null,
                                  label: Text(
                                    widget.columns[index],
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              rows: List.generate(
                                widget.rows.length,
                                (rowNo) {
                                  return DataRow2(
                                    cells: List.generate(
                                      widget.rows[0].length,
                                      (cellNo) => DataCell(
                                        Text(
                                          widget.rows[rowNo][cellNo].toString(),
                                          style: const TextStyle(fontSize: 9),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  showCustomAlert(String message) async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: 130,
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber,
                    size: 40,
                    color: blue,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      message,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    width: 70,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.green)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(color: white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  getUserdata(String input) async {
    searchedList.clear();
    print(citiesList);

    for (int i = 0; i < citiesList.length; i++) {
      if (citiesList[i].toUpperCase().contains(input.trim().toUpperCase())) {
        searchedList.add(citiesList[i]);
      }
    }
    if (cityController.text.isEmpty) {
      isCitySelected = false;
    }
    // citiesList.clear();
    return searchedList;
  }

  getDepoData(String input) async {
    List<String> searchedDepots = [];

    for (var depo in depoList) {
      if (depo.toString().toLowerCase().contains(input)) {
        searchedDepots.add(depo);
      }
    }
    if (input.isEmpty) {
      isDepoSelected = false;
    }
    return searchedDepots;
  }

  void getCityList() async {
    QuerySnapshot citySnap =
        await FirebaseFirestore.instance.collection('DepoName').get();
    citiesList = citySnap.docs.map((city) => city.id).toList();
  }

  getCityData(String input) async {
    searchedDepoList.clear();
    depoList.clear();

    final allCheckboxProvider =
        Provider.of<AllDepoSelectProvider>(context, listen: false);

    if (cityController.text.isNotEmpty) {
      QuerySnapshot depoSnap = await FirebaseFirestore.instance
          .collection('DepoName')
          .doc(cityController.text)
          .collection('AllDepots')
          .get();

      List<String> depoNameList = depoSnap.docs.map((depo) => depo.id).toList();
      searchedDepoList = depoNameList;
      depoList = depoNameList;
    } else {
      searchedDepoList.add('Please Select a City');
    }
    if (selectedDepo.text.isEmpty) {
      isDepoSelected = false;
      allCheckboxProvider.reloadCheckbox();
    }

    return searchedDepoList;
  }
}
