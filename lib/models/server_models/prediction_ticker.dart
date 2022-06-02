class PredictionTicker {
  final String ticker;
  final double predictedPrice;
  final bool atClose;
  final bool isHistory;
  final bool? isDirectionCorrect;
  final double? predictionDelta;
  final DateTime? predictionDate;
  PredictionTicker({
    required this.ticker,
    required this.predictedPrice,
    required this.atClose,
    this.isHistory = false,
    this.isDirectionCorrect,
    this.predictionDate,
    this.predictionDelta,
  });
}