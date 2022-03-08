import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/helpers/ticker_streams.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/yahoo_models/chart_data.dart';
import 'package:stockadvisor/models/yahoo_models/meta_data.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/painters/graph_painter.dart';
import 'package:stockadvisor/providers/cache_provider.dart';
import 'package:stockadvisor/providers/data_provider.dart';
import 'package:stockadvisor/screens/stock_overview12/cupertino/bottom_row.dart';

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
    'YTD': TickerRange.sixMonth,
    '1Y': TickerRange.oneYear,
    '5Y': TickerRange.fiveYear,
    'MAX': TickerRange.maxRange,
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
  static const marketStateConversionMap = {
    'PREPRE': 'Post:',
    'PRE': 'Pre:',
    'REGULAR': '',
    'POST': 'Post:',
    'POSTPOST': 'Post:',
    'CLOSED': 'After mkt:',
  };

  bool isSecondPage = false;
  bool _isLoading = true;
  String selectedTimeframe = "1D";
  double periodPercentage = 0.0;
  double periodPriceDelta = 0.0;
  bool showExtended = true;
  bool areStreamsInitialized = false;
  double currentPrice = 0.0;
  String? companyName;
  late YahooHelperMetaData stockMetadata;
  bool showGraphAnimation = true;

  // late StreamController<YahooHelperPriceData> priceController;
  late StreamController<YahooHelperChartData> chartController;

  YahooHelperPriceData? cachedPrice;
  YahooHelperChartData? cachedChart;
  // String? cachedSvg;
  SvgPicture? cachedSvg;

  final pageController = PageController();

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

  void changeTimeframe(String timeframe, String ticker) {
    setState(() {
      selectedTimeframe = timeframe;
      chartController.close();
      chartController = TickerStreams.chartStreamController(
          ticker: ticker, range: rangeConversionMap[timeframe]!);
      showExtended = (selectedTimeframe == '1D');
      showGraphAnimation = true;
    });
  }

  @override
  void initState() {
    super.initState();
    showGraphAnimation = true;
    initAnimation();
    graphAnimationController.reset();
  }

  @override
  void dispose() {
    graphAnimationController.dispose();
    // priceController.close();
    chartController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final mediaQuery = MediaQuery.of(context);
    final ticker = routeArgs['ticker']! as String;
    // final priceStream =
    //     routeArgs['priceStream'] as Stream<YahooHelperPriceData>;
    // final data = routeArgs['data'] as YahooHelperPriceData;
    if (!areStreamsInitialized) {
      // priceController = TickerStreams.priceStreamController(ticker: ticker);
      chartController = TickerStreams.chartStreamController(
          ticker: ticker, range: rangeConversionMap[selectedTimeframe]!);
      areStreamsInitialized = true;
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black.withOpacity(0.7),
        middle: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<YahooHelperMetaData>(
              future: YahooHelper.getStockMetadata(ticker: ticker),
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
            isSecondPage
                ? Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      ' ${cachedPrice!.lastClosePrice.toStringAsFixed(2)} (${cachedPrice!.lastPercentage.toStringAsFixed(2)}%)',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            getColorByPercentage(cachedPrice!.lastPercentage),
                      ),
                    ),
                  )
                : Text(
                    ticker.toUpperCase(),
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
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  isSecondPage = !isSecondPage;
                });
              },
              scrollDirection: Axis.vertical,
              children: [
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 2 * mediaQuery.devicePixelRatio),
                          child: Column(
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FutureBuilder<String>(
                                      // initialData: cachedSvg,
                                      future: YahooHelper.getPictureLink(
                                          ticker: ticker),
                                      builder: ((context, snapshot) {
                                        if (snapshot.data == null) {
                                          return const CupertinoActivityIndicator(
                                              radius: 10);
                                        }
                                        cachedSvg =
                                            SvgPicture.string(snapshot.data!);
                                        return cachedSvg as Widget;
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                              Consumer<DataProvider>(
                                  builder: (context, provider, _) {
                                var data = provider.getPriceData(ticker: ticker);
                                cachedPrice = data;
                                final price = cachedPrice!.lastClosePrice;
                                final prePostPrice =
                                    cachedPrice!.currentMarketPrice;
                                final percentage = cachedPrice!.lastPercentage;
                                final prePostPercentage =
                                    cachedPrice!.currentPercentage;
                                final priceDelta = price * (percentage / 100);
                                final prePostPriceDelta =
                                    prePostPrice * (prePostPercentage / 100);
                                final marketState = cachedPrice!.marketState;
                                if (periodPercentage == 0.0) {
                                  periodPercentage = percentage;
                                  periodPriceDelta = priceDelta;
                                }
                                return Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: mediaQuery.devicePixelRatio),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              price.toStringAsFixed(2),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13 *
                                                    mediaQuery.devicePixelRatio,
                                              ),
                                            ),
                                            Text(
                                                (periodPercentage > 0
                                                        ? '+'
                                                        : '') +
                                                    '${periodPriceDelta.toStringAsFixed(2)} / ' +
                                                    (periodPercentage > 0
                                                        ? '+'
                                                        : '') +
                                                    '${periodPercentage.toStringAsFixed(2)}%',
                                                style: TextStyle(
                                                    color: getColorByPercentage(
                                                        periodPercentage),
                                                    fontSize: 6 *
                                                        mediaQuery
                                                            .devicePixelRatio,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                        marketState != 'REGULAR' && showExtended
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: mediaQuery
                                                            .devicePixelRatio *
                                                        2.5),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '${marketStateConversionMap[marketState]} ${prePostPrice.toStringAsFixed(2)} ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 6 *
                                                            mediaQuery
                                                                .devicePixelRatio,
                                                        color: CupertinoColors
                                                            .white
                                                            .withOpacity(0.95),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 1),
                                                      child: Text(
                                                        (prePostPercentage > 0
                                                                ? '+'
                                                                : '') +
                                                            '${prePostPriceDelta.toStringAsFixed(2)} / ' +
                                                            (prePostPercentage >
                                                                    0
                                                                ? '+'
                                                                : '') +
                                                            '${prePostPercentage.toStringAsFixed(2)}%',
                                                        style: TextStyle(
                                                          color: getColorByPercentage(
                                                                  prePostPercentage)
                                                              .withOpacity(
                                                                  0.95),
                                                          fontSize: 5 *
                                                              mediaQuery
                                                                  .devicePixelRatio,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              Flexible(
                                flex: 4,
                                fit: FlexFit.tight,
                                child: LayoutBuilder(
                                  builder: ((context, constraints) {
                                    return Container(
                                      // check the animation with expanding container
                                      // color: CupertinoColors.darkBackgroundGray,
                                      width: mediaQuery.size.width,
                                      child:
                                          StreamBuilder<YahooHelperChartData>(
                                        initialData: cachedChart,
                                        stream: chartController.stream
                                            .asBroadcastStream(),
                                        builder: (context, chartSnapshot) {
                                          if (chartSnapshot.data == null) {
                                            return CupertinoActivityIndicator();
                                          }
                                          final data = chartSnapshot.data!;
                                          cachedChart = data;
                                          periodPercentage = data.percentage;
                                          periodPriceDelta =
                                              data.previousClose *
                                                  (data.percentage / 100);
                                          print(data.timestamp.length);
                                          if (showGraphAnimation &&
                                              (chartSnapshot.connectionState !=
                                                      ConnectionState.waiting &&
                                                  _isLoading != false)) {
                                            graphAnimationController.forward();
                                            showGraphAnimation = false;
                                          }
                                          return AnimatedBuilder(
                                            animation: graphAnimation,
                                            builder: (context, _) {
                                              return SizedBox(
                                                width: graphAnimation.value *
                                                    mediaQuery.size.width,
                                                child: Stack(
                                                  children: [
                                                    CustomPaint(
                                                      painter: GraphPainter(
                                                        containerSize: Size(
                                                            graphAnimation
                                                                    .value *
                                                                mediaQuery
                                                                    .size.width,
                                                            constraints
                                                                    .maxHeight -
                                                                10),
                                                        maxSize: Size(
                                                            mediaQuery
                                                                .size.width,
                                                            constraints
                                                                    .maxHeight -
                                                                10),
                                                        timeframe:
                                                            selectedTimeframe,
                                                        high: data.periodHigh,
                                                        low: data.periodLow,
                                                        points: data.close,
                                                        timestampEnd:
                                                            data.timestampEnd,
                                                        timestampStart:
                                                            data.timestampStart,
                                                        currentTimestamp: DateTime
                                                                .now()
                                                            .millisecondsSinceEpoch,
                                                        lastClosePrice:
                                                            data.lastClosePrice,
                                                        previousClose:
                                                            data.previousClose,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        for (var i = 1; i <= 5; i++)
                                          Text(
                                            '$i AM',
                                            style: TextStyle(
                                                fontSize: 7 *
                                                    mediaQuery
                                                        .devicePixelRatio),
                                          ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 3 * mediaQuery.devicePixelRatio),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ...availableTimeframes.map(
                                            (index) => TimeframeCard(
                                              ticker,
                                              index,
                                              mediaQuery,
                                              index == selectedTimeframe,
                                              changeTimeframe,
                                              true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: CupertinoStockOverviewBottomRow(
                                  // priceStream: priceStream,
                                  ticker: ticker,
                                  cache: cachedPrice,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          CupertinoIcons.chevron_down,
                          size: 12 * mediaQuery.devicePixelRatio,
                          color: CupertinoColors.systemGrey,
                        ),
                        onPressed: () {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: const Icon(CupertinoIcons.chevron_up,
                            size: 39, color: CupertinoColors.systemGrey),
                        onPressed: () {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimeframeCard extends StatelessWidget {
  final String ticker;
  final String text;
  final MediaQueryData mediaQuery;
  final Function(String, String) changeTimeframe;
  final bool selected;
  final bool isDarkMode;
  const TimeframeCard(this.ticker, this.text, this.mediaQuery, this.selected,
      this.changeTimeframe, this.isDarkMode,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final defaultPadding = 1.5;
    return GestureDetector(
      onTap: () {
        if (!selected) {
          changeTimeframe(text, ticker);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          // play with colors
          color: selected ? kPrimaryColor : CupertinoColors.darkBackgroundGray,
          borderRadius: BorderRadius.circular(20),
          border: isDarkMode
              ? null
              : Border.all(color: CupertinoColors.systemGrey3),
        ),
        curve: Curves.easeIn,
        child: SizedBox(
          width: mediaQuery.size.width / 8,
          height: mediaQuery.devicePixelRatio * 9,
          child: Padding(
            padding: EdgeInsets.only(top: mediaQuery.devicePixelRatio * 1.2),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 5.5 * mediaQuery.devicePixelRatio,
                fontWeight: FontWeight.bold,
                color: selected
                    ? CupertinoColors.white
                    : isDarkMode
                        ? CupertinoColors.systemGrey3
                        : CupertinoColors.systemGrey4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
