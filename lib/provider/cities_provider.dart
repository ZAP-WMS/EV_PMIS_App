import 'package:flutter/material.dart';

class CitiesProvider extends ChangeNotifier {
  String _citiesName = 'Bengaluru';

  String get getName => _citiesName;

  saveCities(String name) {
    _citiesName = name;
    notifyListeners();
  }
}
