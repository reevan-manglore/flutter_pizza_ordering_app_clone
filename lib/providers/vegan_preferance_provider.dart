import 'package:flutter/widgets.dart';

class VeganPreferanceProvider extends ChangeNotifier {
  bool _veganOnly = false;
  void toggleVegan() {
    _veganOnly = !_veganOnly;
    notifyListeners();
  }

  bool get isveganOnly => _veganOnly;
}
