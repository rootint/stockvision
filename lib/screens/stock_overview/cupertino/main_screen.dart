import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/providers/chart_provider.dart';
import 'package:stockadvisor/providers/data_provider.dart';
import 'package:stockadvisor/providers/info_provider.dart';
import 'package:stockadvisor/providers/server/watchlist_provider.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_row.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/main_row.dart';
import 'package:stockadvisor/protobuf/message.pb.dart';

class CupertinoStockOverviewMainScreen extends StatefulWidget {
  static const routeName = '/stock_overview';
  const CupertinoStockOverviewMainScreen({Key? key}) : super(key: key);

  @override
  State<CupertinoStockOverviewMainScreen> createState() =>
      CupertinoStockOverviewMainScreenState();
}

class CupertinoStockOverviewMainScreenState
    extends State<CupertinoStockOverviewMainScreen>
    with TickerProviderStateMixin {
  bool streamsInitialized = false;
  final scrollController = ScrollController();

  Color getColorByPercentage(double percentage) {
    if (percentage == 0) return CupertinoColors.systemGrey4;
    if (percentage > 0) return kGreenColor;
    if (percentage < 0) return kRedColor;
    return CupertinoColors.white;
  }

  @override
  void deactivate() {
    final chartProvider = Provider.of<ChartProvider>(context);
    chartProvider.removeChartStream();
    final infoProvider = Provider.of<InfoProvider>(context);
    infoProvider.removeInfoStream();
    super.deactivate();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool isNavbarDisplayed = false;

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String ticker = routeArgs['ticker']!;
    final provider = Provider.of<DataProvider>(context);
    final watchlistProvider = Provider.of<WatchlistProvider>(context);
    // optimize

    var priceData = provider.getPriceData(ticker: ticker);
    final tickerData = provider.getTickerData(ticker: ticker);
    final chartProvider = Provider.of<ChartProvider>(context);
    final infoProvider = Provider.of<InfoProvider>(context);
    if (!streamsInitialized) {
      provider.initTickerData(ticker: ticker, fromOverview: true);
      chartProvider.initChartStream(
          ticker: ticker, range: rangeConversionMap['1D']!);
      print('stream init main');
      infoProvider.initInfoStream(ticker: ticker);
      streamsInitialized = true;
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: kBlackColor.withOpacity(0.9),
        middle: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: isNavbarDisplayed ? 1.0 : 0.0,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  tickerData.companyLongName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                child: Text(
                  priceData.lastClosePrice.toStringAsFixed(2) +
                      ' (' +
                      ((priceData.lastPercentage >= 0) ? '↑' : '↓') +
                      (priceData.lastPercentage).abs().toStringAsFixed(2) +
                      '%)',
                  style: TextStyle(
                    fontSize: 13,
                    color: getColorByPercentage(priceData.lastPercentage),
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            (watchlistProvider.containsInWatchlist(ticker: ticker))
                ? CupertinoIcons.star_fill
                : CupertinoIcons.star,
          ),
          onPressed: () {
            if (watchlistProvider.containsInWatchlist(ticker: ticker)) {
              watchlistProvider.removeTickerFromWatchlist(ticker: ticker);
            } else {
              watchlistProvider.addTickerToWatchlist(ticker: ticker);
            }
          },
          alignment: Alignment.centerRight,
        ),
      ),
      backgroundColor: kBlackColor,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            if (scrollController.position.pixels > 170) {
              setState(() {
                isNavbarDisplayed = true;
              });
            } else if (isNavbarDisplayed == true) {
              setState(() {
                isNavbarDisplayed = false;
              });
            }
          }
          return false;
        },
        child: StreamBuilder(
          stream: provider.channelController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var socketData =
                  yaticker.fromBuffer(base64.decode(snapshot.data.toString()));
              if (socketData.id == ticker.toUpperCase()) {
                setState(() {
                  priceData = YahooHelperPriceData(
                    marketState: socketData.marketHours.toString(),
                    currentMarketPrice: socketData.price,
                    currentPercentage: socketData.changePercent,
                    dayHigh: priceData.dayHigh,
                    dayLow: priceData.dayLow,
                    lastClosePrice: priceData.lastClosePrice,
                    lastPercentage: priceData.lastPercentage,
                    pe: priceData.pe,
                    previousDayClose: priceData.previousDayClose,
                    currency: priceData.currency,
                    extendedMarketAvailable: priceData.extendedMarketAvailable,
                    fiftyTwoWeekHigh: priceData.fiftyTwoWeekHigh,
                    fiftyTwoWeekLow: priceData.fiftyTwoWeekLow,
                    trailingAnnualDividendRate:
                        priceData.trailingAnnualDividendRate,
                    trailingAnnualDividendYield:
                        priceData.trailingAnnualDividendYield,
                    lastDividendTimestamp: priceData.lastDividendTimestamp,
                    currentDelta: socketData.change,
                    lastCloseDelta: priceData.lastCloseDelta,
                    openPrice: priceData.openPrice,
                  );
                  // isWSAvailable = true;
                });
              }
            }
            return ListView(
              controller: scrollController,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 7.0),
                  child: CupertinoStockOverviewMainRow(
                    ticker: ticker,
                    priceData: priceData,
                    tickerData: tickerData,
                  ),
                ),
                CupertinoInfoRow(ticker: ticker),
              ],
            );
          },
        ),
      ),
    );
  }
}
