import 'package:drink_reminder/common/theme.dart';
import 'package:drink_reminder/features/hydration_reminder/presentation/pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/hydration_reminder/presentation/provider/drink_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => DrinkModel()),
          ChangeNotifierProvider(create: (context) => MyTheme())
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
