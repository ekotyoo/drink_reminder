import 'dart:math';

import 'package:drink_reminder/common/theme.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/provider/drink_model.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/widgets/wave.dart';
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DrinkModel>(context);
    _animationController.forward();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<MyTheme>(
              builder: (context, provider, child) => Switch(
                value: provider.isDarkTheme ? true : false,
                onChanged: (value) {
                  provider.setTheme(value);
                },
              ),
            ),
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
                  child: Consumer<DrinkModel>(
                    builder: (context, value, child) => InkWell(
                      onTap: () {
                        if (!provider.isAddButtonLongPressed) {
                          provider.updateDrink(200);
                        } else {
                          provider.toggleIsAddButtonLongPressed();
                        }
                      },
                      onLongPress: () {
                        provider.toggleIsAddButtonLongPressed();
                      },
                      customBorder: const CircleBorder(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutQuad,
                        height: value.isAddButtonLongPressed ? 220 : 80,
                        width: value.isAddButtonLongPressed ? 220 : 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.5)),
                        child: LayoutBuilder(
                          builder: (context, constraints) => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.ease,
                            transitionBuilder: (child, animation) {
                              return RotationTransition(
                                turns: animation.drive(Tween(begin: 0, end: 1)),
                                alignment: Alignment.center,
                                child: FadeTransition(
                                    opacity: animation, child: child),
                              );
                            },
                            child: value.isAddButtonLongPressed
                                ? Stack(
                                    children: [
                                      Positioned(
                                        top: 0 + 20,
                                        left: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            provider.undo();
                                            provider
                                                .toggleIsAddButtonLongPressed();
                                          },
                                          child: Column(
                                            children: const [
                                              Icon(Icons.undo),
                                              Text("Undo")
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0 + 20,
                                        left: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            provider.reset();
                                            provider
                                                .toggleIsAddButtonLongPressed();
                                          },
                                          child: Column(
                                            children: const [
                                              Icon(Icons.restore),
                                              Text("Reset")
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.close_rounded,
                                          size: 36,
                                          key: ValueKey("close_icon"),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Icon(
                                    Icons.add_rounded,
                                    size: 36,
                                    key: ValueKey("add_icon"),
                                  ),
                          ),
                        ),
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
          style: Theme.of(context).textTheme.headline3!.copyWith(
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.secondary),
        ),
        Text(
          "Remaining: ${drinkTarget - currentDrink} ml",
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
