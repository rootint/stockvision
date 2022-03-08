import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';

class CupertinoStockOverviewPriceRow extends StatelessWidget {
  final String ticker;
  final Map<String, dynamic> tickerData;
  final YahooHelperPriceData priceData;

  const CupertinoStockOverviewPriceRow({
    required this.ticker,
    required this.tickerData,
    required this.priceData,
    Key? key,
  }) : super(key: key);

  Color getColorByPercentage(double percentage) {
    if (percentage == 0) return CupertinoColors.systemGrey4;
    if (percentage > 0) return kGreenColor;
    if (percentage < 0) return kRedColor;
    return CupertinoColors.white;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SvgPicture.string(tickerData['tickerSvg'], height: 65),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              ticker.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              priceData.currentMarketPrice.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          Text(
            (priceData.currentPercentage > 0 ? '+' : '') +
                '${priceData.currentPercentage.toStringAsFixed(2)} / ' +
                (priceData.currentPercentage > 0 ? '+' : '') +
                '${priceData.currentPercentage.toStringAsFixed(2)}%',
            style: TextStyle(
                color: getColorByPercentage(priceData.currentPercentage),
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
