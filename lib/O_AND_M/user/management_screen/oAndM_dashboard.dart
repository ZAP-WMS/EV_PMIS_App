import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ev_pmis_app/O_AND_M/controller/OAndM_Controller.dart';
import 'package:ev_pmis_app/O_AND_M/o&m_datasource/oAndM_dashboard_datasource.dart';
import 'package:ev_pmis_app/O_AND_M/o&m_model/oAndM_dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../components/Loading_page.dart';
import '../../../style.dart';
import '../../../PMIS/widgets/appbar_back_date.dart';
import '../../../PMIS/widgets/management_screen.dart';
import '../../../PMIS/widgets/progress_loading.dart';

class OAndMDashboardScreen extends StatefulWidget {
  final String? cityName;
  final String? depoName;
  final String? userId;
  final String? role;
  final String? roleCentre;

  const OAndMDashboardScreen(
      {super.key,
      required this.cityName,
      this.depoName,
      this.userId,
      this.role,
      this.roleCentre});

  @override
  State<OAndMDashboardScreen> createState() => _OAndMDashboardScreenState();
}

class _OAndMDashboardScreenState extends State<OAndMDashboardScreen> {
  List<String> cityNames = [];
  String startDate = DateFormat.yMMMd().format(DateTime.now());
  String endDate = DateFormat.yMMMd().format(DateTime.now());
  String? selectedCity;
  bool isFieldEditable = true;
  String? visDate = DateFormat.yMMMd().format(DateTime.now());
  String? selectedDate = DateFormat.yMMM().format(DateTime.now());
  List<GridColumn> columns = [];
  late DataGridController _dataGridController;
  final OAndMController oAndMController = OAndMController();
  Stream? _stream;
  List<dynamic> tabledata2 = [];
  bool isLoading = true;
  bool checkTable = true;
  List<int> faultsOccuredList = [];
  List<int> totalFaultsResolved = [];
  List<int> totalPendingFaults = [];
  List<int> numOfChargersList = [];

  @override
  void initState() {
    getCityNames().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });

    oAndMController.oAndMDashboardDatasource = OAndMDashboardDatasource(
        oAndMController.oAndMModel,
        context,
        widget.cityName!,
        widget.depoName!,
        selectedDate!,
        widget.userId!,
        selectedCity ?? '',
        oAndMController.depotList,
        oAndMController.isCitySelected,
        numOfChargersList,
        faultsOccuredList,
        oAndMController.totalFaultPending,
        oAndMController.totalFaultResolved,
        oAndMController.mttrData,
        oAndMController.chargerAvailabilityList,
        oAndMController.dateRangeSelected,
        oAndMController.totalChargers,
        oAndMController.totalFaultOccured,
        totalPendingFaults,
        totalFaultsResolved);

    _dataGridController = DataGridController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> currentColumnLabels = oAndMDashboardClnName;

    columns.clear();
    for (int i = 0; i < currentColumnLabels.length; i++) {
      columns.add(
        GridColumn(
          autoFitPadding: const EdgeInsets.all(
            8.0,
          ),
          columnName: currentColumnLabels[i],
          visible: true,
          allowEditing: false,
          // currentColumnLabels[i] == 'Sr.No.' ||
          //         currentColumnLabels[i] == 'Location' ||
          //         currentColumnLabels[i] == "Depotname"
          //     ? false
          //     : true,
          width: currentColumnLabels[i] == 'Sr.No.'
              ? MediaQuery.of(context).size.width * 0.1
              : MediaQuery.of(context).size.width *
                  0.3, // You can adjust this width as needed
          label: createColumnLabel(
            oAndMDashboardTableClnName[i],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBarBackDate(
            depoName: widget.depoName ?? '',
            text: 'O & M Dashboard',
            haveSynced: false,
            haveSummary: false,
            haveCalender: false,
            store: () async {
              showProgressDilogue(context);
            },
            showDate: visDate,
            choosedate: () {
              //chooseDate(context);
            },
          )),
      body: isLoading
          ? const LoadingPage()
          : Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(
                        5.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: blue,
                        ),
                      ),
                      height: 40,
                      width: 150,
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                        style: TextStyle(
                          color: blue,
                        ),
                        hint: const Text(
                          "Choose City",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onChanged: (value) {
                          faultsOccuredList.clear();
                          totalFaultsResolved.clear();
                          totalPendingFaults.clear();
                          numOfChargersList.clear();
                          oAndMController.dateRangeSelected = false;
                          selectedCity = value;
                          getDepots(selectedCity!);
                        },
                        value: selectedCity,
                        items: List.generate(
                            cityNames.length,
                            (index) => DropdownMenuItem(
                                  value: cityNames[index],
                                  child: Text(
                                    cityNames[index],
                                    style: TextStyle(
                                      color: blue,
                                    ),
                                  ),
                                )).toList(),
                      )),
                    ),
                  ],
                ),
                Expanded(
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                        headerColor: white, gridLineColor: blue),
                    child: StreamBuilder(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LoadingPage();
                        } else if (!snapshot.hasData ||
                            snapshot.data.exists == false) {
                          return SfDataGrid(
                              source: oAndMController.oAndMDashboardDatasource,
                              allowEditing: true,
                              frozenColumnsCount: 1,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              selectionMode: SelectionMode.single,
                              navigationMode: GridNavigationMode.cell,
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              editingGestureType: EditingGestureType.tap,
                              headerRowHeight: 30,
                              controller: _dataGridController,
                              onQueryRowHeight: (details) {
                                return details
                                    .getIntrinsicRowHeight(details.rowIndex);
                              },
                              columns: columns);
                        } else {
                          return SfDataGrid(
                              source: oAndMController.oAndMDashboardDatasource,
                              allowEditing: true,
                              frozenColumnsCount: 2,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              selectionMode: SelectionMode.single,
                              navigationMode: GridNavigationMode.cell,
                              editingGestureType: EditingGestureType.tap,
                              headerRowHeight: 30,
                              controller: _dataGridController,
                              onQueryRowHeight: (details) {
                                return details
                                    .getIntrinsicRowHeight(details.rowIndex);
                              },
                              columns: columns);
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (selectedCity != null) {
                            dateRange(
                                context,
                                widget.cityName!,
                                widget.depoName!,
                                widget.userId!,
                                oAndMController.depotList,
                                selectedCity!,
                                numOfChargersList,
                                faultsOccuredList,
                                totalPendingFaults,
                                totalFaultsResolved);
                          } else {
                            showCustomAlert();
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            border: Border.all(
                              color: blue,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: blue,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Text(startDate)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          if (selectedCity != null) {
                            dateRange(
                                context,
                                widget.cityName!,
                                widget.depoName!,
                                widget.userId!,
                                oAndMController.depotList,
                                selectedCity!,
                                numOfChargersList,
                                faultsOccuredList,
                                totalPendingFaults,
                                totalFaultsResolved);
                          } else {
                            showCustomAlert();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              3.0,
                            ),
                            border: Border.all(
                              color: blue,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: blue,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Text(endDate)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> dateRange(
      BuildContext context,
      String cityName,
      String depotName,
      String userId,
      List<String> depotList,
      String selectedCity,
      List<int> numOfChargersList,
      List<int> faultsOccuredList,
      List<int> totalPendingFaults,
      List<int> totalFaultsResolved) async {
    if (isLoading == false) {
      setState(() {
        isLoading = true;
      });
    }
    DateTimeRange? selectedDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(
        2100,
      ),
      currentDate: DateTime.now(),
      helpText: "Choose Start And End Date",
    );

    if (selectedDate != null) {
      startDate = DateFormat.yMMMd().format(selectedDate.start);
      endDate = DateFormat.yMMMd().format(selectedDate.end);
      print("startDate - $startDate");
      print("endDate - $endDate");
      oAndMController.targetTime =
          (selectedDate.end.difference(selectedDate.start).inDays + 1) * 24;
      // print("Charger Availability - ${targetTime * 24}");
      oAndMController
          .getTimeLossData(depotList, numOfChargersList.length)
          .whenComplete(() {
        oAndMController.dateRangeSelected = true;
        oAndMController.oAndMDashboardDatasource = OAndMDashboardDatasource(
          oAndMController.oAndMModel,
          context,
          widget.cityName!,
          widget.depoName!,
          selectedDate.toString(),
          widget.userId!,
          selectedCity,
          oAndMController.depotList,
          oAndMController.isCitySelected,
          numOfChargersList,
          faultsOccuredList,
          oAndMController.totalFaultPending,
          oAndMController.totalFaultResolved,
          oAndMController.mttrData,
          oAndMController.chargerAvailabilityList,
          oAndMController.dateRangeSelected,
          oAndMController.totalChargers,
          oAndMController.totalFaultOccured,
          totalPendingFaults,
          totalFaultsResolved,
        );
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future getCityNames() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("DepoName").get();
    cityNames = querySnapshot.docs.map((e) => e.id).toList();
  }

  Future getDepots(String selectedCity) async {
    oAndMController.oAndMModel.clear();
    oAndMController.depotList.clear();
    oAndMController.totalChargers = 0;
    oAndMController.totalMttrForConclusion = 0;
    oAndMController.totalFaultOccured = 0;
    oAndMController.totalFaultResolved = 0;
    oAndMController.totalFaultPending = 0;
    oAndMController.isCitySelected = true;
    if (isLoading == false) {
      setState(() {
        isLoading = true;
      });
    }
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("DepoName")
        .doc(selectedCity)
        .collection("AllDepots")
        .get();

    oAndMController.depotList = querySnapshot.docs.map((e) => e.id).toList();
    for (int i = 0; i < oAndMController.depotList.length; i++) {
      oAndMController.oAndMModel.add(
        OAndMDashboardModel(
            srNo: i + 1,
            location: selectedCity,
            depotName: oAndMController.depotList[i],
            noOfChargers: 0,
            noOfBuses: 0,
            chargerAvailability: "",
            noOfFaultOccured: 0,
            totalFaultsResolved: 0,
            totalFaultsPending: 0,
            chargersMttr: 0.0,
            electricalMttr: 0.0),
      );
    }
    oAndMController.oAndMModel.add(
      OAndMDashboardModel(
          srNo: oAndMController.oAndMModel.length + 1,
          location: selectedCity,
          depotName: '',
          noOfChargers: 0,
          noOfBuses: 0,
          chargerAvailability: "",
          noOfFaultOccured: 0,
          totalFaultsResolved: 0,
          totalFaultsPending: 0,
          chargersMttr: 0.0,
          electricalMttr: 0.0),
    );

    oAndMController.depotList
        .add((oAndMController.oAndMModel.length - 1).toString());

    await getTotalChargers();
    await getFaultsOccured();

    oAndMController.oAndMDashboardDatasource = OAndMDashboardDatasource(
      oAndMController.oAndMModel,
      context,
      widget.cityName!,
      widget.depoName!,
      selectedDate!,
      widget.userId!,
      selectedCity ?? '',
      oAndMController.depotList,
      oAndMController.isCitySelected,
      numOfChargersList,
      faultsOccuredList,
      oAndMController.totalFaultPending,
      oAndMController.totalFaultResolved,
      oAndMController.mttrData,
      oAndMController.chargerAvailabilityList,
      oAndMController.dateRangeSelected,
      oAndMController.totalChargers,
      oAndMController.totalFaultOccured,
      totalPendingFaults,
      totalFaultsResolved,
    );

    setState(() {
      isLoading = false;
    });
  }

  Future getFaultsOccured() async {
    for (int i = 0; i < oAndMController.depotList.length; i++) {
      DocumentSnapshot faultsQuery = await FirebaseFirestore.instance
          .collection("BreakDownData")
          .doc(oAndMController.depotList[i])
          .get();

      if (faultsQuery.exists) {
        Map<String, dynamic> mapData =
            faultsQuery.data() as Map<String, dynamic>;
        List<dynamic> data = mapData['data'];
        List<String> sortChargerList = [];
        for (Map<String, dynamic> map in data) {
          if (sortChargerList.contains(map['Equipment Name']) == false) {
            sortChargerList.add(map['Equipment Name']);
          }
        }
        print("breakdownData - $sortChargerList");
        faultsOccuredList.add(sortChargerList.length);
        oAndMController.totalFaultOccured =
            oAndMController.totalFaultOccured + sortChargerList.length;
        getFaultsResolved(data, sortChargerList, sortChargerList.length);
      } else {
        faultsOccuredList.add(0);
        totalFaultsResolved.add(0);
        totalPendingFaults.add(0);
      }
    }
  }

  void getFaultsResolved(List<dynamic> breakdownData,
      List<String> sortedChargers, int totalNumFaults) {
    int value = 0;
    breakdownData.every((element) {
      if (sortedChargers.contains(element["Equipment Name"]) == true) {
        value++;
        sortedChargers.remove(element["Equipment Name"]);
      }
      return true;
    });

    totalFaultsResolved.add(value);
    oAndMController.totalFaultResolved =
        oAndMController.totalFaultResolved + value;
    oAndMController.totalFaultPending =
        oAndMController.totalFaultPending + (totalNumFaults - value);
    totalPendingFaults.add(totalNumFaults - value);
  }

  Future getTotalChargers() async {
    for (int i = 0; i < oAndMController.depotList.length; i++) {
      DocumentSnapshot chargersQuery = await FirebaseFirestore.instance
          .collection("ChargerAvailability")
          .doc(oAndMController.depotList[i])
          .get();
      if (chargersQuery.exists) {
        Map<String, dynamic> mapData =
            chargersQuery.data() as Map<String, dynamic>;
        List<dynamic> data = mapData['data'];
        numOfChargersList.add(data.length);
        oAndMController.totalChargers =
            oAndMController.totalChargers + data.length;
        print('Total Charger - ${oAndMController.totalChargers}');
      } else {
        numOfChargersList.add(0);
      }
    }
    print("numOfChargerList - $numOfChargersList");
  }

  Widget createColumnLabel(String labelText) {
    return Container(
      alignment: Alignment.center,
      child: Text(labelText,
          overflow: TextOverflow.values.first,
          textAlign: TextAlign.center,
          style: tableheader),
    );
  }

  showCustomAlert() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(
            Icons.warning,
            color: blue,
            size: 60,
          ),
          title: const Text(
            "Please Select City!",
          ),
          actions: [
            SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "OK",
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
