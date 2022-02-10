import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/constants.dart';

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
            color: CupertinoColors.darkBackgroundGray,
            child: Column(
              children: [
                Text("Your Holdings")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
