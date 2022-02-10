class YahooHelperPriceData {
  final String marketState;
  final double lastClosePrice;
  final double currentMarketPrice;
  final double lastPercentage;
  final double currentPercentage;
  final double dayHigh;
  final double dayLow;
  final dynamic pe;
  final double previousDayClose;
  YahooHelperPriceData({
    required this.marketState,
    required this.currentMarketPrice,
    required this.currentPercentage,
    required this.dayHigh,
    required this.dayLow,
    required this.lastClosePrice,
    required this.lastPercentage,
    required this.pe,
    required this.previousDayClose,
  });
}
