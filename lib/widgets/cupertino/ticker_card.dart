import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/yahoo_models/meta_data.dart';
import 'package:stockadvisor/providers/data_provider.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/main_screen.dart';

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
    var provider = Provider.of<DataProvider>(context, listen: false);
    provider.removeTickerPriceStream(ticker: widget.ticker);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final darkModeEnabled = Provider.of<ThemeProvider>(context).isDarkModeEnabled;

    return Consumer<DataProvider>(
      builder: (context, provider, _) {
        if (!widget.init) {
          provider.initTickerData(ticker: widget.ticker);
          widget.init = true;
        }
        var data = provider.getPriceData(ticker: widget.ticker);
        var tickerData = provider.getTickerData(ticker: widget.ticker);
        return Column(
          children: [
            Padding(
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
                        // fit: FlexFit.tight,
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
                                widget.ticker.toUpperCase(),
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
                                text: TextSpan(
                                  text: data.lastClosePrice.toStringAsFixed(2),
                                  style: TextStyle(
                                    color: darkModeEnabled ? CupertinoColors.white : CupertinoColors.darkBackgroundGray,
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
                                ((data.lastPercentage >= 0) ? '+' : '') +
                                data.lastPercentage.toStringAsFixed(2) + '%',
                                style: TextStyle(
                                  fontSize: 15,
                                    color: (data.lastPercentage == 0.0 || data.marketState != "REGULAR")
                                        ? CupertinoColors.inactiveGray
                                        : (data.lastPercentage > 0)
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
            ),
          ],
        );
      },
    );
  }
}
