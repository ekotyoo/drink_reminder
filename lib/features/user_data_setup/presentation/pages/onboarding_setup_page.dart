import 'package:drink_reminder/features/hydration_reminder/presentation/pages/landing_page.dart';
import 'package:flutter/material.dart';

class OnboardingSetup extends StatelessWidget {
  const OnboardingSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Onboarding Setup Page"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const LandingPage(),
                  transitionDuration: const Duration(milliseconds: 1000),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    final tween = Tween<Offset>(
                        begin: const Offset(1, 0), end: Offset.zero);
                    final curvedAnimation =
                        CurvedAnimation(parent: animation, curve: Curves.ease);
                    return SlideTransition(
                      position: tween.animate(curvedAnimation),
                      child: FadeTransition(
                          opacity: curvedAnimation, child: child),
                    );
                  },
                ),
              );
            },
            child: Text("Go to next screen")),
      ),
    );
  }
}
