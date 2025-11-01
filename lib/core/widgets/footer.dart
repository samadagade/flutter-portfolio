import 'package:flutter/material.dart';
import 'package:portfolio/core/util/utility.dart';
import 'package:portfolio/core/widgets/social_icons.dart';

// ignore: non_constant_identifier_names
Widget PortfolioFooter(BuildContext context) {
  final year = DateTime.now().year;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          getColor(context,
              lightColor: Colors.white,
              darkColor: Colors.black.withOpacity(0.3)),
          getColor(context,
              lightColor: Colors.grey.shade100,
              darkColor: Colors.black.withOpacity(0.6)),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, -2),
        )
      ],
    ),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      // Animated gradient text
      ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            getColor(context,
                lightColor: Colors.blueAccent, darkColor: Colors.tealAccent),
            getColor(context,
                lightColor: Colors.purpleAccent,
                darkColor: Colors.orangeAccent),
          ],
        ).createShader(bounds),
        child: Text(
          '© $year Samarth Dagade • All Rights Reserved',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white, // Needed for ShaderMask
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      buttonRowForFooter(context),
    ]),
  );
}
