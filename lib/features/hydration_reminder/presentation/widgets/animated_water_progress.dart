import 'dart:math';
import 'dart:ui' as ui;

import 'package:drink_reminder/features/hydration_reminder/presentation/provider/hydration_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedWaterProgress extends StatefulWidget {
  const AnimatedWaterProgress({Key? key}) : super(key: key);

  @override
  State<AnimatedWaterProgress> createState() => _AnimatedWaterProgressState();
}

class _AnimatedWaterProgressState extends State<AnimatedWaterProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late HydrationChangeNotifier _provider;

  @override
  void initState() {
    _provider = context.read<HydrationChangeNotifier>();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
    startAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void startAnimation() {
    Future.delayed(const Duration(milliseconds: 300))
        .whenComplete(() => _animationController.forward());
  }

  @override
  Widget build(BuildContext context) {
    final _percentage = _provider.isCompleted
        ? 1
        : _provider.currentDrink / _provider.drinkTarget;
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: WaterProgressPainter(
                percentage: _animation.value * _percentage,
                color: Theme.of(context).primaryColor),
            child: WaterProgress(
              percentage: _animation.value * _percentage,
            ),
          );
        });
  }
}

class WaterProgress extends StatelessWidget {
  const WaterProgress({Key? key, required this.percentage}) : super(key: key);

  final double percentage;

  @override
  Widget build(BuildContext context) {
    final _provider = context.read<HydrationChangeNotifier>();
    return SizedBox(
      height: 240,
      width: 240,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PercentageValue(percentage: percentage),
            WaterDrinkValue(
                currentDrink: _provider.currentDrink,
                drinkTarget: _provider.drinkTarget),
            WaterRemainingValue(
              value: _provider.isCompleted
                  ? 0
                  : (_provider.drinkTarget - _provider.currentDrink).toInt(),
            ),
          ],
        ),
      ),
    );
  }
}

class WaterRemainingValue extends StatelessWidget {
  const WaterRemainingValue({Key? key, this.value = 0}) : super(key: key);

  final int value;

  @override
  Widget build(BuildContext context) {
    return Text(value == 0 ? "Goal Achieved!" : "-$value ml",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor));
  }
}

class WaterDrinkValue extends StatelessWidget {
  const WaterDrinkValue(
      {Key? key, required this.currentDrink, required this.drinkTarget})
      : super(key: key);

  final int currentDrink;
  final int drinkTarget;

  @override
  Widget build(BuildContext context) {
    return Text("$currentDrink / $drinkTarget ml",
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.w600,
            ));
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
    return Text("${(percentage * 100).toInt()}%",
        style: Theme.of(context).textTheme.headline3!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary));
  }
}

class WaterProgressPainter extends CustomPainter {
  final double percentage;
  final Color color;

  WaterProgressPainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
              colors: [color.withOpacity(0.1), color],
              startAngle: 3 * pi / 2,
              endAngle: 7 * pi / 2,
              tileMode: ui.TileMode.repeated,
              stops: const [0.01, 0.5])
          .createShader(Rect.fromCircle(center: center, radius: radius));

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round
      ..color = color.withOpacity(0.05);

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
