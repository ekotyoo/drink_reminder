import 'package:drink_reminder/common/widgets/custom_bottom_navigation_bar.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/pages/current_hidration_page.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/pages/drink_page.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/pages/hydration_history_page.dart';
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
    _pageController.dispose();
    super.dispose();
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
            physics: const BouncingScrollPhysics(),
            controller: _pageController,
            children: const [
              DrinkPage(),
              CurrentHidrationPage(),
              HydrationHistoryPage(),
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
                        color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/humidity.svg',
                                color: Theme.of(context).colorScheme.secondary,
                                height: 100,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "You've reach\nyour goal!",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  _animationController.reverse().then(
                                      (value) => provider.toggleIsCompleted());
                                },
                                child: Container(
                                  height: 60,
                                  width: 80,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.check_rounded,
                                      size: 30,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
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
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
