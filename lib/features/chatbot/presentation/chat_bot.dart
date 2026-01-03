import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/core/util/coming_soon_snackbar.dart';
import 'package:portfolio/core/util/connection_checker.dart';
import 'package:portfolio/core/util/utility.dart';
import 'package:portfolio/core/widgets/contact_dialog.dart';
import 'package:portfolio/features/chatbot/data/remote_data_source/chatbot_remote.dart';
import 'package:portfolio/features/chatbot/domain/entity/message.dart';
import 'package:portfolio/features/chatbot/presentation/chat_service.dart';
import 'package:portfolio/features/chatbot/presentation/widgets/attach_button.dart';
import 'package:portfolio/features/chatbot/presentation/widgets/chatbot_appbar.dart';
import 'package:portfolio/features/chatbot/presentation/widgets/info_strip.dart';
import 'package:portfolio/features/chatbot/presentation/widgets/message_bubble.dart';
import 'package:portfolio/features/chatbot/presentation/widgets/suggations.dart';
import 'package:portfolio/features/chatbot/presentation/widgets/typing_bubble.dart';
import 'package:portfolio/features/chatbot/presentation/widgets/typing_dots.dart';
import 'package:portfolio/features/portfolio/domain/entities/project.dart';

import '../../../core/util/app_details.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> with TickerProviderStateMixin {
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
      if (!_scroll.hasClients) return;
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
      appBar: AIBotBar(isDark: isDark),
      body: Column(
        children: [
          const SizedBox(height: 6),
          InfoStrip(isDark: isDark),
          if (_messages.isEmpty) Suggestions(onPick: _sendMessage),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, i) {
                if (_isTyping && i == _messages.length) {
                  return const TypingBubble();
                }

                final msg = _messages[i];
                final showDay = i == 0 ||
                    !sameDay(_messages[i - 1].timestamp, msg.timestamp);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showDay) DaySeparator(date: msg.timestamp),
                    MessageBubble(
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
                    icon: const Icon(Icons.arrow_downward_rounded),
                  ),
                ),
              ),
            ),
          ),
          _Composer(
            controller: _controller,
            onSend: _sendMessage,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 2.0, bottom: 8.0),
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
// BOT LOGIC: API if online+works, else local fallback
// ─────────────────────────────────────────────────────────────────────────────

Future<void> handleUserMessage(
  String originalMessage,
  StreamController<Message> messageController,
  StreamController<bool> typingController,
) async {
  final text = originalMessage.trim();
  final lower = text.toLowerCase();

  if (AppInfo.version == 'Unknown' || AppInfo.buildNumber == 'Unknown') {
    await AppInfo.init();
  }

  void reply(String msg) async {
    await Future.delayed(const Duration(seconds: 1));
    typingController.add(false);
    messageController.add(
      Message(text: msg, isMe: false, timestamp: DateTime.now()),
    );
  }

  // Local bot logic (your existing rules)
  Future<void> localBot() async {
    bool hasAny(List<String> keys) => keys.any((k) => lower.contains(k));
    int? extractIndex1Based(String s) {
      final m = RegExp(r'\b(\d{1,2})\b').firstMatch(s);
      if (m == null) return null;
      return int.tryParse(m.group(1)!);
    }

    String bulletify(List items) => items.map((e) => "• ${e.name}").join("\n");

    if (hasAny(['hello', 'hi', 'hey', 'yo', 'namaste', 'hola'])) {
      reply("Hi there! I’m Samarth’s Assistant 👋\nHow can I help you today?");
      return;
    }

    if (hasAny(
        ['how are you', 'how r u', 'how’s it going', "how's it going"])) {
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

    if (hasAny(['resume', 'cv'])) {
      reply("Here’s Samarth’s resume:\n\n"
          "• View: $resumeUrl\n\n"
          "• Direct download: $resumeDownloadUrl");
      return;
    }

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

    if (hasAny(['skill', 'skills', 'tech stack', 'technology'])) {
      reply("Samarth’s skills:\n${bulletify(skills)}");
      return;
    }

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

    if (hasAny(['project', 'projects'])) {
      final sb = StringBuffer("Here are Samarth’s projects:\n");
      for (int i = 0; i < projects.length; i++) {
        final p = projects[i];
        sb.writeln("${i + 1}. ${p.title} — ${p.subtitle.trim()}");
      }
      sb.writeln(
          "\nAsk for **open Project_Number Or open Project_Name** to see details, GitHub, and Live link.");
      reply(sb.toString());
      return;
    }

    if (hasAny(
        ['open', 'detail', 'details', 'show', 'more about', 'project'])) {
      Project? p;

      final idx = extractIndex1Based(lower);
      if (idx != null && idx >= 1 && idx <= projects.length) {
        p = projects[idx - 1];
      } else {
        String cleaned = lower;

        final commands = [
          'open ',
          'open',
          'detail ',
          'detail',
          'details ',
          'details',
          'show project ',
          'show project',
          'show ',
          'show',
          'more about ',
          'more about',
          'project ',
          'project'
        ];

        for (final cmd in commands) {
          if (cleaned.startsWith(cmd)) {
            cleaned = cleaned.replaceFirst(cmd, '').trim();
          }
        }

        if (cleaned.isEmpty) {
          reply("Tell me which project you'd like to open. For example:\n\n"
              "**open E-Commerce**\n"
              "**open 3**\n"
              "**open Online Code Editor**");
          return;
        }

        final found = projects.where((proj) {
          final t = proj.title.toLowerCase();
          final s = (proj.subtitle).toLowerCase();
          return t.contains(cleaned) || s.contains(cleaned);
        }).toList();

        if (found.isNotEmpty) {
          p = found.first;
        }
      }

      if (p != null) {
        final techs =
            (p.technologies.map((tech) => tech.name).toList()).join(', ');

        reply(
          "**${p.title}**\n\n"
          "${p.subtitle}\n\n"
          "🧑‍💻 **Tech Stack:** $techs\n\n"
          "🌐 **GitHub:** ${p.githubUrl}\n\n"
          "🚀 **Live:** ${p.launchUrl}\n\n"
          "🐞 **Issues:** ${p.githubUrl}/issues",
        );
        return;
      }

      reply("I couldn’t find that project 🤔\n"
          "Try something like:\n\n"
          "• **open 1**\n"
          "• **open digital shop**\n"
          "• **open portfolio app**");
      return;
    }

    if (hasAny(['version', 'build', 'apk', 'download app'])) {
      final apkUrl =
          "https://github.com/samadagade/flutter-portfolio/releases/download/v${AppInfo.version}/flutter_portfolio_v${AppInfo.version}.apk";
      reply("App version: ${AppInfo.version} (build ${AppInfo.buildNumber})\n\n"
          "Android APK: $apkUrl");
      return;
    }

    if (hasAny(['joke'])) {
      reply(
          "Why do programmers prefer dark mode? Because light attracts bugs. 🐛");
      return;
    }

    reply(
        "I’m not sure how to respond to that yet 🤔\n\nTry **help** to see what I can do.");
  }

  // 1) If no internet → local bot
  final online = await NetworkUtils.isConnected;
  if (!online) {
    typingController.add(false);
    await localBot();
    return;
  }

  // 2) Try API → fallback to local on server errors/timeouts
  typingController.add(true);

  try {
    final api = PortfolioBotApi(baseUrl: chatbotBaseUrl);
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();

    final resp = await api
        .ask(sessionId: sessionId, prompt: originalMessage)
        .timeout(const Duration(seconds: 12));

    if (resp.trim().isEmpty) {
      typingController.add(false);
      await localBot();
      return;
    }

    reply(resp);
  } catch (_) {
    typingController.add(false);
    await localBot();
  }
}
