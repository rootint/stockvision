import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/main.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/providers/chart_provider.dart';
import 'package:stockadvisor/providers/data_provider.dart';
import 'package:stockadvisor/providers/server/holdings_provider.dart';
import 'package:stockadvisor/providers/server/prediction_provider.dart';
import 'package:stockadvisor/providers/server/watchlist_provider.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:stockadvisor/screens/search/cupertino/main_screen.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/main_screen.dart';
import 'package:stockadvisor/widgets/cupertino/dashboard_graph_card.dart';
import 'package:stockadvisor/widgets/cupertino/holdings_card.dart';
import 'package:stockadvisor/widgets/cupertino/prediction_ticker_card.dart';
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
  final double mainCardHeight = 200;

  @override
  Widget build(BuildContext context) {
    final userName = "Danil";
    final themeProvider = Provider.of<ThemeProvider>(context);
    final listProvider = Provider.of<WatchlistProvider>(context);
    final predictionProvider = Provider.of<PredictionProvider>(context);
    final watchlist = listProvider.watchlist;
    final predictionList = predictionProvider.predictions;
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final mainCardScrollingController = PageController(
      initialPage: 0,
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        brightness: themeProvider.isDarkModeEnabled
            ? Brightness.dark
            : Brightness.light,
        backgroundColor: themeProvider.isDarkModeEnabled
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
                    color: kBlackColor.withOpacity(0.9),
                    child: CupertinoHoldingsCard(height: mainCardHeight),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Text(
                      "Predicted stocks",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 21,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      for (var item in predictionList)
                        CupertinoTickerPredictionCard(
                          ticker: item,
                          key: Key('${item.ticker}_predict'),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your watchlist",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 21,
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Icon(
                            CupertinoIcons.add,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(
                              CupertinoSearchMainScreen.routeName,
                              arguments: {
                                'holdings': false,
                              }
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Dismissible(
                key: Key(watchlist[index]),
                background: Container(
                  color: CupertinoColors.systemRed,
                  alignment: Alignment.centerRight,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 14.0),
                    child: Icon(CupertinoIcons.trash_fill, color: CupertinoColors.white),
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  listProvider.removeTickerFromWatchlist(ticker: watchlist[index]);
                },
                child: CupertinoTickerCard(
                    ticker: watchlist[index], key: Key(watchlist[index])),
              );
            }
          },
          itemCount: watchlist.length,
        ),
      ),
    );
  }
}


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stockadvisor/constants.dart';
// import 'package:stockadvisor/helpers/yahoo.dart';
// import 'package:stockadvisor/main.dart';
// import 'package:stockadvisor/models/yahoo_models/price_data.dart';
// import 'package:stockadvisor/providers/chart_provider.dart';
// import 'package:stockadvisor/providers/data_provider.dart';
// import 'package:stockadvisor/providers/server/prediction_provider.dart';
// import 'package:stockadvisor/providers/server/watchlist_provider.dart';
// import 'package:stockadvisor/providers/theme_provider.dart';
// import 'package:stockadvisor/screens/stock_overview/cupertino/main_screen.dart';
// import 'package:stockadvisor/widgets/cupertino/dashboard_graph_card.dart';
// import 'package:stockadvisor/widgets/cupertino/holdings_card.dart';
// import 'package:stockadvisor/widgets/cupertino/prediction_ticker_card.dart';
// import 'package:stockadvisor/widgets/cupertino/ticker_card.dart';

// class CupertinoDashboardMainScreen extends StatefulWidget {
//   static const routeName = '/dashboard';
//   const CupertinoDashboardMainScreen({Key? key}) : super(key: key);

//   @override
//   CupertinoDashboardMainScreenState createState() =>
//       CupertinoDashboardMainScreenState();
// }

// class CupertinoDashboardMainScreenState
//     extends State<CupertinoDashboardMainScreen> with TickerProviderStateMixin {
//   static const _tickerList = [
//     'topData',
//     'aapl',
//     'amd',
//     'nvda',
//     'bmw.de',
//     'pltr',
//     'yndx.me',
//     'goog',
//     'amzn',
//     'sber.me',
//     'brk-a',
//     'pton',
//     'brk-b',
//     'msft',
//     'baba',
//     'xom',
//     'lmt',
//     'intc',
//     'mu',
//     'amat',
//     'qcom',
//     'atvi',
//     'crm',
//     'ea',
//     'tsla',
//     'fb',
//     'rub=x'
//   ];
//   final List<double> _tickerLastPrices =
//       List<double>.filled(_tickerList.length, 0);
//   final List<bool> _lastTickerColors =
//       List<bool>.filled(_tickerList.length, false);

//   final double mainCardHeight = 200;

//   void _lastPriceCallback(int index, double lastPrice, bool isLastColorGreen) {
//     _tickerLastPrices[index] = lastPrice;
//     _lastTickerColors[index] = isLastColorGreen;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userName = "Danil";
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final listProvider = Provider.of<WatchlistProvider>(context);
//     final predictionProvider = Provider.of<PredictionProvider>(context);
//     final watchlist = listProvider.watchlist;
//     final predictionList = predictionProvider.predictions;
//     final MediaQueryData mediaQuery = MediaQuery.of(context);
//     final mainCardScrollingController = PageController(
//       initialPage: 0,
//     );

//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//         brightness: themeProvider.isDarkModeEnabled
//             ? Brightness.dark
//             : Brightness.light,
//         backgroundColor: themeProvider.isDarkModeEnabled
//             ? kCupertinoDarkNavColor.withOpacity(0.7)
//             : kCupertinoLightNavColor.withOpacity(0.7),
//         leading: Row(
//           children: [
//             const CircleAvatar(
//               backgroundColor: kPrimaryColor,
//               radius: 15,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: CupertinoButton(
//                 padding: EdgeInsets.zero,
//                 onPressed: () {},
//                 child: Row(
//                   children: [
//                     Text(
//                       userName,
//                       style: TextStyle(color: CupertinoColors.white),
//                     ),
//                     const Icon(
//                       CupertinoIcons.right_chevron,
//                       size: 20,
//                       color: CupertinoColors.systemGrey,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         trailing: CupertinoButton(
//           padding: EdgeInsets.zero,
//           child: const Icon(CupertinoIcons.gear_alt_fill,
//               color: CupertinoColors.systemGrey5),
//           onPressed: () {},
//         ),
//       ),
//       child: CupertinoScrollbar(
//         child: ListView.builder(
//           itemBuilder: (context, index) {
//             if (index == 0) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 250,
//                     color: kBlackColor.withOpacity(0.9),
//                     child: PageView(
//                       controller: mainCardScrollingController,
//                       scrollDirection: Axis.horizontal,
//                       children: [
//                         CupertinoDashboardGraphCard(height: mainCardHeight),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CupertinoHoldingsCard(height: mainCardHeight),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
//                     child: Text(
//                       "Predicted stocks",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 21,
//                       ),
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       CupertinoTickerPredictionCard(
//                         ticker: 'aapl',
//                         key: Key('aapl_prediction'),
//                       ),
//                       CupertinoTickerPredictionCard(
//                         ticker: 'goog',
//                         key: Key('amd_prediction'),
//                       ),
//                       CupertinoTickerPredictionCard(
//                         ticker: 'tsla',
//                         key: Key('tsla_prediction'),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Your watchlist",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 21,
//                           ),
//                         ),
//                         CupertinoButton(
//                           padding: EdgeInsets.zero,
//                           child: const Icon(
//                             CupertinoIcons.add,
//                             color: kPrimaryColor,
//                           ),
//                           onPressed: () {},
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               return CupertinoTickerCard(
//                   ticker: _tickerList[index], key: Key(_tickerList[index]));
//             }
//           },
//           itemCount: _tickerList.length,
//         ),
//       ),
//     );
//   }
// }
