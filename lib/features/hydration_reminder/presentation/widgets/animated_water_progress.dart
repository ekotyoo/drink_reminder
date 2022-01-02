import 'dart:math';
import 'dart:ui' as ui;

import 'package:drink_reminder/common/colors.dart';
import 'package:drink_reminder/common/styles.dart';
import 'package:flutter/material.dart';

class AnimatedWaterProgress extends AnimatedWidget {
  const AnimatedWaterProgress({Key? key, required this.animation})
      : super(key: key, listenable: animation);

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaterProgressPainter(percentage: animation.value),
      child: WaterProgress(
        percentage: animation.value,
      ),
    );
  }
}

class WaterProgress extends StatelessWidget {
  const WaterProgress({Key? key, required this.percentage}) : super(key: key);

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: 240,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PercentageValue(percentage: percentage),
            const WaterDrinkValue(),
            const WaterRemainingValue(),
          ],
        ),
      ),
    );
  }
}

class WaterRemainingValue extends StatelessWidget {
  const WaterRemainingValue({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "-600 ml",
      style: TextStyle(
          fontSize: 12,
          fontFamily: "OpenSans",
          fontWeight: FontWeight.w400,
          color: Colors.grey),
    );
  }
}

class WaterDrinkValue extends StatelessWidget {
  const WaterDrinkValue({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "1290 ml",
      style: TextStyle(
          fontSize: 16,
          fontFamily: "OpenSans",
          fontWeight: FontWeight.w500,
          color: MyColor.blackColor),
    );
  }
}

class PercentageValue extends StatelessWidget {
  const PercentageValue({
    Key? key,
    required this.percentage,
  }) : super(key: key);

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${(percentage * 100).toInt()}%",
      style: MyStyles.extraLarge,
    );
  }
}

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
