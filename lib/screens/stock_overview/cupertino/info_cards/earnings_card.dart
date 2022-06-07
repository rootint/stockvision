import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/yahoo_models/info_data.dart';
import 'package:stockadvisor/painters/earnings_painter.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_card.dart';

class CupertinoInfoEarningsCard extends StatelessWidget {
  final YahooHelperInfoData tickerInfo;
  final MediaQueryData mediaQuery;
  const CupertinoInfoEarningsCard(this.tickerInfo, this.mediaQuery, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return Flexible(
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
                          const SizedBox(height: 5),
                          Text(
                            item["quarter"].toString(),
                            style: const TextStyle(fontSize: 11),
                          ),
                          Text(
                            item["year"].toString(),
                            style: const TextStyle(fontSize: 11),
                          ),
                          const SizedBox(height: 2),
                          (item["actual"] - item["estimate"] > 0)
                              ? Text(
                                  '+' +
                                      ((item["actual"] - item["estimate"]))
                                          .toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: kGreenColor,
                                  ),
                                )
                              : Text(
                                  ((item["actual"] - item["estimate"]))
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: (item["actual"] == item["estimate"])
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
                        const SizedBox(height: 5),
                        Text(
                          'Q' + tickerInfo.currentEarningsQuarter[0],
                          style: const TextStyle(fontSize: 11),
                        ),
                        Text(
                          tickerInfo.currentEarningsYear.toString(),
                          style: const TextStyle(fontSize: 11),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          (tickerInfo.currentEarningsTimestamp == 0)
                              ? '-'
                              : DateFormat('d MMM').format(
                                  DateTime.fromMillisecondsSinceEpoch(1000 *
                                      tickerInfo.currentEarningsTimestamp)),
                          style: const TextStyle(
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
    );
  }
}
