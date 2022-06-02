import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/models/server_models/prediction_ticker.dart';

class PredictionProvider extends ChangeNotifier {
  final List<PredictionTicker> _currentPredictions = [
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

  final List<PredictionTicker> _predictionHistory = [
    PredictionTicker(
      ticker: 'aapl',
      predictedPrice: 170.12,
      atClose: true,
      isHistory: true,
      isDirectionCorrect: true,
      predictionDate: DateTime.now(),
      predictionDelta: -5.3,
    ),
    PredictionTicker(
      ticker: 'goog',
      predictedPrice: 2000.05,
      atClose: true,
      isHistory: true,
      isDirectionCorrect: false,
      predictionDate: DateTime.fromMillisecondsSinceEpoch(101010101),
      predictionDelta: 3.2,
    ),
    PredictionTicker(
      ticker: 'tsla',
      predictedPrice: 750.56,
      atClose: true,
      isHistory: true,
      isDirectionCorrect: true,
      predictionDate: DateTime.fromMillisecondsSinceEpoch(24143134),
      predictionDelta: -10,
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
    // set up a stream??
    // ask how often are they updated
  }

  List<PredictionTicker> get predictions => _currentPredictions;

  List<PredictionTicker> get predictionHistory => _predictionHistory;
}
