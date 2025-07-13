import 'package:flutter/material.dart';
import 'package:portfolio/widgets/basic_widgets/enhanced_snackbar.dart';

comingSoonSnackbar(BuildContext context) {
  return showCustomSnackBar(
      context: context,
      message: "Coming Soon...",
      icon: Icons.access_time,
      backgroundColor: Colors.orangeAccent,
      actionLabel: "Dismiss",
      onAction: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      });
}
