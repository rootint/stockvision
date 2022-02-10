import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/painters/graph_painter.dart';

class CupertinoDashboardGraphCard extends StatefulWidget {
  final double height;
  const CupertinoDashboardGraphCard({
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  _CupertinoDashboardGraphCardState createState() =>
      _CupertinoDashboardGraphCardState();
}

class _CupertinoDashboardGraphCardState
    extends State<CupertinoDashboardGraphCard> with TickerProviderStateMixin {
  final List<String> availableTimeframes = [
    "1D",
    "5D",
    "1M",
    "6M",
    "1Y",
    "5Y",
    "MAX"
  ];
  String selectedTimeframe = "1D";
  final mainTicker = "^IXIC";
  // temporary
  final aiTicker = "TSLA";

  late Animation<double> graphAnimation;
  late AnimationController graphAnimationController;

  void initAnimation() {
    graphAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      // duration: const Duration(milliseconds: 50),
      vsync: this,
    );

    Tween<double> _graphTween = Tween(begin: 0.0, end: 1.0);

    graphAnimation = _graphTween.animate(CurvedAnimation(
        parent: graphAnimationController, curve: Curves.easeInOutSine));
  }

  void changeTimeframe(String timeframe) {
    setState(() {
      selectedTimeframe = timeframe;
    });
  }

  @override
  void initState() {
    super.initState();
    initAnimation();
  }

  @override
  void dispose() {
    graphAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: widget.height,
      width: mediaQuery.size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              color: CupertinoColors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Row(
                      children: [
                        Text("Nasdaq"),
                        Text("0.00%"),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class TimeframeCard extends StatelessWidget {
  final String text;
  final MediaQueryData mediaQuery;
  final Function(String) changeTimeframe;
  final bool selected;
  final bool isDarkMode;
  const TimeframeCard(this.text, this.mediaQuery, this.selected,
      this.changeTimeframe, this.isDarkMode,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!selected) {
          changeTimeframe(text);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          // play with colors
          color: selected ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(10),
          border: isDarkMode ? null : Border.all(color: Colors.grey.shade600),
        ),
        curve: Curves.easeIn,
        child: SizedBox(
          width: mediaQuery.size.width / 9,
          height: 27,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected
                    ? Colors.white
                    : isDarkMode
                        ? Colors.white
                        : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
