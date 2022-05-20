import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/server_models/holdings.dart';
import 'package:stockadvisor/models/server_models/holdings_ticker.dart';
import 'package:stockadvisor/models/yahoo_models/chart_data.dart';
import 'package:stockadvisor/painters/performance_painter.dart';
import 'package:stockadvisor/providers/data_provider.dart';
import 'package:stockadvisor/providers/server/holdings_provider.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:stockadvisor/screens/holdings/cupertino/alltime_provider.dart';
import 'package:stockadvisor/widgets/cupertino/holdings_ticker_card.dart';

class CupertinoHoldingsMainScreen extends StatefulWidget {
  static const routeName = '/holdings';
  const CupertinoHoldingsMainScreen({Key? key}) : super(key: key);

  @override
  State<CupertinoHoldingsMainScreen> createState() =>
      _CupertinoHoldingsMainScreenState();
}

class _CupertinoHoldingsMainScreenState
    extends State<CupertinoHoldingsMainScreen> {
  final scrollController = ScrollController();
  bool isNavbarDisplayed = false;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  String getDeltaString(Holdings holdings, bool isAllTime) {
    if (isAllTime) {
      String arrow = (holdings.deltaAlltime > 0) ? '↑' : '↓';
      return '$arrow${holdings.deltaAlltime.abs().toStringAsFixed(2)} ' +
          '($arrow${holdings.deltaAlltimePercent.abs().toStringAsFixed(2)}%)';
    }
    String arrow = (holdings.deltaToday > 0) ? '↑' : '↓';
    return '$arrow${holdings.deltaToday.abs().toStringAsFixed(2)} ' +
        '($arrow${holdings.deltaTodayPercent.abs().toStringAsFixed(2)}%)';
  }

  Color getDeltaColor(Holdings holdings, bool isAllTime) {
    if (isAllTime) {
      return (holdings.deltaAlltime >= 0) ? kGreenColor : kRedColor;
    }
    return (holdings.deltaToday >= 0) ? kGreenColor : kRedColor;
  }

  @override
  Widget build(BuildContext context) {
    final darkModeEnabled =
        Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    var holdings = Provider.of<HoldingsProvider>(context).holdings;
    final allTimeSwitchProvider = Provider.of<AllTimeProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);
    final mediaQuery = MediaQuery.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Holdings'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child:
              const Icon(CupertinoIcons.search, color: CupertinoColors.white),
          onPressed: () {},
        ),
      ),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            if (scrollController.position.pixels > 170) {
              setState(() {
                isNavbarDisplayed = true;
              });
            } else if (isNavbarDisplayed == true) {
              setState(() {
                isNavbarDisplayed = false;
              });
            }
          }
          return false;
        },
        child: ListView.builder(
          controller: scrollController,
          itemBuilder: ((context, index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: CupertinoColors.darkBackgroundGray,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your holdings:',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: holdings.currentWorth
                                        .toStringAsFixed(0),
                                    style: TextStyle(
                                      color: darkModeEnabled
                                          ? CupertinoColors.white
                                          : CupertinoColors.darkBackgroundGray,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 33,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '.${holdings.currentWorth.toStringAsFixed(2).split('.')[1].substring(0, 2)}\$',
                                        // text: '.00\$',
                                        style: TextStyle(
                                          color: CupertinoColors.systemGrey2,
                                          fontSize: 33,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kCupertinoDarkNavColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 7.0),
                                  child: RichText(
                                    text: TextSpan(
                                      text: getDeltaString(
                                          holdings,
                                          allTimeSwitchProvider
                                              .isSwitchEnabled),
                                      style: TextStyle(
                                          color: getDeltaColor(
                                              holdings,
                                              allTimeSwitchProvider
                                                  .isSwitchEnabled)
                                          // fontWeight: FontWeight.w600,
                                          // fontSize: 33,
                                          ),
                                      children: [
                                        TextSpan(
                                          text: allTimeSwitchProvider
                                                  .isSwitchEnabled
                                              ? ' for all time'
                                              : ' for today',
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            // fontSize: 33,
                                            // fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              onPressed: () =>
                                  allTimeSwitchProvider.onAllTimeSwitch(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.fromLTRB(10, 0, 12, 10),
                  //   child: Text(
                  //     "Performance",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.w600,
                  //       fontSize: 21,
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: Container(
                  //     height: 230,
                  //     decoration: BoxDecoration(
                  //       color: CupertinoColors.darkBackgroundGray,
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: Stack(
                  //       children: [
                  //         Positioned(
                  //           top: 0,
                  //           child: FutureBuilder<YahooHelperChartData>(
                  //             initialData: YahooHelperChartData(
                  //               timestamp: [],
                  //               open: [],
                  //               close: [],
                  //               high: [],
                  //               low: [],
                  //               volume: [],
                  //               percentage: 0,
                  //               previousClose: 0,
                  //               periodHigh: 0,
                  //               periodLow: 0,
                  //               timestampEnd: 0,
                  //               timestampStart: 0,
                  //               lastClosePrice: 0,
                  //             ),
                  //             future: YahooHelper.getChartData({
                  //               'ticker': "^gspc",
                  //               "range": TickerRange.oneYear,
                  //               "interval": TickerInterval.oneDay,
                  //             }),
                  //             builder: ((context, snapshot) {
                  //               var data = snapshot.data!;
                  //               return CustomPaint(
                  //                 painter: PerformancePainter(
                  //                   containerSize:
                  //                       Size(mediaQuery.size.width - 20, 220),
                  //                   leftPadding: -10,
                  //                   sAndPData: data,
                  //                   tickerData: data,
                  //                 ),
                  //               );
                  //             }),
                  //           ),
                  //         ),
                  //         Positioned(
                  //           top: 8,
                  //           left: 8,
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               color: CupertinoColors.black.withOpacity(0.3),
                  //               borderRadius: BorderRadius.circular(12),
                  //             ),
                  //             child: Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 10.0, vertical: 6.0),
                  //               child: Column(
                  //                 crossAxisAlignment:
                  //                     CrossAxisAlignment.start,
                  //                 children: [
                  //                   Row(
                  //                     children: [
                  //                       Container(
                  //                         height: 14,
                  //                         width: 2,
                  //                         decoration: BoxDecoration(
                  //                           color: kGreenColor,
                  //                           borderRadius:
                  //                               BorderRadius.circular(10),
                  //                         ),
                  //                       ),
                  //                       Text('  Portfolio'),
                  //                     ],
                  //                   ),
                  //                   SizedBox(
                  //                     height: 2,
                  //                   ),
                  //                   Row(
                  //                     children: [
                  //                       Container(
                  //                         height: 14,
                  //                         width: 2,
                  //                         decoration: BoxDecoration(
                  //                           color: kPrimaryColor,
                  //                           borderRadius:
                  //                               BorderRadius.circular(10),
                  //                         ),
                  //                       ),
                  //                       Text('  S&P 500'),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 12, 10),
                    child: Text(
                      "Stocks",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return CupertinoTickerHoldingsCard(
                ticker: (holdings.tickerList[index - 1]),
                key: Key(holdings.tickerList[index - 1].toString()),
              );
            }
          }),
          itemCount: holdings.tickerList.length + 1,
        ),
      ),
    );
  }
}
