import 'package:drink_reminder/common/colors.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/pages/current_hidration_page.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/pages/drink_page.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late PageController _pageController;
  final int _initialPage = 0;
  int _selectedPage = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: _initialPage);
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
      body: Stack(
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
        ],
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

    _animationController.reset();
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
                      return Icon(
                        Icons.check_box_outline_blank_rounded,
                        size: 30,
                        color: widget.currentIndex == 0
                            ? _colorTween.evaluate(_animationController)
                            : MyColor.blackColor,
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
                        return Icon(
                          Icons.circle_outlined,
                          size: 30,
                          color: widget.currentIndex == 1
                              ? _colorTween.evaluate(_animationController)
                              : MyColor.blackColor,
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
                        return Icon(
                          Icons.indeterminate_check_box_outlined,
                          size: 30,
                          color: widget.currentIndex == 2
                              ? _colorTween.evaluate(_animationController)
                              : MyColor.blackColor,
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
