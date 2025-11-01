import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/core/util/utility.dart';
import 'package:portfolio/core/widgets/enhanced_snackbar.dart';
import 'package:share_plus/share_plus.dart';

void copyToClipboard({
  required BuildContext context,
  required String clipbarodData,
}) {
  Clipboard.setData(ClipboardData(text: clipbarodData));
}

String getPhoneUrl() {
  final String url = 'tel:$phoneNumber';
  return url;
}

/// Builds a nicely formatted block of text from either:
/// - [raw] a full custom string, or
/// - [lines] a list of lines, or
/// - [labeled] a map of {Label: Value}
String _buildShareText({
  String? raw,
  List<String>? lines,
  Map<String, String>? labeled,
}) {
  if (raw != null && raw.trim().isNotEmpty) return raw;
  if (lines != null && lines.isNotEmpty) return lines.join('\n');
  if (labeled != null && labeled.isNotEmpty) {
    return labeled.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }
  return '';
}

String _buildCopyText({
  String? raw,
  List<String>? lines,
  Map<String, String>? labeled,
}) {
  if (raw != null && raw.trim().isNotEmpty) return raw;
  if (lines != null && lines.isNotEmpty) return lines.join('\n');
  if (labeled != null && labeled.isNotEmpty) {
    return labeled.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }
  return '';
}

/// Dynamic dialog: pass any content you want to copy/share.
/// Keep your theme & glass blur intact.
Future<void> showShareCopyDialog(
  BuildContext context, {
  String title = "Share or Copy to Clipboard",

  // What is SHOWN in the dialog (existing API)
  String? raw,
  List<String>? lines,
  Map<String, String>? labeled,

  // What is actually COPIED/SHARED (new & optional)
  String? shareRaw,
  List<String>? shareLines,
  Map<String, String>? shareLabeled,
  VoidCallback? onAfterCopy,
  VoidCallback? onAfterShare,
  Color copyColor = Colors.teal,
  Color shareColor = Colors.cyan,
}) async {
  // Build display text (what users see)
  final displayText =
      _buildShareText(raw: shareRaw, lines: shareLines, labeled: shareLabeled);

  // Build share text (what gets copied/shared); falls back to display if not provided
  String shareText = _buildShareText(
    raw: shareRaw,
    lines: shareLines,
    labeled: shareLabeled,
  );
  String copyText = _buildCopyText(
    raw: raw,
    lines: lines,
    labeled: labeled,
  );
  if (shareText.trim().isEmpty) {
    shareText = displayText;
  }

  showDialog(
    context: context,
    barrierColor:
        Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: getColor(
            context,
            lightColor: Colors.transparent,
            darkColor: Colors.transparent,
          ),
          title: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: getColor(
                  context,
                  lightColor: Colors.black,
                  darkColor: Colors.white,
                ),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (displayText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: getColor(context,
                        lightColor: Colors.grey.shade100,
                        darkColor: Colors.grey.shade900),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SelectableText(
                    displayText,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: getColor(
                        context,
                        lightColor: Colors.black87,
                        darkColor: Colors.white70,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Copy
                  IconButton(
                    tooltip: "Copy",
                    iconSize: 32,
                    icon: FaIcon(FontAwesomeIcons.copy, color: copyColor),
                    onPressed: () {
                      copyToClipboard(
                          context: context, clipbarodData: copyText);
                      Navigator.pop(context);
                      showCustomSnackBar(
                        context: context,
                        icon: FontAwesomeIcons.clipboardCheck,
                        message: 'Details copied to clipboard!',
                        backgroundColor: copyColor,
                      );
                      onAfterCopy?.call();
                    },
                  ),
                  const SizedBox(width: 24),

                  // Share
                  IconButton(
                    tooltip: "Share",
                    iconSize: 32,
                    icon:
                        FaIcon(FontAwesomeIcons.shareNodes, color: shareColor),
                    onPressed: () {
                      Share.share(shareText, subject: title);
                      Navigator.pop(context);
                      onAfterShare?.call();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void>? showShareCopyDialogByType(
    {required BuildContext context, required PopupOption option}) {
  switch (option) {
    case PopupOption.contactme:
      return showShareCopyDialog(
        context,
        title: "Let's Connect Professionally!",
        lines: [
          "Let’s connect!",
          "Mail : $email",
          "Mobile Number : $phoneNumber"
              "LinkedIn: $linkedinProfileUrl",
          "GitHub: $githubProfileUrl",
          "Resume: $resumeUrl"
        ],
        shareLines: [
          "Let’s connect!",
          "Mail : $email",
          "Mobile Number : $phoneNumber",
          "LinkedIn: $linkedinProfileUrl",
          "GitHub: $githubProfileUrl",
        ],
      );
    case PopupOption.linkedin:
      return showShareCopyDialog(
        context,
        title: "LinkedIn Details",
        lines: [linkedinProfileUrl],
        shareLines: [
          "Let’s connect with Linkedin!",
          "LinkedIn: $linkedinProfileUrl",
        ],
      );
    case PopupOption.github:
      return showShareCopyDialog(context, title: "GitHub Details", lines: [
        githubProfileUrl
      ], shareLines: [
        "Let’s connect with GitHub!",
        "GitHub: $githubProfileUrl",
      ]);
    case PopupOption.androidapk:
      return showShareCopyDialog(
        context,
        title: "Android APK Details!",
        lines: [androidAPKUrl],
        shareLines: [
          "Let’s Share Android APK!",
          "Android APK: $androidAPKUrl",
        ],
      );
    case PopupOption.resume:
      return showShareCopyDialog(
        context,
        title: "Hire Me!",
        lines: [resumeUrl],
        shareLines: [
          "Resume : $resumeUrl",
        ],
      );
  }
}


enum PopupOption { contactme, linkedin, github, androidapk, resume }
