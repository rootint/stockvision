import 'dart:async';

import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/yahoo_models/chart_data.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';

class TickerStreams {
  static const intervalMap = {
    TickerRange.oneDay: TickerInterval.twoMinute,
    TickerRange.fiveDay: TickerInterval.fifteenMinute,
    TickerRange.oneMonth: TickerInterval.sixtyMinute,
    TickerRange.ytd: TickerInterval.ninetyMinute,
    TickerRange.oneYear: TickerInterval.oneDay,
    TickerRange.fiveYear: TickerInterval.fiveDay,
    TickerRange.maxRange: TickerInterval.oneMonth,
  };

  static StreamController<YahooHelperPriceData> priceStreamController(
      {required String ticker}) {
    late StreamController<YahooHelperPriceData> controller;
    Timer? timer;

    void tick() async {
      final data = await YahooHelper.getCurrentPrice(ticker: ticker);
      controller.add(data);
    }

    void start() {
      if (timer == null) {
        tick();
      }
      timer = Timer.periodic(const Duration(milliseconds: 1200), (_) => tick());
    }

    void stop() {
      timer?.cancel();
      timer = null;
    }

    controller = StreamController<YahooHelperPriceData>.broadcast(
      onListen: start,
      onCancel: stop,
    );

    return controller;  
  }

  static StreamController<YahooHelperChartData> chartStreamController({
    required String ticker,
    required TickerRange range,
  }) {
    late StreamController<YahooHelperChartData> controller;
    Timer? timer;

    void tick() async {
      final data = await YahooHelper.getChartData(
          ticker: ticker, interval: intervalMap[range]!, range: range);
      controller.add(data);
    }

    void start() {
      if (timer == null) {
        tick();
      }
      timer = Timer.periodic(const Duration(seconds: 55), (_) => tick());
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
}
