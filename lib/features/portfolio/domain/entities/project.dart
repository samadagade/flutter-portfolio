class Project {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final List<String> technologies;
  final String githubUrl;
  final String launchUrl;
  final String apkUrl;
  final String date;

  const Project({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.technologies,
    required this.githubUrl,
    required this.launchUrl,
    this.apkUrl = '',
    this.date = 'Recently',
  });
}
