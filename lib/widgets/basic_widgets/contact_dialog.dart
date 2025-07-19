import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/util/lauch_url.dart';
import 'package:portfolio/util/mail_to.dart';

void showContactDialog(BuildContext context) {
  showDialog(
    context: context,
    // ignore: deprecated_member_use
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: getColor(context,
              lightColor: Colors.white,
              darkColor: Colors.black),
          title: Center(
              child: Text(
            "Contact Me",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: getColor(context,
                    lightColor: Colors.black, darkColor: Colors.white)),
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Let’s connect!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: getColor(context,
                          lightColor: Colors.black, darkColor: Colors.white))),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: "WhatsApp",
                    iconSize: 32,
                    onPressed: () => launchLink(whatsappContactUrl, context),
                    icon:
                        FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    tooltip: "Email",
                    iconSize: 32,
                    onPressed: () => launchMailto(),
                    icon: FaIcon(FontAwesomeIcons.envelope, color: Colors.blue),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
