import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';

class CupertinoStockOverviewBottomRow extends StatelessWidget {
  final String ticker;
  final Stream<YahooHelperPriceData> priceStream;
  final YahooHelperPriceData? cache;

  const CupertinoStockOverviewBottomRow({
    required this.ticker,
    required this.priceStream,
    required this.cache,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        final defaultTextStyle = TextStyle(fontSize: height / 7);
        final iconSize = height / 5.5;
        final EdgeInsets leftCardPadding = EdgeInsets.fromLTRB(
          width * 0.03,
          height * 0.055,
          width * 0.035,
          height * 0.055,
        );
        final EdgeInsets rightCardPadding = EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.055,
        );
        return Row(
          children: [
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: CupertinoColors.darkBackgroundGray,
                    child: StreamBuilder<YahooHelperPriceData>(
                      initialData: cache,
                      stream: priceStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const CupertinoActivityIndicator();
                        }
                        final data = snapshot.data!;
                        return Padding(
                          padding: leftCardPadding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InfoRow(
                                data: data.previousDayClose.toStringAsFixed(2),
                                icon: Icon(CupertinoIcons.time,
                                    size: iconSize, color: kSecondaryColor),
                                labelText: '  Open',
                                textStyle: defaultTextStyle,
                              ),
                              InfoRow(
                                data: data.dayHigh.toStringAsFixed(2),
                                icon: Icon(CupertinoIcons.arrow_up,
                                    size: iconSize, color: kGreenColor),
                                labelText: '  High',
                                textStyle: defaultTextStyle,
                              ),
                              InfoRow(
                                data: data.dayLow.toStringAsFixed(2),
                                icon: Icon(CupertinoIcons.arrow_down,
                                    size: iconSize, color: kRedColor),
                                labelText: '  Low',
                                textStyle: defaultTextStyle,
                              ),
                              InfoRow(
                                data: data.pe == 'N/A' ? data.pe : data.pe.toStringAsFixed(2),
                                icon: Icon(CupertinoIcons.chart_bar,
                                    size: iconSize, color: kPrimaryColor),
                                labelText: '  P/E',
                                textStyle: defaultTextStyle,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: CupertinoColors.darkBackgroundGray,
                    child: Padding(
                      padding: rightCardPadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Predicted at open:', style: defaultTextStyle),
                          Text('190.00',
                              style: defaultTextStyle.copyWith(
                                  fontWeight: FontWeight.bold)),
                          Text('+4.53 / +1.55%',
                              style: defaultTextStyle.copyWith(
                                  color: kGreenColor)),
                        ],
                      ),
                    ),
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

class InfoRow extends StatelessWidget {
  final String data;
  final Icon icon;
  final String labelText;
  final TextStyle textStyle;
  const InfoRow({
    required this.data,
    required this.icon,
    required this.labelText,
    required this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: icon,
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Text(
            labelText,
            style: textStyle,
          ),
        ),
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: Text(
            data,
            style: textStyle,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
