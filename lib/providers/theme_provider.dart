import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkModeEnabled = true;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  void _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isDarkModeEnabled') != null) {
      _isDarkModeEnabled = prefs.getBool('isDarkModeEnabled')!;
    } else {
      _isDarkModeEnabled = SchedulerBinding.instance!.window.platformBrightness == Brightness.dark;
      prefs.setBool('isDarkModeEnabled', _isDarkModeEnabled);
    }
    notifyListeners();
  }

  void _loadThemeToPrefs(bool mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkModeEnabled', mode);
  }

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  set isDarkModeEnabled(bool mode) {
    _loadThemeToPrefs(mode);
    _isDarkModeEnabled = mode;
    notifyListeners();
  }
}