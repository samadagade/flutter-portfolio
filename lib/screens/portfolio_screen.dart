import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/util/lauch_url.dart';
import 'package:portfolio/widgets/basic_widgets/contact_dialog.dart';
import 'package:portfolio/widgets/basic_widgets/contact_button.dart';
import '../widgets/basic_widgets/body.dart';

class Portfolio extends StatefulWidget {
  final VoidCallback toggleTheme;
  const Portfolio({super.key, required this.toggleTheme});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        shadowColor: Colors.black12,
        title: Row(
          children: [
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.blueAccent.withOpacity(0.6),
                          blurRadius: _glowAnimation.value,
                          spreadRadius: _glowAnimation.value / 2,
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage(
                          'assets/images/social/profile_picture.jpeg'),
                    ));
              },
            ),
            const SizedBox(width: 12),
            const Text(
              "Samarth",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          if (kIsWeb && screenWidth > 405)
            IconButton(
              iconSize: 18,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
              icon: Icon(Icons.android, size: 18),
              onPressed: () {
                if (kIsWeb) {
                  launchLink(anroidAPKUrl, context);
                }
              },
            ),
          IconButton(
            onPressed: widget.toggleTheme,
            icon: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
          Container(
            height: 18,
            width: 1,
            color: Colors.grey.shade400,
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),
          ContactButton(
              buttonText: "Contact Me",
              icon: const FaIcon(
                FontAwesomeIcons.solidComments,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () {
                showContactDialog(context);
              }),
          const SizedBox(width: 16),
        ],
      ),
      body: Body(),
    );
  }
}
