import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/constants.dart';

class AnalyticsPainter extends CustomPainter {
  final double rating;
  final Size size;

  AnalyticsPainter({
    required this.rating,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size _) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = kRedColor
      ..shader = ui.Gradient.linear(
        Offset(-size.width / 2 + 15, size.height / 2),
        Offset(size.width / 2 - 15, size.height / 2),
        [
          kRedColor,
          kSecondaryColor,
          kGreenColor,
          kPrimaryColor,
        ],
        [0, 0.25, 0.75, 1],
      );
    const double topPadding = 9;
    final radius = size.width / 2.5;
    const endAngle = math.pi / 6;
    canvas.drawArc(Rect.fromCircle(center: Offset(0, topPadding), radius: radius),
        math.pi / 6, -math.pi * 4 / 3, false, paint);
    canvas.drawCircle(
        Offset(
            (radius) * math.cos(endAngle), topPadding + (radius) * math.sin(endAngle)),
        0.001,
        paint);
    canvas.drawCircle(
        Offset((radius) * math.cos(endAngle - math.pi * 4 / 3),
            topPadding + (radius) * math.sin(endAngle - math.pi * 4 / 3)),
        0.001,
        paint);

    final targetX =
        radius * math.cos((rating - 1) * 4 / 9 * math.pi - math.pi / 6);
    final targetY =
        radius * -math.sin((rating - 1) * 4 / 9 * math.pi - math.pi / 6);
    final indicatorPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..color = CupertinoColors.white;

    canvas.drawLine(
      Offset(targetX * 0.9, targetY * 0.9 + topPadding),
      Offset(targetX * 1.1, targetY * 1.1 + topPadding),
      indicatorPaint,
    );
    canvas.drawCircle(
        Offset(targetX * 0.9, targetY * 0.9 + topPadding), 0.001, indicatorPaint);
    canvas.drawCircle(
        Offset(targetX * 1.1, targetY * 1.1 + topPadding), 0.001, indicatorPaint);
  }

  @override
  bool shouldRepaint(AnalyticsPainter oldDelegate) {
    return false;
  }
}
