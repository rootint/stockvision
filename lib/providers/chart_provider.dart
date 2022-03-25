import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stockadvisor/helpers/ticker_streams.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/yahoo_models/chart_data.dart';

class ChartProvider extends ChangeNotifier {
  // final Map<String, StreamController<YahooHelperChartData>>
  //     _chartStreamControllers = {};
  // final Map<String, StreamSubscription<YahooHelperChartData>>
  //     _chartStreamSubscribers = {};
  late StreamController<YahooHelperChartData> _chartStreamController;
  late StreamSubscription<YahooHelperChartData> _chartStreamSubscriber;
  final Map<String, Map<TickerRange, YahooHelperChartData?>?> _chartData = {};

  ChartProvider() {
    _initCacheFromMemory();
  }

  void _initCacheFromMemory() {}

  void _loadCacheIntoMemory() {}

  // Ticker Chart Stream handlers

  void initChartStream({required String ticker, required TickerRange range}) {
    _chartStreamController =
        TickerStreams.chartStreamController(ticker: ticker, range: range);
    _chartStreamSubscriber =
        _chartStreamController.stream.listen((data) {
      if (!_chartData.containsKey(ticker)) {
        _chartData[ticker] = {TickerRange.oneDay: null};
      }
      _chartData[ticker]![range] = data;
      print('$ticker stream going....');
      notifyListeners();
    });
  }

  void removeChartStream() {
    _chartStreamController.close();
    _chartStreamSubscriber.cancel();
    print('chart gone!');
    // _chartStreamControllers.forEach((key, value) {
    //   _chartStreamControllers[key]!.close();
    //   print('closed! $key');
    // });
    // _chartStreamSubscribers.forEach((key, value) {
    //   _chartStreamSubscribers[key]!.cancel();
    // });
    // _chartStreamControllers.clear();
    // _chartStreamSubscribers.clear();
    // notifyListeners();
  }

  YahooHelperChartData getChartData(
      {required String ticker, required TickerRange range}) {
    if (_chartData.containsKey(ticker) &&
        _chartData[ticker]!.containsKey(range)) {
      return _chartData[ticker]![range]!;
    } else {
      return YahooHelperChartData(
        timestamp: [],
        open: [],
        close: [],
        high: [],
        low: [],
        volume: [],
        percentage: 0,
        previousClose: 0,
        periodHigh: 0,
        periodLow: 0,
        timestampEnd: 0,
        timestampStart: 0,
        lastClosePrice: 0,
      );
    }
  }
}
