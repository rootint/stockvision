import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/providers/server/prediction_provider.dart';
import 'package:stockadvisor/providers/server/watchlist_provider.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:stockadvisor/screens/search/cupertino/main_screen.dart';
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
    // final MediaQueryData mediaQuery = MediaQuery.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        brightness: themeProvider.isDarkModeEnabled
            ? Brightness.dark
            : Brightness.light,
        backgroundColor: themeProvider.isDarkModeEnabled
            ? kCupertinoDarkNavColor.withOpacity(0.7)
            : kCupertinoLightNavColor.withOpacity(0.7),
        middle: const Text("Dashboard"),
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
                    child: const CupertinoHoldingsCard(),
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
                  ticker: watchlist[index],
                  key: Key(watchlist[index]),
                ),
              );
            }
          },
          itemCount: watchlist.length,
          // itemCount: 3,
        ),
      ),
    );
  }
}
