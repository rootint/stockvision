import 'dart:async';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/helpers/ticker_streams.dart';
import 'package:stockadvisor/models/yahoo_models/chart_data.dart';
import 'package:stockadvisor/models/yahoo_models/meta_data.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/painters/graph_painter.dart';
import 'package:stockadvisor/providers/chart_provider.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';

class CupertinoStockOverviewMainRow extends StatefulWidget {
  final String ticker;
  final YahooHelperPriceData priceData;
  final Map<String, dynamic> tickerData;
  // final YahooHelperChartData chartData;
  const CupertinoStockOverviewMainRow({
    required this.ticker,
    required this.priceData,
    required this.tickerData,
    Key? key,
  }) : super(key: key);

  @override
  State<CupertinoStockOverviewMainRow> createState() =>
      _CupertinoStockOverviewMainRowState();
}

class _CupertinoStockOverviewMainRowState
    extends State<CupertinoStockOverviewMainRow> with TickerProviderStateMixin {
  String selectedTimeframe = "1D";
  bool firstLoading = true;
  bool isStreamInitialized = false;

  // Slider

  bool sliderShown = false;
  double sliderPosition = 0.0;
  int hapticDelay = 0;
  double sliderDeltaPrice = 0.0;
  double sliderPrice = 0.0;
  double sliderPercentage = 0.0;
  DateTime? sliderTimestamp;
  double sliderPointY = 0.0;
  Color sliderPointColor = CupertinoColors.systemGrey4;

  void initSlider(double deltaX, YahooHelperChartData data, Size size) {
    setState(() {
      if (hapticDelay == 0) {
        HapticFeedback.lightImpact();
        hapticDelay = 3;
      }
      hapticDelay--;
      sliderShown = true;
      var index = ((data.close.length / size.width) * deltaX).round();
      if (index >= data.close.length) index = data.close.length - 1;
      sliderPosition = index * (size.width / data.close.length);
      sliderPrice = data.close[index];
      var high = max(data.periodHigh, data.previousClose);
      var low = min(data.periodLow, data.previousClose);
      double scaleFactor = (size.height - 10) / (high - low);
      sliderPointY = (size.height / 2 + 5) -
          (sliderPrice - (high + low) / 2) * scaleFactor;
      sliderDeltaPrice = sliderPrice - data.previousClose;
      sliderPercentage = ((sliderPrice / data.previousClose) - 1) * 100;
      sliderTimestamp =
          DateTime.fromMillisecondsSinceEpoch(data.timestamp[index] * 1000);
      sliderPointColor = getColorByPercentage(sliderPercentage);
    });
  }

  // Animation

  bool showGraphAnimation = true;
  bool startAnimation = false;
  bool reverseAnimation = false;
  late Animation<double> graphAnimation;
  late AnimationController graphAnimationController;
  YahooHelperChartData? prevChartData;

  void initAnimation() {
    graphAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    Tween<double> _graphTween = Tween(begin: 0.0, end: 1.0);

    graphAnimation = _graphTween.animate(CurvedAnimation(
        parent: graphAnimationController, curve: Curves.easeInOutSine));
  }

  // Other

  bool isTimeframeChanged = false;

  void changeTimeframe(String timeframe, String ticker) {
    setState(() {
      final chartProvider = Provider.of<ChartProvider>(context, listen: false);
      prevChartData = chartProvider.getChartData(
          ticker: ticker, range: rangeConversionMap[selectedTimeframe]!);
      chartProvider.removeChartStream();
      chartProvider.initChartStream(
          ticker: ticker, range: rangeConversionMap[timeframe]!);
      reverseAnimation = true;
      isTimeframeChanged = true;
      selectedTimeframe = timeframe;
    });
  }

  Color getColorByPercentage(double percentage) {
    if (percentage == 0) return CupertinoColors.systemGrey4;
    if (percentage > 0) return kGreenColor;
    if (percentage < 0) return kRedColor;
    return CupertinoColors.white;
  }

  // Overrides

  @override
  void initState() {
    super.initState();
    showGraphAnimation = true;
    initAnimation();
    graphAnimationController.reset();
  }

  @override
  void deactivate() {
    final chartProvider = Provider.of<ChartProvider>(context);
    chartProvider.removeChartStream();
    super.deactivate();
  }

  @override
  void dispose() {
    graphAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final chartProvider = Provider.of<ChartProvider>(context);
    // if (!isStreamInitialized) {
    //   chartProvider.initChartStream(
    //       ticker: widget.ticker, range: rangeConversionMap[selectedTimeframe]!);
    //   print('stream init');
    //   isStreamInitialized = true;
    // }

    double prevPeriodClose = 0.0;
    if (firstLoading) {
      prevPeriodClose = widget.priceData.previousDayClose;
    } else {
      prevPeriodClose = chartProvider
          .getChartData(
              ticker: widget.ticker,
              range: rangeConversionMap[selectedTimeframe]!)
          .previousClose;
      if (prevPeriodClose == 0 && prevChartData != null)
        prevPeriodClose = prevChartData!.previousClose;
    }

    // data for main market period
    double lastPercentage =
        widget.priceData.lastClosePrice / prevPeriodClose * 100 - 100;
    double lastPriceDelta = prevPeriodClose * lastPercentage / 100;
    double currentPrice = widget.priceData.currentMarketPrice;

    // data for extended market periods
    double currentPercentage = widget.priceData.currentPercentage;
    double currentPriceDelta = currentPrice * currentPercentage / 100;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SVG ICON
              Padding(
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SvgPicture.string(widget.tickerData['tickerSvg'],
                      height: 62),
                ),
              ),
              // TICKER NAME
              Padding(
                padding: const EdgeInsets.only(top: 2.0, bottom: 1.0),
                child: Text(
                  widget.ticker.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
              ),
              // FULL TICKER NAME / CURRENCY / MARKET STATE
              if (sliderShown)
                Text(
                  DateFormat('jm').format(sliderTimestamp!) +
                      DateFormat(' - dd MMM y').format(sliderTimestamp!),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: CupertinoColors.systemGrey2,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.tickerData.containsKey('meta')
                        ? '${(widget.tickerData['meta']! as YahooHelperMetaData).companyLongName} • ${widget.priceData.currency} • ${widget.priceData.marketState == "REGULAR" ? "Open" : "Closed"}'
                        : 'Loading...',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: CupertinoColors.systemGrey2,
                    ),
                  ),
                ),
              // CURRENT STOCK PRICE
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  sliderShown
                      ? sliderPrice.toStringAsFixed(2)
                      : widget.priceData.lastClosePrice.toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                    color: widget.priceData.marketState == "REGULAR"
                        ? CupertinoColors.white
                        : CupertinoColors.systemGrey4,
                  ),
                ),
              ),
              // CURRENT PERIOD PERCENTAGE
              if (sliderShown)
                Text(
                  (sliderDeltaPrice > 0 ? '+' : '') +
                      '${sliderDeltaPrice.toStringAsFixed(2)} / ' +
                      (sliderPercentage > 0 ? '+' : '') +
                      '${sliderPercentage.toStringAsFixed(2)}%',
                  style: TextStyle(
                      color: getColorByPercentage(sliderPercentage),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                )
              else
                Text(
                  (lastPriceDelta > 0 ? '+' : '') +
                      '${lastPriceDelta.toStringAsFixed(2)} / ' +
                      (lastPercentage > 0 ? '+' : '') +
                      '${lastPercentage.toStringAsFixed(2)}%',
                  style: TextStyle(
                      color: getColorByPercentage(lastPercentage),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              // EXTENDED MARKET PERCENTAGE
              if (widget.priceData.marketState != 'REGULAR' &&
                  widget.priceData.extendedMarketAvailable)
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: RichText(
                    text: TextSpan(
                      text: marketStateConversionMap[
                              widget.priceData.marketState]! +
                          ' ',
                      style: const TextStyle(
                        fontSize: 12,
                        letterSpacing: 0.04,
                        fontWeight: FontWeight.w400,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: (currentPriceDelta > 0 ? '+' : '') +
                              '${currentPriceDelta.toStringAsFixed(2)} / ' +
                              (currentPercentage > 0 ? '+' : '') +
                              '${currentPercentage.toStringAsFixed(2)}%',
                          style: TextStyle(
                              color: getColorByPercentage(currentPercentage),
                              letterSpacing: 0.04,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
        // CHART + OPEN/CLOSE + SLIDER
        SizedBox(
          width: mediaQuery.size.width,
          height: 250,
          child: Consumer<ChartProvider>(
            builder: (context, provider, _) {
              var data = provider.getChartData(
                  ticker: widget.ticker,
                  range: rangeConversionMap[selectedTimeframe]!);
              if (prevChartData == null && data.close.isEmpty) {
                return Stack(
                  children: [
                    Positioned(
                      top: 130,
                      child: Container(
                        height: 1.1,
                        width: mediaQuery.size.width,
                        color: CupertinoColors.inactiveGray,
                      ),
                    ),
                  ],
                );
              } else {
                var realData = data;
                if (reverseAnimation) {
                  data = prevChartData!;
                  graphAnimationController.reverse();
                }
                if (reverseAnimation && graphAnimationController.isDismissed) {
                  data = realData;
                  reverseAnimation = false;
                  graphAnimationController.forward();
                }
                if (firstLoading) {
                  graphAnimationController.forward();
                  firstLoading = false;
                }
              }
              return GestureDetector(
                child: Stack(
                  children: [
                    // GRAPH
                    AnimatedBuilder(
                      animation: graphAnimation,
                      builder: (context, _) {
                        return SizedBox(
                          width: mediaQuery.size.width,
                          child: CustomPaint(
                            painter: GraphPainter(
                              containerSize: Size(mediaQuery.size.width, 250),
                              animationValue: graphAnimation.value,
                              maxSize: Size(mediaQuery.size.width, 250),
                              timeframe: selectedTimeframe,
                              high: data.periodHigh,
                              low: data.periodLow,
                              points: data.close,
                              timestampEnd: data.timestampEnd,
                              timestampStart: data.timestampStart,
                              currentTimestamp:
                                  DateTime.now().millisecondsSinceEpoch,
                              lastClosePrice: data.lastClosePrice,
                              previousClose: data.previousClose,
                              opened: widget.priceData.marketState == 'REGULAR',
                              sliderPosition: sliderPosition,
                            ),
                          ),
                        );
                      },
                    ),
                    // HIGH / LOW CARDS
                    Positioned(
                      right: mediaQuery.size.width / 25,
                      top: 40,
                      bottom: 30,
                      child: AnimatedOpacity(
                        opacity:
                            graphAnimationController.isCompleted ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 250),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (double i in [data.periodHigh, data.periodLow])
                              Container(
                                decoration: BoxDecoration(
                                  color: kBlackColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.5),
                                  child: Text(
                                    i.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: CupertinoColors.systemGrey5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // This container allows the gesturedetector to span the entire graph
                    Container(
                      width: mediaQuery.size.width,
                      height: 250,
                      color: kBlackColor.withAlpha(0),
                    ),
                    // SLIDER
                    if (sliderShown)
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: sliderPosition,
                        child: Container(
                          width: 0.8,
                          color: CupertinoColors.systemGrey4,
                        ),
                      ),
                    if (sliderShown)
                      Positioned(
                        top: sliderPointY - 2.5,
                        left: sliderPosition - 2.5,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: sliderPointColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                // GESTURES FOR THE SLIDER
                onHorizontalDragUpdate: (details) {
                  initSlider(
                    details.localPosition.dx,
                    data,
                    Size(mediaQuery.size.width, 250),
                  );
                },
                onHorizontalDragEnd: (details) {
                  setState(() {
                    sliderShown = false;
                    sliderPosition = mediaQuery.size.width;
                  });
                },
                onHorizontalDragStart: (details) {
                  initSlider(
                    details.localPosition.dx,
                    data,
                    Size(mediaQuery.size.width, 250),
                  );
                },
                onHorizontalDragDown: (details) {
                  initSlider(
                    details.localPosition.dx,
                    data,
                    Size(mediaQuery.size.width, 250),
                  );
                },
                onHorizontalDragCancel: () {
                  setState(() {
                    sliderShown = false;
                    sliderPosition = mediaQuery.size.width;
                  });
                },
                onLongPressMoveUpdate: (details) {
                  initSlider(
                    details.localPosition.dx,
                    data,
                    Size(mediaQuery.size.width, 250),
                  );
                },
                onLongPressStart: (details) {
                  initSlider(
                    details.localPosition.dx,
                    data,
                    Size(mediaQuery.size.width, 250),
                  );
                },
                onLongPressDown: (details) {
                  initSlider(
                    details.localPosition.dx,
                    data,
                    Size(mediaQuery.size.width, 250),
                  );
                },
                onLongPressEnd: (details) {
                  setState(() {
                    sliderShown = false;
                    sliderPosition = mediaQuery.size.width;
                  });
                },
              );
            },
          ),
        ),
        // TIMEFRAME CARDS
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...availableTimeframes.map(
                (index) => TimeframeCard(
                  widget.ticker,
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
    return GestureDetector(
      onTap: () {
        if (!selected) {
          changeTimeframe(text, ticker);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected ? kPrimaryColor : CupertinoColors.darkBackgroundGray,
          borderRadius: BorderRadius.circular(9),
          border: isDarkMode
              ? null
              : Border.all(color: CupertinoColors.systemGrey3),
        ),
        curve: Curves.easeIn,
        child: SizedBox(
          width: mediaQuery.size.width / 8.2,
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
                        ? CupertinoColors.systemGrey
                        : CupertinoColors.systemGrey2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
