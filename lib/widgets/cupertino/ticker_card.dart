import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/models/yahoo_models/socket_data.dart';
import 'package:stockadvisor/providers/data_provider.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/main_screen.dart';
import 'package:stockadvisor/protobuf/message.pb.dart';

class CupertinoTickerCard extends StatefulWidget {
  final String ticker;
  bool init = false;

  CupertinoTickerCard({
    required this.ticker,
    required Key? key,
  }) : super(key: key);

  @override
  State<CupertinoTickerCard> createState() => _CupertinoTickerCardState();
}

class _CupertinoTickerCardState extends State<CupertinoTickerCard> {
  YahooHelperSocketData cache = YahooHelperSocketData();
  // void _initTicker(DataProvider provider, YahooHelperPriceData data) async {
  //   print('init ${widget.ticker}');
  //   provider.initTickerData(ticker: widget.ticker);
  //   widget.init = true;
  //   provider.subscribeToWebsocket(widget.ticker);
  //   priceCache = data.currentMarketPrice;
  //   cache.percentage = data.currentPercentage;
  //   cache.marketHours = data.marketState + '_MARKET';
  //   print(priceCache);
  // }

  @override
  void deactivate() {
    var provider = Provider.of<DataProvider>(context, listen: false);
    // provider.removeTickerPriceStream(ticker: widget.ticker);
    provider.unsubscribeFromWebsocket(widget.ticker);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final provider = Provider.of<DataProvider>(context);

    if (!widget.init) {
      print('init ${widget.ticker}');
      provider.initTickerData(ticker: widget.ticker);
      widget.init = true;
      provider.subscribeToWebsocket(widget.ticker);
      // priceCache = data.currentMarketPrice;
      // cache.percentage = data.currentPercentage;
      // cache.marketHours = data.marketState + '_MARKET';

      // print(priceCache);
    }
    var tickerData = provider.getTickerData(ticker: widget.ticker);
    final darkModeEnabled =
        Provider.of<ThemeProvider>(context).isDarkModeEnabled;

    return FutureBuilder(
      future: provider.initTickerData(ticker: widget.ticker),
      builder: (context, futureData) => StreamBuilder(
        stream: provider.channelController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var socketData =
                yaticker.fromBuffer(base64.decode(snapshot.data.toString()));
            if (socketData.id == widget.ticker.toUpperCase()) {
              setState(() {
                cache.percentage = socketData.changePercent;
                cache.delta = socketData.change;
                cache.price = socketData.price;
                cache.marketHours = socketData.marketHours.toString();
              });
            }
          } else if (futureData.connectionState == ConnectionState.done) {
            var priceData = provider.getPriceData(ticker: widget.ticker);
            cache.percentage = priceData.currentPercentage;
            cache.delta = priceData.currentDelta;
            cache.price = priceData.currentMarketPrice;
            cache.marketHours = priceData.marketState;
          }
          return Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushNamed(
                  CupertinoStockOverviewMainScreen.routeName,
                  arguments: {
                    'ticker': widget.ticker,
                  },
                );
              },
              child: Container(
                height: 70,
                width: mediaQuery.size.width,
                color: CupertinoColors.activeBlue.withAlpha(0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SvgPicture.string(
                          tickerData.iconSvg,
                          height: 47,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.ticker.toUpperCase() + ' ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                                if (cache.marketHours.toString() ==
                                    "PRE_MARKET")
                                  const Text("Pre",
                                      style: TextStyle(
                                          color: CupertinoColors.inactiveGray))
                                else if (cache.marketHours.toString() ==
                                    "POST_MARKET")
                                  const Text("Post",
                                      style: TextStyle(
                                          color: CupertinoColors.inactiveGray))
                                else if (cache.marketHours.toString() ==
                                    "REGULAR_MARKET")
                                  Container()
                                else
                                  const Text("Closed",
                                      style: TextStyle(
                                          color: CupertinoColors.inactiveGray))
                              ],
                            ),
                            Text(
                              tickerData.companyLongName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: CupertinoColors.systemGrey2,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: cache.price.toStringAsFixed(2),
                                style: TextStyle(
                                  color: darkModeEnabled
                                      ? CupertinoColors.white
                                      : CupertinoColors.darkBackgroundGray,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: tickerData.currency,
                                    style: const TextStyle(
                                      color: CupertinoColors.systemGrey2,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              ((cache.percentage >= 0) ? '↑' : '↓') +
                                  cache.percentage.abs().toStringAsFixed(2) +
                                  '%',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: (cache.percentage == 0.0 ||
                                          cache.marketHours.toString() !=
                                              "REGULAR_MARKET")
                                      ? CupertinoColors.inactiveGray
                                      : (cache.percentage > 0)
                                          ? kGreenColor
                                          : kRedColor),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TickerCard extends StatelessWidget {
  const TickerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
