import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/server_models/prediction_ticker.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/painters/analytics_painter.dart';
import 'package:stockadvisor/painters/earnings_painter.dart';
import 'package:stockadvisor/providers/yahoo/info_provider.dart';
import 'package:stockadvisor/providers/yahoo/price_provider.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_card.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_cards/analytics_card.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_cards/daily_change_card.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_cards/dividends_card.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_cards/earnings_card.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_cards/holdings_add_card.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_cards/prediction_card.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_cards/year_change_card.dart';

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
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final tickerInfo = Provider.of<YahooInfoProvider>(context).getInfoData(widget.ticker);
    YahooHelperPriceData priceData =
        Provider.of<YahooPriceProvider>(context).getPriceData(widget.ticker);
    final Map<String, String> _infoMap = {
      "1 Year Target": tickerInfo.targetMedianPrice.toStringAsFixed(2),
      // market cap
      // p/e ratio
      // volumes
      // beta / eps
      // 52 week range?
    };

    

    return Column(
      children: [
        CupertinoInfoPredictionCard(widget.ticker, priceData),
        Row(
          children: [
            CupertinoInfoDailyChangeCard(widget.ticker, priceData),
            CupertinoInfoHoldingsAddCard(widget.ticker),
          ],
        ),
        Row(
          children: [
            CupertinoInfoAnalyticsCard(widget.ticker, mediaQuery, tickerInfo),
            CupertinoInfoDividendsCard(priceData),
          ],
        ),
        Row(
          children: [
            CupertinoInfoYearChangeCard(tickerInfo, priceData),
            CupertinoInfoEarningsCard(tickerInfo, mediaQuery),
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

// CupertinoInfoCard(
//   height: 200,
//   title: "PRICE RANGES",
//   titleIcon: CupertinoIcons.graph_square_fill,
//   rowPosition: RowPosition.left,
//   child: Padding(
//     padding: const EdgeInsets.symmetric(vertical: 5.0),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Day Range',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(top: 10.0, bottom: 4.0),
//                     child: Stack(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                               color: kGreenColor,
//                               borderRadius: BorderRadius.circular(10),
//                               gradient: const LinearGradient(
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.topRight,
//                                 colors: [
//                                   kRedColor,
//                                   kGreenColor,
//                                 ],
//                               )),
//                           width: double.infinity,
//                           height: 7,
//                         ),
//                         Positioned(
//                           left: (mediaQuery.size.width - 50 - 12) *
//                               dayPosition,
//                           top: -3.5,
//                           child: Container(
//                             width: 14,
//                             height: 14,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: CupertinoColors.white,
//                               border: Border.all(
//                                 color:
//                                     CupertinoColors.darkBackgroundGray,
//                                 width: 3.5,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(priceData.dayLow.toStringAsFixed(2)),
//                       Text(priceData.lastClosePrice.toStringAsFixed(2)),
//                       Text(priceData.dayHigh.toStringAsFixed(2)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Year Range',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(top: 10.0, bottom: 4.0),
//                     child: Stack(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                               color: kGreenColor,
//                               borderRadius: BorderRadius.circular(10),
//                               gradient: const LinearGradient(
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.topRight,
//                                 colors: [
//                                   kRedColor,
//                                   kGreenColor,
//                                 ],
//                               )),
//                           width: double.infinity,
//                           height: 7,
//                         ),
//                         Positioned(
//                           left: (mediaQuery.size.width - 50 - 12) *
//                               yearPosition,
//                           top: -3.5,
//                           child: Container(
//                             width: 14,
//                             height: 14,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: CupertinoColors.white,
//                               border: Border.all(
//                                 color:
//                                     CupertinoColors.darkBackgroundGray,
//                                 width: 3.5,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(priceData.fiftyTwoWeekLow.toStringAsFixed(2)),
//                       Text(priceData.lastClosePrice.toStringAsFixed(2)),
//                       Text(priceData.fiftyTwoWeekHigh.toStringAsFixed(2)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   ),
// ),

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
