import 'package:drink_reminder/common/colors.dart';
import 'package:flutter/material.dart';

class CupList extends StatelessWidget {
  const CupList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 160,
              decoration: BoxDecoration(
                color: MyColor.blueAccentColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              height: 80,
              width: 160,
              decoration: BoxDecoration(
                color: MyColor.blueAccentColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 160,
              decoration: BoxDecoration(
                color: MyColor.blueAccentColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              height: 80,
              width: 160,
              decoration: BoxDecoration(
                color: MyColor.blueAccentColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
