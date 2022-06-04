import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/server_models/prediction_ticker.dart';
import 'package:stockadvisor/models/yahoo_models/meta_data.dart';
import 'package:stockadvisor/providers/data_provider.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/main_screen.dart';

class CupertinoTickerPredictionCard extends StatefulWidget {
  final PredictionTicker ticker;
  bool init = false;

  CupertinoTickerPredictionCard({
    required this.ticker,
    required Key? key,
  }) : super(key: key);

  @override
  State<CupertinoTickerPredictionCard> createState() =>
      _CupertinoTickerPredictionCardState();
}

class _CupertinoTickerPredictionCardState
    extends State<CupertinoTickerPredictionCard> {
  @override
  void deactivate() {
    var provider = Provider.of<DataProvider>(context, listen: false);
    // provider.removeTickerPriceStream(ticker: widget.ticker.ticker);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final darkModeEnabled =
        Provider.of<ThemeProvider>(context).isDarkModeEnabled;

    return Consumer<DataProvider>(
      builder: (context, provider, _) {
        if (!widget.init) {
          provider.initTickerData(ticker: widget.ticker.ticker);
          widget.init = true;
        }
        var data = provider.getPriceData(ticker: widget.ticker.ticker);
        var tickerData = provider.getTickerData(ticker: widget.ticker.ticker);
        final predictionPriceDelta =
            widget.ticker.predictedPrice - data.lastClosePrice;
        final predictionPricePercent =
            (predictionPriceDelta / data.lastClosePrice) * 100;
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
            child: Container(
              height: 90,
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
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            tickerData.companyLongName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              // fontWeight: FontWeight.w500,
                              color: CupertinoColors.systemGrey2,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Prediction:',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: CupertinoColors.systemGrey4,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
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
                                  text: tickerData.currency,
                                  style: TextStyle(
                                    color: CupertinoColors.systemGrey2,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.ticker.atClose ? 'At close:' : 'At open:',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${widget.ticker.predictedPrice.toStringAsFixed(2)} / ' +
                                ((predictionPricePercent > 0) ? '↑' : '↓') +
                                '${predictionPricePercent.abs().toStringAsFixed(2)}%',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: (predictionPriceDelta == 0.0)
                                    ? CupertinoColors.inactiveGray
                                    : (predictionPriceDelta > 0)
                                        ? kGreenColor
                                        : kRedColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
