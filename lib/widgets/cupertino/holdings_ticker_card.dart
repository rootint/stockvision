import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/server_models/holdings_ticker.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:stockadvisor/providers/yahoo/meta_provider.dart';
import 'package:stockadvisor/providers/yahoo/price_provider.dart';
import 'package:stockadvisor/screens/holdings/cupertino/alltime_provider.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/main_screen.dart';
import 'package:stockadvisor/protobuf/message.pb.dart';

class CupertinoTickerHoldingsCard extends StatefulWidget {
  final HoldingsTicker ticker;
  bool init = false;

  CupertinoTickerHoldingsCard({
    required this.ticker,
    required Key? key,
  }) : super(key: key);

  @override
  State<CupertinoTickerHoldingsCard> createState() =>
      _CupertinoTickerHoldingsCardState();
}

class _CupertinoTickerHoldingsCardState
    extends State<CupertinoTickerHoldingsCard> {
  @override
  void deactivate() {
    var provider = Provider.of<YahooPriceProvider>(context, listen: false);
    provider.removePriceStream(widget.ticker.ticker);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final darkModeEnabled =
        Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    final isAllTime = Provider.of<AllTimeProvider>(context).isSwitchEnabled;
    final provider = Provider.of<YahooPriceProvider>(context);
    final priceData = provider.getPriceData(widget.ticker.ticker);
    final metadata = Provider.of<YahooMetaProvider>(context)
        .getMetaData(widget.ticker.ticker);
    if (!widget.init) {
      provider.initPriceStream(widget.ticker.ticker);
      widget.init = true;
    }
    late double lastPercentage;
    late double priceDelta;
    if (!isAllTime) {
      lastPercentage =
          priceData.currentMarketPrice / priceData.previousDayClose * 100 - 100;
      priceDelta = priceData.previousDayClose * lastPercentage / 100;
    } else {
      lastPercentage =
          priceData.currentMarketPrice / widget.ticker.avgShareCost * 100 - 100;
      priceDelta = widget.ticker.avgShareCost *
          lastPercentage /
          100 *
          widget.ticker.amount;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            CupertinoStockOverviewMainScreen.routeName,
            arguments: {
              'ticker': widget.ticker.ticker,
            },
          );
        },
        onLongPress: () {
          print("asdasd");
        },
        child: Container(
          height: 90,
          width: mediaQuery.size.width,
          color: CupertinoColors.activeBlue.withAlpha(0),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                // fit: FlexFit.tight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SvgPicture.string(
                    metadata.iconSvg,
                    height: 47,
                    // fit: BoxFit.scaleDown,
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
                      Text(
                        widget.ticker.ticker.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        metadata.companyLongName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          // fontWeight: FontWeight.w500,
                          color: CupertinoColors.systemGrey2,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${widget.ticker.amount} pc • ${widget.ticker.avgShareCost.toStringAsFixed(2)}${metadata.currency}',
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: priceData.currentMarketPrice.toStringAsFixed(2),
                          style: TextStyle(
                            color: darkModeEnabled
                                ? CupertinoColors.white
                                : CupertinoColors.darkBackgroundGray,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                              text: metadata.currency,
                              style: const TextStyle(
                                color: CupertinoColors.systemGrey2,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        ((priceDelta >= 0) ? '↑' : '↓') +
                            '${priceDelta.abs().toStringAsFixed(2)}${metadata.currency}',
                        style: TextStyle(
                          fontSize: 14,
                          color: (priceDelta == 0.0)
                              ? CupertinoColors.inactiveGray
                              : (priceDelta > 0)
                                  ? kGreenColor
                                  : kRedColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ((lastPercentage >= 0) ? '↑' : '↓') +
                            '${lastPercentage.abs().toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: (lastPercentage == 0.0)
                              ? CupertinoColors.inactiveGray
                              : (lastPercentage > 0)
                                  ? kGreenColor
                                  : kRedColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
