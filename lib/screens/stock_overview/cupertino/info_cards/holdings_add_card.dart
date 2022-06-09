import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/server_models/holdings_ticker.dart';
import 'package:stockadvisor/providers/server/holdings_provider.dart';
import 'package:stockadvisor/providers/yahoo/price_provider.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/info_card.dart';

class CupertinoInfoHoldingsAddCard extends StatefulWidget {
  final String ticker;
  final HoldingsProvider holdingsProvider;
  const CupertinoInfoHoldingsAddCard(this.ticker, this.holdingsProvider,
      {Key? key})
      : super(key: key);

  @override
  State<CupertinoInfoHoldingsAddCard> createState() =>
      _CupertinoInfoHoldingsAddCardState();
}

class _CupertinoInfoHoldingsAddCardState
    extends State<CupertinoInfoHoldingsAddCard> {
  bool isBuySelected = true;
  bool isInitialized = false;
  double priceSelected = 0.0;
  int amountSelected = 1;
  final priceController = TextEditingController();
  final amountController = TextEditingController();

  void _onBuySellButtonPress(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (amountSelected == 0) {
      _showAmountZeroDialog(context);
      return;
    }
    if (widget.holdingsProvider.containsTicker(widget.ticker)) {
      widget.holdingsProvider.updateTicker(
        data: HoldingsTicker(
          ticker: widget.ticker,
          amount: amountSelected,
          avgShareCost: priceSelected,
        ),
      );
    } else {
      widget.holdingsProvider.addTicker(
        data: HoldingsTicker(
          ticker: widget.ticker,
          amount: amountSelected,
          avgShareCost: priceSelected,
        ),
      );
    }
    setState(() {
      priceSelected = Provider.of<YahooPriceProvider>(context, listen: false)
          .getPriceData(widget.ticker)
          .currentMarketPrice;
      amountSelected = 1;
      amountController.text = amountSelected.toString();
      priceController.text = priceSelected.toStringAsFixed(2);
    });
  }

  void _showAmountZeroDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: const Text(
          'Please select an amount of shares that is greater than zero.',
          style: TextStyle(fontSize: 14),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      priceSelected = Provider.of<YahooPriceProvider>(context, listen: false)
          .getPriceData(widget.ticker)
          .currentMarketPrice;
      priceController.text = priceSelected.toStringAsFixed(2);
      amountController.text = amountSelected.toString();
      isInitialized = true;
    }
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
                              FocusManager.instance.primaryFocus?.unfocus();
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
                              FocusManager.instance.primaryFocus?.unfocus();
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
              Column(
                children: [
                  CupertinoTextFieldWithButtons(
                    onPlusPress: () {
                      setState(() {
                        priceSelected += 1;
                        priceController.text = priceSelected.toStringAsFixed(2);
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onMinusPress: () {
                      setState(() {
                        if (priceSelected >= 1) {
                          priceSelected -= 1;
                          priceController.text =
                              priceSelected.toStringAsFixed(2);
                        }
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    placeholder: priceSelected.toStringAsFixed(2),
                    controller: priceController,
                  ),
                  const SizedBox(height: 4),
                  CupertinoTextFieldWithButtons(
                    onPlusPress: () {
                      setState(() {
                        amountSelected += 1;
                        print(amountSelected);
                        amountController.text = amountSelected.toString();
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onMinusPress: () {
                      setState(() {
                        if (amountSelected >= 1) {
                          amountSelected -= 1;
                          amountController.text = amountSelected.toString();
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                      });
                    },
                    placeholder: amountSelected.toString(),
                    controller: amountController,
                  ),
                ],
              ),
              ProperButton(
                onPressed: () => _onBuySellButtonPress(context),
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
              onTap: widget.onMinusPress,
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
              onTap: widget.onPlusPress,
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
