import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/yahoo_models/meta_data.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:web_socket_channel/io.dart';

class DataProvider extends ChangeNotifier {
  final Map<String, YahooHelperPriceData> _priceData = {};
  final Map<String, YahooHelperMetaData> _tickerData = {};
  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://streamer.finance.yahoo.com/'));
  final channelController = StreamController.broadcast();

  DataProvider() {
    _initCacheFromMemory();
    _initWebSocketStream();
  }
  void _initCacheFromMemory() {}
  void _loadCacheIntoMemory() {}

  void _initWebSocketStream() {
    channelController.addStream(channel.stream);
  }

  void subscribeToWebsocket(String ticker) {
    channel.sink.add('{"subscribe":["$ticker"]}');
    print('ok $ticker');
  }

  void unsubscribeFromWebsocket(String ticker) {
    channel.sink.add('{"unsubscribe":["$ticker"]}');
    print('removed $ticker');
  }

  Future<void> initTickerData(
      {required String ticker, bool fromOverview = false}) async {
    if (!_tickerData.containsKey(ticker) || fromOverview) {
      _tickerData[ticker] = await YahooHelper.getStockMetadata(ticker: ticker);
      _priceData[ticker] = await YahooHelper.getCurrentPrice(ticker);
      print('ticker data init!');
      notifyListeners();
    }
  }

  // Getters / Setters

  YahooHelperPriceData getPriceData({required String ticker}) {
    if (_priceData.containsKey(ticker)) {
      return _priceData[ticker]!;
    } else {
      return YahooHelperPriceData(
        marketState: 'N/A',
        currentDelta: 0.0,
        lastCloseDelta: 0.0,
        currentMarketPrice: 0.0,
        currentPercentage: 0.0,
        openPrice: 0.0,
        dayHigh: 0.0,
        dayLow: 0.0,
        lastClosePrice: 0.0,
        lastPercentage: 0.0,
        pe: 0.0,
        previousDayClose: 0.0,
        currency: 'N/A',
        extendedMarketAvailable: false,
        fiftyTwoWeekHigh: 0.0,
        fiftyTwoWeekLow: 0.0,
        trailingAnnualDividendRate: 0.0,
        trailingAnnualDividendYield: 0.0,
        lastDividendTimestamp: 0,
      );
    }
  }

  YahooHelperMetaData getTickerData({required String ticker}) {
    if (!_tickerData.containsKey(ticker)) {
      return YahooHelperMetaData(
        iconSvg: '<svg width="56" height="56"></svg>',
        companyLongName: "Loading...",
        currency: "\$",
        exchangeName: "Loading...",
        type: "Loading...",
      );
    }
    return _tickerData[ticker]!;
  }
}
