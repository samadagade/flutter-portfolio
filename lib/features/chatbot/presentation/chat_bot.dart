import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/core/util/coming_soon_snackbar.dart';
import 'package:portfolio/core/util/utility.dart';
import 'package:portfolio/core/widgets/contact_dialog.dart';
import 'package:portfolio/core/widgets/share_copy.dart';
import 'package:portfolio/features/portfolio/domain/entities/project.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:math';

import '../../../core/util/app_details.dart';

class Message {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  Message({required this.text, required this.isMe, required this.timestamp});
}

class ChatService {
  final StreamController<Message> _messageController =
      StreamController<Message>.broadcast();
  final StreamController<bool> _typingController =
      StreamController<bool>.broadcast();
  // ignore: unused_field
  final Random _random = Random();

  Stream<Message> get messageStream => _messageController.stream;
  Stream<bool> get typingStream => _typingController.stream;

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final message = Message(text: text, isMe: true, timestamp: DateTime.now());

    _messageController.add(message);
    handleUserMessage(text, _messageController);
  }

  void dispose() {
    _messageController.close();
    _typingController.close();
  }
}

class SimpleChat extends StatefulWidget {
  const SimpleChat({super.key});

  @override
  State<SimpleChat> createState() => _SimpleChatState();
}

class _SimpleChatState extends State<SimpleChat> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final ChatService _chatService = ChatService();
  final List<Message> _messages = [];

  bool _isTyping = false;
  bool _showJump = false;

  @override
  void initState() {
    super.initState();

    _scroll.addListener(() {
      final atBottom =
          _scroll.position.pixels >= _scroll.position.maxScrollExtent - 60;
      setState(() => _showJump = !atBottom);
    });

    _chatService.messageStream.listen((m) {
      setState(() => _messages.add(m));
      _scrollToBottom();
    });

    _chatService.typingStream.listen((v) {
      setState(() => _isTyping = v);
      if (v) _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    _chatService.dispose();
    super.dispose();
  }

  // ── actions
  void _sendMessage(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return;
    _chatService.sendMessage(text);
    _controller.clear();
    HapticFeedback.selectionClick();
    setState(() {});
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0E1117) : const Color(0xFFF6F7FB),
      appBar: _AIBotBar(isDark: isDark),
      body: Column(
        children: [
          // helper chip row
          const SizedBox(height: 6),
          _InfoStrip(isDark: isDark),

          // suggestions (first open state)
          if (_messages.isEmpty) _Suggestions(onPick: _sendMessage),

          // messages
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, i) {
                if (_isTyping && i == _messages.length) {
                  return const _TypingBubble();
                }

                final msg = _messages[i];
                final showDay = i == 0 ||
                    !_sameDay(_messages[i - 1].timestamp, msg.timestamp);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showDay) _DaySeparator(date: msg.timestamp),
                    _MessageBubble(
                      message: msg,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 6),
                  ],
                );
              },
            ),
          ),

          Visibility(
            visible: _showJump,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 180),
              offset: _showJump ? Offset.zero : const Offset(0, 1.5),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: _showJump ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: IconButton(
                      onPressed: _scrollToBottom,
                      icon: const Icon(Icons.arrow_downward_rounded)),
                ),
              ),
            ),
          ),

          // composer
          _Composer(
            controller: _controller,
            onSend: _sendMessage,
          ),

          Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 8.0),
            child: Text(
              "Chatbot can make mistakes. Please verify critical information.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// APP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _AIBotBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDark;
  const _AIBotBar({required this.isDark});

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
              // reset chat
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const SimpleChat(),
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

// ─────────────────────────────────────────────────────────────────────────────
// INFO STRIP + SUGGESTIONS
// ─────────────────────────────────────────────────────────────────────────────

class _InfoStrip extends StatelessWidget {
  final bool isDark;
  const _InfoStrip({required this.isDark});

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

class _Suggestions extends StatelessWidget {
  final void Function(String) onPick;
  const _Suggestions({required this.onPick});

  @override
  Widget build(BuildContext context) {
    final chips = [
      'projects',
      'skills',
      'experience',
      'open portfolio',
      'resume',
      'apk',
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: chips
              .map((c) => ActionChip(
                    label: Text(c),
                    onPressed: () => onPick(c),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MESSAGE BUBBLE (markdown + code, copy, link open, tails, timestamps)
// ─────────────────────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isDark;

  const _MessageBubble({required this.message, required this.isDark});

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
      bottomLeft: Radius.circular(me ? 18 : 4), // tail
      bottomRight: Radius.circular(me ? 4 : 18), // tail
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
          // markdown-rendered text
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
          // long press: copy
          GestureDetector(
            onLongPress: () async {
              showShareCopyDialog(context,
                  title: "Copy Or Share Message",
                  lines: [message.text],
                  shareLines: [message.text]);
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied message')),
              );
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
    // basic code block theme
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

// ─────────────────────────────────────────────────────────────────────────────
// TYPING + DAY SEPARATOR
// ─────────────────────────────────────────────────────────────────────────────

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

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
            child: const _TypingDots(),
          ),
        ],
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController c;
  late final Animation<double> a1;
  late final Animation<double> a2;
  late final Animation<double> a3;

  @override
  void initState() {
    super.initState();
    c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat();
    a1 = CurvedAnimation(
        parent: c, curve: const Interval(0.0, 0.6, curve: Curves.easeInOut));
    a2 = CurvedAnimation(
        parent: c, curve: const Interval(0.2, 0.8, curve: Curves.easeInOut));
    a3 = CurvedAnimation(
        parent: c, curve: const Interval(0.4, 1.0, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget dot(Animation<double> a) => AnimatedBuilder(
          animation: a,
          builder: (_, __) => Transform.translate(
            offset: Offset(0, -3 * (a.value - 0.5).abs() * 2),
            child: Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[700],
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
    return Row(
        mainAxisSize: MainAxisSize.min, children: [dot(a1), dot(a2), dot(a3)]);
  }
}

class _DaySeparator extends StatelessWidget {
  final DateTime date;
  const _DaySeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final label = _sameDay(date, now)
        ? 'Today'
        : _sameDay(date, now.subtract(const Duration(days: 1)))
            ? 'Yesterday'
            : "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Expanded(child: Divider(height: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          const Expanded(child: Divider(height: 1)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPOSER
// ─────────────────────────────────────────────────────────────────────────────

class _Composer extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String) onSend;
  const _Composer({required this.controller, required this.onSend});

  @override
  State<_Composer> createState() => _ComposerState();
}

class _ComposerState extends State<_Composer> {
  bool canSend = false;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    final v = widget.controller.text.trim().isNotEmpty;
    if (v != canSend) setState(() => canSend = v);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            // _IconBtn(icon: Icons.attach_file,
            // onTap: () {
            //   ChatGPTAttachButton(context, onSelected: (value) {

            //   },);
            //   HapticFeedback.heavyImpact();
            //  }),
            AttachButton(
              icon: Icons.attach_file,
              onSelected: (value) {
                if (value == AttachmentAction.contact) {
                  showContactDialog(context);
                } else if (value == AttachmentAction.gallery) {
                  comingSoonSnackbar(context);
                } else if (value == AttachmentAction.upload) {
                  comingSoonSnackbar(context);
                }
              },
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151A1F) : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black12),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.35)
                          : Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: widget.controller,
                  minLines: 1,
                  maxLines: 6,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    hintText:
                        'Message Samarth’s Assistant… (supports *Markdown* + ```code```)',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (v) => widget.onSend(v),
                ),
              ),
            ),
            const SizedBox(width: 6),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: canSend
                  ? _RoundBtn(
                      key: const ValueKey('send'),
                      color: Theme.of(context).colorScheme.primary,
                      icon: Icons.send_rounded,
                      onTap: () => widget.onSend(widget.controller.text),
                    )
                  : _RoundBtn(
                      key: const ValueKey('mic'),
                      color: Theme.of(context).colorScheme.secondary,
                      icon: Icons.mic_none_rounded,
                      onTap: () => HapticFeedback.selectionClick(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDarkMode(context) ? const Color(0xFF151A1F) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: Colors.grey[600]),
        ),
      ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const _RoundBtn(
      {super.key,
      required this.color,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _fmtTime(DateTime t) {
  final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final m = t.minute.toString().padLeft(2, '0');
  final ampm = t.hour >= 12 ? 'PM' : 'AM';
  return '$h:$m $ampm';
}

// Call this instead of your old switch:
// handleUserMessage(originalMessage);

Future<void> handleUserMessage(
    String originalMessage, StreamController<Message> messageController) async {
  final text = originalMessage.trim();
  final lower = text.toLowerCase();

  // Make sure app info is loaded (for version / APK URL)
  if (AppInfo.version == 'Unknown' || AppInfo.buildNumber == 'Unknown') {
    await AppInfo.init();
  }

  void reply(String msg) {
    messageController.add(
      Message(
        text: msg,
        isMe: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  // -------------- tiny NLP helpers --------------
  bool hasAny(List<String> keys) => keys.any((k) => lower.contains(k));
  // ignore: no_leading_underscores_for_local_identifiers
  int? _extractIndex1Based(String s) {
    final m = RegExp(r'\b(\d{1,2})\b').firstMatch(s);
    if (m == null) return null;
    return int.tryParse(m.group(1)!);
  }

  // ignore: no_leading_underscores_for_local_identifiers
  List<Project>? _findProjectByName(String query) {
    final q = query.toLowerCase();
    try {
      return projects
          .where(
            (p) =>
                p.title.toString().toLowerCase().contains(q) ||
                (p.subtitle).toLowerCase().contains(q),
          )
          .toList();
    } catch (_) {
      return null;
    }
  }

  // ignore: no_leading_underscores_for_local_identifiers
  String _bulletify(List items) => items.map((e) => "• ${e.name}").join("\n");

  // -------------- small talk --------------
  if (hasAny(['hello', 'hi', 'hey', 'yo', 'namaste', 'hola'])) {
    reply("Hi there! I’m Samarth’s Assistant 👋\nHow can I help you today?");
    return;
  }

  if (hasAny(['how are you', 'how r u', 'how’s it going'])) {
    reply(
        "I’m just a bunch of code, but thanks for asking! 😊 What can I do for you?");
    return;
  }

  if (hasAny(['who are you', 'your name', 'introduce yourself'])) {
    reply(
        "I’m Samarth’s Assistant. I can show projects, skills, experience, resume, and links. Type **help** to see everything I can do.");
    return;
  }

  if (hasAny(['thank', 'thanks', 'ty', 'thx'])) {
    reply("Happy to help! 🙌");
    return;
  }

  if (hasAny(['bye', 'goodbye', 'see you'])) {
    reply("Bye! If you need anything, just ping me again. 👋");
    return;
  }

  // -------------- help / menu --------------
  if (hasAny(['help', 'what can you do', 'menu', 'options'])) {
    reply("Here’s what I can do:\n\n"
        "• **projects** – list all projects\n\n"
        "• **open Project_Name** – show details + links\n\n"
        "• **skills** – list technical skills\n\n"
        "• **experience** – show work experience\n\n"
        "• **resume** or **cv** – view/download resume\n\n"
        "• **github / linkedin / twitter / gfg / website** – open profile links\n\n"
        "• **contact / email / phone / whatsapp** – show contact details\n\n"
        "• **version** or **apk** – show app version & APK link\n\n");
    return;
  }

  // -------------- resume --------------
  if (hasAny(['resume', 'cv'])) {
    reply("Here’s Samarth’s resume:\n\n"
        "• View: $resumeUrl\n\n"
        "• Direct download: $resumeDownloadUrl");
    return;
  }
  // -------------- personal details --------------
  if (hasAny(['age', 'old are you', 'your age'])) {
    final age = DateTime.now().year - 2002; // Replace with actual birth year
    reply("Samarth is $age years old.");
    return;
  }

  if (hasAny(['dob', 'Date Of Birth', 'samarth\'s dob'])) {
    final dob = DateTime(2002, 7, 28);
    final age = DateTime.now().year - dob.year;
    final formattedDob = "${dob.day.toString().padLeft(2, '0')}-"
        "${dob.month.toString().padLeft(2, '0')}-"
        "${dob.year}";
    reply("Samarth's date of birth is $formattedDob and he is $age years old.");
    return;
  }

  // -------------- links / social --------------
  if (hasAny(['github'])) {
    reply("GitHub: $githubProfileUrl");
    return;
  }
  if (hasAny(['linkedin'])) {
    reply("LinkedIn: $linkedinProfileUrl");
    return;
  }
  if (hasAny(['twitter', 'x.com'])) {
    reply("Twitter: $twitterProfileUrl");
    return;
  }
  if (hasAny(['geeksforgeeks', 'gfg'])) {
    reply("GeeksforGeeks: $gfgProfileUrl");
    return;
  }
  if (hasAny(['website', 'portfolio', 'web'])) {
    reply("Website: $webUrl");
    return;
  }

  // -------------- contact --------------
  if (hasAny(['contact', 'email', 'mail'])) {
    reply("You can email Samarth at: $email");
    return;
  }
  if (hasAny(['phone', 'call', 'mobile', 'number'])) {
    reply("Phone: $phoneNumber");
    return;
  }
  if (hasAny(['whatsapp', 'whats app', 'wa'])) {
    reply("WhatsApp: $whatsappContactUrl");
    return;
  }

  // -------------- skills --------------
  if (hasAny(['skill', 'skills', 'tech stack', 'technology'])) {
    reply("Samarth’s skills:\n${_bulletify(skills)}");
    return;
  }

  // -------------- experience --------------
  if (hasAny(['experience', 'work history', 'work exp', 'job'])) {
    final sb = StringBuffer();
    for (final exp in experiences) {
      sb.writeln("**${exp.role}** @ ${exp.company}\n\n");
      sb.writeln('**Duration:** ${exp.duration}\n\n');
      sb.writeln("${exp.description}\n");
    }
    reply(sb.toString());
    return;
  }

  // -------------- projects (list) --------------
  if (hasAny(['project', 'projects'])) {
    final sb = StringBuffer("Here are Samarth’s projects:\n");
    for (int i = 0; i < projects.length; i++) {
      final p = projects[i];
      sb.writeln("${i + 1}. ${p.title} — ${p.subtitle.trim()}");
    }
    sb.writeln(
        "\nAsk for **open Project_Name** to see details, GitHub, and Live link.");
    reply(sb.toString());
    return;
  }

  // -------------- project details & open by index or name --------------
  if (hasAny(['open', 'detail', 'details', 'more about', 'show', 'project '])) {
    // Try index first
    final idx = _extractIndex1Based(lower);
    Project? p;
    if (idx != null && idx >= 1 && idx <= projects.length) {
      p = projects[idx - 1];
    } else {
      // Try name match
      final foundProjects = _findProjectByName(
          lower.replaceAll(RegExp(r'open|details?|show'), '').trim());
      p = (foundProjects != null && foundProjects.isNotEmpty)
          ? foundProjects.first
          : null;
    }

    if (p != null) {
      final techs = (p.technologies as List).cast<String>().join(', ');
      reply(
        "**${p.title}**\n\n"
        "${p.subtitle}\n\n"
        "🧑‍💻 Technologies: $techs\n\n"
        "🌐 GitHub: ${p.githubUrl}\n\n"
        "💻 Live: ${p.launchUrl}\n\n"
        "🐞 Have a Bug or Feature Idea? : ${p.githubUrl}/issues",
      );
      return;
    }
    // If user asked to open but we couldn't resolve:
    reply(
        "I couldn’t find that project. Try **Open Project_Name** or any details of that project.");
    return;
  }

  // -------------- version / APK --------------
  if (hasAny(['version', 'build', 'apk', 'download app'])) {
    final apkUrl =
        "https://github.com/samadagade/flutter-portfolio/releases/download/v${AppInfo.version}/flutter_portfolio_v${AppInfo.version}.apk";
    reply("App version: ${AppInfo.version} (build ${AppInfo.buildNumber})\n\n"
        "Android APK: $apkUrl");
    return;
  }

  // -------------- easter eggs --------------
  if (hasAny(['joke'])) {
    reply(
        "Why do programmers prefer dark mode? Because light attracts bugs. 🐛");
    return;
  }

  // -------------- default fallback --------------
  reply("I’m not sure how to respond to that yet 🤔\n\n"
      "Try **help** to see what I can do.");
}

enum AttachmentAction { upload, gallery, camera, audio, contact, location }

/// Drop-in: place this where your attach button goes.
/// It shows a small anchored popup menu like ChatGPT.
class AttachButton extends StatefulWidget {
  const AttachButton({
    super.key,
    required this.onSelected,
    this.icon = Icons.attach_file,
  });

  final ValueChanged<AttachmentAction> onSelected;
  final IconData icon;

  @override
  State<AttachButton> createState() => _ChatGPTAttachButtonState();
}

class _ChatGPTAttachButtonState extends State<AttachButton> {
  final MenuController _menuController = MenuController();

  void _openMenu() {
    HapticFeedback.heavyImpact();
    _menuController.open();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return MenuAnchor(
      controller: _menuController,
      alignmentOffset: const Offset(0, 8), // a little gap under the button
      style: MenuStyle(
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
        backgroundColor: WidgetStatePropertyAll(scheme.surface),
        elevation: const WidgetStatePropertyAll(8),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        shadowColor: WidgetStatePropertyAll(Colors.black.withOpacity(0.2)),
      ),
      builder: (context, controller, child) {
        return IconButton(
          tooltip: 'Attach',
          icon: Icon(widget.icon),
          onPressed: _openMenu,
        );
      },
      menuChildren: [
        // Primary CTA — mirrors ChatGPT's "Upload from device"
        MenuItemButton(
          leadingIcon: const Icon(Icons.upload_file_rounded),
          child: const Text('Upload from device'),
          onPressed: () => widget.onSelected(AttachmentAction.upload),
        ),
        const Divider(height: 8),
        MenuItemButton(
          leadingIcon: const Icon(Icons.person_add_alt_1_rounded),
          child: const Text('Contact'),
          onPressed: () => widget.onSelected(AttachmentAction.contact),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.photo_library_rounded),
          child: const Text('Gallery'),
          onPressed: () => widget.onSelected(AttachmentAction.gallery),
        ),
      ],
    );
  }
}
