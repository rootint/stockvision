import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/models/yahoo_models/info_data.dart';
import 'package:stockadvisor/painters/analytics_painter.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_card.dart';

class CupertinoInfoAnalyticsCard extends StatelessWidget {
  final String ticker;
  final MediaQueryData mediaQuery;
  final YahooHelperInfoData tickerInfo;
  const CupertinoInfoAnalyticsCard(
      this.ticker, this.mediaQuery, this.tickerInfo,
      {Key? key})
      : super(key: key);

  static const Map<String, String> _recommendationMap = {
    "buy": "Buy",
    "strong_buy": "Strong Buy",
    "hold": "Hold",
    "sell": "Sell",
    "strong_sell": "Strong Sell",
  };

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: CupertinoInfoCard(
        title: 'ANALYTICS',
        titleIcon: CupertinoIcons.chart_bar_alt_fill,
        isSquare: true,
        rowPosition: RowPosition.left,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 3),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: Text(
                        tickerInfo.recommendationMean.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      _recommendationMap[tickerInfo.recommendationKey] ?? 'N/A',
                      maxLines: 1,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Center(
                child: CustomPaint(
                  painter: AnalyticsPainter(
                    rating: (tickerInfo.recommendationMean != 0)
                        ? tickerInfo.recommendationMean
                        : 2.5,
                    size: Size(mediaQuery.size.width / 2 - 36,
                        mediaQuery.size.width / 2 - 36),
                  ),
                ),
              ),
              const Positioned(
                bottom: 0,
                left: 5,
                child: Text(
                  'Sell',
                  style: TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey4,
                  ),
                ),
              ),
              const Positioned(
                bottom: 0,
                right: 5,
                child: Text(
                  'Buy',
                  style: TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
