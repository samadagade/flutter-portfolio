import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/util/lauch_url.dart';
import 'package:portfolio/widgets/basic_widgets/contact_button.dart';
import 'package:portfolio/widgets/basic_widgets/social_icons.dart';

Widget leftPanel(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  double headingFontSize =
      screenWidth > 800 ? 48 : (screenWidth > 600 ? 36 : 28);

  return SingleChildScrollView(
    child: Column(
      children: [
        Stack(
          children: [
            Opacity(
              opacity: 0.5,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Image.asset(
                    "assets/images/social/background_picture.png",
                    height: screenWidth > 450
                        ? screenHeight - 60
                        : screenHeight * 0.83,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    AnimatedTextKit(
                      key: const Key("animated_text"),
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TyperAnimatedText(
                          "Hi, \nI'm Samarth \nSoftware Developer",
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(
                            fontSize: headingFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
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
