import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/util/lauch_url.dart';

class ButtonRow extends StatelessWidget {
  const ButtonRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          iconSize: 40,
          color: getColor(context,
              lightColor: Color(0xFF0D5EC8),
              darkColor: Color(0xFF0A66C2)), // LinkedIn
          icon: const FaIcon(FontAwesomeIcons.linkedin),
          onPressed: () {
            launchLink(linkedinProfileUrl, context);
          },
        ),
        IconButton(
          iconSize: 40,
          color: getColor(context,
              lightColor: Color(0xFF171515), darkColor: Colors.white), // GitHub
          icon: const FaIcon(FontAwesomeIcons.github),
          onPressed: () {
            launchLink(githubProfileUrl, context);
          },
        ),
        GestureDetector(
          child: Image.network(
            "https://img.icons8.com/?size=256&id=AbQBhN9v62Ob&format=png",
            height: 40,
            width: 40,
            color: getColor(context,
                lightColor: Colors.white, darkColor: Color(0xFF32CD32)),
          ),
          onTap: () {
            launchLink(gfgProfileUrl, context);
          },
        )
      ],
    );
  }
}

Widget buttonRowForFooter(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        iconSize: 10,
        color: getColor(context,
            lightColor: Color(0xFF0D5EC8), darkColor: Color(0xFF0A66C2)),
        icon: FaIcon(FontAwesomeIcons.linkedin),
        onPressed: () {
          launchLink(linkedinProfileUrl, context);
        },
      ),
      Container(
        height: 20,
        width: 1,
        color: Colors.grey.shade400,
      ),
      IconButton(
        iconSize: 10,
        color: getColor(context,
            lightColor: Color(0xFF171515), darkColor: Colors.white),
        icon: FaIcon(FontAwesomeIcons.github),
        onPressed: () {
          launchLink(githubProfileUrl, context);
        },
      ),
    ],
  );
}
