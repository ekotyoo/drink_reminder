import 'package:drink_reminder/common/theme.dart';
import 'package:drink_reminder/features/hydration_history/presentation/providers/hydration_history_viewmodel.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'features/hydration_reminder/presentation/provider/drink_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<DrinkModel>(create: (context) => DrinkModel()),
          ChangeNotifierProvider<HydrationHistoryViewModel>(
              create: (context) => HydrationHistoryViewModel()),
          ChangeNotifierProvider<MyTheme>(create: (context) => MyTheme())
        ],
        builder: (context, child) => Consumer<MyTheme>(
              builder: (context, value, child) {
                return MaterialApp(
                  title: 'Flutter Demo',
                  debugShowCheckedModeBanner: false,
                  theme: MyTheme.light(),
                  darkTheme: MyTheme.dark(),
                  home: const LandingPage(),
                  themeMode:
                      value.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ));
  }
}
