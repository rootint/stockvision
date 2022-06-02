import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final listProvider = Provider.of<WatchlistProvider>(context);
    final predictionProvider = Provider.of<PredictionProvider>(context);
    final watchlist = listProvider.watchlist;
    final predictionList = predictionProvider.predictions;
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        brightness: themeProvider.isDarkModeEnabled
            ? Brightness.dark
            : Brightness.light,
        backgroundColor: themeProvider.isDarkModeEnabled
            ? kCupertinoDarkNavColor.withOpacity(0.7)
            : kCupertinoLightNavColor.withOpacity(0.7),
        middle: const Text("Dashboard"),
        // trailing: CupertinoButton(
        //   padding: EdgeInsets.zero,
        //   child: const Icon(CupertinoIcons.gear_alt_fill,
        //       color: CupertinoColors.systemGrey5),
        //   onPressed: () {},
        // ),
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
                    child: CupertinoHoldingsCard(),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 8),
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
                    padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
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
                              },
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
                    child: Icon(CupertinoIcons.trash_fill,
                        color: CupertinoColors.white),
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  listProvider.removeTickerFromWatchlist(
                      ticker: watchlist[index]);
                },
                child: CupertinoTickerCard(
                    ticker: watchlist[index], key: Key(watchlist[index])),
              );
              // return Slidable(
              //   key: Key(watchlist[index]),

              //   endActionPane: ActionPane(
              //     motion: const ScrollMotion(),
              //     dismissible: DismissiblePane(onDismissed: () => ,),
              //     children: [
              //       SlidableAction(
              //         onPressed: (_) => listProvider.removeTickerFromWatchlist(
              //             ticker: watchlist[index]),
              //         backgroundColor: CupertinoColors.systemRed,
              //         foregroundColor: CupertinoColors.white,
              //         icon: CupertinoIcons.trash_fill,
              //       ),
              //     ],
              //   ),
              //   child: CupertinoTickerCard(
              //       ticker: watchlist[index], key: Key(watchlist[index])),
              // );
            }
          },
          itemCount: watchlist.length,
        ),
      ),
    );
  }
}
