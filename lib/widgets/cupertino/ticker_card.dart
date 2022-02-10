import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/providers/cache_provider.dart';
import 'package:stockadvisor/providers/data_provider.dart';

class CupertinoTickerCard extends StatefulWidget {
  // refactor this shit a bit
  final String ticker;
  double lastPrice = 0.0;
  final bool isLastColorGreen;
  final int index;
  final void Function(int, double, bool) lastPriceFunc;
  // final Stream<YahooHelperPriceData> priceStream;
  final YahooHelperPriceData data;

  // need: ticker, lastprice, callback, lastcolor, index
  CupertinoTickerCard({
    required this.ticker,
    required this.lastPrice,
    required this.lastPriceFunc,
    required this.isLastColorGreen,
    required this.index,
    // required this.priceStream,
    required this.data,
    required Key? key,
  }) : super(key: key);

  @override
  State<CupertinoTickerCard> createState() => _CupertinoTickerCardState();
}

class _CupertinoTickerCardState extends State<CupertinoTickerCard> {
  late double currentPrice;
  bool cacheLoaded = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Consumer<DataProvider>(
      builder: (context, provider, _) {
        var data = provider.getPriceData(ticker: widget.ticker);
        return Container(
          width: mediaQuery.size.width,
          height: 90,
          // color: kGreenColor,
          decoration: BoxDecoration(
              border: Border.all(), color: CupertinoColors.darkBackgroundGray),
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
        );
      },
    );
    // child: Consumer<CacheProvider>(
    //   builder: (context, provider, _) => StreamBuilder<YahooHelperPriceData>(
    //     initialData: provider.getPriceData(ticker: widget.ticker),
    //     stream: widget.priceStream,
    //     builder: (context, snapshot) {
    //       if (snapshot.data == null) {
    //         return Container();
    //       }
    //       provider.addPriceData(ticker: widget.ticker, data: snapshot.data!);
    //       return Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           Text(
    //             widget.ticker.toUpperCase(),
    //             style: const TextStyle(fontWeight: FontWeight.bold),
    //           ),
    //           RichText(
    //             text: TextSpan(
    //               children: [
    //                 TextSpan(
    //                   text: snapshot.data!.lastClosePrice.toStringAsFixed(2),
    //                   style: TextStyle(
    //                       color: CupertinoColors.white,
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: 16),
    //                 ),
    //                 // TextSpan(
    //                 //   text: ,
    //                 //   style: TextStyle(
    //                 //       fontWeight: FontWeight.bold,
    //                 //       color: CupertinoColors.systemGrey3,
    //                 //       fontSize: 16),
    //                 // ),
    //               ],
    //             ),
    //             textAlign: TextAlign.end,
    //           ),
    //         ],
    //       );
    //     }
    //   ),
    // ),

    // );
  }
}
