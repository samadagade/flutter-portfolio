import 'package:portfolio/features/portfolio/domain/entities/skill.dart';

class Project {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final List<Skill> technologies;
  final String githubUrl;
  final String launchUrl;
  final String apkUrl;
  final String date;
  final bool isFeatured;

  const Project({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.technologies,
    required this.githubUrl,
    required this.launchUrl,
    this.isFeatured = true,
    this.apkUrl = '',
    this.date = 'Recently',
  });

  bool get hasApk => apkUrl.isNotEmpty;
}