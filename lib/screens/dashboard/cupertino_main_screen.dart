import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/helpers/ticker_streams.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/providers/cache_provider.dart';
import 'package:stockadvisor/providers/chart_provider.dart';
import 'package:stockadvisor/providers/data_provider.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/main_screen.dart';
import 'package:stockadvisor/widgets/cupertino/dashboard_graph_card.dart';
import 'package:stockadvisor/widgets/cupertino/holdings_card.dart';
import 'package:stockadvisor/widgets/cupertino/ticker_card.dart';

class CupertinoDashboardMainScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  const CupertinoDashboardMainScreen({Key? key}) : super(key: key);

  @override
  CupertinoDashboardMainScreenState createState() =>
      CupertinoDashboardMainScreenState();
}

class CupertinoDashboardMainScreenState
    extends State<CupertinoDashboardMainScreen> with TickerProviderStateMixin {
  static const _tickerList = [
    'topData',
    'aapl',
    'amd',
    'nvda',
    'bmw.de',
    'pltr',
    'yndx.me',
    'goog',
    'amzn',
    'sber.me',
    'brk-a',
    'pton',
    'brk-b',
    'msft',
    'baba',
    'xom',
    'lmt',
    'intc',
    'mu',
    'amat',
    'qcom',
    'atvi',
    'crm',
    'ea',
    'tsla',
    'fb',
    'rub=x'
  ];
  final List<double> _tickerLastPrices =
      List<double>.filled(_tickerList.length, 0);
  final List<bool> _lastTickerColors =
      List<bool>.filled(_tickerList.length, false);

  final double mainCardHeight = 300;

  void _lastPriceCallback(int index, double lastPrice, bool isLastColorGreen) {
    _tickerLastPrices[index] = lastPrice;
    _lastTickerColors[index] = isLastColorGreen;
  }

  @override
  Widget build(BuildContext context) {
    final userName = "Danil";
    // cacheProvider = CacheProvider();
    final provider = Provider.of<ThemeProvider>(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final mainCardScrollingController = PageController(
      initialPage: 0,
    );

    return ChangeNotifierProvider(
      create: (_) => CacheProvider(),
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            brightness:
                provider.isDarkModeEnabled ? Brightness.dark : Brightness.light,
            backgroundColor: provider.isDarkModeEnabled
                ? kCupertinoDarkNavColor.withOpacity(0.7)
                : kCupertinoLightNavColor.withOpacity(0.7),
            leading: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: kPrimaryColor,
                  radius: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text(
                          userName,
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                        const Icon(
                          CupertinoIcons.right_chevron,
                          size: 20,
                          color: CupertinoColors.systemGrey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.gear_alt_fill,
                  color: CupertinoColors.systemGrey5),
              onPressed: () {},
            ),
          ),
          child: CupertinoScrollbar(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 300,
                        color: kCupertinoDarkNavColor.withOpacity(0.7),
                        child: PageView(
                          controller: mainCardScrollingController,
                          scrollDirection: Axis.horizontal,
                          children: [
                            CupertinoDashboardGraphCard(height: mainCardHeight),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CupertinoHoldingsCard(height: mainCardHeight),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                        child: Text(
                          "Maintained stocks",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                    ],
                  );
                } else {
                  return CupertinoTickerCard(ticker: _tickerList[index], key: Key(_tickerList[index]));
                }
              },
              itemCount: _tickerList.length,
            ),
          )
          // child: CupertinoScrollbar(
          //   child: ListView(
          //     children: [
          //       Container(
          //         height: 300,
          //         color: kCupertinoDarkNavColor.withOpacity(0.7),
          //         child: PageView(
          //           controller: mainCardScrollingController,
          //           scrollDirection: Axis.horizontal,
          //           children: [
          //             CupertinoDashboardGraphCard(height: mainCardHeight),
          //             Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 CupertinoHoldingsCard(height: mainCardHeight),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //       const Padding(
          //         padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
          //         child: Text(
          //           "Maintained stocks",
          //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          //         ),
          //       ),
          //       Expanded(
          //         child: ListView.builder(
          //           itemBuilder: ((context, index) {
          //             var ticker = _tickerList[index];
          //             bool init = false;
          //             return Consumer<DataProvider>(
          //               builder: (ctx, provider, _) {
          //                 if (!init) {
          //                   provider.initTickerData(ticker: ticker);
          //                   init = true;
          //                 }
          //                 YahooHelperPriceData data =
          //                     provider.getPriceData(ticker: ticker);
          //                 return Padding(
          //                   padding: const EdgeInsets.symmetric(horizontal: 15),
          //                   child: GestureDetector(
          //                     onTap: () {
          //                       Navigator.of(context, rootNavigator: true)
          //                           .pushNamed(
          //                         CupertinoStockOverviewMainScreen.routeName,
          //                         arguments: {
          //                           'ticker': ticker,
          //                           // 'priceStream': priceStream,
          //                           'data': data,
          //                           // 'imageSvg': null,
          //                         },
          //                       );
          //                     },
          //                     child: CupertinoTickerCard(
          //                       ticker: ticker,
          //                       lastPrice: 0,
          //                       lastPriceFunc: _lastPriceCallback,
          //                       isLastColorGreen: false,
          //                       index: 0,
          //                       // priceStream: price,
          //                       data: data,
          //                       key: Key(ticker),
          //                     ),
          //                   ),
          //                 );
          //               },
          //             );
          //           }),
          //           itemCount: _tickerList.length,
          //         ),
          //       ),
          //       // ..._tickerList.map(
          //       //   (ticker) {
          //       //     bool init = false;
          //       //     return Consumer<DataProvider>(
          //       //       builder: (ctx, provider, _) {
          //       //         if (!init) {
          //       //           provider.initTickerData(ticker: ticker);
          //       //           init = true;
          //       //         }
          //       //         YahooHelperPriceData data = provider.getPriceData(ticker: ticker);
          //       //         return Padding(
          //       //           padding: const EdgeInsets.symmetric(horizontal: 15),
          //       //           child: GestureDetector(
          //       //             onTap: () {
          //       //               Navigator.of(context, rootNavigator: true)
          //       //                   .pushNamed(
          //       //                 CupertinoStockOverviewMainScreen.routeName,
          //       //                 arguments: {
          //       //                   'ticker': ticker,
          //       //                   // 'priceStream': priceStream,
          //       //                   'data': data,
          //       //                   // 'imageSvg': null,
          //       //                 },
          //       //               );
          //       //             },
          //       //             child: CupertinoTickerCard(
          //       //               ticker: ticker,
          //       //               lastPrice: 0,
          //       //               lastPriceFunc: _lastPriceCallback,
          //       //               isLastColorGreen: false,
          //       //               index: 0,
          //       //               // priceStream: price,
          //       //               data: data,
          //       //               key: Key(ticker),
          //       //             ),
          //       //           ),
          //       //         );
          //       //       },
          //       //     );
          //       //   },
          //       // ),
          //     ],
          //   ),
          // ),
          // child: ListView(
          //   children: [
          //     ...tickerList
          //         .map((ticker) => CupertinoTickerCard(ticker, key: Key(ticker)))
          //   ],
          // ),
          // child: ListView.builder(
          //   itemBuilder: (ctx, index) {
          //     return CupertinoTickerCard(
          //       ticker: _tickerList[index],
          //       lastPrice: _getTickerLastPrice(index)[0],
          //       lastPriceFunc: _lastPriceCallback,
          //       isLastColorGreen: _getTickerLastPrice(index)[1],
          //       index: index,
          //       key: Key(_tickerList[index]),
          //     );
          //   },
          //   itemCount: _tickerList.length,
          // ),

          // wtf why it has the same performance as listview.builder???
          // child: Stack(
          //   children: [
          //     // SafeArea(child: CupertinoDashboardGraphCard()),
          //     ListView(
          //       children: [
          //         Column(
          //           children: [
          //             Container(height: 300),
          //             Container(
          //               color: CupertinoColors.darkBackgroundGray,
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
          //                     child: Text(
          //                       "Maintained stocks",
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.bold, fontSize: 25),
          //                     ),
          //                   ),
          //                   ..._tickerList.map(
          //                     (ticker) => Padding(
          //                       padding: const EdgeInsets.symmetric(horizontal: 15),
          //                       child: CupertinoTickerCard(
          //                         ticker: ticker,
          //                         lastPrice: 0,
          //                         lastPriceFunc: _lastPriceCallback,
          //                         isLastColorGreen: false,
          //                         index: 0,
          //                         key: Key(ticker),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             // const DashboardIndexTitleCard(),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          ),
    );
  }
}
