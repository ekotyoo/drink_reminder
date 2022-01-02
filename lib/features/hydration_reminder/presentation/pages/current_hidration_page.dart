import 'package:drink_reminder/common/styles.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/widgets/animated_water_progress.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/widgets/cup_list.dart';
import 'package:flutter/material.dart';

class CurrentHidrationPage extends StatefulWidget {
  const CurrentHidrationPage({Key? key}) : super(key: key);

  @override
  State<CurrentHidrationPage> createState() => _CurrentHidrationPageState();
}

class _CurrentHidrationPageState extends State<CurrentHidrationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  final double currentProgress = 0.8;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _progressAnimation = Tween<double>(begin: 0, end: currentProgress).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));

    Future.delayed(const Duration(milliseconds: 300))
        .then((value) => _animationController.forward());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Current Hydration",
                  style: MyStyles.heading,
                  textAlign: TextAlign.center,
                ),
              ),
              // const SizedBox(height: 100),
              Expanded(
                flex: 2,
                child: AnimatedWaterProgress(
                  animation: _progressAnimation,
                ),
              ),
              Expanded(
                  flex: 1,
                  child: CupList(
                    animation: _animationController,
                  )),
              const SizedBox(height: 100),
            ],
          )),
    );
  }
}
