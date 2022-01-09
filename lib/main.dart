import 'package:drink_reminder/common/theme.dart';
import 'package:drink_reminder/features/hydration_history/presentation/providers/hydration_history_change_notifier.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'features/hydration_reminder/presentation/provider/hydration_change_notifier.dart';
import '/common/service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<HydrationChangeNotifier>(
              create: (context) => di.locator<HydrationChangeNotifier>()),
          ChangeNotifierProvider<HydrationHistoryChangeNotifier>(
              create: (context) =>
                  di.locator<HydrationHistoryChangeNotifier>()),
          ChangeNotifierProvider<ThemeChangeNotifier>(
              create: (context) => di.locator<ThemeChangeNotifier>())
        ],
        builder: (context, child) => Consumer<ThemeChangeNotifier>(
              builder: (context, value, child) {
                return MaterialApp(
                  title: 'Flutter Demo',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeChangeNotifier.light(),
                  darkTheme: ThemeChangeNotifier.dark(),
                  home: const LandingPage(),
                  themeMode:
                      value.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ));
  }
}
