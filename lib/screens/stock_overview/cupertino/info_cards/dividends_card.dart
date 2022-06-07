import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_card.dart';

class CupertinoInfoDividendsCard extends StatelessWidget {
  final YahooHelperPriceData priceData;
  const CupertinoInfoDividendsCard(this.priceData, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime lastDividendDate = DateTime.fromMillisecondsSinceEpoch(
        priceData.lastDividendTimestamp * 1000);
    return Flexible(
      flex: 1,
      child: CupertinoInfoCard(
        title: 'DIVIDENDS',
        titleIcon: CupertinoIcons.creditcard_fill,
        rowPosition: RowPosition.right,
        isSquare: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (priceData.trailingAnnualDividendYield * 100)
                            .toStringAsFixed(2) +
                        '%',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 1),
                  if (priceData.trailingAnnualDividendRate != 0)
                    Text(
                      '(${priceData.trailingAnnualDividendRate.toStringAsFixed(2)} ${priceData.currency} per year)',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: CupertinoColors.systemGrey2,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
              Text(
                (priceData.lastDividendTimestamp == 0 &&
                        priceData.trailingAnnualDividendRate != 0)
                    ? 'No data on last payout.'
                    : (priceData.lastDividendTimestamp == 0)
                        ? 'This company doesn\'t pay dividends.'
                        : 'Last dividend payout was on ${DateFormat('dd MMMM, y').format(lastDividendDate)}.',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
