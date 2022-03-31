import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/server_models/holdings_ticker.dart';
import 'package:stockadvisor/models/yahoo_models/chart_data.dart';
import 'package:stockadvisor/painters/performance_painter.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
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
  final list = [
    'top',
    // HoldingsTicker(ticker: 'aapl', amount: 3, avgShareCost: 167.31),
    // HoldingsTicker(ticker: 'amd', amount: 2, avgShareCost: 146.09),
    // HoldingsTicker(ticker: 'nvda', amount: 1, avgShareCost: 225.48),
    // HoldingsTicker(ticker: 'msft', amount: 1, avgShareCost: 300.94),
    // HoldingsTicker(ticker: 'intc', amount: 1, avgShareCost: 52.25),
  ];
  @override
  Widget build(BuildContext context) {
    final darkModeEnabled =
        Provider.of<ThemeProvider>(context).isDarkModeEnabled;
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
      child: CupertinoScrollbar(
        child: ListView.builder(
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
                      // height: 175,
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
                                    text: '1350',
                                    style: TextStyle(
                                      color: darkModeEnabled
                                          ? CupertinoColors.white
                                          : CupertinoColors.darkBackgroundGray,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 33,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '.01\$',
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
                                // CupertinoButton(
                                //   padding: EdgeInsets.zero,
                                //   onPressed: () {},
                                //   child: Icon(
                                //     CupertinoIcons.eye_fill,
                                //     color: CupertinoColors.systemGrey3,
                                //   ),
                                // ),
                              ],
                            ),
                            // const SizedBox(
                            //   height: -5,
                            // ),
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
                                  // child: Row(
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.center,
                                  //   children: [
                                  //     Text(
                                  //       '+24.96 (4.31%)',
                                  //       style: TextStyle(color: kGreenColor),
                                  //     ),
                                  //     Text(' today'),
                                  //   ],
                                  // ),
                                  child: RichText(
                                    text: TextSpan(
                                      text: '+50.91 (+1.85%)',
                                      style: TextStyle(color: kGreenColor
                                          // fontWeight: FontWeight.w600,
                                          // fontSize: 33,
                                          ),
                                      children: [
                                        TextSpan(
                                          text: ' for today',
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
                              onPressed: () {},
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Today:',
                            //       style: TextStyle(
                            //         fontSize: 15,
                            //       ),
                            //     ),
                            //     Text(
                            //       '+10.01 (+4.52%)',
                            //       textAlign: TextAlign.end,
                            //       style: TextStyle(
                            //         color: kGreenColor,
                            //         fontSize: 15,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(
                            //   height: 5,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'All time:',
                            //       style: TextStyle(
                            //         fontSize: 15,
                            //       ),
                            //     ),
                            //     Text(
                            //       '-15.01 (-6.59%)',
                            //       textAlign: TextAlign.end,
                            //       style: TextStyle(
                            //         color: kRedColor,
                            //         fontSize: 15,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 12, 10),
                    child: Text(
                      "Performance",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 21,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 230,
                      decoration: BoxDecoration(
                        color: CupertinoColors.darkBackgroundGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            child: FutureBuilder<YahooHelperChartData>(
                              initialData: YahooHelperChartData(
                                timestamp: [],
                                open: [],
                                close: [],
                                high: [],
                                low: [],
                                volume: [],
                                percentage: 0,
                                previousClose: 0,
                                periodHigh: 0,
                                periodLow: 0,
                                timestampEnd: 0,
                                timestampStart: 0,
                                lastClosePrice: 0,
                              ),
                              future: YahooHelper.getChartData({
                                'ticker': "^gspc",
                                "range": TickerRange.oneYear,
                                "interval": TickerInterval.oneDay,
                              }),
                              builder: ((context, snapshot) {
                                var data = snapshot.data!;
                                return CustomPaint(
                                  painter: PerformancePainter(
                                    containerSize: Size(mediaQuery.size.width - 20, 220),
                                    leftPadding: -10,
                                    sAndPData: data,
                                    tickerData: data,
                                  ),
                                );
                              }),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: CupertinoColors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 14,
                                          width: 2,
                                          decoration: BoxDecoration(
                                            color: kGreenColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        Text('  Portfolio'),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 14,
                                          width: 2,
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        Text('  S&P 500'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                  ticker: (list[index] as HoldingsTicker), key: Key(list[index].toString()));
            }
          }),
          itemCount: list.length,
        ),
      ),
    );
  }
}
