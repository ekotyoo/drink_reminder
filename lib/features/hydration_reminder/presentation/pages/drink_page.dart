import 'package:drink_reminder/common/colors.dart';
import 'package:drink_reminder/common/styles.dart';
import 'package:flutter/material.dart';

class DrinkPage extends StatefulWidget {
  const DrinkPage({Key? key}) : super(key: key);

  @override
  _DrinkPageState createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: MyColor.primaryColor.withOpacity(0.4),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            ),
            Positioned(
                top: 150,
                left: 0,
                right: 0,
                child: Column(
                  children: const [
                    Text(
                      "1290 ml",
                      style: MyStyles.extraLarge,
                    ),
                    Text(
                      "Remaining: 603 ml",
                      style: TextStyle(
                          color: MyColor.blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: "OpenSans"),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final clippedPath = Path();

    clippedPath.lineTo(0, size.height);
    clippedPath.lineTo(size.width, size.height);
    clippedPath.lineTo(size.width, 0);
    clippedPath.close();

    return clippedPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
