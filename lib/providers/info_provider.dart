import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stockadvisor/helpers/ticker_streams.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/yahoo_models/info_data.dart';
import 'package:stockadvisor/models/yahoo_models/spark_data.dart';

class InfoProvider extends ChangeNotifier {
  late StreamController<YahooHelperInfoData> _streamController;
  late StreamSubscription<YahooHelperInfoData> _streamSubscriber;
  final Map<String, YahooHelperInfoData?> _infoData = {};
  YahooHelperSparkData? _tickerGraph;

  ChartProvider() {
    _initCacheFromMemory();
  }

  void _initCacheFromMemory() {}

  void _loadCacheIntoMemory() {}

  // Ticker Info Stream handlers

  void initInfoStream({required String ticker}) async {
    // _tickerGraph ??= await YahooHelper.getSparkData(ticker);
    _streamController = TickerStreams.infoStreamController(ticker: ticker);
    _streamSubscriber = _streamController.stream.listen((data) {
      _infoData[ticker] = data;
      print('$ticker stream going....');
      notifyListeners();
    });
  }

  void removeInfoStream() {
    _tickerGraph = null;
    _streamController.close();
    _streamSubscriber.cancel();
    print('info gone!');
  }

  YahooHelperSparkData getChartData({required String ticker}) {
    if (_tickerGraph != null) {
      return _tickerGraph!;
    } else {
      return YahooHelperSparkData(
        chartPreviousClose: 0,
        close: [],
        firstTimestamp: 0,
      );
    }
  }

  YahooHelperInfoData getInfoData({required String ticker}) {
    if (_infoData.containsKey(ticker)) {
      return _infoData[ticker]!;
    } else {
      return YahooHelperInfoData(
        sAndPYearChange: 0,
        yearChange: 0,
        recommendationKey: 'N/A',
        recommendationMean: 0.0,
        targetMedianPrice: 0.0,
        currentEarningsEstimate: 0,
        currentEarningsQuarter: "N/A",
        currentEarningsTimestamp: 0,
        currentEarningsYear: 0,
        earningsHistory: [
          {"N/A": 0}
        ],
      );
    }
  }
}
