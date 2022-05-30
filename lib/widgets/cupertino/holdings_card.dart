import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/server_models/holdings.dart';
import 'package:stockadvisor/providers/server/holdings_provider.dart';
import 'package:stockadvisor/providers/theme_provider.dart';

class CupertinoHoldingsCard extends StatefulWidget {
  final double height;
  const CupertinoHoldingsCard({
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  _CupertinoHoldingsCardState createState() => _CupertinoHoldingsCardState();
}

class _CupertinoHoldingsCardState extends State<CupertinoHoldingsCard> {
  final isLogOn = true;

  String getDeltaString(Holdings holdings) {
    String arrow = (holdings.deltaAlltime > 0) ? '↑' : '↓';
    return '$arrow${holdings.deltaAlltime.abs().toStringAsFixed(2)} ' +
        '($arrow${holdings.deltaAlltimePercent.abs().toStringAsFixed(2)}%)';
  }

  Color getDeltaColor(Holdings holdings) =>
      (holdings.deltaAlltime >= 0) ? kGreenColor : kRedColor;

  @override
  Widget build(BuildContext context) {
    final darkModeEnabled =
        Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    final holdingsProvider = Provider.of<HoldingsProvider>(context);
    var holdings = holdingsProvider.holdings;
    final mediaQuery = MediaQuery.of(context);
    if (!isLogOn) {
      return NotLoggedInCard(
          height: widget.height, width: mediaQuery.size.width);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: CupertinoColors.darkBackgroundGray,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your holdings:',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: holdings.currentWorth.toStringAsFixed(0),
                      style: TextStyle(
                        color: darkModeEnabled
                            ? CupertinoColors.white
                            : CupertinoColors.darkBackgroundGray,
                        fontWeight: FontWeight.w600,
                        fontSize: 33,
                      ),
                      children: [
                        TextSpan(
                          text:
                              '.${holdings.currentWorth.toStringAsFixed(2).split('.')[1].substring(0, 2)}\$',
                          // text: '.00\$',
                          style: TextStyle(
                            color: CupertinoColors.systemGrey2,
                            fontSize: 33,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: RichText(
                  text: TextSpan(
                    text: getDeltaString(holdings),
                    style: TextStyle(color: getDeltaColor(holdings)
                        // fontWeight: FontWeight.w600,
                        // fontSize: 33,
                        ),
                    children: [
                      TextSpan(
                        text: ' for all time',
                        style: TextStyle(
                          color: CupertinoColors.inactiveGray,
                          // fontSize: 33,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotLoggedInCard extends StatelessWidget {
  final double height;
  final double width;
  const NotLoggedInCard({
    required this.height,
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: CupertinoColors.darkBackgroundGray,
            child: const Center(
              child: Text(
                "Please log in or sign up to view your holdings",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
