import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/helpers/ticker_streams.dart';
import 'package:stockadvisor/models/yahoo_models/meta_data.dart';

class CupertinoStockOverviewNavBar extends StatelessWidget {
  final String ticker;
  CupertinoStockOverviewNavBar({
    required this.ticker,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return CupertinoNavigationBar(
    //   middle: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       FutureBuilder<YahooHelperMetaData>(
    //         future:
    //             StockInfoHelper.getStockMetadata(ticker: ticker),
    //         builder: (ctx, snapshot) {
    //           if (snapshot.connectionState == ConnectionState.waiting) {
    //             return Text(companyName != null ? companyName! : 'Loading...');
    //           }
    //           stockMetadata = snapshot.data!;
    //           companyName = stockMetadata.companyLongName;
    //           return SizedBox(
    //             width: mediaQuery.size.width / 1.5,
    //             child: Text(
    //               companyName!,
    //               overflow: TextOverflow.ellipsis,
    //               textAlign: TextAlign.center,
    //             ),
    //           );
    //         },
    //       ),
    //       Text(
    //         ticker.toUpperCase(),
    //         style: const TextStyle(
    //             fontSize: 14, color: CupertinoColors.systemGrey3),
    //       ),
    //     ],
    //   ),
    //   trailing: CupertinoButton(
    //     padding: EdgeInsets.zero,
    //     child: const Icon(CupertinoIcons.star),
    //     onPressed: () {},
    //     alignment: Alignment.centerRight,
    //   ),
    // );
    return Container();
  }
}
