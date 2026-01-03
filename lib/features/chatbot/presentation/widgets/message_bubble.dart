import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:portfolio/core/widgets/share_copy.dart';
import 'package:portfolio/features/chatbot/domain/entity/message.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isDark;

  const MessageBubble({super.key, required this.message, required this.isDark});

   String _fmtTime(DateTime t) {
  final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final m = t.minute.toString().padLeft(2, '0');
  final ampm = t.hour >= 12 ? 'PM' : 'AM';
  return '$h:$m $ampm';
}
  @override
  Widget build(BuildContext context) {
    final me = message.isMe;
    final maxWidth = MediaQuery.of(context).size.width * 0.80;
    final screenWidth = MediaQuery.of(context).size.width;

    final bg = me
        ? Theme.of(context).colorScheme.primary
        : (isDark ? const Color(0xFF1A1F24) : Colors.white);

    final textColor =
        me ? Colors.white : (isDark ? Colors.white : Colors.black87);

    final border =
        me ? null : Border.all(color: isDark ? Colors.white10 : Colors.black12);

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(me ? 18 : 4),
      bottomRight: Radius.circular(me ? 4 : 18),
    );

    final time = _fmtTime(message.timestamp);

    final bubble = Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        border: border,
        boxShadow: [
          BoxShadow(
            color: me
                ? Theme.of(context).primaryColor.withOpacity(0.25)
                : (isDark
                    ? Colors.black.withOpacity(0.30)
                    : Colors.black.withOpacity(0.06)),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _MarkdownMessage(
            text: message.text,
            isUser: me,
            color: textColor,
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: me ? Colors.white.withOpacity(0.9) : Colors.grey,
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: screenWidth > 800
          ? const EdgeInsets.only(top: 6, bottom: 2, left: 80, right: 80)
          : const EdgeInsets.only(top: 6, bottom: 2, left: 6, right: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!me)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: isDark
                    ? Colors.blueGrey.shade800
                    : Colors.blueGrey.shade100,
                child: const Icon(Icons.smart_toy_outlined, size: 16),
              ),
            ),
          GestureDetector(
            onLongPress: () async {
              showShareCopyDialog(
                context,
                title: "Copy Or Share Message",
                lines: [message.text],
                shareLines: [message.text],
              );
              HapticFeedback.mediumImpact();
            },
            child: bubble,
          ),
        ],
      ),
    );
  }
}


class _MarkdownMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final Color color;

  const _MarkdownMessage({
    required this.text,
    required this.isUser,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final codeBg = isUser
        ? Colors.white.withOpacity(0.18)
        : Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF11151A)
            : const Color(0xFFF1F3F6);

    return MarkdownBody(
      data: text,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(fontSize: 15, height: 1.35, color: color),
        codeblockDecoration: BoxDecoration(
          color: codeBg,
          borderRadius: BorderRadius.circular(10),
        ),
        code: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.4,
          color: color,
        ),
        blockquoteDecoration: BoxDecoration(
          color: codeBg.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        blockquote: TextStyle(color: color.withOpacity(0.95)),
        a: TextStyle(
          decoration: TextDecoration.underline,
          color: isUser ? Colors.white : Theme.of(context).colorScheme.primary,
        ),
        listBullet: TextStyle(color: color),
      ),
      onTapLink: (text, href, title) async {
        if (href == null) return;
        final uri = Uri.tryParse(href);
        if (uri == null) return;
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    );
  }
}