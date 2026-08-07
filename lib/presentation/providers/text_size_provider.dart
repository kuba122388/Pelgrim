import 'package:flutter/cupertino.dart';

class TextSizeProvider extends ChangeNotifier {
  double _scaleFactor = 0;

  double get scaleFactor => _scaleFactor;

  void increaseScaleFactor() {
    if (_scaleFactor < 12) {
      _scaleFactor += 1;
      notifyListeners();
    }
  }

  void decreaseScaleFactor() {
    if (_scaleFactor > 0) {
      _scaleFactor -= 1;
      notifyListeners();
    }
  }
}
