class YahooHelperChartData {
  final List<int> timestamp;
  final List<double> open;
  final List<double> close;
  final List<double> high;
  final List<double> low;
  final List<int> volume;
  final double percentage;
  final double previousClose;
  final double periodHigh;
  final double periodLow;
  final int timestampStart;
  final int timestampEnd;
  final double lastClosePrice;
  YahooHelperChartData({
    required this.timestamp,
    required this.open,
    required this.close,
    required this.high,
    required this.low,
    required this.volume,
    required this.percentage,
    required this.previousClose,
    required this.periodHigh,
    required this.periodLow,
    required this.timestampEnd,
    required this.timestampStart,
    required this.lastClosePrice,
  });
}
