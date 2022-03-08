import 'dart:math';
import 'package:flutter/cupertino.dart';
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
  // final double 

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
      ..color = CupertinoColors.systemGrey;
    final lineY = maxSize.height / 2;
    double currentWidth;
    // print(' ${currentTimestamp / 1000} $timestampStart');
    // print(DateTime.fromMillisecondsSinceEpoch(timestampEnd * 1000));
    // print(DateTime.fromMillisecondsSinceEpoch(timestampStart * 1000));
    int tS = timestampStart;
    // print(timestampEnd - timestampStart);
    if (timestampEnd - timestampStart > 86400) {
      tS += 86400;
    }
    if (timeframe == '1D') {
      high = max(high, previousClose);
      low = min(low, previousClose);
      if ((currentTimestamp / 1000) < tS ||
          (currentTimestamp / 1000) > timestampEnd) {
        currentWidth = maxSize.width;
      } else {
        currentWidth = maxSize.width *
            ((currentTimestamp / 1000 - tS) / (timestampEnd - tS));
      }
    } else {
      currentWidth = maxSize.width;
    }
    // high -= 10;
    // fix padding (22)
    // double dx = (maxSize.width - 22) / (points!.chartQuotes!.low!.length);

    // fix intramarket bug

    double dx = (currentWidth) / (points.length);
    double scaleFactor = (containerSize.height - 10) / (high - low);
    double prevY = containerSize.height - (points[0] - low) * scaleFactor;
    // print('$high $low $prevY $previousClose');
    final double previousCloseY =
        containerSize.height - (previousClose - low) * scaleFactor;
    for (int i = 0; i < points.length; i++) {
      if (dx * i < containerSize.width) {
        // double currentY =
        //     containerSize.height - (points[i] - low) * scaleFactor;

        canvas.drawLine(
          Offset((dx * i), lineY),
          Offset(dx * (i - 1), lineY),
          paint,
        );
        prevY = currentY;
      }
    }
    int prevI = -7;
    for (int i = 0; i < containerSize.width; i += 15) {
      canvas.drawLine(Offset(prevI.toDouble() + 7, previousCloseY),
          Offset(i.toDouble(), previousCloseY), lastClosePaint);
      prevI = i;
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
