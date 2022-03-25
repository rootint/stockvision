import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/providers/data_provider.dart';
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
    return Consumer<DataProvider>(
      builder: (context, provider, _) {
        if (!widget.init) {
          provider.initTickerData(ticker: widget.ticker);
          widget.init = true;
        }
        var data = provider.getPriceData(ticker: widget.ticker);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
              width: mediaQuery.size.width,
              height: 90,
              // color: kGreenColor,
              decoration: BoxDecoration(
                  border: Border.all(),
                  color: CupertinoColors.darkBackgroundGray),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.ticker.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data.lastClosePrice.toStringAsFixed(2),
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
