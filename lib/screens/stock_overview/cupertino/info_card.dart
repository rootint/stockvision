import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/screens/stock_overview/constants.dart';

class CupertinoInfoCard extends StatelessWidget {
  final String title;
  final IconData titleIcon;
  final double innerHeight;
  final double width;
  final RowPosition rowPosition;
  final Widget child;
  final bool isSquare;
  const CupertinoInfoCard({
    required this.title,
    required this.titleIcon,
    required this.rowPosition,
    required this.child,
    this.innerHeight = 150,
    this.isSquare = false,
    this.width = double.infinity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding;
    switch (rowPosition) {
      case RowPosition.left:
        padding = const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 2.0);
        break;
      case RowPosition.right:
        padding = const EdgeInsets.fromLTRB(0.0, 10.0, 12.0, 2.0);
        break;
      case RowPosition.center:
        padding = const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 2.0);
        break;
    }

    return (isSquare)
        ? AspectRatio(
            aspectRatio: 1.05,
            child: Padding(
              padding: padding,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: CupertinoColors.darkBackgroundGray,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13.0, vertical: 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            titleIcon,
                            color: CupertinoColors.systemGrey.withOpacity(0.55),
                            size: 12,
                          ),
                          Text(
                            ' $title',
                            style: TextStyle(
                              color: CupertinoColors.inactiveGray
                                  .withOpacity(0.55),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: child),
                      // child,
                    ],
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: padding,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: CupertinoColors.darkBackgroundGray,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13.0, vertical: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          titleIcon,
                          color: CupertinoColors.systemGrey.withOpacity(0.55),
                          size: 12,
                        ),
                        Text(
                          ' $title',
                          style: TextStyle(
                            color:
                                CupertinoColors.inactiveGray.withOpacity(0.55),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: innerHeight,
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
