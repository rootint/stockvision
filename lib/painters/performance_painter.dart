import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/models/yahoo_models/chart_data.dart';

class PerformancePainter extends CustomPainter {
  final YahooHelperChartData tickerData;
  final YahooHelperChartData sAndPData;
  final Size containerSize;
  final double leftPadding;

  PerformancePainter({
    required this.containerSize,
    required this.leftPadding,
    required this.sAndPData,
    required this.tickerData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (tickerData.close.isNotEmpty && sAndPData.close.isNotEmpty) {
      final bool sAndPIncreasing =
          sAndPData.close[0] < sAndPData.close[sAndPData.close.length - 1];
      final bool tickerIncreasing =
          tickerData.close[0] < tickerData.close[tickerData.close.length - 1];
      final sAndPPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = kPrimaryColor;
      final tickerPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = kGreenColor;

      final sAndPLow = sAndPData.close.reduce(math.min);
      final sAndPHigh = sAndPData.close.reduce(math.max);
      final tickerLow = tickerData.close.reduce(math.min);
      final tickerHigh = tickerData.close.reduce(math.max);

      final sAndPPercentage = (sAndPHigh - sAndPLow) / sAndPLow;
      final tickerPercentage = (tickerHigh - tickerLow) / tickerLow;

      final maxPercentage = math.max(sAndPPercentage, tickerPercentage);

      final sAndPScaleFactor = (containerSize.height - 10) /
          (sAndPHigh - sAndPLow) *
          sAndPPercentage /
          maxPercentage;
      final tickerScaleFactor = (containerSize.height - 10) /
          (tickerHigh - tickerLow) *
          tickerPercentage /
          maxPercentage;

      final dx = (containerSize.width + leftPadding / 2) / sAndPData.close.length;
      double prevTickerY = containerSize.height -
          (tickerData.close[0] - tickerLow) * tickerScaleFactor;
      double prevSAndPY = containerSize.height -
          (sAndPData.close[0] - sAndPLow) * sAndPScaleFactor;
      print(dx.toString() + " " + sAndPScaleFactor.toString());
      for (int i = 0; i < sAndPData.close.length; i++) {
        if (dx * i < containerSize.width) {
          final tickerY = containerSize.height -
              (tickerData.close[i] - tickerLow) * tickerScaleFactor;
          final sAndPY = containerSize.height -
              (sAndPData.close[i] - sAndPLow) * sAndPScaleFactor;
          canvas.drawLine(
            Offset((dx * i - leftPadding / 2), tickerY),
            Offset(dx * (i - 1) - leftPadding / 2, prevTickerY),
            tickerPaint,
          );
          canvas.drawLine(
            Offset((dx * i)- leftPadding / 2, sAndPY),
            Offset(dx * (i - 1) - leftPadding / 2, prevSAndPY),
            sAndPPaint,
          );
          prevTickerY = tickerY;
          prevSAndPY = sAndPY;
        }
      }
      canvas.drawLine(
        Offset(containerSize.width, prevTickerY),
        Offset(containerSize.width - dx, prevTickerY),
        tickerPaint,
      );
      canvas.drawLine(
        Offset(containerSize.width, prevSAndPY),
        Offset(containerSize.width - dx, prevSAndPY),
        sAndPPaint,
      );
    }
  }

  @override
  bool shouldRepaint(PerformancePainter oldDelegate) {
    return false;
  }
}
