import 'package:drink_reminder/common/colors.dart';
import 'package:drink_reminder/common/styles.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/pages/current_hidration_page.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/pages/drink_page.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/provider/drink_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  final int _initialPage = 0;
  int _selectedPage = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: _initialPage);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void animateToPage(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<DrinkModel>(
        create: (context) => DrinkModel(),
        child: Stack(
          children: [
            PageView(
              onPageChanged: (value) {
                setState(() {
                  _selectedPage = value;
                });
              },
              controller: _pageController,
              children: [
                const DrinkPage(),
                const CurrentHidrationPage(),
                Container(
                  color: Colors.white,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomBottomNavigationBar(
                onTap: (index) => animateToPage(index),
                currentIndex: _selectedPage,
              ),
            ),
            Consumer<DrinkModel>(
              builder: (context, provider, child) {
                if (provider.isCompleted) {
                  _animationController.forward();
                  return TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, value, child) => FadeTransition(
                      opacity: _animationController,
                      child: SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(0, 0.5), end: Offset.zero)
                            .animate(CurvedAnimation(
                                parent: _animationController,
                                curve: Curves.ease)),
                        child: Container(
                          color: MyColor.secodaryColor,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/humidity.svg',
                                  color: MyColor.blackColor,
                                  height: 100,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "You\'ve reach\nyour goal!",
                                  style: MyStyles.heading,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                GestureDetector(
                                  onTap: () {
                                    _animationController.reverse().then(
                                        (value) =>
                                            provider.toggleIsCompleted());
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 80,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: MyColor.blackColor,
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.check_rounded,
                                          size: 30, color: Colors.white),
                                    ),
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
                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar(
      {Key? key, this.onTap, required this.currentIndex})
      : super(key: key);

  final Function(int)? onTap;
  final int currentIndex;

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late ColorTween _colorTween;
  late AnimationController _animationController;
  double indicatorPosition = 38.2;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _colorTween = ColorTween(begin: MyColor.blackColor, end: Colors.white);
    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void moveBottomNavigationIndicator(int index) {
    final double screenWidth = MediaQuery.of(context).size.width;

    switch (index) {
      case 0:
        indicatorPosition = ((screenWidth / (3 - index)) * (index)) + 38.2;
        break;
      case 1:
        indicatorPosition = (screenWidth / (3 - index)) - 40;
        break;
      default:
        indicatorPosition = (screenWidth / (3 - index) - 80) - 38.2;
    }
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    moveBottomNavigationIndicator(widget.currentIndex);
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
            left: indicatorPosition,
            child: Container(
              height: 60,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: MyColor.blackColor,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  widget.onTap?.call(0);
                  moveBottomNavigationIndicator(0);
                },
                child: Container(
                  height: 60,
                  width: 80,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: AnimatedBuilder(
                    animation: _colorTween.animate(_animationController),
                    builder: (context, child) {
                      return Container(
                        height: 24,
                        width: 24,
                        padding: const EdgeInsets.all(6),
                        child: SvgPicture.asset(
                          'assets/icons/humidity.svg',
                          color: widget.currentIndex == 0
                              ? _colorTween.evaluate(_animationController)
                              : MyColor.blackColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  widget.onTap?.call(1);
                  moveBottomNavigationIndicator(1);
                },
                child: Container(
                  height: 60,
                  width: 80,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: AnimatedBuilder(
                      animation: _colorTween.animate(_animationController),
                      builder: (context, child) {
                        return Container(
                          height: 24,
                          width: 24,
                          padding: const EdgeInsets.all(6),
                          child: SvgPicture.asset(
                            'assets/icons/progress.svg',
                            color: widget.currentIndex == 1
                                ? _colorTween.evaluate(_animationController)
                                : MyColor.blackColor,
                          ),
                        );
                      }),
                ),
              ),
              InkWell(
                onTap: () {
                  widget.onTap?.call(2);
                  moveBottomNavigationIndicator(2);
                },
                child: Container(
                  height: 60,
                  width: 80,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: AnimatedBuilder(
                      animation: _colorTween.animate(_animationController),
                      builder: (context, child) {
                        return Container(
                          height: 24,
                          width: 24,
                          padding: const EdgeInsets.all(8),
                          child: SvgPicture.asset(
                            'assets/icons/menu.svg',
                            color: widget.currentIndex == 2
                                ? _colorTween.evaluate(_animationController)
                                : MyColor.blackColor,
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
