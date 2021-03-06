import 'package:drink_reminder/features/hydration_reminder/domain/entities/cup.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/provider/hydration_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CupList extends AnimatedWidget {
  const CupList({Key? key, required this.animation})
      : super(key: key, listenable: animation);

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: animation, curve: Curves.ease);
    return FadeTransition(
      opacity: curvedAnimation,
      child: SlideTransition(
        position:
            Tween<Offset>(begin: const Offset(0.2, 0), end: const Offset(0, 0))
                .animate(curvedAnimation),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupItem(cup: cups[0]),
                  const SizedBox(width: 16),
                  CupItem(cup: cups[1]),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupItem(cup: cups[2]),
                  const SizedBox(width: 16),
                  CupItem(cup: cups[3]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CupItem extends StatelessWidget {
  const CupItem({Key? key, required this.cup}) : super(key: key);

  final Cup cup;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        context.read<HydrationChangeNotifier>().setSelectedCup(cup);
      },
      child: Consumer<HydrationChangeNotifier>(
        builder: (context, value, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            height: 70,
            width: 168,
            decoration: BoxDecoration(
              color: context.read<HydrationChangeNotifier>().selectedCup.id ==
                      cup.id
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  cup.imagePath,
                  color: Theme.of(context).colorScheme.secondary,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 8),
                Text("${cup.capacity} ml",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }
}
