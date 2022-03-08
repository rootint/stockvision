import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/helpers/ticker_streams.dart';
import 'package:stockadvisor/models/yahoo_models/chart_data.dart';
import 'package:stockadvisor/models/yahoo_models/meta_data.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/painters/graph_painter.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';

class CupertinoStockOverviewMainRow extends StatefulWidget {
  final String ticker;
  final YahooHelperPriceData priceData;
  final Map<String, dynamic> tickerData;
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
  Map<String, YahooHelperChartData> chartCache = {};
  bool showExtended = true;
  bool areStreamsInitialized = false;
  bool startAnimation = false;

  late StreamController<YahooHelperChartData> chartController;

  bool showGraphAnimation = true;
  late Animation<double> graphAnimation;
  late AnimationController graphAnimationController;

  void initAnimation() {
    graphAnimationController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    Tween<double> _graphTween = Tween(begin: 0.0, end: 1.0);

    graphAnimation = _graphTween.animate(CurvedAnimation(
        parent: graphAnimationController, curve: Curves.easeInOutSine));
  }

  void changeTimeframe(String timeframe, String ticker) {
    setState(() {
      selectedTimeframe = timeframe;
      chartController.close();
      chartController = TickerStreams.chartStreamController(
          ticker: ticker, range: rangeConversionMap[timeframe]!);
      showExtended = (selectedTimeframe == '1D');
      // showGraphAnimation = true;
      graphAnimationController.reset();
    });
  }

  Color getColorByPercentage(double percentage) {
    if (percentage == 0) return CupertinoColors.systemGrey4;
    if (percentage > 0) return kGreenColor;
    if (percentage < 0) return kRedColor;
    return CupertinoColors.white;
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
    chartController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    if (!areStreamsInitialized) {
      chartController = TickerStreams.chartStreamController(
          ticker: widget.ticker, range: rangeConversionMap[selectedTimeframe]!);
      areStreamsInitialized = true;
    }
    double lastClosePrice = widget.priceData.lastClosePrice;
    double lastPercentage = widget.priceData.lastPercentage;
    double lastPriceDelta = lastClosePrice * lastPercentage / 100;
    double currentPrice = widget.priceData.currentMarketPrice;
    double currentPercentage = widget.priceData.currentPercentage;
    double currentPriceDelta = currentPrice * currentPercentage / 100;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SvgPicture.string(widget.tickerData['tickerSvg'],
                      height: 62),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  widget.ticker.toUpperCase(),
                  // (widget.tickerData['meta']! as YahooHelperMetaData).companyLongName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
              ),
              Text(
                '${(widget.tickerData['meta']! as YahooHelperMetaData).companyLongName} • ${widget.priceData.currency}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: CupertinoColors.systemGrey2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  widget.priceData.lastClosePrice.toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                  ),
                ),
              ),
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
              widget.priceData.marketState != 'REGULAR'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: RichText(
                        text: TextSpan(
                          text: marketStateConversionMap[
                                  widget.priceData.marketState]! +
                              ' ',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                          children: <TextSpan>[
                            TextSpan(
                              text: (currentPriceDelta > 0 ? '+' : '') +
                                  '${currentPriceDelta.toStringAsFixed(2)} / ' +
                                  (currentPercentage > 0 ? '+' : '') +
                                  '${currentPercentage.toStringAsFixed(2)}%',
                              style: TextStyle(
                                  color:
                                      getColorByPercentage(currentPercentage),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        SizedBox(
          width: mediaQuery.size.width,
          height: 250,
          child: StreamBuilder<YahooHelperChartData>(
            initialData: chartCache[selectedTimeframe],
            stream: chartController.stream.asBroadcastStream(),
            builder: (context, chartSnapshot) {
              if (chartSnapshot.data == null) {
                return CupertinoActivityIndicator();
              }
              final data = chartSnapshot.data!;
              chartCache[selectedTimeframe] = data;
              final periodPercentage = data.percentage;
              currentPriceDelta = data.previousClose * (data.percentage / 100);
              currentPercentage = periodPercentage;

              graphAnimationController.forward();
              
              return Stack(
                children: [
                  AnimatedBuilder(
                    animation: graphAnimation,
                    builder: (context, _) {
                      return SizedBox(
                        width: graphAnimation.value * mediaQuery.size.width,
                        child: CustomPaint(
                          painter: GraphPainter(
                            containerSize: Size(
                                graphAnimation.value * mediaQuery.size.width,
                                245),
                            // animationValue: graphAnimation.value,
                            maxSize: Size(mediaQuery.size.width, 245),
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
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: mediaQuery.size.width / 25,
                    top: 40,
                    bottom: 30,
                    child: AnimatedOpacity(
                      opacity: graphAnimationController.isCompleted ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      // curve: Curves.easeInOut,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (double i in [data.periodHigh, data.periodLow])
                            Container(
                              decoration: BoxDecoration(
                                color: CupertinoColors.darkBackgroundGray
                                    .withOpacity(0.8),
                                // color: CupertinoColors.systemRed,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.5),
                                child: Text(i.toStringAsFixed(2),
                                    style: TextStyle(fontSize: 13)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     children: [
                  //       for (int i = 0; i < 10; ++i)
                  //         Container(
                  //           width: 5,
                  //           height: i * 10,
                  //           color: kRedColor,
                  //         ),
                  //     ],
                  //   ),
                  // )
                ],
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8, left: 12, right: 12),
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
          // play with colors
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
            padding: EdgeInsets.only(top: 4),
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
