import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/yahoo_models/info_data.dart';

class YahooInfoProvider extends ChangeNotifier {
  late StreamController<YahooHelperInfoData> _streamController;
  late StreamSubscription<YahooHelperInfoData> _streamSubscriber;
  final Map<String, YahooHelperInfoData?> _infoData = {};

  YahooInfoProvider() {
    _initCacheFromMemory();
  }

  void _initCacheFromMemory() {}
  void _loadCacheIntoMemory() {}

  StreamController<YahooHelperInfoData> _infoStreamController(String ticker) {
    late StreamController<YahooHelperInfoData> controller;
    Timer? timer;

    void tick() async {
      final data = await YahooHelper.getInfoData(ticker);
      controller.add(data);
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

    controller = StreamController<YahooHelperInfoData>.broadcast(
      onListen: start,
      onCancel: stop,
    );

    return controller;
  }

  void initInfoStream(String ticker) async {
    _streamController = _infoStreamController(ticker);
    _streamSubscriber = _streamController.stream.listen(
      (data) {
        _infoData[ticker] = data;
        print('$ticker stream going....');
        notifyListeners();
      },
    );
  }

  void removeInfoStream() {
    _streamController.close();
    _streamSubscriber.cancel();
    print('info gone!');
  }

  YahooHelperInfoData getInfoData(String ticker) {
    if (_infoData.containsKey(ticker)) {
      return _infoData[ticker]!;
    } else {
      return YahooHelperInfoData(
        sAndPYearChange: 0,
        yearChange: 0,
        recommendationKey: 'N/A',
        recommendationMean: 0.0,
        targetMedianPrice: 0.0,
        currentEarningsEstimate: 0,
        currentEarningsQuarter: "N/A",
        currentEarningsTimestamp: 0,
        currentEarningsYear: 0,
        earningsHistory: [
          {"N/A": 0}
        ],
      );
    }
  }
}
