import 'dart:math';

import 'package:drink_reminder/features/hydration_reminder/presentation/provider/drink_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedAddDrinkButton extends StatefulWidget {
  const AnimatedAddDrinkButton({Key? key}) : super(key: key);

  @override
  _AnimatedAddDrinkButtonState createState() => _AnimatedAddDrinkButtonState();
}

class _AnimatedAddDrinkButtonState extends State<AnimatedAddDrinkButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _animationController2;
  late Animation<double> _addDrinkAnimation;
  late Animation<double> _addDrinkAnimationOpacity;
  late Animation<double> _animation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animationController2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _addDrinkAnimationOpacity = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween<double>(
            begin: 0,
            end: 1,
          ),
          weight: 50),
      TweenSequenceItem(
          tween: Tween<double>(
            begin: 1,
            end: 0,
          ),
          weight: 50),
    ]).animate(
        CurvedAnimation(parent: _animationController2, curve: Curves.ease));

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCubic));
    _addDrinkAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController2, curve: Curves.ease));
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1, curve: Curves.ease)));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrinkModel>(
      builder: (context, value, child) => InkWell(
        onTap: () {
          if (!value.isAddButtonExpanded) {
            value.updateDrink(value.selectedCup.capacity);
            _animationController2.reset();
            _animationController2.forward();
          } else {
            value.toggleIsAddButtonExpanded();
            _animationController.reverse();
          }
        },
        onLongPress: () {
          if (!value.isAddButtonExpanded) {
            value.toggleIsAddButtonExpanded();
            _animationController.forward();
          }
        },
        customBorder: const CircleBorder(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          height: value.isAddButtonExpanded ? 220 : 80,
          width: value.isAddButtonExpanded ? 220 : 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withOpacity(0.5)),
          child: LayoutBuilder(
            builder: (context, constraints) => AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..rotateZ(_animation.value * pi / 4),
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: value.isAddButtonExpanded
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add_rounded,
                            size: 36,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..rotateZ((1 - _animation.value) * -pi / 2),
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: Stack(
                          children: [
                            Positioned(
                              left: constraints.minHeight / 2,
                              right: 0,
                              top: 16,
                              child: AbsorbPointer(
                                absorbing: !value.isAddButtonExpanded,
                                child: GestureDetector(
                                  onTap: () {
                                    value.undo();
                                    value.toggleIsAddButtonExpanded();
                                    _animationController.reverse();
                                  },
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.undo,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      Text(
                                        "Undo",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 16,
                              child: AbsorbPointer(
                                absorbing: !value.isAddButtonExpanded,
                                child: GestureDetector(
                                  onTap: () {
                                    value.reset();
                                    value.toggleIsAddButtonExpanded();
                                    _animationController.reverse();
                                  },
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.restore_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      Text(
                                        "Reset",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: AnimatedBuilder(
                      animation: _addDrinkAnimation,
                      builder: (context, child) => Transform(
                          transform: Matrix4.identity()
                            ..translate(0.0, _addDrinkAnimation.value * -100.0),
                          child: Opacity(
                            opacity: _addDrinkAnimationOpacity.value,
                            child: child,
                          )),
                      child: Text(
                          "+${context.read<DrinkModel>().selectedCup.capacity} ml",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
