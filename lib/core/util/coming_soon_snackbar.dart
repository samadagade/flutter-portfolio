import 'package:flutter/material.dart';
import 'package:portfolio/core/widgets/enhanced_snackbar.dart';

comingSoonSnackbar(BuildContext context, {String? message}) {
  return showCustomSnackBar(
      context: context,
      message: message ?? "Coming Soon...",
      icon: Icons.access_time,
      backgroundColor: Colors.orangeAccent,
      actionLabel: "Dismiss",
      onAction: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      });
}
