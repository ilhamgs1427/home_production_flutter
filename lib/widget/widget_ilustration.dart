import 'package:flutter/material.dart';
import 'package:home_production/constans.dart';

class WidgetIlustration extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle1;
  final String subtitle2;
  WidgetIlustration(
      {required this.image,
      required this.title,
      required this.subtitle1,
      required this.subtitle2});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
          width: 250,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          title,
          style: textTextStyle.copyWith(
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),
        Column(
          children: [
            Text(
              subtitle1,
              style: secondaryTextStyle.copyWith(
                fontSize: 15,
                fontWeight: bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              subtitle2,
              style: secondaryTextStyle.copyWith(
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ],
    );
  }
}
