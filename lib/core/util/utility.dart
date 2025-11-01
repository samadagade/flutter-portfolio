import 'package:flutter/material.dart';

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
