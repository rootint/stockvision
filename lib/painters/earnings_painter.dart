import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stockadvisor/constants.dart';

class EarningsPainter extends CustomPainter {
  final double high;
  final double low;
  final double estimate;
  final double actual;
  final Size containerSize;
  final bool current;

  EarningsPainter({
    required this.actual,
    required this.estimate,
    required this.high,
    required this.low,
    required this.containerSize,
    this.current = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final estimatePaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 6
      ..color = CupertinoColors.systemGrey4;

    final actualPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 6
      ..color = (estimate > actual) ? kRedColor : kGreenColor;

    final scaleFactor = containerSize.height / (high - low);

    if (estimate <= actual && !current) {
      canvas.drawCircle(Offset(4, containerSize.height), 3, actualPaint);
      canvas.drawLine(
          Offset(4, containerSize.height),
          Offset(4, containerSize.height - (actual - low) * scaleFactor),
          actualPaint);
      canvas.drawCircle(
          Offset(4, containerSize.height - (actual - low) * scaleFactor),
          3,
          actualPaint);
    }
    
    canvas.drawCircle(Offset(-4, containerSize.height), 3, estimatePaint);
    canvas.drawLine(
        Offset(-4, containerSize.height),
        Offset(-4, containerSize.height - (estimate - low) * scaleFactor),
        estimatePaint);
    canvas.drawCircle(
      Offset(-4, containerSize.height - (estimate - low) * scaleFactor),
      3,
      estimatePaint,
    );

    if (estimate > actual && !current) {
      canvas.drawCircle(Offset(4, containerSize.height), 3, actualPaint);
      canvas.drawLine(
          Offset(4, containerSize.height),
          Offset(4, containerSize.height - (actual - low) * scaleFactor),
          actualPaint);
      canvas.drawCircle(
          Offset(4, containerSize.height - (actual - low) * scaleFactor),
          3,
          actualPaint);
    }
  }

  @override
  bool shouldRepaint(EarningsPainter oldDelegate) {
    return false;
  }
}
