import 'package:drink_reminder/features/hydration_history/domain/entities/history.dart';
import 'package:drink_reminder/features/hydration_history/presentation/providers/hydration_history_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HydrationHistoryPage extends StatefulWidget {
  const HydrationHistoryPage({Key? key}) : super(key: key);

  @override
  _HydrationHistoryPageState createState() => _HydrationHistoryPageState();
}

class _HydrationHistoryPageState extends State<HydrationHistoryPage> {
  @override
  void didChangeDependencies() {
    Provider.of<HydrationHistoryChangeNotifier>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.center,
              child: Text(
                "History",
                style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Consumer<HydrationHistoryChangeNotifier>(
                builder: (context, provider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: HistoryMode.values
                      .map((value) => HistoryModeItem(mode: value))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Consumer<HydrationHistoryChangeNotifier>(
                  builder: (context, value, child) => DayModeGraph(
                    data: value.currentWeekHistory,
                  ),
                )),
            Expanded(child: Container())
          ],
        ),
      ),
    );
  }
}

class DayModeGraph extends StatefulWidget {
  const DayModeGraph({Key? key, required this.data}) : super(key: key);

  final List<History?> data;

  @override
  State<DayModeGraph> createState() => _DayModeGraphState();
}

class _DayModeGraphState extends State<DayModeGraph>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SvgPicture.asset(
                  "assets/icons/humidity.svg",
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Average",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.5),
                        ),
                  ),
                  Consumer<HydrationHistoryChangeNotifier>(
                    builder: (context, value, child) => Text(
                      "${value.average.toStringAsFixed(2)} L",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              7,
              (index) {
                final History? history = widget.data[index];

                double value = 0.0;
                if (history != null) {
                  value = history.value.toDouble();
                }
                final highestValue =
                    Provider.of<HydrationHistoryChangeNotifier>(context)
                        .highestValue
                        .toDouble();
                final height = (value / highestValue) * 100;
                return SizedBox(
                  height: 150 + 8 + 36,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            height:
                                value == 0 ? 0 : _animation.value * height + 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 8),
                            width: 36,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SizedBox(
                              child: Text(
                                (value / 1000).toStringAsPrecision(2),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Days.values[index].name.substring(0, 2).replaceFirst(
                            Days.values[index].name[0],
                            Days.values[index].name[0].toUpperCase()),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.5)),
                      )
                    ],
                  ),
                );
              },
            ).toList(),
          )
        ],
      ),
    );
  }
}

class HistoryModeItem extends StatelessWidget {
  const HistoryModeItem({Key? key, required this.mode}) : super(key: key);

  final HistoryMode mode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<HydrationHistoryChangeNotifier>().selectedMode = mode;
      },
      borderRadius: BorderRadius.circular(20),
      child: Consumer<HydrationHistoryChangeNotifier>(
        builder: (context, value, child) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          width: 80,
          height: 50,
          decoration: BoxDecoration(
              color: value.selectedMode == mode
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Text(
              mode.name.replaceFirst(mode.name[0], mode.name[0].toUpperCase()),
              style: Theme.of(context).textTheme.button!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: value.selectedMode == mode
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Theme.of(context).colorScheme.secondary),
            ),
          ),
        ),
      ),
    );
  }
}
