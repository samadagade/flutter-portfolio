import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/core/util/lauch_url.dart';
import 'package:portfolio/core/widgets/contact_button.dart';
import 'package:portfolio/core/widgets/share_copy.dart';
import 'package:portfolio/core/widgets/social_icons.dart';
import 'package:portfolio/features/chatbot/presentation/chat_bot.dart';


Widget leftPanel(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  // ignore: unused_local_variable
  double screenHeight = MediaQuery.of(context).size.height;
  double headingFontSize =
      screenWidth > 800 ? 48 : (screenWidth > 600 ? 36 : 28);

  return SingleChildScrollView(
    child: Column(
      children: [
        Stack(
          children: [
            // Opacity(
            //   opacity: 0.5,
            //   child: Padding(
            //     padding: const EdgeInsets.all(4.0),
            //     child: ClipRRect(
            //       borderRadius: const BorderRadius.all(Radius.circular(20)),
            //       child: Image.asset(
            //         "assets/images/social/background_image_1.png",
            //         height: screenWidth > 450
            //             ? screenHeight - 60
            //             : screenHeight * 0.83,
            //         width: double.infinity,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            // ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Text(
                      "Hi, \nI'm Samarth",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth > 800
                            ? 36
                            : (screenWidth > 600 ? 28 : 24),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedTextKit(
                      isRepeatingAnimation: true,
                      repeatForever: true,
                      pause: const Duration(seconds: 2),
                      animatedTexts: [
                        TyperAnimatedText(
                          "Software Developer",
                          textStyle: TextStyle(
                            color: Colors.amber,
                            fontSize: headingFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        TyperAnimatedText(
                          "Flutter Developer",
                          textStyle: TextStyle(
                            fontSize: headingFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        TyperAnimatedText(
                          "Java Developer",
                          textStyle: TextStyle(
                            color: Colors.orange,
                            fontSize: headingFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       ChatBotButton(onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ChatBot(),
                            ),
                          );
                        }),
                        ContactButton(
                            buttonText: "Resume",
                            icon: const Icon(
                              FontAwesomeIcons.filePdf,
                              size: 16,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              launchLink(
                                  // ignore: use_build_context_synchronously
                                  resumeUrl,
                                  context);
                            },
                            onLongPress: () => showShareCopyDialogByType(
                                  context: context,
                                  option: PopupOption.resume,
                                )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (!kIsWeb) Positioned(right: 60, top: 650, child: ButtonRow()),
          ],
        ),
      ],
    ),
  );
}




/// Chatbot Call-to-Action Button
class ChatBotButton extends StatelessWidget {
  final VoidCallback onTap;
  const ChatBotButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6D5DF6), Color(0xFF22D3EE)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.smart_toy_outlined, color: Colors.white),
            Text(
              "AI Help",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}