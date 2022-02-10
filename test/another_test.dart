import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/helpers/ticker_streams.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/yahoo_models/chart_data.dart';
import 'package:stockadvisor/models/yahoo_models/meta_data.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/painters/graph_painter.dart';

class CupertinoStockOverviewScreen extends StatefulWidget {
  static const routeName = '/stock_overview';

  const CupertinoStockOverviewScreen({Key? key}) : super(key: key);

  @override
  _CupertinoStockOverviewScreenState createState() =>
      _CupertinoStockOverviewScreenState();
}

class _CupertinoStockOverviewScreenState
    extends State<CupertinoStockOverviewScreen> with TickerProviderStateMixin {
  static const rangeConversionMap = {
    '1D': TickerRange.oneDay,
    '5D': TickerRange.fiveDay,
    '1M': TickerRange.oneMonth,
    'YTD': TickerRange.ytd,
    '1Y': TickerRange.oneYear,
    '5Y': TickerRange.fiveYear,
    'MAX': TickerRange.maxRange,
  };
  static const marketStateConversionMap = {
    'PREPRE': 'Post:',
    'PRE': 'Pre:',
    'REGULAR': '',
    'POST': 'Post:',
    'POSTPOST': 'Post:',
  };

  static const List<String> availableTimeframes = [
    "1D",
    "5D",
    "1M",
    "YTD",
    "1Y",
    "5Y",
    "MAX"
  ];
  bool _isLoading = false;
  String selectedTimeframe = "1D";
  double currentPrice = 0.0;
  String? companyName;
  late YahooHelperMetaData stockMetadata;
  YahooHelperPriceData? cachedPrice;
  YahooHelperChartData? cachedChart;

  late Animation<double> graphAnimation;
  late AnimationController graphAnimationController;

  void initAnimation() {
    graphAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    Tween<double> _graphTween = Tween(begin: 0.0, end: 1.0);

    graphAnimation = _graphTween.animate(CurvedAnimation(
        parent: graphAnimationController, curve: Curves.easeInOutSine));
  }

  Color getColorByPercentage(double percentage) {
    if (percentage == 0) return CupertinoColors.systemGrey4;
    if (percentage > 0) return kGreenColor;
    if (percentage < 0) return kRedColor;
    return CupertinoColors.white;
  }

  void changeTimeframe(String timeframe) {
    setState(() {
      selectedTimeframe = timeframe;
    });
  }

  @override
  void initState() {
    super.initState();
    initAnimation();
  }

  @override
  void dispose() {
    // dispose "while"
    graphAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final mediaQuery = MediaQuery.of(context);
    final isPredictable = true;
    // future builder?
    print('build');
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<YahooHelperMetaData>(
              future: StockInfoHelper.getStockMetadata(
                  ticker: routeArgs['ticker']!),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                      companyName != null ? companyName! : 'Loading...');
                }
                stockMetadata = snapshot.data!;
                companyName = stockMetadata.companyLongName;
                return SizedBox(
                  width: mediaQuery.size.width / 1.5,
                  child: Text(
                    companyName!,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            Text(
              routeArgs['ticker']!.toUpperCase(),
              style: const TextStyle(
                  fontSize: 14, color: CupertinoColors.systemGrey3),
            ),
          ],
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.star),
          onPressed: () {},
          alignment: Alignment.centerRight,
        ),
      ),
      child: _isLoading
          ? const Center(
              child: CupertinoActivityIndicator(
                radius: 20,
              ),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: StreamBuilder<YahooHelperPriceData>(
                            initialData: cachedPrice,
                            stream: StockInfoHelper.stockPriceStream(
                                ticker: routeArgs['ticker']!),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return CupertinoActivityIndicator();
                              }
                              final price = snapshot.data!.lastClosePrice;
                              final prePostPrice =
                                  snapshot.data!.currentMarketPrice;
                              cachedPrice = snapshot.data!;
                              final percentage = snapshot.data!.lastPercentage;
                              final priceDelta = price * (percentage / 100);
                              final prePostPercentage =
                                  snapshot.data!.currentPercentage;
                              final prePostPriceDelta =
                                  prePostPrice * (prePostPercentage / 100);
                              final marketState = cachedPrice!.marketState;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Current price: ',
                                      style: TextStyle(fontSize: 17)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            price.toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 36,
                                            ),
                                          ),
                                          Text(
                                            (percentage > 0 ? '+' : '') +
                                                '${priceDelta.toStringAsFixed(2)} / ' +
                                                (percentage > 0 ? '+' : '') +
                                                '${percentage.toStringAsFixed(2)}%',
                                            style: TextStyle(
                                                color: getColorByPercentage(
                                                    percentage),
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),

                                      //
                                      prePostPrice != price
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${marketStateConversionMap[marketState]} ${cachedPrice!.currentMarketPrice.toStringAsFixed(2)} ',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    (prePostPercentage > 0
                                                            ? '+'
                                                            : '') +
                                                        '${prePostPriceDelta.toStringAsFixed(2)} / ' +
                                                        (prePostPercentage > 0
                                                            ? '+'
                                                            : '') +
                                                        '${prePostPercentage.toStringAsFixed(2)}%',
                                                    style: TextStyle(
                                                      color:
                                                          getColorByPercentage(
                                                              prePostPercentage),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      isPredictable
                          ? Flexible(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: const [
                                    Text('Predicted at close:',
                                        style: TextStyle(fontSize: 14)),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3, bottom: 3),
                                      child: Text(
                                        '190.00',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 23),
                                      ),
                                    ),
                                    Text(
                                      '+2.50 / +1.57%',
                                      style: TextStyle(
                                          color: kRedColor, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Text('')
                    ],
                  ),
                ),
                StreamBuilder<YahooHelperChartData>(
                  initialData: cachedChart,
                  stream: StockInfoHelper.stockChartStream(
                      ticker: routeArgs['ticker']!,
                      range: rangeConversionMap[selectedTimeframe]!),
                  builder: (context, chartSnapshot) {
                    if (chartSnapshot.data == null) {
                      return SizedBox(
                          height: 230, child: CupertinoActivityIndicator());
                    }
                    final data = chartSnapshot.data!;
                    print('stream recalculated');
                    if (chartSnapshot.connectionState !=
                        ConnectionState.waiting) {
                      graphAnimationController.reset();
                      graphAnimationController.forward();
                    }
                    return AnimatedBuilder(
                      animation: graphAnimation,
                      builder: (context, _) {
                        // print(graphAnimation);
                        return SizedBox(
                          width: graphAnimation.value * mediaQuery.size.width,
                          // width: mediaQuery.size.width,

                          height: 230,
                          // color: CupertinoColors.darkBackgroundGray,
                          child: Stack(
                            children: [
                              CustomPaint(
                                painter: GraphPainter(
                                  containerSize: Size(
                                      graphAnimation.value *
                                          mediaQuery.size.width,
                                      200),
                                  // containerSize: Size(mediaQuery.size.width, 200),
                                  maxSize: Size(mediaQuery.size.width, 200),
                                  high: data.periodHigh,
                                  low: data.periodLow,
                                  points: data.close,
                                  timestampEnd: data.timestampEnd,
                                  timestampStart: data.timestampStart,
                                  currentTimestamp:
                                      DateTime.now().millisecondsSinceEpoch,
                                  lastClosePrice: data.lastClosePrice,
                                  previousClose: data.previousClose,
                                ),
                              ),

                              // for (var i = 0; i < data.timestamp.length; i++)
                              //   if (i % (data.timestamp.length ~/ 6) == 0)
                              //   Positioned(
                              //     left: i.toDouble(),
                              //     bottom: 10,
                              //     child: Text(DateTime.fromMillisecondsSinceEpoch(data.timestamp[i] * 1000).hour.toString()),
                              //   ),
                              // Positioned(
                              //   bottom: (data.previousClose - data.periodLow) *
                              //       ((230 - 10) /
                              //           (data.periodHigh - data.periodLow)),
                              //   right: 5,
                              //   child: Text(
                              //     chartSnapshot.data!.previousClose.toString(),
                              //     style: TextStyle(
                              //       fontSize: 12,
                              //       color: CupertinoColors.systemGrey3,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),


                          //   Text(DateTime.fromMillisecondsSinceEpoch(
                          //           chartSnapshot.data!.timestampStart * 1000)
                          //       .toString()),
                          //   Text(DateTime.fromMillisecondsSinceEpoch(
                          //           chartSnapshot.data!.timestampEnd * 1000)
                          //       .toString()),
                        );
                      },
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...availableTimeframes.map(
                      (index) => TimeframeCard(
                        index,
                        mediaQuery,
                        index == selectedTimeframe,
                        changeTimeframe,
                        true,
                      ),
                    ),
                  ],
                ),
                // fix stream error on scroll
                // Container(
                //   height: 600,
                //   width: mediaQuery.size.width,
                //   color: CupertinoColors.darkBackgroundGray,
                // ),
              ],
            ),
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
          // play with colors
          color: selected ? kPrimaryColor : kCupertinoDarkNavColor,
          borderRadius: BorderRadius.circular(8),
          border: isDarkMode
              ? null
              : Border.all(color: CupertinoColors.systemGrey3),
        ),
        curve: Curves.easeIn,
        child: SizedBox(
          width: 43,
          height: 23,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: selected
                    ? CupertinoColors.white
                    : isDarkMode
                        ? CupertinoColors.white
                        : CupertinoColors.systemGrey4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
