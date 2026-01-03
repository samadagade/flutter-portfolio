import 'package:flutter/material.dart';

class InfoStrip extends StatelessWidget {
  final bool isDark;
  const InfoStrip({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _pill(icon: Icons.shield_outlined, text: 'Privacy focused'),
        const SizedBox(width: 8),
        _pill(icon: Icons.auto_awesome_outlined, text: 'Markdown & code'),
      ]),
    );
  }

  Widget _pill({required IconData icon, required String text}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ]),
      );
}
