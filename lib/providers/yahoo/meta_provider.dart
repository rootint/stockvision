import 'package:flutter/foundation.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/yahoo_models/meta_data.dart';

class YahooMetaProvider extends ChangeNotifier {
  final Map<String, bool> _isMetaInit = {};
  final Map<String, YahooHelperMetaData> _metaData = {};

  YahooMetaProvider() {
    _initCacheFromMemory();
  }

  void _initCacheFromMemory() {}
  void _loadCacheIntoMemory() {}

  void initTickerData(String ticker) async {
    if (!_metaData.containsKey(ticker)) {
      _metaData[ticker] = await YahooHelper.getMetaData(ticker);
      print('$ticker data init');
      notifyListeners();
    }
  }

  YahooHelperMetaData getMetaData(String ticker) {
    if (!_metaData.containsKey(ticker)) {
      if (_isMetaInit[ticker] == null || _isMetaInit[ticker] == false) {
        initTickerData(ticker);
        _isMetaInit[ticker] = true;
      }
      return YahooHelperMetaData(
        iconSvg: '<svg width="56" height="56"></svg>',
        companyLongName: "Loading...",
        currency: "\$",
        exchangeName: "Loading...",
        type: "Loading...",
      );
    }
    return _metaData[ticker]!;
  }
}