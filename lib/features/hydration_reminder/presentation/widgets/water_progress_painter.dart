import 'dart:math';
import 'dart:ui' as ui;

import 'package:drink_reminder/common/colors.dart';
import 'package:flutter/material.dart';

class WaterProgressPainter extends CustomPainter {
  final double percentage;

  WaterProgressPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
              colors: [MyColor.blueColor.withOpacity(0.1), MyColor.blueColor],
              startAngle: 3 * pi / 2,
              endAngle: 7 * pi / 2,
              tileMode: ui.TileMode.repeated,
              stops: const [0.01, 0.5])
          .createShader(Rect.fromCircle(center: center, radius: radius));

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round
      ..color = MyColor.blueColor.withOpacity(0.05);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + pi / 14, (2 * pi - 2 * pi / 14), false, backgroundPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + pi / 14, (2 * pi - 2 * pi / 14) * percentage, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
