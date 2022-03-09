import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/providers/data_provider.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/bottom_row.dart';
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
  final scrollController = ScrollController();

  Color getColorByPercentage(double percentage) {
    if (percentage == 0) return CupertinoColors.systemGrey4;
    if (percentage > 0) return kGreenColor;
    if (percentage < 0) return kRedColor;
    return CupertinoColors.white;
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

    final double position = 1 -
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
                  tickerData.containsKey('meta') ? tickerData['meta']!.companyLongName : 'Loading...',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                child: Text(
                  ' ${priceData.lastClosePrice.toStringAsFixed(2)} (${priceData.lastPercentage.toStringAsFixed(2)}%)',
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
            // CupertinoStockOverviewBottomRow(
            //   ticker: ticker,
            //   data: priceData,
            // ),
            CupertinoInfoCard(
              title: 'PREDICTION',
              titleIcon: CupertinoIcons.eye_solid,
              rowPosition: RowPosition.left,
              height: 85,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Predicted at open:',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "190.00",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: " USD",
                                  style: TextStyle(
                                    color: CupertinoColors.inactiveGray,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  )),
                            ],
                          ),
                        ),
                        Text(
                          '+12.34 / +10.01%',
                          style: TextStyle(color: kGreenColor, fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            CupertinoInfoCard(
              title: 'PRICE RANGES',
              titleIcon: CupertinoIcons.graph_square_fill,
              rowPosition: RowPosition.left,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 80,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Day Range'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(priceData.dayLow.toStringAsFixed(2)),
                              Text(priceData.lastClosePrice.toStringAsFixed(2)),
                              Text(priceData.dayHigh.toStringAsFixed(2)),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: kGreenColor,
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.topRight,
                                      colors: [
                                        kRedColor,
                                        kGreenColor,
                                      ],
                                    )),
                                width: double.infinity,
                                height: 7,
                              ),
                              Positioned(
                                left: (mediaQuery.size.width - 50 - 12) *
                                    position,
                                top: -3.5,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: CupertinoColors.white,
                                    border: Border.all(
                                      color: CupertinoColors.darkBackgroundGray,
                                      width: 3.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: CupertinoInfoCard(
                    title: 'INFO',
                    titleIcon: CupertinoIcons.info_circle_fill,
                    height: 160,
                    rowPosition: RowPosition.left,
                    child: Container(),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: CupertinoInfoCard(
                    title: 'MARKET CAP',
                    titleIcon: CupertinoIcons.chart_bar_alt_fill,
                    height: 160,
                    rowPosition: RowPosition.right,
                    child: Container(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CupertinoInfoCard extends StatelessWidget {
  final String title;
  final IconData titleIcon;
  final double height;
  final double width;
  final RowPosition rowPosition;
  final Widget child;
  const CupertinoInfoCard({
    required this.title,
    required this.titleIcon,
    required this.rowPosition,
    required this.child,
    this.height = 160,
    this.width = double.infinity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding;
    switch (rowPosition) {
      case RowPosition.left:
        padding = const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 2.0);
        break;
      case RowPosition.right:
        padding = const EdgeInsets.fromLTRB(0.0, 10.0, 12.0, 2.0);
        break;
      case RowPosition.center:
        padding = const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 2.0);
        break;
    }
    ;
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: CupertinoColors.darkBackgroundGray,
        ),
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    titleIcon,
                    color: CupertinoColors.systemGrey.withOpacity(0.55),
                    size: 12,
                  ),
                  Text(
                    ' $title',
                    style: TextStyle(
                      color: CupertinoColors.inactiveGray.withOpacity(0.55),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
