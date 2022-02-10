import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/painters/graph_painter.dart';
import 'package:yahoofin/yahoofin.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  TestWidgetState createState() => TestWidgetState();
}

class TestWidgetState extends State<TestWidget> with TickerProviderStateMixin {
  final List<String> availableTimeframes = [
    "1D",
    "5D",
    "1M",
    "6M",
    "1Y",
    "5Y",
    "MAX"
  ];
  final mainTicker = "^IXIC";
  bool isLoading = true;
  StockChart? quotePrices;
  double periodHigh = 0.0;
  double periodLow = 0.0;
  double currentPrice = 0.0;
  double percentage = 0.0;
  String selectedTimeframe = "1D";
  List<num> pointsList = [];
  late YahooFin yahooHandler;
  late StockInfo stockInfo;
  late StockQuote stockPrice;
  late StockHistory graphHistory;
  late StockChart graphChart;
  late StockChart percentageHelper;
  late StockHistory lastHistory;

  late Animation<double> graphAnimation;
  late AnimationController graphAnimationController;

  @override
  void initState() {
    super.initState();
    // initYahooAPI(mainTicker);
    getStockInfo(mainTicker, selectedTimeframe);
    initAnimation();
  }

  @override
  void dispose() {
    graphAnimationController.dispose();
    super.dispose();
  }

  void initAnimation() {
    graphAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      // duration: const Duration(milliseconds: 50),
      vsync: this,
    );

    Tween<double> _graphTween = Tween(begin: 0.0, end: 1.0);

    graphAnimation = _graphTween.animate(CurvedAnimation(
        parent: graphAnimationController, curve: Curves.easeInOutSine));
  }

  void initYahooAPI(String ticker) async {
    yahooHandler = YahooFin();
    stockInfo = yahooHandler.getStockInfo(ticker: ticker);
    stockPrice = await yahooHandler.getPrice(stockInfo: stockInfo);
    graphHistory = yahooHandler.initStockHistory(ticker: ticker);

    // Data for percentage
    lastHistory = yahooHandler.initStockHistory(ticker: ticker);
  }

  void getStockInfo(String ticker, String timeframe) async {
    yahooHandler = YahooFin();
    stockInfo = yahooHandler.getStockInfo(ticker: ticker);
    stockPrice = await yahooHandler.getPrice(stockInfo: stockInfo);
    graphHistory = yahooHandler.initStockHistory(ticker: ticker);

    // Data for percentage
    lastHistory = yahooHandler.initStockHistory(ticker: ticker);
    isLoading = true;

    late double lastClosePrice;

    late double high;
    late double low;

    switch (timeframe) {
      case '1D':
        graphChart = await yahooHandler.getChartQuotes(
          stockHistory: graphHistory,
          interval: StockInterval.twoMinute,
          period: StockRange.oneDay,
        );
        percentageHelper = await yahooHandler.getChartQuotes(
          stockHistory: lastHistory,
          interval: StockInterval.oneDay,
          period: StockRange.oneMonth,
        );
        lastClosePrice = percentageHelper.chartQuotes!
            .close![percentageHelper.chartQuotes!.close!.length - 2]
            .toDouble();
        high = stockPrice.dayHigh!;
        low = stockPrice.dayLow!;
        pointsList = graphChart.chartQuotes!.close!;
        break;
      case '5D':
        graphChart = await yahooHandler.getChartQuotes(
          stockHistory: graphHistory,
          interval: StockInterval.fifteenMinute,
          period: StockRange.fiveDay,
        );
        percentageHelper = await yahooHandler.getChartQuotes(
          stockHistory: lastHistory,
          interval: StockInterval.oneDay,
          period: StockRange.fiveDay,
        );

        lastClosePrice = percentageHelper.chartQuotes!.open![0].toDouble();

        high = 0;
        low = percentageHelper
            .chartQuotes!.low![percentageHelper.chartQuotes!.low!.length - 1]
            .toDouble();
        for (int i = 0; i < 5; i++) {
          var currentLow = percentageHelper.chartQuotes!
              .low![percentageHelper.chartQuotes!.low!.length - i - 1]
              .toDouble();
          var currentHigh = percentageHelper.chartQuotes!
              .high![percentageHelper.chartQuotes!.high!.length - i - 1]
              .toDouble();
          if (currentLow < low) {
            low = currentLow;
          }
          if (currentHigh > high) {
            high = currentHigh;
          }
        }
        pointsList = graphChart.chartQuotes!.close!;
        break;
      case '1M':
        graphChart = await yahooHandler.getChartQuotes(
          stockHistory: graphHistory,
          interval: StockInterval.sixtyMinute,
          period: StockRange.oneMonth,
        );
        percentageHelper = await yahooHandler.getChartQuotes(
          stockHistory: lastHistory,
          interval: StockInterval.oneMonth,
          period: StockRange.oneMonth,
        );
        lastClosePrice = graphChart.chartQuotes!.close![0].toDouble();
        high = percentageHelper.chartQuotes!.high![0].toDouble();
        low = percentageHelper.chartQuotes!.low![0].toDouble();
        pointsList = graphChart.chartQuotes!.close!;
        break;
      case '6M':
        graphChart = await yahooHandler.getChartQuotes(
          stockHistory: graphHistory,
          interval: StockInterval.oneDay,
          period: StockRange.sixMonth,
        );

        percentageHelper = await yahooHandler.getChartQuotes(
          stockHistory: lastHistory,
          interval: StockInterval.oneMonth,
          period: StockRange.sixMonth,
        );
        lastClosePrice = percentageHelper.chartQuotes!.open![0].toDouble();
        high = 0;
        low = percentageHelper.chartQuotes!.low![0].toDouble();
        for (int i = 0; i < 6; i++) {
          var currentLow = percentageHelper.chartQuotes!
              .low![percentageHelper.chartQuotes!.low!.length - i - 1]
              .toDouble();
          var currentHigh = percentageHelper.chartQuotes!
              .high![percentageHelper.chartQuotes!.high!.length - i - 1]
              .toDouble();
          if (currentLow < low) {
            low = currentLow;
          }
          if (currentHigh > high) {
            high = currentHigh;
          }
        }
        pointsList = graphChart.chartQuotes!.close!;
        break;
      case '1Y':
        graphChart = await yahooHandler.getChartQuotes(
          stockHistory: graphHistory,
          interval: StockInterval.oneDay,
          period: StockRange.oneYear,
        );
        percentageHelper = await yahooHandler.getChartQuotes(
          stockHistory: lastHistory,
          interval: StockInterval.oneMonth,
          period: StockRange.oneYear,
        );
        lastClosePrice = percentageHelper.chartQuotes!.open![0].toDouble();
        low = percentageHelper.chartQuotes!.low![0].toDouble();
        high = 0;
        for (int i = 0; i < 12; i++) {
          var currentLow = percentageHelper.chartQuotes!
              .low![percentageHelper.chartQuotes!.low!.length - i - 1]
              .toDouble();
          var currentHigh = percentageHelper.chartQuotes!
              .high![percentageHelper.chartQuotes!.high!.length - i - 1]
              .toDouble();
          if (currentLow < low) {
            low = currentLow;
          }
          if (currentHigh > high) {
            high = currentHigh;
          }
        }
        pointsList = graphChart.chartQuotes!.close!;
        break;
      case '5Y':
        graphChart = await yahooHandler.getChartQuotes(
          stockHistory: graphHistory,
          interval: StockInterval.oneWeek,
          period: StockRange.fiveYear,
        );
        percentageHelper = await yahooHandler.getChartQuotes(
          stockHistory: lastHistory,
          interval: StockInterval.oneMonth,
          period: StockRange.fiveYear,
        );
        lastClosePrice = percentageHelper.chartQuotes!.open![0].toDouble();
        pointsList = graphChart.chartQuotes!.close!;
        print(DateTime.fromMillisecondsSinceEpoch(percentageHelper.chartQuotes!
                .timestamp![percentageHelper.chartQuotes!.close!.length - 6]
                .toInt() *
            1000));
        low = percentageHelper.chartQuotes!.low![0].toDouble();
        high = 0;
        for (int i = 0; i < 12; i++) {
          var currentLow = percentageHelper.chartQuotes!
              .low![percentageHelper.chartQuotes!.low!.length - i - 1]
              .toDouble();
          var currentHigh = percentageHelper.chartQuotes!
              .high![percentageHelper.chartQuotes!.high!.length - i - 1]
              .toDouble();
          if (currentLow < low) {
            low = currentLow;
          }
          if (currentHigh > high) {
            high = currentHigh;
          }
        }
        break;
      case 'MAX':
        graphChart = await yahooHandler.getChartQuotes(
          stockHistory: graphHistory,
          interval: StockInterval.oneMonth,
          period: StockRange.maxRange,
        );
        percentageHelper = await yahooHandler.getChartQuotes(
          stockHistory: lastHistory,
          interval: StockInterval.threeMonth,
          period: StockRange.maxRange,
        );
        lastClosePrice = percentageHelper.chartQuotes!.open![0].toDouble();
        pointsList = graphChart.chartQuotes!.close!;
        print(DateTime.fromMillisecondsSinceEpoch(percentageHelper.chartQuotes!
                .timestamp![percentageHelper.chartQuotes!.close!.length - 6]
                .toInt() *
            1000));
        low = percentageHelper.chartQuotes!.low![0].toDouble();
        high = 0;
        for (int i = 0; i < 12; i++) {
          var currentLow = percentageHelper.chartQuotes!
              .low![percentageHelper.chartQuotes!.low!.length - i - 1]
              .toDouble();
          var currentHigh = percentageHelper.chartQuotes!
              .high![percentageHelper.chartQuotes!.high!.length - i - 1]
              .toDouble();
          if (currentLow < low) {
            low = currentLow;
          }
          if (currentHigh > high) {
            high = currentHigh;
          }
        }
        break;
    }

    setState(() {
      graphAnimationController.reset();
      isLoading = false;
      quotePrices = graphChart;
      currentPrice = stockPrice.currentPrice!;
      percentage = (currentPrice - lastClosePrice) / lastClosePrice * 100;
      periodHigh = high;
      periodLow = low;
      graphAnimationController.forward();
    });
  }

  void changeTimeframe(String timeframe) {
    setState(() {
      selectedTimeframe = timeframe;
      getStockInfo(mainTicker, selectedTimeframe);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isDarkMode =
        CupertinoTheme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(11),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: isDarkMode ? CupertinoColors.black : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Flexible(
                        flex: 4,
                        fit: FlexFit.tight,
                        child: Text(
                          "Nasdaq",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        fit: FlexFit.tight,
                        child: Text(
                          currentPrice.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            isLoading
                                ? "0.00%"
                                : (percentage > 0
                                    ? "+${percentage.toStringAsFixed(2)}%"
                                    : '${percentage.toStringAsFixed(2)}%'),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isLoading
                                    ? Colors.grey.shade500
                                    : (percentage > 0
                                        ? kGreenColor
                                        : kRedColor)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 13,
                fit: FlexFit.tight,
                child: isLoading
                    ? const Center(
                        child: CupertinoActivityIndicator(
                          radius: 20,
                        ),
                      )
                    : AnimatedBuilder(
                        animation: graphAnimation,
                        // color: kBlackElevation4,
                        builder: (context, _) {
                          // print(graphAnimation.value);
                          return Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: SizedBox(
                              width:
                                  graphAnimation.value * mediaQuery.size.width,
                              height: double.infinity,
                              child: CustomPaint(
                                painter: GraphPainter(
                                  pointsList as List<double>,
                                  periodHigh,
                                  periodLow,
                                  Size(mediaQuery.size.width, 140),
                                  Size(
                                      graphAnimation.value *
                                          mediaQuery.size.width,
                                      140),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              // TODO: add timestamps at the bottom
              // Flexible(
              //   flex: 2,
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.only(left: 5, right: 5, bottom: 8),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         ...availableTimeframes.map(
              //           (timeframe) => TimeframeCard(
              //               timeframe,
              //               mediaQuery,
              //               timeframe == selectedTimeframe,
              //               changeTimeframe,
              //               isDarkMode),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      width: mediaQuery.size.width,
      height: 300,
    );
  }
}

class TimeframeCard extends StatelessWidget {
  final String text;
  final MediaQueryData mediaQuery;
  final Function(String) changeTimeframe;
  final bool selected;
  final bool isDarkMode;
  const TimeframeCard(this.text, this.mediaQuery, this.selected,
      this.changeTimeframe, this.isDarkMode,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!selected) {
          changeTimeframe(text);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(10),
          border: isDarkMode ? null : Border.all(color: Colors.grey.shade600),
        ),
        curve: Curves.easeIn,
        child: SizedBox(
          width: mediaQuery.size.width / 9,
          height: 27,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected
                    ? Colors.white
                    : isDarkMode
                        ? Colors.white
                        : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// it works so it is kinda cool


// child: NestedScrollView(
//         headerSliverBuilder: (context, isInnerBoxScrolled) => [
//           CupertinoSliverNavigationBar(
//             largeTitle: Container(
//               // height: 300,
//               child: Text('hi there'),
//             ),
//             leading: Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: kPrimaryColor,
//                   radius: 15,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10),
//                   child: CupertinoButton(
//                     padding: EdgeInsets.zero,
//                     onPressed: () {},
//                     child: Row(
//                       children: [
//                         Text(
//                           'Profile',
//                           style: TextStyle(color: CupertinoColors.white),
//                         ),
//                         Icon(
//                           CupertinoIcons.right_chevron,
//                           size: 20,
//                           color: CupertinoColors.systemGrey,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             trailing: CupertinoButton(
//               padding: EdgeInsets.zero,
//               child: const Icon(CupertinoIcons.gear_alt_fill,
//                   color: CupertinoColors.systemGrey5),
//               onPressed: () {},
//             ),
//           ),
//         ],
//         body: Container(),
//       ),