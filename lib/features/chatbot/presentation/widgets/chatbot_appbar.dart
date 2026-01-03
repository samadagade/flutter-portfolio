// ─────────────────────────────────────────────────────────────────────────────
// APP BAR
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/features/chatbot/presentation/chat_bot.dart';

class AIBotBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDark;
  const AIBotBar({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: isDark ? const Color(0xFF0E1117) : Colors.white,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 8),
          Stack(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: isDark
                    ? Colors.blueGrey.shade800
                    : Colors.blueGrey.shade100,
                child: const Icon(Icons.smart_toy_outlined, size: 20),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade400,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? const Color(0xFF0E1117) : Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Samarth’s Assistant',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 2),
                Text('Online • fast, helpful, friendly',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            tooltip: 'New chat',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const ChatBot(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
              HapticFeedback.mediumImpact();
            },
            icon: const Icon(Icons.add_comment_outlined),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}