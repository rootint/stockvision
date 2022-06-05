import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/providers/server/holdings_provider.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_card.dart';

class CupertinoHoldingsRow extends StatelessWidget {
  final String ticker;
  const CupertinoHoldingsRow(this.ticker, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final holdingsProvider = Provider.of<HoldingsProvider>(context);
    return Column(
      children: [
        if (holdingsProvider.containsTicker(ticker))
          CupertinoInfoCard(
            title: 'HOLDINGS',
            titleIcon: CupertinoIcons.money_dollar,
            rowPosition: RowPosition.left,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 3.0),
              child: Column(
                children: [
                  Text(holdingsProvider.holdingsMap[ticker]!.amount.toString())
                ],
              ),
            ),
          ),
      ],
    );
  }
}
