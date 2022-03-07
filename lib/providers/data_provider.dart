import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/helpers/ticker_streams.dart';

class DataProvider extends ChangeNotifier {
  var priceController = StreamController<YahooHelperPriceData>();
  var closed = false;

  final Map<String, StreamController<YahooHelperPriceData>>
      _priceStreamControllers = {};
  final Map<String, StreamSubscription<YahooHelperPriceData>>
      _priceStreamSubscribers = {};
  final Map<String, Map<String, dynamic>> _priceData = {};

  DataProvider() {
    _initCacheFromMemory();
  }

  void initTickerPriceStream({required String ticker}) {
    if (!_priceStreamControllers.containsKey(ticker)) {
      _priceStreamControllers[ticker] =
          TickerStreams.priceStreamController(ticker: ticker);
      _priceStreamSubscribers[ticker] =
          _priceStreamControllers[ticker]!.stream.listen((data) {
        _addPriceData(ticker: ticker, data: data);
      });
    }
  }

  void _addPriceData({
    required String ticker,
    required YahooHelperPriceData data,
  }) {
    if (!_priceData.containsKey(ticker)) {
      _priceData[ticker] = {};
    }
    _priceData[ticker]!['price'] = data;
    // print(data.currentMarketPrice);
    notifyListeners();
  }

  YahooHelperPriceData getPriceData({required String ticker}) {
    if (_priceData.containsKey(ticker)) {
      return _priceData[ticker]!['price'];
    } else {
      return YahooHelperPriceData(
        marketState: 'N/A',
        currentMarketPrice: 0.0,
        currentPercentage: 0.0,
        dayHigh: 0.0,
        dayLow: 0.0,
        lastClosePrice: 0.0,
        lastPercentage: 0.0,
        pe: 0.0,
        previousDayClose: 0.0,
      );
    }
  }

  void removeTickerPriceStream({required String ticker}) {
    _priceStreamSubscribers[ticker]!.cancel();
    _priceStreamControllers[ticker]!.close();
    _priceStreamControllers.remove(ticker);
  }

  void _initCacheFromMemory() {}

  void _loadCacheIntoMemory() {}
}
