// import 'package:aistock/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stockadvisor/constants.dart';
// import 'package:yahoofin/yahoofin.dart';
import 'package:yahoofin/yahoofin.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

// fix images loaded as assets (maybe use firebase or something like that)
// may be loaded as svg from tradingview via http package
// fix overall widget architecture (getStockInfo might be outsourced)

class DashboardTickerCard extends StatefulWidget {
  final String ticker;
  // final String companyName;
  // final String currency;

  DashboardTickerCard(this.ticker, {Key? key}) : super(key: key);

  @override
  _DashboardTickerCardState createState() => _DashboardTickerCardState();
}

class _DashboardTickerCardState extends State<DashboardTickerCard> {
  bool isLoading = true;
  final double cardHeight = 100;
  String companyName = '';
  String currency = '';
  double currentPrice = 0.0;
  double percentage = 0.0;
  List<double> history = [];
  // List<charts.Series<double, double>> chartData = [];

  void getStockInfo(String ticker) async {
    isLoading = true;
    final yahooHandler = YahooFin();
    StockInfo info = yahooHandler.getStockInfo(ticker: ticker);
    StockQuote price = await yahooHandler.getPrice(stockInfo: info);
    StockHistory history = yahooHandler.initStockHistory(ticker: ticker);
    StockChart chart = await yahooHandler.getChartQuotes(
      stockHistory: history,
      interval: StockInterval.oneDay,
      period: StockRange.oneMonth,
    );
    StockMeta meta = await yahooHandler.getMetaData(ticker);
    setState(() {
      isLoading = false;
      companyName = meta.longName!;
      currentPrice = price.currentPrice!;
      var c = chart.chartQuotes!;
      percentage = (currentPrice - c.close![c.close!.length - 2]) /
          c.close![c.close!.length - 2] *
          100;
    });
  }

  @override
  void initState() {
    getStockInfo(widget.ticker);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isDarkMode = CupertinoTheme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      child: ClipRRect(
        borderRadius:
            const BorderRadius.all(Radius.circular(20)),
        child: Container(
          color: isDarkMode ? kCupertinoDarkNavColor : CupertinoColors.systemGrey6,
          // fix inkwell not obeying parent (cliprrect borders are not respected)
          // add ontap animation
          child: GestureDetector(
            onTap: () => getStockInfo(widget.ticker),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  // fit: FlexFit.tight,
                  child: Padding(
                    // doesn't work well
                    padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(20)),
                      child: Container(
                              width: 50,
                              height: 50,
                              color: isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade500,
                            )
                          // : Image.asset(
                          //     // '${widget.ticker.toLowerCase()}.png',
                          //     width: 50,
                          //     height: 50,
                          //   ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: isLoading
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                    color: isDarkMode
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade500,
                                    width: mediaQuery.size.width * 0.15,
                                    height: mediaQuery.textScaleFactor * 17),
                              )
                            : Text(
                                widget.ticker.toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: isLoading
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                    color: isDarkMode
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade500,
                                    width: mediaQuery.size.width * 0.4,
                                    height: mediaQuery.textScaleFactor * 17),
                              )
                            : Text(
                                companyName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600),
                              ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 3),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: currentPrice.toStringAsFixed(2),
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                TextSpan(
                                  text: '\$',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Card(
                            color: (isLoading || percentage == 0)
                                ? isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade500
                                : (percentage > 0 ? Colors.green : Colors.red),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 2,
                                bottom: 2,
                                left: 8,
                                right: 5,
                              ),
                              child: Text(
                                percentage > 0
                                    ? "+${percentage.toStringAsFixed(2)}%"
                                    : '${percentage.toStringAsFixed(2)}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      width: mediaQuery.size.width,
      height: cardHeight,
    );
  }
}
