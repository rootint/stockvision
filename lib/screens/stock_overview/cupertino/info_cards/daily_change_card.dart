import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_card.dart';

class CupertinoInfoDailyChangeCard extends StatelessWidget {
  final String ticker;
  final YahooHelperPriceData priceData;
  const CupertinoInfoDailyChangeCard(this.ticker, this.priceData, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    double dayPosition = 1 -
        (priceData.dayHigh - priceData.lastClosePrice) /
            (priceData.dayHigh - priceData.dayLow);

    return Flexible(
      flex: 1,
      child: CupertinoInfoCard(
        title: 'DAILY CHANGE',
        titleIcon: CupertinoIcons.arrow_up_right,
        rowPosition: RowPosition.left,
        isSquare: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Text(
                    priceData.openPrice.toStringAsFixed(2) + ' ',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'at open',
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.systemGrey2,
                    ),
                  )
                ],
              ),
              const Spacer(),
              Text(
                'Current: ' + priceData.lastClosePrice.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.systemGrey4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 8.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: kGreenColor,
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: [
                            kRedColor,
                            kGreenColor,
                          ],
                        ),
                      ),
                      width: double.infinity,
                      height: 7,
                    ),
                    Positioned(
                      left: (mediaQuery.size.width / 2 - 50 - 12) * dayPosition,
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Today\'s low is ${priceData.dayLow.toStringAsFixed(2)}, and high is ${priceData.dayHigh.toStringAsFixed(2)}.',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
