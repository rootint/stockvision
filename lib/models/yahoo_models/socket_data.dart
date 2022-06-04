class YahooHelperSocketData {
  double currentMarketPrice;
  double currentPercentage;
  double lastPercentage;
  double currentDelta;
  double lastClosePrice;
  double lastCloseDelta;
  String marketHours;
  YahooHelperSocketData({
    this.lastCloseDelta = 0,
    this.currentDelta = 0,
    this.currentMarketPrice = 0,
    this.currentPercentage = 0,
    this.lastClosePrice = 0,
    this.lastPercentage = 0,
    this.marketHours = '',
  });
}