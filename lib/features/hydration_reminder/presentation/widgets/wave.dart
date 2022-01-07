import 'dart:math';

import 'package:flutter/material.dart';

class Wave extends StatefulWidget {
  const Wave({Key? key, required this.percentage}) : super(key: key);
  final double percentage;

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
    super.initState();
  }

  @override
  void dispose() {
    _animationController1.dispose();
    _animationController2.dispose();
    _animationController3.dispose();
    super.dispose();
  }

  void startAnimation() {
    Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
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
    _percentage = widget.percentage;
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
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
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
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
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
                    Icon(
                      Icons.arrow_right_rounded,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(
                      "${(_animationController3.value * _percentage * 100).toInt()}%",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary),
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
