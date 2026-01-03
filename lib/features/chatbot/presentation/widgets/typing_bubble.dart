import 'package:flutter/material.dart';
import 'package:portfolio/core/util/utility.dart';
import 'package:portfolio/features/chatbot/presentation/widgets/typing_dots.dart';

class TypingBubble extends StatelessWidget {
  const TypingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    final radius = const BorderRadius.only(
      topLeft: Radius.circular(18),
      topRight: Radius.circular(18),
      bottomLeft: Radius.circular(4),
      bottomRight: Radius.circular(18),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 60, top: 4, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor:
                isDark ? Colors.blueGrey.shade800 : Colors.blueGrey.shade100,
            child: const Icon(Icons.smart_toy_outlined, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1F24) : Colors.white,
              borderRadius: radius,
              border:
                  Border.all(color: isDark ? Colors.white10 : Colors.black12),
            ),
            child: const TypingDots(),
          ),
        ],
      ),
    );
  }
}