import 'package:flutter/material.dart';
import 'package:portfolio/core/widgets/enhanced_snackbar.dart';
import 'package:portfolio/util/connection_checker.dart';

noInternetSnackbar(BuildContext context) {
  return showCustomSnackBar(
    // ignore: use_build_context_synchronously
    context: context,
    message: "No Internet Connection",
    icon: Icons.wifi_off,
    backgroundColor: Colors.redAccent.shade700,
    actionLabel: 'Retry',
    onAction: () {
      isConnected();
    },
  );
}
