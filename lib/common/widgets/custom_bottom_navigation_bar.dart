import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  late AnimationController _animationController;
  double indicatorPosition = 38.2;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void moveBottomNavigationIndicator(int index) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double buttonSize = 80;

    switch (index) {
      case 0:
        indicatorPosition = ((screenWidth / (3 - index)) * (index)) +
            (screenWidth - buttonSize * 3) / 4;
        break;
      case 1:
        indicatorPosition = (screenWidth / (3 - index)) - buttonSize / 2;
        break;
      default:
        indicatorPosition = (screenWidth / (3 - index) - buttonSize) -
            (screenWidth - buttonSize * 3) / 4;
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
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _bottomNavigationIcons
                .asMap()
                .entries
                .map(
                  (element) => CustomBottomNavigationBarItem(
                    iconPath: element.value,
                    onTap: (value) {
                      widget.onTap?.call(value);
                      moveBottomNavigationIndicator(value);
                    },
                    isSelected: widget.currentIndex == element.key,
                    index: element.key,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBarItem extends StatefulWidget {
  const CustomBottomNavigationBarItem({
    Key? key,
    this.isSelected = false,
    required this.iconPath,
    this.onTap,
    required this.index,
  }) : super(key: key);

  final bool isSelected;
  final String iconPath;
  final ValueChanged<int>? onTap;
  final int index;

  @override
  State<CustomBottomNavigationBarItem> createState() =>
      _CustomBottomNavigationBarItemState();
}

class _CustomBottomNavigationBarItemState
    extends State<CustomBottomNavigationBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSelected) {
      _animationController.forward(from: 0);
    } else {
      _animationController.reverse(from: 1);
    }
    return InkWell(
      onTap: () {
        widget.onTap?.call(widget.index);
      },
      child: Container(
        height: 60,
        width: 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: AnimatedBuilder(
            animation: ColorTween(
                    begin: Theme.of(context).colorScheme.secondary,
                    end: Theme.of(context).scaffoldBackgroundColor)
                .animate(_animationController),
            builder: (context, child) {
              return Container(
                  height: 24,
                  width: 24,
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    widget.iconPath,
                    color: widget.isSelected
                        ? ColorTween(
                            begin: Theme.of(context).colorScheme.secondary,
                            end: Theme.of(context).scaffoldBackgroundColor,
                          ).evaluate(_animationController)
                        : Theme.of(context).colorScheme.secondary,
                  ));
            }),
      ),
    );
  }
}

const List<String> _bottomNavigationIcons = [
  'assets/icons/humidity.svg',
  'assets/icons/progress.svg',
  'assets/icons/menu.svg'
];
