// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:stockadvisor/constants.dart';
// import 'package:stockadvisor/helpers/ticker_streams.dart';
// import 'package:stockadvisor/models/yahoo_models/chart_data.dart';
// import 'package:stockadvisor/models/yahoo_models/price_data.dart';
// import 'package:stockadvisor/painters/graph_painter.dart';
// import 'package:stockadvisor/screens/stock_overview/constants.dart';

// class CupertinoStockOverviewGraphRow extends StatefulWidget {
//   final String ticker;
//   final YahooHelperPriceData priceData;
//   const CupertinoStockOverviewGraphRow({
//     required this.ticker,
//     required this.priceData,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<CupertinoStockOverviewGraphRow> createState() =>
//       _CupertinoStockOverviewGraphRowState();
// }

// class _CupertinoStockOverviewGraphRowState
//     extends State<CupertinoStockOverviewGraphRow>
//     with TickerProviderStateMixin {
//   String selectedTimeframe = "1D";
//   YahooHelperChartData? cachedChart;
//   bool showExtended = true;
//   bool areStreamsInitialized = false;

//   late StreamController<YahooHelperChartData> chartController;

//   bool showGraphAnimation = true;
//   late Animation<double> graphAnimation;
//   late AnimationController graphAnimationController;

//   void initAnimation() {
//     graphAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 900),
//       vsync: this,
//     );

//     Tween<double> _graphTween = Tween(begin: 0.0, end: 1.0);

//     graphAnimation = _graphTween.animate(CurvedAnimation(
//         parent: graphAnimationController, curve: Curves.easeInOutSine));
//   }

//   void changeTimeframe(String timeframe, String ticker) {
//     print(timeframe);
//     setState(() {
//       selectedTimeframe = timeframe;
//       chartController.close();
//       chartController = TickerStreams.chartStreamController(
//           ticker: ticker, range: rangeConversionMap[timeframe]!);
//       showExtended = (selectedTimeframe == '1D');
//       showGraphAnimation = true;
//       graphAnimationController.reset();
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     showGraphAnimation = true;
//     initAnimation();
//     graphAnimationController.reset();
//   }

//   @override
//   void dispose() {
//     graphAnimationController.dispose();
//     chartController.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     if (!areStreamsInitialized) {
//       chartController = TickerStreams.chartStreamController(
//           ticker: widget.ticker, range: rangeConversionMap[selectedTimeframe]!);
//       areStreamsInitialized = true;
//     }
//     return Column(
//       children: [
//         Container(
//           // check the animation with expanding container
//           // color: CupertinoColors.darkBackgroundGray,
//           width: mediaQuery.size.width,
//           height: 250,
//           child: StreamBuilder<YahooHelperChartData>(
//             initialData: cachedChart,
//             stream: chartController.stream.asBroadcastStream(),
//             builder: (context, chartSnapshot) {
//               if (chartSnapshot.data == null) {
//                 return CupertinoActivityIndicator();
//               }
//               final data = chartSnapshot.data!;
//               cachedChart = data;
//               final periodPercentage = data.percentage;
//               final periodPriceDelta =
//                   data.previousClose * (data.percentage / 100);
//               // if (showGraphAnimation &&
//                   // (chartSnapshot.connectionState != ConnectionState.waiting)) {
//                 graphAnimationController.forward();
//                 // showGraphAnimation = false;
//               // }
//               print('iter');
//               return AnimatedBuilder(
//                 animation: graphAnimation,
//                 builder: (context, _) {
//                   return SizedBox(
//                     width: graphAnimation.value * mediaQuery.size.width,
//                     child: CustomPaint(
//                       painter: GraphPainter(
//                         containerSize: Size(
//                             graphAnimation.value * mediaQuery.size.width,
//                             240),
//                         maxSize: Size(mediaQuery.size.width, 230),
//                         timeframe: selectedTimeframe,
//                         high: data.periodHigh,
//                         low: data.periodLow,
//                         points: data.close,
//                         timestampEnd: data.timestampEnd,
//                         timestampStart: data.timestampStart,
//                         currentTimestamp:
//                             DateTime.now().millisecondsSinceEpoch,
//                         lastClosePrice: data.lastClosePrice,
//                         previousClose: data.previousClose,
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//         Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 for (var i = 1; i <= 5; i++)
//                   Text(
//                     '$i AM',
//                     style:
//                         TextStyle(fontSize: 7 * mediaQuery.devicePixelRatio),
//                   ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: 3 * mediaQuery.devicePixelRatio),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ...availableTimeframes.map(
//                     (index) => TimeframeCard(
//                       widget.ticker,
//                       index,
//                       mediaQuery,
//                       index == selectedTimeframe,
//                       changeTimeframe,
//                       true,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class TimeframeCard extends StatelessWidget {
//   final String ticker;
//   final String text;
//   final MediaQueryData mediaQuery;
//   final Function(String, String) changeTimeframe;
//   final bool selected;
//   final bool isDarkMode;
//   const TimeframeCard(this.ticker, this.text, this.mediaQuery, this.selected,
//       this.changeTimeframe, this.isDarkMode,
//       {Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // final defaultPadding = 1.5;
//     return GestureDetector(
//       onTap: () {
//         if (!selected) {
//           changeTimeframe(text, ticker);
//         }
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         decoration: BoxDecoration(
//           // play with colors
//           color: selected ? kPrimaryColor : CupertinoColors.darkBackgroundGray,
//           borderRadius: BorderRadius.circular(20),
//           border: isDarkMode
//               ? null
//               : Border.all(color: CupertinoColors.systemGrey3),
//         ),
//         curve: Curves.easeIn,
//         child: SizedBox(
//           width: mediaQuery.size.width / 8,
//           height: 23,
//           child: Padding(
//             padding: EdgeInsets.only(top: 4),
//             child: Text(
//               text,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 color: selected
//                     ? CupertinoColors.white
//                     : isDarkMode
//                         ? CupertinoColors.systemGrey3
//                         : CupertinoColors.systemGrey4,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
