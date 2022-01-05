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

  final double currentProgress = 0.8;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    startAnimation();
  }

  void startAnimation() {
    Future.delayed(const Duration(milliseconds: 300))
        .whenComplete(() => _animationController.forward());
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
          body: Column(
        children: [
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Current Hydration",
              style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary),
              textAlign: TextAlign.center,
            ),
          ),
          const Expanded(
            flex: 2,
            child: AnimatedWaterProgress(),
          ),
          Expanded(
              flex: 1,
              child: CupList(
                animation: _animationController,
              )),
          const Spacer(),
        ],
      )),
    );
  }
}
