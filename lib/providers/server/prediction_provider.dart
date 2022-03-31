import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/models/server_models/prediction_ticker.dart';

class PredictionProvider extends ChangeNotifier {
  final List<PredictionTicker> _predictions = [
    PredictionTicker(
      ticker: 'aapl',
      predictedPrice: 180.01,
      atClose: true,
    ),
    PredictionTicker(
      ticker: 'goog',
      predictedPrice: 2582.59,
      atClose: true,
    ),
    PredictionTicker(
      ticker: 'tsla',
      predictedPrice: 1109.82,
      atClose: true,
    ),
  ];

  PredictionProvider() {
    initPredictions();
  }

  void initPredictions() async {
    // these have to be authenticated!!!!!!!
    // paid product
  }

  void updatePredictions() async {
    // ask how often are they updated
  }

  List<PredictionTicker> get predictions => _predictions;
}
