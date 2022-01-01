import 'package:drink_reminder/common/colors.dart';
import 'package:flutter/material.dart';

class WaterProgress extends StatelessWidget {
  const WaterProgress({Key? key, required this.percentage}) : super(key: key);

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: 240,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${(percentage * 100).toInt()}%",
              style: const TextStyle(
                  fontSize: 48,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w600,
                  color: MyColor.blackColor),
            ),
            const Text(
              "1290 ml",
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w500,
                  color: MyColor.blackColor),
            ),
            const Text(
              "-600 ml",
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
