import 'package:drink_reminder/common/theme.dart';
import 'package:drink_reminder/features/hydration_history/presentation/providers/hydration_history_change_notifier.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/pages/landing_page.dart';
import 'package:drink_reminder/features/user_data_setup/presentation/pages/onboarding_setup_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'features/hydration_reminder/presentation/provider/hydration_change_notifier.dart';
import '/common/service_locator.dart' as di;

bool? isFirstLaunch;

Future<bool> getFirstLaunchStatus() async {
  var isFirstLaunch =
      await di.locator<GetStorage>().read('first_launch_status');
  if (isFirstLaunch != null && !isFirstLaunch) {
    di.locator<GetStorage>().write('first_launch_status', false);
    return false;
  } else {
    di.locator<GetStorage>().write('first_launch_status', false);
    return true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  await GetStorage.init();
  await di.locator<GetStorage>().write('complete_status', false);
  isFirstLaunch = await getFirstLaunchStatus();
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
                  home: isFirstLaunch == true || isFirstLaunch == null
                      ? const OnboardingSetup()
                      : const LandingPage(),
                  themeMode:
                      value.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ));
  }
}
