import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/providers/chart_provider.dart';
import 'package:stockadvisor/providers/data_provider.dart';
import 'package:stockadvisor/providers/info_provider.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_row.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/main_row.dart';

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
    final mediaQuery = MediaQuery.of(context);
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String ticker = routeArgs['ticker']!;
    final provider = Provider.of<DataProvider>(context);
    final priceData = provider.getPriceData(ticker: ticker);
    final tickerData = provider.getTickerData(ticker: ticker);
    final chartProvider = Provider.of<ChartProvider>(context);
    final infoProvider = Provider.of<InfoProvider>(context);
    if (!streamsInitialized) {
      chartProvider.initChartStream(
          ticker: ticker, range: rangeConversionMap['1D']!);
      print('stream init main');
      infoProvider.initInfoStream(ticker: ticker);
      streamsInitialized = true;
    }

    double position = 1 -
        (priceData.dayHigh - priceData.lastClosePrice) /
            (priceData.dayHigh - priceData.dayLow);
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
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                child: Text(
                  ' ${priceData.lastClosePrice.toStringAsFixed(2)} (${(priceData.lastPercentage).toStringAsFixed(2)}%)',
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
          child: const Icon(CupertinoIcons.star),
          onPressed: () {},
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
        child: ListView(
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
        ),
      ),
    );
  }
}
