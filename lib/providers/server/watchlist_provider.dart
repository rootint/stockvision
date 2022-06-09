import 'package:flutter/cupertino.dart';

class WatchlistProvider extends ChangeNotifier {
  List<String> _watchlist = [
    'aapl',
    'brk-a',
    'amd',
    'nvda',
    'bmw.de',
    'pltr',
    'yndx.me',
    'goog',
    'amzn',
    'sber.me',
  ];

  WatchlistProvider() {
    initWatchlist();
  }

  void initWatchlist() async {
    // once again, authenticated requests
  }

  void sendWatchlist() async {
    // send the new data to the server
  }

  void addTickerToWatchlist({required String ticker}) {
    _watchlist.add(ticker);
    // print(ticker)
    notifyListeners();
  }

  void removeTickerFromWatchlist({required String ticker}) {
    _watchlist.remove(ticker);
    notifyListeners();
  }

  void rearrangeWatchList({required List<String> newWatchlist}) {
    _watchlist = newWatchlist;
    notifyListeners();
  }

  bool containsInWatchlist({required String ticker}) {
    return _watchlist.contains(ticker);
  }

  List<String> get watchlist => _watchlist;
}
