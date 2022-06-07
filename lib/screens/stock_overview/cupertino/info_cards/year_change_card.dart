import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/yahoo_models/info_data.dart';
import 'package:stockadvisor/models/yahoo_models/price_data.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_card.dart';

class CupertinoInfoYearChangeCard extends StatelessWidget {
  final YahooHelperInfoData tickerInfo;
  final YahooHelperPriceData priceData;
  const CupertinoInfoYearChangeCard(this.tickerInfo, this.priceData, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double yearlyDelta = priceData.lastClosePrice -
        (priceData.lastClosePrice / (1 + tickerInfo.yearChange));
    return Flexible(
      flex: 1,
      child: CupertinoInfoCard(
        title: '52 WEEK CHANGE',
        titleIcon: CupertinoIcons.calendar,
        rowPosition: RowPosition.left,
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
                    // ((tickerInfo.yearChange * 100).toStringAsFixed(2) +
                    //     '%'),
                    '${(tickerInfo.yearChange > 0) ? '↑' : '↓'}${(tickerInfo.yearChange.abs() * 100).toStringAsFixed(2)}%',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '${(tickerInfo.yearChange > 0) ? '↑' : '↓'}${(yearlyDelta.abs().toStringAsFixed(2))} ${priceData.currency}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: CupertinoColors.systemGrey2,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Text(
                (tickerInfo.sAndPYearChange == 0)
                    ? 'Could not load the data.'
                    : (tickerInfo.sAndPYearChange > 0)
                        ? 'S&P 500 rose ${(tickerInfo.sAndPYearChange.abs() * 100).toStringAsFixed(2)}%.'
                        : 'S&P 500 fell ${(tickerInfo.sAndPYearChange.abs() * 100).toStringAsFixed(2)}%.',
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

class CupertinoTextFieldWithButtons extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final Function() onPlusPress;
  final Function() onMinusPress;
  const CupertinoTextFieldWithButtons({
    required this.placeholder,
    required this.controller,
    required this.onMinusPress,
    required this.onPlusPress,
    Key? key,
  }) : super(key: key);

  @override
  State<CupertinoTextFieldWithButtons> createState() =>
      _CupertinoTextFieldWithButtonsState();
}

class _CupertinoTextFieldWithButtonsState
    extends State<CupertinoTextFieldWithButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCupertinoDarkNavColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: widget.onPlusPress,
              child: const Center(
                child: Icon(
                  CupertinoIcons.minus,
                  color: CupertinoColors.inactiveGray,
                  size: 20,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: CupertinoTextField(
              decoration: const BoxDecoration(
                color: kCupertinoDarkNavColor,
              ),
              textAlign: TextAlign.center,
              placeholder: widget.placeholder,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              controller: widget.controller,
              cursorColor: kPrimaryColor,
            ),
          ),
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: widget.onMinusPress,
              child: const Center(
                child: Icon(
                  CupertinoIcons.add,
                  color: CupertinoColors.inactiveGray,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProperButton extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  const ProperButton({
    required this.child,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<ProperButton> createState() => _ProperButtonState();
}

class _ProperButtonState extends State<ProperButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        setState(() {
          isPressed = true;
        });
        widget.onPressed();
      },
      onPointerUp: (event) {
        setState(() {
          isPressed = false;
        });
      },
      child: Opacity(
        opacity: isPressed ? 0.5 : 1.0,
        child: widget.child,
      ),
    );
  }
}
