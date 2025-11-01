import 'package:flutter/foundation.dart';
import 'package:portfolio/features/portfolio/domain/entities/experience.dart';
import 'package:portfolio/features/portfolio/domain/entities/project.dart';
import 'package:portfolio/features/portfolio/domain/entities/skill.dart';
import 'core/util/app_details.dart';

// Social media and contact URLs
String resumeUrl =
    "https://drive.google.com/file/d/1Ptw9xWTdnjbF0SPnrQzXW1hwj75ZFYyw/view";
String resumeDownloadUrl =
    "https://drive.google.com/file/d/1Ptw9xWTdnjbF0SPnrQzXW1hwj75ZFYyw";
String linkedinProfileUrl = "https://www.linkedin.com/in/samarth-dagade/";
String githubProfileUrl = "https://github.com/samadagade";
String twitterProfileUrl = "https://twitter.com/DagadeSamarth";
String gfgProfileUrl = "https://www.geeksforgeeks.org/user/samarthdagade/";
String androidAPKUrl =
    "https://github.com/samadagade/flutter-portfolio/releases/download/v${AppInfo.version}/flutter_portfolio_v${AppInfo.version}.apk";
String webUrl = "https://samarth-dagade.netlify.app";
String exampleUrl = "https://example.com";
String whatsappContactUrl = "https://wa.me/9325728101";

// Social configuration for the app
bool showBlogsTab = false;
bool showImagesInProjectTab = true;
bool showFooter = kIsWeb;
bool showSearchButtonInAppBar = false;
bool showDrawer = false;

// contact details
final phoneNumber = '+91 9325728101';
final email = 'samarthdagade@gmail.com';

// List of projects
final List<Project> projects = List.unmodifiable(const [
  Project(
    id: "1",
    title: "E-Commerce App",
    subtitle:
        "E-Commerce app with Firebase Auth, Bloc, wishlist, cart, and clean UI built using Flutter.",
    image:
        "https://cdn.acowebs.com/wp-content/uploads/2019/02/Impact-of-eCommerce-On-Society.png",
    technologies: ["Flutter", "Firebase", "Bloc", "Git", "Github"],
    githubUrl: "https://github.com/samadagade/E-commerce-App",
    launchUrl: "https://luma-ecommerce.netlify.app/",
  ),
  Project(
    id: "2",
    title: "Smart Home Hub",
    subtitle:
        "Developed a modular Java Smart Home System (TV, Thermostat, Speakers) using OOP; ensured reliability via full JUnit testing.",
    image: "assets/images/project/smart_home_hub.png",
    technologies: ["Java", "OOP", "Junit", "Git", "Github"],
    githubUrl: "https://github.com/samadagade/Smart-Home",
    launchUrl: "https://github.com/samadagade/Smart-Home",
  ),
  Project(
    id: "3",
    title: "Multi-Threaded File Downloader",
    subtitle:
        "Developed a Glassmorphism-styled web app for fast multi-threaded downloads with connection detection and pause/resume control.",
    image: "assets/images/project/multi-threaded-file-downloader.jpg",
    technologies: ["HTML", "CSS", "JS", "Git", "Github"],
    githubUrl: "https://github.com/samadagade/Multi-Threaded-Downloader",
    launchUrl: "https://samadagade.github.io/Multi-Threaded-Downloader/",
  ),
  Project(
    id: "4",
    title: "CodeAlchemy – Online Code Editor",
    subtitle:
        "A lightweight, browser-based live editor that lets you write and instantly preview HTML, CSS, and JavaScript in real time.",
    image: "assets/images/project/online-code-editor.png",
    technologies: ["HTML", "CSS", "JS", "Git", "Github"],
    githubUrl: "https://github.com/samadagade/OnlineCodeEditor",
    launchUrl: "https://samadagade.github.io/OnlineCodeEditor/",
  ),
  Project(
    id: "5",
    title: "Portfolio Website",
    subtitle: "A personal portfolio built using HTML, CSS, and JavaScript.",
    image: "assets/images/project/portfolio.png",
    technologies: ["HTML", "CSS", "JS", "Git", "Github"],
    githubUrl: "https://github.com/samadagade/portfolio",
    launchUrl: "https://samadagade.github.io/portfolio/##",
  ),
]);

// List of experiences
final List<Experience> experiences = List.unmodifiable(const [
  Experience(
    role: "Junior Software Developer",
    company: "Börm Bruckmeier Infotech India Pvt. Ltd.",
    duration: "Oct 2024 - Present",
    description:
        '• Improved and redesigned UI/UX components across multiple Flutter-based apps (AP, Rheum-a, DGK Web, EHA Web), including responsive layouts, navigation flow, and feedback integration.\n'
        '• Led implementation of new features such as splash screens, user account systems, TOC with gradient support, and analytics tracking, along with structured testing and deployment via TestFlight.\n'
        '• Created detailed flowcharts for user account and login processes, resolved complex bugs, and researched browser history management in Flutter Web to support scalable web solutions.',
  ),
]);

// List of skills
final List<Skill> skills = List.unmodifiable(const [
  Skill(name: "Flutter"),
  Skill(name: "Java"),
  Skill(name: "SQL"),
  Skill(name: "Git"),
  Skill(name: "OOP"),
  Skill(name: "HTML"),
  Skill(name: "CSS"),
  Skill(name: "Firebase"),
  Skill(name: "Regex"),
  Skill(name: "GitHub"),
  Skill(name: "DSA"),
  Skill(name: "Unit"),
  Skill(name: "Spring Boot"),
]);
