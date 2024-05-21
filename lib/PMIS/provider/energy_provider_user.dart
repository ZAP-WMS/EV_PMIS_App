import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EnergyProvider extends ChangeNotifier {
  List<dynamic> intervalListData = [];
  List<dynamic> energyListData = [];
  double _maxEnergyConsumed = 0.0;
  double get maxEnergyConsumed => _maxEnergyConsumed;

  List<dynamic> get intervalData => intervalListData;
  List<dynamic> get energyData => energyListData;

  fetchGraphData(String cityName, String depoName, dynamic userId) async {
    final List<dynamic> timeIntervalList = [];
    final List<dynamic> energyConsumedList = [];

    timeIntervalList.clear();
    energyConsumedList.clear();
    String monthName = DateFormat('MMMM').format(
      DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('EnergyManagementTable')
        .doc(cityName)
        .collection('Depots')
        .doc(depoName)
        .collection('Year')
        .doc(DateTime.now().year.toString())
        .collection('Months')
        .doc(monthName)
        .collection('Date')
        .doc(DateFormat.yMMMMd().format(DateTime.now()))
        .collection('UserId')
        .doc(userId)
        .get()
        .then((value) {
      var alldata = value.data();
      if (alldata != null) {
        for (int i = 0; i < alldata['data'].length; i++) {
          if (_maxEnergyConsumed < alldata['data'][i]['energyConsumed']) {
            _maxEnergyConsumed = alldata['data'][i]['energyConsumed'];
          }
          // fetchedData.add(EnergyManagementModel.fromJson(alldata));
          timeIntervalList.add(alldata['data'][i]['timeInterval']);
          energyConsumedList.add(alldata['data'][i]['energyConsumed']);
          // print(energyConsumedList);
        }
        // _energydata = fetchedData;
        intervalListData = timeIntervalList;
        energyListData = energyConsumedList;
        notifyListeners();
      } else {
        intervalListData = timeIntervalList;
        energyListData = energyConsumedList;
        notifyListeners();
      }
    });
  }
}
