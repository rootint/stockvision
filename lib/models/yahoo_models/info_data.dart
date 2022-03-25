class YahooHelperInfoData {
  final double yearChange;
  final double sAndPYearChange;
  final double recommendationMean;
  final String recommendationKey;
  final double targetMedianPrice;
  final int currentEarningsYear;
  final String currentEarningsQuarter;
  final int currentEarningsTimestamp;
  final double currentEarningsEstimate;
  final List<Map<String, dynamic>> earningsHistory;
  YahooHelperInfoData({
    required this.sAndPYearChange,
    required this.yearChange,
    required this.recommendationMean,
    required this.recommendationKey,
    required this.targetMedianPrice,
    required this.currentEarningsQuarter,
    required this.currentEarningsTimestamp,
    required this.currentEarningsYear,
    required this.currentEarningsEstimate,
    required this.earningsHistory,
  });
}
