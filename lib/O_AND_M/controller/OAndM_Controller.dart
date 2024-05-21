import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/O_AND_M/o&m_datasource/oAndM_dashboard_datasource.dart';
import 'package:ev_pmis_app/O_AND_M/o&m_model/oAndM_dashboard_model.dart';

class OAndMController {
  int targetTime = 0;
  bool isCitySelected = false;
  bool dateRangeSelected = false;
  List<double> mttrData = [];
  List<OAndMDashboardModel> oAndMModel = [];
  List<String> depotList = [];
  List<String> chargerAvailabilityList = [];
  int totalChargers = 0;
  int totalFaultOccured = 0;
  int totalFaultResolved = 0;
  int totalFaultPending = 0;
  int totalAverageMttr = 0;
  int totalChargerAvailability = 0;
  int totalBuses = 0;
  double totalMttrForConclusion = 0;
  late OAndMDashboardDatasource oAndMDashboardDatasource;

  Future<void> getTimeLossData(
      List<String> depotList, int totalChargers) async {
    chargerAvailabilityList.clear();
    mttrData.clear();
    totalMttrForConclusion = 0;
    for (int i = 0; i < depotList.length; i++) {
      //Fetch Breakdown Data
      DocumentSnapshot breakdownSnap = await FirebaseFirestore.instance
          .collection("BreakDownData")
          .doc(depotList[i])
          .get();

      if (breakdownSnap.exists) {
        Map<String, dynamic> breakdownData =
            breakdownSnap.data() as Map<String, dynamic>;
        List<dynamic> breakdownMapData = breakdownData['data'];

        double totalMttr = 0.0;
        for (int j = 0; j < breakdownMapData.length; j++) {
          totalMttr =
              totalMttr + double.parse(breakdownMapData[j]["MTTR"].toString());
        }
        mttrData.add(totalMttr);
        totalMttrForConclusion = totalMttrForConclusion + totalMttr;
      } else {
        mttrData.add(0.0);
      }
    }
    calculateAvailability(mttrData, targetTime, totalChargers);
  }

  List<String> calculateAvailability(
      List<double> totalMttr, int targetTime, int totalNumChargers) {
    for (int i = 0; i < totalMttr.length; i++) {
      double availability = (((targetTime * totalNumChargers) - totalMttr[i]) /
              (targetTime * totalNumChargers)) *
          100;
      chargerAvailabilityList.add(
        availability.toStringAsFixed(
          2,
        ),
      );
    }
    print("chargerAvailabilityList - $chargerAvailabilityList");
    return chargerAvailabilityList;
  }
}
