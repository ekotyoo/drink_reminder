import 'package:drink_reminder/common/styles.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/widgets/cup_list.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/widgets/water_progress.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/widgets/water_progress_painter.dart';
import 'package:flutter/material.dart';

class CurrentHidrationPage extends StatefulWidget {
  const CurrentHidrationPage({Key? key}) : super(key: key);

  @override
  State<CurrentHidrationPage> createState() => _CurrentHidrationPageState();
}

class _CurrentHidrationPageState extends State<CurrentHidrationPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  final double currentProgress = 0.50;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _progressAnimation = Tween<double>(begin: 0, end: currentProgress).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              const SizedBox(height: 60),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Current Hydration",
                  style: MyStyles.heading,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 60),
              AnimatedWaterProgress(
                animation: _progressAnimation,
              ),
              const SizedBox(height: 60),
              const CupList(),
            ],
          )),
    );
  }
}

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
