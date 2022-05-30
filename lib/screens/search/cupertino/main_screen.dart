import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/helpers/yahoo.dart';
import 'package:stockadvisor/models/yahoo_models/search_data.dart';
import 'package:stockadvisor/models/yahoo_models/search_item.dart';
import 'package:stockadvisor/providers/server/watchlist_provider.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/main_screen.dart';

class CupertinoSearchMainScreen extends StatefulWidget {
  static const routeName = "/search";
  const CupertinoSearchMainScreen({Key? key}) : super(key: key);

  @override
  State<CupertinoSearchMainScreen> createState() =>
      _CupertinoSearchMainScreenState();
}

class _CupertinoSearchMainScreenState extends State<CupertinoSearchMainScreen> {
  YahooHelperSearchData? _displayData;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, bool>;
    bool isAccessedFromHoldings = routeArgs['holdings']!;
    final watchlistProvider = Provider.of<WatchlistProvider>(context);
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: CupertinoSearchTextField(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      placeholder: 'Search ticker...',
                      controller: textController,
                      onChanged: (q) async {
                        if (textController.text.isNotEmpty) {
                          var data = await YahooHelper.getSearchData(query: q);
                          setState(() {
                            _displayData = data;
                          });
                        } else {
                          setState(() {
                            _displayData = null;
                          });
                        }
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
              if (_displayData != null)
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      print("here?");
                      var key = _displayData!.searchResult.keys.toList()[index];
                      var item = _displayData!.searchResult[key]!;
                      return GestureDetector(
                        onTap: () {
                          print(isAccessedFromHoldings);
                          if (isAccessedFromHoldings) {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(
                              CupertinoStockOverviewMainScreen.routeName,
                              arguments: {
                                'ticker': key,
                              },
                            );
                          } else {
                            if (!watchlistProvider.containsInWatchlist(
                                ticker: key)) {
                              watchlistProvider.addTickerToWatchlist(
                                  ticker: key);
                            }
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          color: CupertinoColors.black.withAlpha(0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        key.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(item.longName),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item.exchangeName),
                                      Text(item.type),
                                    ],
                                  ),
                                ),
                              ],
                              // children: [
                              //   Text(key.toUpperCase()),
                              //   Text(item.exchangeName),
                              //   Text(item.longName),
                              //   Text(item.type),
                              // ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: (_displayData == null)
                        ? 0
                        : (_displayData!.searchResult.length > 10
                            ? 5
                            : _displayData!.searchResult.length),
                  ),
                )
              else
                Container(),
              // CupertinoButton(
              //   child: const Text('search APPL'),
              //   onPressed: () {
              //     YahooHelper.getSearchData(query: 'AAPL');
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
