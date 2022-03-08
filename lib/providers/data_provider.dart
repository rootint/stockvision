import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/yahoo_models/meta_data.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/helpers/ticker_streams.dart';

class DataProvider extends ChangeNotifier {
  final Map<String, StreamController<YahooHelperPriceData>>
      _priceStreamControllers = {};
  final Map<String, StreamSubscription<YahooHelperPriceData>>
      _priceStreamSubscribers = {};
  final Map<String, YahooHelperPriceData?> _priceData = {};
  final Map<String, Map<String, dynamic>> _tickerData = {};

  DataProvider() {
    _initCacheFromMemory();
  }

  void _initCacheFromMemory() {}

  void _loadCacheIntoMemory() {}

  void initTickerData({required String ticker}) async {
    initTickerPriceStream(ticker: ticker);
    print('called' + ticker);
    if (!_tickerData.containsKey(ticker)) {
      _tickerData[ticker] = {};
    }
    if (!_tickerData[ticker]!.containsKey('tickerSvg')) {
      _tickerData[ticker]!['tickerSvg'] =
          await YahooHelper.getPictureLink(ticker: ticker);
      notifyListeners();
    }
    if (!_tickerData[ticker]!.containsKey('meta')) {
      _tickerData[ticker]!['meta'] =
          await YahooHelper.getStockMetadata(ticker: ticker);
      notifyListeners();
    }
  }

  // Ticker Price Stream handlers

  void initTickerPriceStream({required String ticker}) {
    if (!_priceStreamControllers.containsKey(ticker)) {
      _priceStreamControllers[ticker] =
          TickerStreams.priceStreamController(ticker: ticker);
      _priceStreamSubscribers[ticker] =
          _priceStreamControllers[ticker]!.stream.listen((data) {
        if (!_priceData.containsKey(ticker)) {
          _priceData[ticker] = null;
        }
        _priceData[ticker] = data;
        notifyListeners();
      });
    }
  }

  void removeTickerPriceStream({required String ticker}) {
    _priceStreamSubscribers[ticker]!.cancel();
    _priceStreamControllers[ticker]!.close();
    _priceStreamControllers.remove(ticker);
    notifyListeners();
  }

  // Getters / Setters

  YahooHelperPriceData getPriceData({required String ticker}) {
    if (_priceData.containsKey(ticker)) {
      return _priceData[ticker]!;
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
        currency: 'N/A',
      );
    }
  }

  Map<String, dynamic> getTickerData({required String ticker}) {
    if (!_tickerData.containsKey(ticker) || !_tickerData[ticker]!.containsKey('tickerSvg')) {
      return {
        'tickerSvg': '<svg width="56" height="56"></svg>',
        'meta': YahooHelperMetaData(
          companyLongName: "",
          currency: "USD",
          exchangeName: "",
          marketCap: "",
        ),
      };
    }
    return _tickerData[ticker]!;
  }
}
