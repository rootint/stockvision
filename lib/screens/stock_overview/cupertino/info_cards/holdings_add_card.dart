import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_card.dart';

class CupertinoInfoHoldingsAddCard extends StatefulWidget {
  final String ticker;
  const CupertinoInfoHoldingsAddCard(this.ticker, {Key? key}) : super(key: key);

  @override
  State<CupertinoInfoHoldingsAddCard> createState() =>
      _CupertinoInfoHoldingsAddCardState();
}

class _CupertinoInfoHoldingsAddCardState
    extends State<CupertinoInfoHoldingsAddCard> {
  bool isBuySelected = true;
  final priceController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: CupertinoInfoCard(
        title: 'ADD TO HOLDINGS',
        titleIcon: CupertinoIcons.add,
        rowPosition: RowPosition.right,
        isSquare: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 9.0, bottom: 3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      decoration: BoxDecoration(
                        color: kCupertinoDarkNavColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isBuySelected = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isBuySelected
                                    ? kGreenColor
                                    : CupertinoColors.activeBlue.withAlpha(0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: constraints.maxWidth / 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: Text(
                                  "BUY",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isBuySelected
                                        ? CupertinoColors.black
                                        : CupertinoColors.inactiveGray,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isBuySelected = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isBuySelected
                                    ? CupertinoColors.activeBlue.withAlpha(0)
                                    : kRedColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: constraints.maxWidth / 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: Text(
                                  "SELL",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isBuySelected
                                        ? CupertinoColors.inactiveGray
                                        : CupertinoColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Column(
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: [
              //         Text('Price'),
              //         Text('Amount'),
              //       ],
              //     ),
              //     LayoutBuilder(
              //       builder: (context, constraints) => Row(
              //         children: [
              //           CupertinoTextField(),
              //           CupertinoTextField(),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              Column(
                children: [
                  // CupertinoTextFieldWithButtons(
                  //     placeholder: 'Price',
                  //     controller: priceController),
                  // const SizedBox(height: 4),
                  // CupertinoTextFieldWithButtons(
                  //     placeholder: 'Amount',
                  //     controller: amountController),
                ],
              ),
              ProperButton(
                onPressed: () {
                  print('$isBuySelected');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isBuySelected ? kGreenColor : kRedColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "${isBuySelected ? 'BUY' : 'SELL'} ${widget.ticker.toUpperCase()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: isBuySelected
                            ? CupertinoColors.black
                            : CupertinoColors.white,
                      ),
                    ),
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
