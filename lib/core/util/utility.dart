import 'package:flutter/material.dart';
import 'package:portfolio/app_config.dart';

// Return true when dark mode is on
bool isDarkMode(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

// Returns color based on current theme (light/dark)
Color getColor(BuildContext context,
    {required Color lightColor, required Color darkColor}) {
  return Theme.of(context).brightness == Brightness.dark
      ? darkColor
      : lightColor;
}

/// Checks if the given URL is a network image URL.
bool isNetworkImage(String url) {
  return url.startsWith('http://') || url.startsWith('https://');
}

// Return an call url
String getPhoneUrl() {
  final String url = 'tel:$phoneNumber';
  return url;
}
