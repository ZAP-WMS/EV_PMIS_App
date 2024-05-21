import 'package:flutter/foundation.dart';

class ScrollProvider with ChangeNotifier {
  bool _isVisible = false;
  bool get isVisible => _isVisible;

  void setTop(bool value) {
    _isVisible = value;
    notifyListeners();
  }
}
