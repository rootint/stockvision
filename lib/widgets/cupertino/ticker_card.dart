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

  @override
  void deactivate() {
    var provider = Provider.of<DataProvider>(context, listen: false);
    provider.unsubscribeFromWebsocket(widget.ticker);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DataProvider>(context);
    YahooHelperPriceData priceData =
        provider.getPriceData(ticker: widget.ticker);
    bool isWSAvailable = false;

    if (!widget.init) {
      provider.initTickerData(ticker: widget.ticker);
      widget.init = true;
      provider.subscribeToWebsocket(widget.ticker);
    }

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
                cache.currentPercentage = socketData.changePercent;
                cache.currentDelta = socketData.change;
                cache.currentMarketPrice = socketData.price;
                cache.marketHours = socketData.marketHours.toString();
                isWSAvailable = true;
              });
            }
          } else if (futureData.connectionState == ConnectionState.done) {
            priceData = provider.getPriceData(ticker: widget.ticker);
            cache.lastPercentage = priceData.lastPercentage;
            cache.lastCloseDelta = priceData.lastCloseDelta;
            cache.lastClosePrice = priceData.lastClosePrice;
            cache.marketHours = priceData.marketState;
            cache.currentDelta = priceData.currentDelta;
            cache.currentMarketPrice = priceData.currentMarketPrice;
            cache.currentPercentage = priceData.currentPercentage;
          }
          return TickerCard(
            cache,
            widget.ticker,
            provider,
            priceData,
            isWSAvailable,
          );
        },
      ),
    );
  }
}

class TickerCard extends StatelessWidget {
  YahooHelperSocketData cache;
  final String ticker;
  final DataProvider provider;
  final YahooHelperPriceData data;
  final bool isWSAvailable;
  TickerCard(
      this.cache, this.ticker, this.provider, this.data, this.isWSAvailable,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var tickerData = provider.getTickerData(ticker: ticker);
    final darkModeEnabled =
        Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    if (isWSAvailable) {
      cache.lastCloseDelta = cache.currentDelta;
      cache.lastClosePrice = cache.currentMarketPrice;
      cache.lastPercentage = cache.currentPercentage;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            CupertinoStockOverviewMainScreen.routeName,
            arguments: {
              'ticker': ticker,
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
                            ticker.toUpperCase() + '  ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          if (cache.marketHours != "REGULAR_MARKET" &&
                              cache.marketHours != '' &&
                              data.extendedMarketAvailable != false)
                            Container(
                              decoration: BoxDecoration(
                                color: CupertinoColors.darkBackgroundGray,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      (cache.marketHours == "CLOSED")
                                          ? CupertinoIcons.moon_stars_fill
                                          : (cache.marketHours == "PRE_MARKET")
                                              ? CupertinoIcons.sun_max_fill
                                              : CupertinoIcons.moon_fill,
                                      color: (cache.marketHours == 'CLOSED')
                                          ? CupertinoColors.inactiveGray
                                          : (cache.marketHours == "PRE_MARKET")
                                              ? kSecondaryColor
                                              : kPrimaryColor,
                                      size: 15,
                                    ),
                                    Text(
                                      '  ' +
                                          ((cache.currentPercentage >= 0)
                                              ? '↑'
                                              : '↓') +
                                          cache.currentPercentage
                                              .abs()
                                              .toStringAsFixed(2) +
                                          '%',
                                      style: TextStyle(
                                        color: (cache.marketHours.toString() !=
                                                "REGULAR_MARKET")
                                            ? CupertinoColors.inactiveGray
                                            : (cache.currentPercentage >= 0)
                                                ? kGreenColor
                                                : kRedColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                          text: cache.lastClosePrice.toStringAsFixed(2),
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
                        ((cache.lastPercentage >= 0) ? '↑' : '↓') +
                            cache.lastPercentage.abs().toStringAsFixed(2) +
                            '%',
                        style: TextStyle(
                          fontSize: 15,
                          color: (cache.lastPercentage == 0.0 ||
                                  cache.marketHours.toString() !=
                                      "REGULAR_MARKET")
                              ? CupertinoColors.inactiveGray
                              : (cache.lastPercentage > 0)
                                  ? kGreenColor
                                  : kRedColor,
                          fontWeight: FontWeight.w500,
                        ),
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
  }
}
