class PredictionTicker {
  final String ticker;
  final double predictedPrice;
  final bool atClose;
  PredictionTicker({
    required this.ticker,
    required this.predictedPrice,
    required this.atClose,
  });
}