import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/models/server_models/holdings_ticker.dart';

/*
  server:
    userId
      watchlist
        List<Strings> - just tickers
      holdings
        List<String> - compressed strings 

// SQL database?????????

*/
class HoldingsProvider extends ChangeNotifier {
  final Map<String, HoldingsTicker> _holdings = {
    "aapl": HoldingsTicker(ticker: 'aapl', amount: 3, avgShareCost: 167.31),
    "amd": HoldingsTicker(ticker: 'amd', amount: 2, avgShareCost: 146.09),
    "nvda": HoldingsTicker(ticker: 'nvda', amount: 1, avgShareCost: 225.48),
    "msft": HoldingsTicker(ticker: 'msft', amount: 1, avgShareCost: 300.94),
    "intc": HoldingsTicker(ticker: 'intc', amount: 1, avgShareCost: 52.25),
  };

  HoldingsProvider() {
    initHoldingsData();
  }

  void initHoldingsData() async {
    // _holdingsList = await ...
    // send an authenticated request to the server
    // by user id or anything
    // and get the list of holdings
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
    // remove the ticker from the list 
    // via an authenticated request to the server
  }

  String generateServerString({required HoldingsTicker data}) {
    return "${data.ticker};${data.amount};${data.avgShareCost}";
  }

  // List<HoldingsTicker> get holdingsList => _holdings.values.toList();
}
