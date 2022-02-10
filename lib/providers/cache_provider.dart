import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/yahoo_models/chart_data.dart';
import 'package:stockadvisor/models/yahoo_models/meta_data.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';

class CacheProvider extends ChangeNotifier {
  Map<String, Map<String, dynamic>> _cache = {};

  CacheProvider() {
    _getCacheFromMemory();
  }

  void _getCacheFromMemory() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('cache') != null) {
      _cache = json.decode(prefs.getString('cache')!);
      print(_cache);
    } else {
      print('wtf');
    }
  }

  void loadCacheToMemory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cache', json.encode(_cache));
    print('is anything here');
  }

  void addPriceData({
    required String ticker,
    required YahooHelperPriceData data,
  }) {
    if (!_cache.containsKey(ticker)) {
      _cache[ticker] = {};
    }
    _cache[ticker]!['price'] = data;
  }

  void addMetaData({
    required String ticker,
    required YahooHelperMetaData data,
  }) {
    if (!_cache.containsKey(ticker)) {
      _cache[ticker] = {};
    }
    _cache[ticker]!['metadata'] = data;
  }

  void addTickerSvg({required String ticker, required String data}) {
    if (!_cache.containsKey(ticker)) {
      _cache[ticker] = {};
    }
    _cache[ticker]!['imageSvg'] = data;
  }

  void addChartData({
    required String ticker,
    required YahooHelperChartData data,
    required TickerRange range,
  }) {
    if (!_cache.containsKey(ticker)) {
      _cache[ticker] = {};
    }
    _cache[ticker]!['chart'] = data;
  }

  YahooHelperPriceData? getPriceData({required String ticker}) {
    if (_cache.containsKey(ticker)) {
      return _cache[ticker]!['price'];
    } else {
      return null;
    }
  }

  String? getTickerSvg({required String ticker}) {
    if (_cache.containsKey(ticker)) {
      return _cache[ticker]!['imageSvg'];
    } else {
      return null;
    }
  }

  YahooHelperChartData? getChartData({required String ticker, required TickerRange range}) {
    if (_cache.containsKey(ticker)) {
      return _cache[ticker]!['chart'];
    } else {
      return null;
    }
  }

  YahooHelperMetaData? getMetaData({required String ticker}) {
    if (_cache.containsKey(ticker)) {
      return _cache[ticker]!['metadata'];
    } else {
      return null;
    }
  }
}
