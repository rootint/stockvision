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
  final String currency;
  final bool extendedMarketAvailable;
  final double fiftyTwoWeekLow;
  final double fiftyTwoWeekHigh;
  final double trailingAnnualDividendRate;
  final double trailingAnnualDividendYield;
  final int lastDividendTimestamp;
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
    required this.currency,
    required this.extendedMarketAvailable,
    required this.fiftyTwoWeekHigh,
    required this.fiftyTwoWeekLow,
    required this.trailingAnnualDividendRate,
    required this.trailingAnnualDividendYield,
    required this.lastDividendTimestamp,
  });
}
