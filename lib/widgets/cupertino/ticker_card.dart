import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/models/yahoo_models/socket_data.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:stockadvisor/providers/yahoo/meta_provider.dart';
import 'package:stockadvisor/providers/yahoo/price_provider.dart';
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
  @override
  void deactivate() {
    var provider = Provider.of<YahooPriceProvider>(context, listen: false);
    provider.removePriceStream(widget.ticker);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<YahooPriceProvider>(context);
    YahooHelperPriceData priceData = provider.getPriceData(widget.ticker);
    bool isWSAvailable = false;

    if (!widget.init) {
      provider.initPriceStream(widget.ticker);
      widget.init = true;
    }

    return TickerCard(
      widget.ticker,
      provider,
      priceData,
      isWSAvailable,
    );
  }
}

class TickerCard extends StatelessWidget {
  final String ticker;
  final YahooPriceProvider provider;
  final YahooHelperPriceData data;
  final bool isWSAvailable;
  TickerCard(this.ticker, this.provider, this.data, this.isWSAvailable,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var metadata = Provider.of<YahooMetaProvider>(context).getMetaData(ticker);
    final darkModeEnabled =
        Provider.of<ThemeProvider>(context).isDarkModeEnabled;
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
                    metadata.iconSvg,
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
                          if (data.marketState != "REGULAR_MARKET" &&
                              data.marketState != '' && data.marketState != "REGULAR" && 
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
                                      (data.marketState == "CLOSED")
                                          ? CupertinoIcons.moon_stars_fill
                                          : (data.marketState ==
                                                      "PRE_MARKET" ||
                                                  data.marketState == "PRE")
                                              ? CupertinoIcons.sun_max_fill
                                              : CupertinoIcons.moon_fill,
                                      color: (data.marketState == 'CLOSED')
                                          ? CupertinoColors.inactiveGray
                                          : (data.marketState ==
                                                      "PRE_MARKET" ||
                                                  data.marketState == "PRE")
                                              ? kSecondaryColor
                                              : kPrimaryColor,
                                      size: 15,
                                    ),
                                    Text(
                                      '  ' +
                                          ((data.currentPercentage >= 0)
                                              ? '↑'
                                              : '↓') +
                                          data.currentPercentage
                                              .abs()
                                              .toStringAsFixed(2) +
                                          '%',
                                      style: TextStyle(
                                        color: (![
                                          "PRE_MARKET, POST_MARKET, PRE, POST"
                                        ].contains(
                                                data.marketState.toString()))
                                            ? (data.currentPercentage >= 0)
                                                ? kGreenColor
                                                : kRedColor
                                            : CupertinoColors.inactiveGray,
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
                        metadata.companyLongName,
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
                          text: data.lastClosePrice.toStringAsFixed(2),
                          style: TextStyle(
                            color: darkModeEnabled
                                ? CupertinoColors.white
                                : CupertinoColors.darkBackgroundGray,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: metadata.currency,
                              style: const TextStyle(
                                color: CupertinoColors.systemGrey2,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        ((data.lastPercentage >= 0) ? '↑' : '↓') +
                            data.lastPercentage.abs().toStringAsFixed(2) +
                            '%',
                        style: TextStyle(
                          fontSize: 15,
                          color: (data.lastPercentage == 0.0 ||
                                  data.marketState.toString() !=
                                          "REGULAR_MARKET" &&
                                      data.marketState != "REGULAR")
                              ? CupertinoColors.inactiveGray
                              : (data.lastPercentage > 0)
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
