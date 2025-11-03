import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Skill {
  final String name;
  const Skill({required this.name});

    Widget get icon{
    switch (name.toLowerCase()) {
      case 'flutter':
        return Image.asset("assets/images/project/flutter.png");
      case 'firebase':
        return Image.asset("assets/images/project/firebase.png");
      case 'react':
        return const FaIcon(FontAwesomeIcons.react,
            size: 16, color: Colors.cyan);
      case 'git':
        return Image.asset("assets/images/project/git.png");
      case 'junit':
        return Image.asset("assets/images/project/junit.png");
      case 'github':
        return const FaIcon(FontAwesomeIcons.github,
            size: 16, color: Colors.black);
      case 'java':
        return const FaIcon(FontAwesomeIcons.java,
            size: 16, color: Colors.redAccent);
      case 'mysql':
        return const FaIcon(FontAwesomeIcons.database,
            size: 16, color: Colors.teal);
      case 'html':
        return const FaIcon(FontAwesomeIcons.html5,
            size: 16, color: Colors.deepOrange);
      case 'css':
        return const FaIcon(FontAwesomeIcons.css3Alt,
            size: 16, color: Colors.blue);
      case 'js':
      case 'javascript':
        return const FaIcon(FontAwesomeIcons.js,
            size: 16, color: Colors.orange);
      default:
        return const Icon(Icons.memory, size: 16, color: Colors.indigo);
    }
  }
}

