import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/core/util/lauch_url.dart';
import 'package:portfolio/core/util/utility.dart';
import 'package:portfolio/core/widgets/contact_button.dart';
import 'package:portfolio/core/widgets/share_copy.dart';
import 'package:portfolio/core/widgets/social_icons.dart';

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
                            color: getColor(context,
                                lightColor: Colors.black,
                                darkColor: Colors.amber),
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
                            color: getColor(context,
                                lightColor: Colors.black,
                                darkColor: Colors.lightBlue),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        TyperAnimatedText(
                          "Java Developer",
                          textStyle: TextStyle(
                            color: getColor(context,
                                lightColor: Colors.black,
                                darkColor: Colors.orange),
                            fontSize: headingFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
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
                        onLongPress: () => showShareCopyDialogByType(
                              context: context,
                              option: PopupOption.resume,
                            )),
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
