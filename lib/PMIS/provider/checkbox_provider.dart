import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/PMIS/common_screen/citiespage/depot.dart';
import 'package:ev_pmis_app/PMIS/user/screen/safetyfield.dart';
import 'package:flutter/foundation.dart';

class CheckboxProvider extends ChangeNotifier {
  List<bool> defaultCcBooleanValue = [];
  List<bool> defaultToBooleanValue = [];
  List<String> currentCcValue = [];
  List<String> currentToValue = [];
  List<String> defaulyCcMailData = [];
  List<String> defaultToMailData = [];

  List<bool> get myCcBooleanValue => defaultCcBooleanValue;
  List<bool> get myToBooleanValue => defaultToBooleanValue;
  List<String> get myCcMailValue => defaulyCcMailData;
  List<String> get myToMailValue => defaultToMailData;
  List<String> get ccValue => currentCcValue;
  List<String> get toValue => currentToValue;

  void setMyCcBooleanValue(int index, bool newValue) {
    defaultCcBooleanValue[index] = newValue;
    notifyListeners();
  }

  void getCurrentCcValue(int index, String value) {
    currentCcValue.add(value);
    notifyListeners();
  }

  void getCurrentToValue(int index, String value) {
    currentToValue.add(value);
    // currentToValue[index] = value;
    notifyListeners();
  }

  void setMyToBooleanValue(int index, bool newValue) {
    defaultToBooleanValue[index] = newValue;
    notifyListeners();
  }

  fetchCcMaidId() async {
    List<String> allId = [];
    allId.clear();
    await FirebaseFirestore.instance
        .collection('UsersMailId')
        .doc('CcMailId')
        .get()
        .then((value) {
      if (value.data() != null) {
        for (int i = 0; i < value.data()!['ALLId'].length; i++) {
          allId.add(value.data()!['ALLId'][i]);
        }
        defaulyCcMailData = allId;
        notifyListeners();
      }
    });
  }

  fetchToMaidId(String cityName) async {
    List<String> allId = [];
    allId.clear();
    await FirebaseFirestore.instance
        .collection('AssignedRole')
        .where('roles', arrayContains: 'Project Manager')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        if (doc != null && doc['cities'].contains(cityName)) {
          await FirebaseFirestore.instance
              .collection('User')
              .doc(doc['username'])
              .get()
              .then((value) {
            allId.add(value.data()?['Email'] ?? '');
          });
        }
        defaultToMailData = allId;
        notifyListeners();
      });
    });
  }
}
