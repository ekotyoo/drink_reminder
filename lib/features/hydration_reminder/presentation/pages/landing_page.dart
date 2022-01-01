import 'package:drink_reminder/common/colors.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/pages/current_hidration_page.dart';
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
  double _animatedPaddingValue = 40;

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
    setState(() {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
      moveBottomNavigationIndicator(index);
    });
  }

  void moveBottomNavigationIndicator(int index) {
    setState(() {
      _selectedPage = index;
      if (index == 0) {
        _animatedPaddingValue =
            ((MediaQuery.of(context).size.width / (3 - index)) * (index)) +
                38.2;
      } else if (index == 1) {
        _animatedPaddingValue =
            (MediaQuery.of(context).size.width / (3 - index)) - 40;
      } else {
        _animatedPaddingValue =
            (MediaQuery.of(context).size.width / (3 - index) - 80) - 38.2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              setState(() {
                moveBottomNavigationIndicator(value);
              });
            },
            controller: _pageController,
            children: [
              Container(
                color: Colors.white,
              ),
              const CurrentHidrationPage(),
              Container(
                color: Colors.white,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(bottom: 24),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                    left: _animatedPaddingValue,
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
                          animateToPage(0);
                        },
                        child: Container(
                          height: 60,
                          width: 80,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.check_box_outline_blank_rounded,
                            size: 30,
                            color: _selectedPage == 0
                                ? Colors.white
                                : MyColor.blackColor,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          animateToPage(1);
                        },
                        child: Container(
                          height: 60,
                          width: 80,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.circle_outlined,
                            size: 30,
                            color: _selectedPage == 1
                                ? Colors.white
                                : MyColor.blackColor,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          animateToPage(2);
                        },
                        child: Container(
                          height: 60,
                          width: 80,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.indeterminate_check_box_outlined,
                            size: 30,
                            color: _selectedPage == 2
                                ? Colors.white
                                : MyColor.blackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
