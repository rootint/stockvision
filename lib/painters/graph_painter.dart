import 'dart:math';
import 'dart:ui' as ui;
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
  final double animationValue;
  final bool loading;
  final bool opened;
  final double sliderPosition;

  GraphPainter({
    required this.points,
    required this.high,
    required this.low,
    required this.maxSize,
    required this.containerSize,
    required this.timestampEnd,
    required this.timestampStart,
    required this.currentTimestamp,
    required this.previousClose,
    required this.lastClosePrice,
    required this.timeframe,
    required this.animationValue,
    this.loading = false,
    this.opened = true,
    this.sliderPosition = double.infinity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    late Paint paint;

    high = max(high, previousClose);
    low = min(low, previousClose);
    final double avg = (high + low) / 2;
    double scaleFactor = (containerSize.height - 10) / (high - low);
    final double previousCloseY =
        containerSize.height - (previousClose - low) * scaleFactor;

    if (opened) {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..color = (lastClosePrice > previousClose) ? kGreenColor : kRedColor
        ..shader = ui.Gradient.linear(
          Offset(maxSize.width / 2, previousCloseY - 5),
          Offset(maxSize.width / 2, previousCloseY + 5),
          [
            kGreenColor,
            kRedColor,
          ],
        );
    } else {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..color = (lastClosePrice > previousClose)
            ? kGreenColor.withOpacity(0.65)
            : kRedColor.withOpacity(0.65)
        ..shader = ui.Gradient.linear(
          Offset(maxSize.width / 2, previousCloseY - 5),
          Offset(maxSize.width / 2, previousCloseY + 5),
          [
            kGreenColor,
            kRedColor,
          ],
        );
    }
    final lastClosePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = CupertinoColors.systemGrey.withAlpha((animationValue * 255).toInt());

    // ..shader = ui.Gradient.linear(
    //   Offset(maxSize.width / 2, 50),
    //   Offset(maxSize.width / 2, maxSize.height - 50),
    //   [
    //     kGreenColor,
    //     kRedColor,
    //   ],
    // );
    final lineY = maxSize.height / 2;
    if (loading) {
      canvas.drawLine(
        Offset(0, containerSize.height / 2),
        Offset(containerSize.width, containerSize.height / 2),
        paint,
      );
    }
    double currentWidth;
    // print(' ${currentTimestamp / 1000} $timestampStart');
    // print(DateTime.fromMillisecondsSinceEpoch(timestampEnd * 1000));
    // print(DateTime.fromMillisecondsSinceEpoch(timestampStart * 1000));
    // int tS = timestampStart;
    // // print(timestampEnd - timestampStart);
    // if (timestampEnd - timestampStart > 86400) {
    //   tS += 86400;
    // }
    // if (timeframe == '1D') {
    //   high = max(high, previousClose);
    //   low = min(low, previousClose);
    //   if ((currentTimestamp / 1000) < tS ||
    //       (currentTimestamp / 1000) > timestampEnd) {
    //     currentWidth = maxSize.width;
    //   } else {
    //     currentWidth = maxSize.width *
    //         ((currentTimestamp / 1000 - tS) / (timestampEnd - tS));
    //   }
    // } else {
    //   currentWidth = maxSize.width;
    // }
    // high -= 10;
    // fix padding (22)
    // double dx = (maxSize.width - 22) / (points!.chartQuotes!.low!.length);

    // fix intramarket bug
    // double dx = (currentWidth) / (points.length);
    double dx = maxSize.width / points.length;

    // double prevY = containerSize.height - (points[0] - low) * scaleFactor;

    double prevY = lineY - ((points[0] - avg) * scaleFactor) * animationValue;
    for (int i = 0; i < points.length; i++) {
      if (dx * i < containerSize.width) {
        double currentY =
            (lineY + 5) - ((points[i] - avg) * scaleFactor) * animationValue;
        // double currentY = containerSize.height - (points[i] - low) * scaleFactor;
        canvas.drawLine(
          Offset((dx * i), currentY),
          Offset(dx * (i - 1), prevY),
          paint,
        );
        prevY = currentY;
      }
    }
    canvas.drawLine(
      Offset(maxSize.width, prevY),
      Offset(maxSize.width - dx, prevY),
      paint,
    );
    int prevI = -8;
    for (int i = 0; i < containerSize.width; i += 8) {
      canvas.drawLine(Offset(prevI.toDouble() + 6, previousCloseY),
          Offset(i.toDouble(), previousCloseY), lastClosePaint);
      prevI = i;
    }
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) {
    return oldDelegate.animationValue != 1.0;
  }
}
