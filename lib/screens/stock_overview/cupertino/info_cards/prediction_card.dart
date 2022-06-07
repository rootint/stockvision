import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/server_models/prediction_ticker.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/providers/server/prediction_provider.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_card.dart';

class CupertinoInfoPredictionCard extends StatelessWidget {
  final String ticker;
  final YahooHelperPriceData priceData;
  const CupertinoInfoPredictionCard(this.ticker, this.priceData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final predictionProvider = Provider.of<PredictionProvider>(context);
    bool isPredicted = false;
    PredictionTicker? prediction;
    double predictionDelta = 0;
    double predictionPercent = 0;
    double predictionPrice = 0;
    for (var item in predictionProvider.predictions) {
      if (item.ticker == ticker) {
        predictionPrice = item.predictedPrice;
        isPredicted = true;
        prediction = item;
        predictionDelta = item.predictedPrice - priceData.lastClosePrice;
        predictionPercent = (predictionDelta / priceData.lastClosePrice) * 100;
        break;
      }
    }
    return (isPredicted)
        ? CupertinoInfoCard(
            title: 'PREDICTION',
            titleIcon: CupertinoIcons.eye_solid,
            rowPosition: RowPosition.left,
            innerHeight: 55,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Predicted ${(prediction!.atClose) ? 'at close:' : 'at open:'}',
                    style: const TextStyle(
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
                          text: predictionPrice.toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          children: const [
                            TextSpan(
                              text: " " + 'USD',
                              style: TextStyle(
                                color: CupertinoColors.inactiveGray,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        ((predictionPercent > 0) ? '↑' : '↓') +
                            '${predictionDelta.toStringAsFixed(2)} / ' +
                            ((predictionPercent > 0) ? '↑' : '↓') +
                            '${predictionPercent.abs().toStringAsFixed(2)}%',
                        style:
                            const TextStyle(color: kGreenColor, fontSize: 13),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}
