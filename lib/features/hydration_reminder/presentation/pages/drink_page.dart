import 'dart:math';

import 'package:drink_reminder/common/colors.dart';
import 'package:drink_reminder/common/styles.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/provider/drink_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrinkPage extends StatefulWidget {
  const DrinkPage({Key? key}) : super(key: key);

  @override
  _DrinkPageState createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DrinkModel>(context);
    _animationController.forward();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: FadeTransition(
                opacity: _animation,
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: Consumer<DrinkModel>(builder: (context, value, child) {
                    return Wave(
                      currentDrink: value.currentDrink,
                      drinkTarget: value.drinkTarget,
                    );
                  }),
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _animation,
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: GestureDetector(
                    onTap: () {
                      provider.updateDrink(200);
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 150,
                left: 0,
                right: 0,
                child: Consumer<DrinkModel>(
                  builder: (context, value, child) => AnimatedWaterValue(
                    animation: _animation,
                    drinkTarget: value.drinkTarget,
                    currentDrink: value.currentDrink,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class AnimatedWaterValue extends AnimatedWidget {
  const AnimatedWaterValue(
      {Key? key,
      required this.animation,
      required this.drinkTarget,
      required this.currentDrink})
      : super(key: key, listenable: animation);

  final Animation<double> animation;
  final int drinkTarget;
  final int currentDrink;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${(animation.value * drinkTarget).toInt()} ml",
          style: MyStyles.extraLarge,
        ),
        Text(
          "Remaining: ${drinkTarget - currentDrink} ml",
          style: const TextStyle(
              color: MyColor.blackColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: "OpenSans"),
        ),
      ],
    );
  }
}

class Wave extends StatefulWidget {
  const Wave({Key? key, required this.currentDrink, required this.drinkTarget})
      : super(key: key);
  final int currentDrink;
  final int drinkTarget;

  @override
  _WaveState createState() => _WaveState();
}

class _WaveState extends State<Wave> with TickerProviderStateMixin {
  late AnimationController _animationController1;
  late AnimationController _animationController2;
  late AnimationController _animationController3;
  late List<Offset> _points;
  late double _percentage;

  @override
  void initState() {
    super.initState();
    _animationController1 = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 10000),
        upperBound: 2 * pi);

    _animationController2 = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 9000),
        upperBound: 2 * pi);

    _animationController3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    startAnimation();
  }

  @override
  void dispose() {
    _animationController1.dispose();
    _animationController2.dispose();
    _animationController3.dispose();
    super.dispose();
  }

  void startAnimation() {
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      _animationController1.repeat();
      _animationController2.repeat();
      _animationController3.forward();
    });
  }

  List<Offset> initPoints() {
    List<Offset> points = [];
    for (int i = 0; i < MediaQuery.of(context).size.width.toInt(); i++) {
      double x = i.toDouble();
      double y = 0;

      points.add(Offset(x, y));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    _points = initPoints();
    _percentage = widget.currentDrink / widget.drinkTarget;
    final _screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        AnimatedBuilder(
            animation: _animationController1,
            builder: (context, _) {
              return ClipPath(
                clipper: WaveClipper(_animationController1.value, _points),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.ease,
                  height: (_percentage == 0)
                      ? _screenSize.height * 0.05
                      : _screenSize.height * _percentage +
                          _screenSize.height * 0.05,
                  decoration: BoxDecoration(
                    color: MyColor.primaryColor.withOpacity(0.4),
                  ),
                ),
              );
            }),
        AnimatedBuilder(
            animation: _animationController2,
            builder: (context, _) {
              return ClipPath(
                clipper: WaveClipper(_animationController2.value - 5, _points),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.ease,
                  height: (_percentage == 0)
                      ? _screenSize.height * 0.05
                      : _screenSize.height * _percentage +
                          _screenSize.height * 0.05,
                  decoration: BoxDecoration(
                    color: MyColor.primaryColor.withOpacity(0.4),
                  ),
                ),
              );
            }),
        Positioned(
          left: 20,
          top: 40,
          child: AnimatedBuilder(
              animation: _animationController3,
              builder: (context, child) {
                return Row(
                  children: [
                    const Icon(
                      Icons.arrow_right_rounded,
                      size: 30,
                      color: MyColor.blueColor,
                    ),
                    Text(
                      "${(_animationController3.value * _percentage * 100).toInt()}%",
                      style: MyStyles.extraLarge.copyWith(fontSize: 36),
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double _value;
  final List<Offset> _wavePoints;

  WaveClipper(this._value, this._wavePoints);

  @override
  getClip(Size size) {
    final clippedPath = Path();
    _makeSinWave(size);
    clippedPath.addPolygon(_wavePoints, false);
    clippedPath.lineTo(size.width, size.height);
    clippedPath.lineTo(0, size.height);
    clippedPath.close();

    return clippedPath;
  }

  void _makeSinWave(Size size) {
    const double amplitude = 30;

    for (var x = 0; x < size.width - 1; x++) {
      double y = amplitude * sin(x * 0.015 - _value) + 50;
      Offset newOffset = Offset(x.toDouble(), y);
      _wavePoints[x] = newOffset;
    }
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
