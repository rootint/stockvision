import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/server_models/prediction_ticker.dart';
import 'package:stockadvisor/providers/data_provider.dart';
import 'package:stockadvisor/providers/theme_provider.dart';

class CupertinoNotificationPredictionCard extends StatefulWidget {
  final PredictionTicker data;
  const CupertinoNotificationPredictionCard({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  State<CupertinoNotificationPredictionCard> createState() =>
      CupertinoNotificationPredictionCardState();
}

class CupertinoNotificationPredictionCardState
    extends State<CupertinoNotificationPredictionCard> {
  @override
  Widget build(BuildContext context) {
    final darkModeEnabled =
        Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    final metadataProvider = Provider.of<DataProvider>(context);
    metadataProvider.initTickerData(ticker: widget.data.ticker);
    final tickerMetadata =
        metadataProvider.getTickerData(ticker: widget.data.ticker);
    return SizedBox(
      height: 70,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            // fit: FlexFit.tight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SvgPicture.string(
                tickerMetadata.iconSvg,
                height: 47,
              ),
            ),
          ),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.data.ticker.toUpperCase() + ' ',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        DateFormat('d MMM, yyyy').format(
                          widget.data.predictionDate!,
                        ),
                        style: const TextStyle(
                          color: CupertinoColors.inactiveGray,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    (widget.data.isDirectionCorrect!)
                        ? 'Direction correct'
                        : 'Direction missed',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: widget.data.isDirectionCorrect!
                          ? kGreenColor
                          : kRedColor,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      text: widget.data.predictedPrice.toStringAsFixed(2),
                      style: TextStyle(
                        color: darkModeEnabled
                            ? CupertinoColors.white
                            : CupertinoColors.darkBackgroundGray,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: tickerMetadata.currency,
                          style: const TextStyle(
                            color: CupertinoColors.systemGrey2,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    ((widget.data.predictionDelta! >= 0) ? '↑' : '↓') +
                        (widget.data.predictionDelta! /
                                widget.data.predictedPrice *
                                100)
                            .abs()
                            .toStringAsFixed(2) +
                        '%',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: (widget.data.predictionDelta! > 0)
                          ? kGreenColor
                          : kRedColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
