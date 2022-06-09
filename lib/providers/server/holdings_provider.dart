import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/models/server_models/holdings.dart';
import 'package:stockadvisor/models/server_models/holdings_ticker.dart';
import 'package:stockadvisor/providers/yahoo/price_provider.dart';

/*
  server:
    userId
      watchlist
        List<Strings> - just tickers
      holdings
        List<String> - compressed strings 

// SQL database?????????

*/

// stream with holdings
// stream returns Holdings model

class HoldingsProvider with ChangeNotifier {
  final Map<String, HoldingsTicker> _holdingsList = {
    "aapl": HoldingsTicker(ticker: 'aapl', amount: 3, avgShareCost: 167.31),
    "amd": HoldingsTicker(ticker: 'amd', amount: 2, avgShareCost: 146.09),
    "nvda": HoldingsTicker(ticker: 'nvda', amount: 1, avgShareCost: 225.48),
    "msft": HoldingsTicker(ticker: 'msft', amount: 1, avgShareCost: 300.94),
    "intc": HoldingsTicker(ticker: 'intc', amount: 1, avgShareCost: 52.25),
    "pfe": HoldingsTicker(ticker: 'pfe', amount: 1, avgShareCost: 54.9),
    // "gazp.me":
    //     HoldingsTicker(ticker: 'gazp.me', amount: 30, avgShareCost: 253.83),
    // "nvtk.me":
    //     HoldingsTicker(ticker: 'nvtk.me', amount: 2, avgShareCost: 1276.9),
    // "sber.me":
    //     HoldingsTicker(ticker: 'sber.me', amount: 30, avgShareCost: 139.65),
  };

  late Holdings _holdings;

  HoldingsProvider() {
    initHoldingsData();
  }

  void update(YahooPriceProvider data) {
    double deltaToday = 0.0;
    double deltaTodayPercent = 0.0;
    double deltaAlltime = 0.0;
    double deltaAlltimePercent = 0.0;
    double currentWorth = 0.0;
    double overallBuyPrice = 0.0;
    double onMarketOpenWorth = 0.0;
    _holdingsList.forEach((key, value) {
      currentWorth += data.getPriceData(key).currentMarketPrice * value.amount;
      onMarketOpenWorth += data.getPriceData(key).previousDayClose * value.amount;
      overallBuyPrice += value.avgShareCost * value.amount;
    });
    deltaAlltime = currentWorth - overallBuyPrice;
    deltaAlltimePercent = currentWorth / overallBuyPrice * 100 - 100;
    deltaToday = currentWorth - onMarketOpenWorth;
    deltaTodayPercent = currentWorth / onMarketOpenWorth * 100 - 100;
    // print(currentWorth);
    _holdings = Holdings(
      tickerList: _holdingsList.values.toList(),
      currentWorth: currentWorth,
      deltaAlltime: deltaAlltime,
      deltaAlltimePercent: deltaAlltimePercent,
      deltaToday: deltaToday,
      deltaTodayPercent: deltaTodayPercent,
    );
  }

  void initHoldingsData() async {
    
  }

  void addTicker({required HoldingsTicker data}) {
    // _holdingsList.add(data);
    // send the holdings data as a json
    // to the server via an authenticated request
  }

  void removeTicker({required HoldingsTicker data}) {
    // remove the ticker from the list
    // via an authenticated request to the server
  }

  void updateTicker({required HoldingsTicker data}) {
    // remove and add a new ticker from the list
    // via an authenticated request to the server
  }

  bool containsTicker(String ticker) {
    return _holdingsList.containsKey(ticker);
  }

  String generateServerString({required HoldingsTicker data}) {
    return "${data.ticker};${data.amount};${data.avgShareCost}";
  }

  // List<HoldingsTicker> get holdingsList => _holdings.values.toList();
  Holdings get holdings => _holdings;
  Map<String, HoldingsTicker> get holdingsMap => _holdingsList;
}
