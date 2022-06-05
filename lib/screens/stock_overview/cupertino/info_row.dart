import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/server_models/prediction_ticker.dart';
import 'package:stockadvisor/models/yahoo_models/info_data.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/models/yahoo_models/spark_data.dart';
import 'package:stockadvisor/painters/analytics_painter.dart';
import 'package:stockadvisor/painters/earnings_painter.dart';
import 'package:stockadvisor/providers/data_provider.dart';
import 'package:stockadvisor/providers/info_provider.dart';
import 'package:stockadvisor/providers/server/prediction_provider.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';

class CupertinoInfoRow extends StatefulWidget {
  final String ticker;
  const CupertinoInfoRow({
    required this.ticker,
    Key? key,
  }) : super(key: key);

  @override
  State<CupertinoInfoRow> createState() => _CupertinoInfoRowState();
}

class _CupertinoInfoRowState extends State<CupertinoInfoRow> {
  final Map<String, String> _recommendationMap = {
    "buy": "Buy",
    "strong_buy": "Strong Buy",
    "hold": "Hold",
    "sell": "Sell",
    "strong_sell": "Strong Sell",
  };

  @override
  Widget build(BuildContext context) {
    final infoProvider = Provider.of<InfoProvider>(context);
    // final dataProvider = Provider.of<DataProvider>(context);
    final predictionProvider = Provider.of<PredictionProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    YahooHelperInfoData tickerInfo =
        infoProvider.getInfoData(ticker: widget.ticker);
    // YahooHelperSparkData tickerGraph =
    //     infoProvider.getChartData(ticker: widget.ticker);
    // YahooHelperSparkData sAndPGraph = dataProvider.getSAndPChart();
    YahooHelperPriceData priceData =
        Provider.of<DataProvider>(context).getPriceData(ticker: widget.ticker);
    double dayPosition = 1 -
        (priceData.dayHigh - priceData.lastClosePrice) /
            (priceData.dayHigh - priceData.dayLow);
    double yearPosition = 1 -
        (priceData.fiftyTwoWeekHigh - priceData.lastClosePrice) /
            (priceData.fiftyTwoWeekHigh - priceData.fiftyTwoWeekLow);
    double yearlyDelta = priceData.lastClosePrice -
        (priceData.lastClosePrice / (1 + tickerInfo.yearChange));
    DateTime lastDividendDate = DateTime.fromMillisecondsSinceEpoch(
        priceData.lastDividendTimestamp * 1000);
    final Map<String, String> _infoMap = {
      "1 Year Target": tickerInfo.targetMedianPrice.toStringAsFixed(2),
      // market cap
      // p/e ratio
      // volumes
      // beta / eps
      // 52 week range?
    };

    bool isPredicted = false;
    PredictionTicker? prediction;
    double predictionDelta = 0;
    double predictionPercent = 0;
    double predictionPrice = 0;
    for (var item in predictionProvider.predictions) {
      if (item.ticker == widget.ticker) {
        predictionPrice = item.predictedPrice;
        isPredicted = true;
        prediction = item;
        predictionDelta = item.predictedPrice - priceData.lastClosePrice;
        predictionPercent = (predictionDelta / priceData.lastClosePrice) * 100;
        break;
      }
    }

    List<double> earningsList = [];
    double earningsMin = 0.0;
    double earningsMax = 0.0;
    if (tickerInfo.earningsHistory.length > 2) {
      for (var item in tickerInfo.earningsHistory
          .sublist(tickerInfo.earningsHistory.length - 2)) {
        earningsList.add(item["estimate"]);
        earningsList.add(item["actual"]);
      }
      earningsList.add(tickerInfo.currentEarningsEstimate);
      earningsMin = earningsList.reduce(min);
      earningsMax = earningsList.reduce(max);
    }

    return Column(
      children: [
        if (isPredicted)
          CupertinoInfoCard(
            title: 'PREDICTION',
            titleIcon: CupertinoIcons.eye_solid,
            rowPosition: RowPosition.left,
            innerHeight: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Predicted at open:',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: predictionPrice.toStringAsFixed(2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                                text: " USD",
                                style: TextStyle(
                                  color: CupertinoColors.inactiveGray,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                      ),
                      Text(
                        ((predictionPercent > 0) ? '↑' : '↓') +
                            '${predictionDelta.toStringAsFixed(2)} / ' +
                            ((predictionPercent > 0) ? '↑' : '↓') +
                            '${predictionPercent.abs().toStringAsFixed(2)}%',
                        style: TextStyle(color: kGreenColor, fontSize: 13),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        // CupertinoInfoCard(
        //   title: "52 WEEK PERFORMANCE",
        //   titleIcon: CupertinoIcons.graph_square_fill,
        //   rowPosition: RowPosition.left,
        //   innerHeight: 230,
        //   child: Stack(
        //     children: [
        //       Positioned(
        //         top: 0,
        //         left: 0,
        //         right: 0,
        //         bottom: 0,
        //         child: CustomPaint(
        //           painter: PerformancePainter(
        //             containerSize: Size(mediaQuery.size.width - 38, 200),
        //             sAndPData: sAndPGraph,
        //             tickerData: tickerGraph,
        //             leftPadding: 13,
        //           ),
        //         ),
        //       ),
        //       Positioned(
        //         bottom: 3,
        //         child: Text(
        //           DateFormat('d.MM.yyyy').format(
        //             DateTime.fromMillisecondsSinceEpoch(
        //                 tickerGraph.firstTimestamp * 1000),
        //           ),
        //           style: TextStyle(
        //             fontSize: 13,
        //             color: CupertinoColors.systemGrey5,
        //           ),
        //         ),
        //       ),
        //       Positioned(
        //         bottom: 3,
        //         right: 0,
        //         child: Text(
        //           DateFormat('d.MM.yyyy').format(DateTime.now()),
        //           style: TextStyle(
        //             fontSize: 13,
        //             color: CupertinoColors.systemGrey5,
        //           ),
        //         ),
        //       ),
        //       Positioned(
        //         right: 0,
        //         top: 20,
        //         bottom: 50,
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             for (double i in [tickerInfo.yearChange, tickerInfo.sAndPYearChange])
        //               Container(
        //                 decoration: BoxDecoration(
        //                   color: kBlackColor.withOpacity(0.2),
        //                   borderRadius: BorderRadius.circular(5),
        //                 ),
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(1.5),
        //                   child: Text(
        //                     (i * 100).toStringAsFixed(2) + '%',
        //                     style: const TextStyle(
        //                       fontSize: 13,
        //                       color: CupertinoColors.systemGrey5,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        //
        Row(
          children: [
            Flexible(
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
                                tickerInfo.recommendationMean
                                    .toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '${_recommendationMap[tickerInfo.recommendationKey] ?? 'N/A'}',
                              maxLines: 1,
                              style: TextStyle(fontSize: 16),
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
                      Positioned(
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
                      Positioned(
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
            ),
            Flexible(
              flex: 1,
              child: CupertinoInfoCard(
                title: 'DIVIDENDS',
                titleIcon: CupertinoIcons.creditcard_fill,
                rowPosition: RowPosition.right,
                isSquare: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (priceData.trailingAnnualDividendYield * 100)
                                    .toStringAsFixed(2) +
                                '%',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 1),
                          if (priceData.trailingAnnualDividendRate != 0)
                            Text(
                              '(${priceData.trailingAnnualDividendRate.toStringAsFixed(2)} ${priceData.currency} per year)',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: CupertinoColors.systemGrey2,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        (priceData.lastDividendTimestamp == 0 &&
                                priceData.trailingAnnualDividendRate != 0)
                            ? 'No data on last payout.'
                            : (priceData.lastDividendTimestamp == 0)
                                ? 'This company doesn\'t pay dividends.'
                                : 'Last dividend payout was on ${DateFormat('dd MMMM, y').format(lastDividendDate)}.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: CupertinoInfoCard(
                title: '52 WEEK CHANGE',
                titleIcon: CupertinoIcons.calendar,
                rowPosition: RowPosition.left,
                isSquare: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // ((tickerInfo.yearChange * 100).toStringAsFixed(2) +
                            //     '%'),
                            '${(tickerInfo.yearChange > 0) ? '↑' : '↓'}${(tickerInfo.yearChange.abs() * 100).toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '${(tickerInfo.yearChange > 0) ? '↑' : '↓'}${(yearlyDelta.abs().toStringAsFixed(2))} ${priceData.currency}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: CupertinoColors.systemGrey2,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        (tickerInfo.sAndPYearChange == 0)
                            ? 'Could not load the data.'
                            : (tickerInfo.sAndPYearChange > 0)
                                ? 'S&P 500 rose ${(tickerInfo.sAndPYearChange.abs() * 100).toStringAsFixed(2)}%.'
                                : 'S&P 500 fell ${(tickerInfo.sAndPYearChange.abs() * 100).toStringAsFixed(2)}%.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: CupertinoInfoCard(
                title: "EARNINGS",
                titleIcon: CupertinoIcons.money_dollar_circle_fill,
                rowPosition: RowPosition.right,
                isSquare: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (tickerInfo.earningsHistory.length > 2)
                        for (var item in tickerInfo.earningsHistory
                            .sublist(tickerInfo.earningsHistory.length - 2))
                          Column(
                            children: [
                              Expanded(
                                child: CustomPaint(
                                  painter: EarningsPainter(
                                    actual: item['actual'],
                                    estimate: item['estimate'],
                                    high: earningsMax,
                                    low: earningsMin,
                                    containerSize:
                                        Size(10, mediaQuery.size.width / 5 - 5),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 5),
                                  Text(
                                    item["quarter"].toString(),
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  Text(
                                    item["year"].toString(),
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  SizedBox(height: 2),
                                  (item["actual"] - item["estimate"] > 0)
                                      ? Text(
                                          '+' +
                                              ((item["actual"] -
                                                      item["estimate"]))
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: kGreenColor,
                                          ),
                                        )
                                      : Text(
                                          ((item["actual"] - item["estimate"]))
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: (item["actual"] ==
                                                    item["estimate"])
                                                ? CupertinoColors.systemGrey4
                                                : kRedColor,
                                          ),
                                        )
                                ],
                              ),
                            ],
                          ),
                      if (tickerInfo.earningsHistory.length > 2)
                        Column(
                          children: [
                            Expanded(
                              child: CustomPaint(
                                painter: EarningsPainter(
                                  actual: 0.0,
                                  estimate: tickerInfo.currentEarningsEstimate,
                                  high: earningsMax,
                                  low: earningsMin,
                                  current: true,
                                  containerSize:
                                      Size(10, mediaQuery.size.width / 5 - 5),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  'Q' + tickerInfo.currentEarningsQuarter[0],
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(
                                  tickerInfo.currentEarningsYear.toString(),
                                  style: TextStyle(fontSize: 11),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  (tickerInfo.currentEarningsTimestamp == 0)
                                      ? '-'
                                      : DateFormat('d MMM').format(DateTime
                                          .fromMillisecondsSinceEpoch(1000 *
                                              tickerInfo
                                                  .currentEarningsTimestamp)),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: CupertinoColors.systemGrey4,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Flexible(
            //   flex: 1,
            //   child: CupertinoInfoCard(
            //     title: '1 YEAR TARGET',
            //     titleIcon: CupertinoIcons.chart_bar_square_fill,
            //     rowPosition: RowPosition.right,
            //     isSquare: true,
            //     child: Padding(
            //       padding: const EdgeInsets.only(top: 8.0, bottom: 3),
            //       child: Column(
            //         children: [
            //           RichText(
            //             text: TextSpan(
            //               text: tickerInfo.targetMedianPrice.toStringAsFixed(2),
            //               style: TextStyle(
            //                 fontWeight: FontWeight.w500,
            //                 fontSize: 22,
            //               ),
            //               children: [
            //                 TextSpan(
            //                   text: ' ' + priceData.currency,
            //                   style: TextStyle(
            //                     color: CupertinoColors.inactiveGray,
            //                     fontWeight: FontWeight.w500,
            //                     fontSize: 20,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        const Center(
            child: Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Text(
            'This is not financial advice. \nStock information might be delayed.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
        )),
      ],
    );
  }
}

class CupertinoInfoCard extends StatelessWidget {
  final String title;
  final IconData titleIcon;
  final double innerHeight;
  final double width;
  final RowPosition rowPosition;
  final Widget child;
  final bool isSquare;
  const CupertinoInfoCard({
    required this.title,
    required this.titleIcon,
    required this.rowPosition,
    required this.child,
    this.innerHeight = 150,
    this.isSquare = false,
    this.width = double.infinity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding;
    switch (rowPosition) {
      case RowPosition.left:
        padding = const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 2.0);
        break;
      case RowPosition.right:
        padding = const EdgeInsets.fromLTRB(0.0, 10.0, 12.0, 2.0);
        break;
      case RowPosition.center:
        padding = const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 2.0);
        break;
    }

    return (isSquare)
        ? AspectRatio(
            aspectRatio: 1.05,
            child: Padding(
              padding: padding,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: CupertinoColors.darkBackgroundGray,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13.0, vertical: 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            titleIcon,
                            color: CupertinoColors.systemGrey.withOpacity(0.55),
                            size: 12,
                          ),
                          Text(
                            ' $title',
                            style: TextStyle(
                              color: CupertinoColors.inactiveGray
                                  .withOpacity(0.55),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: child),
                      // child,
                    ],
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: padding,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: CupertinoColors.darkBackgroundGray,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13.0, vertical: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          titleIcon,
                          color: CupertinoColors.systemGrey.withOpacity(0.55),
                          size: 12,
                        ),
                        Text(
                          ' $title',
                          style: TextStyle(
                            color:
                                CupertinoColors.inactiveGray.withOpacity(0.55),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: innerHeight,
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
