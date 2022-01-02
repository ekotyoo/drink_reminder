import 'dart:math';

import 'package:drink_reminder/common/colors.dart';
import 'package:drink_reminder/common/styles.dart';
import 'package:flutter/material.dart';

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
    _offsetAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: const Wave(),
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              left: 0,
              right: 0,
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
            Positioned(
                top: 150,
                left: 0,
                right: 0,
                child: AnimatedWaterValue(
                  animation: _animation,
                )),
          ],
        ),
      ),
    );
  }
}

class AnimatedWaterValue extends AnimatedWidget {
  const AnimatedWaterValue({Key? key, required this.animation})
      : super(key: key, listenable: animation);

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${(animation.value * 1290).toInt()} ml",
          style: MyStyles.extraLarge,
        ),
        const Text(
          "Remaining: 603 ml",
          style: TextStyle(
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
  const Wave({Key? key}) : super(key: key);

  @override
  _WaveState createState() => _WaveState();
}

class _WaveState extends State<Wave> with TickerProviderStateMixin {
  late AnimationController _animationController1;
  late AnimationController _animationController2;
  late List<Offset> _points;

  @override
  void initState() {
    _animationController1 = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 10000),
        upperBound: 2 * pi);

    _animationController2 = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 9000),
        upperBound: 2 * pi);

    _animationController1.repeat();
    _animationController2.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController1.dispose();
    _animationController2.dispose();
    super.dispose();
  }

  List<Offset> initPoints() {
    List<Offset> points = [];
    Random r = Random();
    for (int i = 0; i < MediaQuery.of(context).size.width.toInt(); i++) {
      double x = i.toDouble();

      // Set this point's y-coordinate to a random value
      // no greater than 80% of the container's height
      double y = 0;

      points.add(Offset(x, y));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    _points = initPoints();
    return Stack(
      children: [
        AnimatedBuilder(
            animation: _animationController1,
            builder: (context, _) {
              return ClipPath(
                clipper: WaveClipper(_animationController1.value, _points),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
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
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: MyColor.primaryColor.withOpacity(0.4),
                  ),
                ),
              );
            }),
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  double _value;
  List<Offset> _wavePoints;

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
    final double amplitude = size.height / 10;
    final yOffset = amplitude;

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
