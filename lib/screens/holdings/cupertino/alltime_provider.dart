import 'package:flutter/foundation.dart';

class AllTimeProvider extends ChangeNotifier {
  bool _isAllTimeEnabled = false;

  void onAllTimeSwitch() {
    _isAllTimeEnabled = !_isAllTimeEnabled;
    notifyListeners();
  }

  bool get isSwitchEnabled => _isAllTimeEnabled;
}