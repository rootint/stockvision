import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stockadvisor/constants.dart';

class GraphPainter extends CustomPainter {
  final List<double> points;
  double high;
  double low;
  final Size maxSize;
  final Size containerSize;
  final int timestampStart;
  final int timestampEnd;
  final int currentTimestamp;
  final double previousClose;
  final double lastClosePrice;
  final String timeframe;

  GraphPainter(
      {required this.points,
      required this.high,
      required this.low,
      required this.maxSize,
      required this.containerSize,
      required this.timestampEnd,
      required this.timestampStart,
      required this.currentTimestamp,
      required this.previousClose,
      required this.lastClosePrice,
      required this.timeframe});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = (lastClosePrice > previousClose) ? kGreenColor : kRedColor;
    final lastClosePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = kSecondaryColor;
    double currentWidth;
    if (timeframe == '1D') {
      high = max(high, previousClose);
      low = min(low, previousClose);
      if ((currentTimestamp / 1000) < timestampStart ||
          (currentTimestamp / 1000) > timestampEnd) {
        currentWidth = maxSize.width;
      } else {
        currentWidth = maxSize.width *
            ((currentTimestamp / 1000 - timestampStart) /
                (timestampEnd - timestampStart));
      }
    } else {
      currentWidth = maxSize.width;
    }
    print('called');
    // high -= 10;
    // fix padding (22)
    // double dx = (maxSize.width - 22) / (points!.chartQuotes!.low!.length);

    // fix intramarket bug

    // print(' ${currentTimestamp / 1000} $timestampStart');
    // print(DateTime.fromMillisecondsSinceEpoch(timestampEnd * 1000));
    // print(DateTime.fromMillisecondsSinceEpoch(timestampStart * 1000));
    double dx = (currentWidth) / (points.length);
    double scaleFactor = (containerSize.height - 10) / (high - low);
    double prevY = containerSize.height - (points[0] - low) * scaleFactor;
    // print('$high $low $prevY $previousClose');
    final double previousCloseY =
        containerSize.height - (previousClose - low) * scaleFactor;
    for (int i = 0; i < points.length; i++) {
      if (dx * i < containerSize.width) {
        double currentY =
            containerSize.height - (points[i] - low) * scaleFactor;
        canvas.drawLine(
          Offset((dx * i), currentY),
          Offset(dx * (i - 1), prevY),
          paint,
        );
        // if (i % 9 == 0 && timeframe == '1D') {
        //   canvas.drawLine(
        //       Offset((containerSize.width / points.length) * i, previousCloseY),
        //       Offset((containerSize.width / points.length) * (i - 6),
        //           previousCloseY),
        //       lastClosePaint);
        // }
        prevY = currentY;
      }
    }
    // canvas.drawLine(
    //     Offset(containerSize.width, previousCloseY),
    //     Offset(containerSize.width - points.length % 5, previousCloseY),
    //     lastClosePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // check if it is true or false
    return false;
  }
}
