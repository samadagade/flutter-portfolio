import 'package:flutter/material.dart';

class ContactButton extends StatelessWidget {
  final String? buttonText;
  final Widget? icon;
  final VoidCallback onPressed;
  const ContactButton({
    required this.buttonText,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: icon!,
        label: Text(
          "$buttonText",
          style: const TextStyle(color: Colors.black),
        ),
        style: TextButton.styleFrom(
            backgroundColor: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            )),
      ),
    );
  }
}
