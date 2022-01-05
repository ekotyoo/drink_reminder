import 'package:drink_reminder/features/hydration_reminder/domain/entities/cup.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/provider/drink_model.dart';
import 'package:flutter/material.dart';
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
        context.read<DrinkModel>().setSelectedCup(cup);
      },
      child: Consumer<DrinkModel>(
        builder: (context, value, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            height: 70,
            width: 168,
            decoration: BoxDecoration(
              color: context.read<DrinkModel>().selectedCup.id == cup.id
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(cup.image,
                    color: Theme.of(context).colorScheme.secondary, size: 24),
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
