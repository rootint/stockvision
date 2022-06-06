import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:web_socket_channel/io.dart';
import 'package:stockadvisor/protobuf/message.pb.dart';

class YahooPriceProvider extends ChangeNotifier {
  final Map<String, StreamController<YahooHelperPriceData>>
      _priceStreamControllers = {};
  final Map<String, StreamSubscription<YahooHelperPriceData>>
      _priceStreamSubscribers = {};
  final _socketController = StreamController.broadcast();
  final Map<String, StreamSubscription<dynamic>> _socketStreamSubscribers = {};
  final Map<String, YahooHelperPriceData?> _priceData = {};
  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://streamer.finance.yahoo.com/'));

  YahooPriceProvider() {
    _socketController.addStream(channel.stream);
    _initCacheFromMemory();
  }

  void _initCacheFromMemory() {}
  void _loadCacheIntoMemory() {}

  StreamController<YahooHelperPriceData> priceStreamController(
      {required String ticker}) {
    late StreamController<YahooHelperPriceData> controller;
    Timer? timer;

    void tick() async {
      if (!controller.isClosed) {
        final data = await YahooHelper.getPriceData(ticker);
        controller.add(data);
      }
    }

    void start() {
      if (timer == null) {
        tick();
      }
      timer = Timer.periodic(const Duration(seconds: 600), (_) => tick());
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

  void _subscribeToWebsocket(String ticker) {
    channel.sink.add('{"subscribe":["$ticker"]}');
    print('ok $ticker');
  }

  void _unsubscribeFromWebsocket(String ticker) {
    channel.sink.add('{"unsubscribe":["$ticker"]}');
    print('removed $ticker');
  }

  void initPriceStream(String ticker) async {
    if (!_priceStreamControllers.containsKey(ticker)) {
      _subscribeToWebsocket(ticker);
      _priceStreamControllers[ticker] = priceStreamController(ticker: ticker);
      _priceStreamSubscribers[ticker] =
          _priceStreamControllers[ticker]!.stream.listen(
        (data) {
          if (!_priceData.containsKey(ticker)) {
            _priceData[ticker] = null;
          }
          _priceData[ticker] = data;
          notifyListeners();
        },
      );
      _socketStreamSubscribers[ticker] = _socketController.stream.listen(
        (data) {
          var socketData = yaticker.fromBuffer(base64.decode(data.toString()));
          if (socketData.id == ticker.toUpperCase()) {
            if (_priceData[ticker] != null) {
              bool isExtendedMarketNow =
                  socketData.marketHours.toString() != "REGULAR_MARKET";
              _priceData[ticker] = YahooHelperPriceData(
                marketState: socketData.marketHours.toString(),
                currentMarketPrice: socketData.price,
                currentPercentage: socketData.changePercent,
                dayHigh: _priceData[ticker]!.dayHigh,
                dayLow: _priceData[ticker]!.dayLow,
                lastClosePrice: isExtendedMarketNow
                    ? _priceData[ticker]!.lastClosePrice
                    : socketData.price,
                lastPercentage: isExtendedMarketNow
                    ? _priceData[ticker]!.lastPercentage : socketData.changePercent,
                pe: _priceData[ticker]!.pe,
                previousDayClose: _priceData[ticker]!.previousDayClose,
                currency: _priceData[ticker]!.currency,
                extendedMarketAvailable:
                    _priceData[ticker]!.extendedMarketAvailable,
                fiftyTwoWeekHigh: _priceData[ticker]!.fiftyTwoWeekHigh,
                fiftyTwoWeekLow: _priceData[ticker]!.fiftyTwoWeekLow,
                trailingAnnualDividendRate:
                    _priceData[ticker]!.trailingAnnualDividendRate,
                trailingAnnualDividendYield:
                    _priceData[ticker]!.trailingAnnualDividendYield,
                lastDividendTimestamp:
                    _priceData[ticker]!.lastDividendTimestamp,
                currentDelta: socketData.change,
                lastCloseDelta: isExtendedMarketNow
                    ? _priceData[ticker]!.lastCloseDelta : socketData.change,
                openPrice: _priceData[ticker]!.openPrice,
              );
              notifyListeners();
            }
          }
        },
      );
    }
    if (!_priceData.containsKey(ticker)) {
      _priceData[ticker] = await YahooHelper.getPriceData(ticker);
      print('$ticker price init!');
      notifyListeners();
    }
  }

  void removePriceStream(String ticker) {
    _unsubscribeFromWebsocket(ticker);
    _priceStreamSubscribers[ticker]!.cancel();
    _priceStreamControllers.remove(ticker);
    print('$ticker removed!');
  }

  YahooHelperPriceData getPriceData(String ticker) {
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
}
