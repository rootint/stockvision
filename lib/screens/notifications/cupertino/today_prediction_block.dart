import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/server_models/prediction_ticker.dart';
import 'package:stockadvisor/providers/data_provider.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:stockadvisor/protobuf/message.pb.dart';

class CupertinoTodayPredictionBlock extends StatelessWidget {
  final List<PredictionTicker> predictions;
  const CupertinoTodayPredictionBlock(this.predictions, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.darkBackgroundGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            for (var item in predictions) TickerRow(item),
          ],
        ),
      ),
    );
  }
}

class TickerRow extends StatefulWidget {
  final PredictionTicker data;
  const TickerRow(this.data, {Key? key}) : super(key: key);

  @override
  State<TickerRow> createState() => _TickerRowState();
}

class _TickerRowState extends State<TickerRow> {
  @override
  Widget build(BuildContext context) {
    final darkModeEnabled =
        Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    final provider = Provider.of<DataProvider>(context);
    // sockets
    var currentPrice =
        provider.getPriceData(ticker: widget.data.ticker).currentMarketPrice;
    provider.initTickerData(ticker: widget.data.ticker);
    final metadata = provider.getTickerData(ticker: widget.data.ticker);
    return StreamBuilder(
      stream: provider.channelController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var socketData =
              yaticker.fromBuffer(base64.decode(snapshot.data.toString()));
          if (socketData.id == widget.data.ticker.toUpperCase()) {
            setState(() {
              currentPrice = socketData.price;
            });
          }
        }
        return SizedBox(
          height: 70,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SvgPicture.string(
                    metadata.iconSvg,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        metadata.companyLongName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Prediction' +
                            ((widget.data.atClose) ? ' at close:' : 'at open:'),
                      ),
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
                          text: currentPrice.toStringAsFixed(2),
                          style: TextStyle(
                            color: darkModeEnabled
                                ? CupertinoColors.white
                                : CupertinoColors.darkBackgroundGray,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: metadata.currency,
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
                        ((widget.data.predictedPrice > currentPrice)
                                ? '↑'
                                : '↓') +
                            widget.data.predictedPrice.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 15,
                          color: (widget.data.predictedPrice > currentPrice)
                              ? kGreenColor
                              : kRedColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
