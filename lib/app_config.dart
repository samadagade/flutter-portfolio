import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Social media and contact URLs
String resumeUrl =
    "https://drive.google.com/file/d/1Ptw9xWTdnjbF0SPnrQzXW1hwj75ZFYyw/view";
String linkedinProfileUrl = "https://www.linkedin.com/in/samarth-dagade/";
String githubProfileUrl = "https://github.com/Samadagade";
String twitterProfileUrl =
    "https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://twitter.com/DagadeSamarth&ved=2ahUKEwjusoiEvZOMAxV2R2wGHZ49Dm4QFnoECCMQAQ&usg=AOvVaw0DcM11uDPl-nTa3oCI7HWx";
String gfgProfileUrl = "https://www.geeksforgeeks.org/user/samarthdagade/";
String anroidAPKUrl =
    "https://drive.google.com/file/d/1SKktVHe6Nn3T-31xn78geDFOCd3DhMhz/view?usp=sharing";
String exampleUrl = "https://example.com";
String whatsappContactUrl = "https://wa.me/9325728101";

// Social configuration for the app
bool showBlogsTab = false;
bool showImagesInProjectTab = true;
bool showFooter = kIsWeb ? true : false;

//List of projects
final List<Map<String, dynamic>> projects = [
  {
    "id": "1",
    "title": "Multi-Threaded File Downloader",
    "subtitle":
        "Developed a Glassmorphism-styled web app for fast multi-threaded downloads with connection detection and pause/resume control.",
    "image": "assets/images/project/multi-threaded-file-downloader.jpg",
    "technologies": ["HTML", "CSS", "JS", "Git", "Github"],
    "github_url": "https://github.com/samadagade/Multi-Threaded-Downloader",
    "launch_url": "https://samadagade.github.io/Multi-Threaded-Downloader/",
  },
  {
    "id": "2",
    "title": "Smart Home Hub",
    "subtitle":
        "Developed a modular Java Smart Home System (TV, Thermostat, Speakers) using OOP; ensured reliability via full JUnit testing.",
    "image": "assets/images/project/smart_home.png",
    "technologies": ["Java", "OOP", "Junit", "Git", "Github"],
    "github_url": "https://github.com/samadagade/Smart-Home",
    "launch_url": "https://github.com/samadagade/Smart-Home",
  },
  {
    "id": "3",
    "title": "Portfolio Website",
    "subtitle": "A personal portfolio built using HTML, CSS, and JavaScript.",
    "image": "assets/images/project/portfolio.png",
    "technologies": ["HTML", "CSS", "JS", "Git", "Github"],
    "github_url": "https://github.com/samadagade/portfolio",
    "launch_url": "https://samadagade.github.io/portfolio/##",
  },
  {
    "id": "4",
    "title": "E-Commerce App",
    "subtitle":
        "E-Commerce app with Firebase Auth, Bloc, wishlist, cart, and clean UI built using Flutter.",
    "image":
        "https://cdn.acowebs.com/wp-content/uploads/2019/02/Impact-of-eCommerce-On-Society.png",
    "technologies": ["Flutter", "Firebase", "Bloc", "Git", "Github",]
  },
];

//list of experiences
final experiences = [
  {
    "role": "Junior Software Developer",
    "company": "Börm Bruckmeier Infotech India Pvt. Ltd.",
    "duration": "Oct 2024 - Present",
    "description":
        '• Improved and redesigned UI/UX components across multiple Flutter-based apps (AP, Rheum-a, DGK Web, EHA Web), including responsive layouts, navigation flow, and feedback integration.\n'
            '• Led implementation of new features such as splash screens, user account systems, TOC with gradient support, and analytics tracking, along with structured testing and deployment via TestFlight.\n'
            '• Created detailed flowcharts for user account and login processes, resolved complex bugs, and researched browser history management in Flutter Web to support scalable web solutions.',
  },
];

// List of skills
final List<String> skills = [
  "Flutter",
  "Java",
  "SQL",
  "Git",
  "OOP",
  "HTML",
  "CSS",
  "Firebase",
  "Regex",
  "Github",
  "DSA",
  "Junit",
  "Springboot"
];

//to manage color based on theme
Color getColor(BuildContext context,
    {required Color lightColor, required Color darkColor}) {
  return Theme.of(context).brightness == Brightness.dark
      ? darkColor
      : lightColor;
}
