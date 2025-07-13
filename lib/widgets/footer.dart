import 'package:flutter/material.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/widgets/basic_widgets/social_icons.dart';

// ignore: non_constant_identifier_names
Widget PortfolioFooter(BuildContext context) {
  final year = DateTime.now().year;

  return Container(
    //color: getColor(context, lightColor: Colors.white, darkColor: Color(0xFF101820)),
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '© $year Samarth Dagade All rights reserved.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: getColor(context,
                lightColor: Colors.black, darkColor: Colors.white70),
            fontSize: 13,
            height: 1.6,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.code,
                color: getColor(context,
                    lightColor: Colors.black, darkColor: Colors.tealAccent),
                size: 18),
            const SizedBox(width: 8),
            Text(
              'Crafted with Flutter',
              style: TextStyle(
                color: getColor(context,
                    lightColor: Colors.black,
                    darkColor: Colors.tealAccent.shade100),
                fontSize: 13,
                letterSpacing: 0.8,
              ),
            ),
            Container(
              height: 20, // adjust as needed
              width: 1,
              color: Colors.grey.shade400,
              margin: EdgeInsets.only(left: 8),
            ),
            buttonRowForFooter(context),
          ],
        ),
      ],
    ),
  );
}
