import 'package:flutter/material.dart';

class CitiesProvider extends ChangeNotifier {
  String _citiesName = 'Ahmedabad';

  String get getName => _citiesName;

  saveCities(String name) {
    _citiesName = name;
    print("cities Name: $_citiesName");
    notifyListeners();
  }
}
