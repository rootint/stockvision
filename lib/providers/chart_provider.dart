import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/yahoo_models/chart_data.dart';

class ChartProvider extends ChangeNotifier {
  static const intervalMap = {
    TickerRange.oneDay: TickerInterval.twoMinute,
    TickerRange.fiveDay: TickerInterval.fifteenMinute,
    TickerRange.oneMonth: TickerInterval.sixtyMinute,
    TickerRange.sixMonth: TickerInterval.oneDay,
    TickerRange.oneYear: TickerInterval.oneDay,
    TickerRange.fiveYear: TickerInterval.fiveDay,
    TickerRange.maxRange: TickerInterval.oneMonth,
  };
  late StreamController<YahooHelperChartData> _chartStreamController;
  late StreamSubscription<YahooHelperChartData> _chartStreamSubscriber;
  final Map<String, Map<TickerRange, YahooHelperChartData?>?> _chartData = {};

  ChartProvider() {
    _initCacheFromMemory();
  }

  void _initCacheFromMemory() {}

  void _loadCacheIntoMemory() {}

  // Ticker Chart Stream handlers

  StreamController<YahooHelperChartData> chartStreamController({
    required String ticker,
    required TickerRange range,
  }) {
    late StreamController<YahooHelperChartData> controller;
    Timer? timer;

    void tick() async {
      final data = await YahooHelper.getChartData(
          {'ticker': ticker, 'interval': intervalMap[range]!, 'range': range});
      // final data = await compute(YahooHelper.getChartData, {
      //   'ticker': ticker,
      //   'interval': intervalMap[range]!,
      //   'range': range,
      // });
      controller.add(data);
    }

    void start() {
      if (timer == null) {
        tick();
      }
      timer = Timer.periodic(const Duration(seconds: 110), (_) => tick());
    }

    void stop() {
      timer?.cancel();
      timer = null;
    }

    controller = StreamController<YahooHelperChartData>.broadcast(
      onListen: start,
      onCancel: stop,
    );

    return controller;
  }

  void initChartStream({required String ticker, required TickerRange range}) {
    _chartStreamController =
        chartStreamController(ticker: ticker, range: range);
    _chartStreamSubscriber = _chartStreamController.stream.listen((data) {
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
