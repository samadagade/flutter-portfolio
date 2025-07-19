import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FaIcon, FontAwesomeIcons;
import 'package:portfolio/app_config.dart';
import 'package:portfolio/util/lauch_url.dart';

Widget buildProjectsSection() {
  Widget getTechIcon(String tech) {
    switch (tech.toLowerCase()) {
      case 'flutter':
           return Image.asset("assets/images/project/flutter.png",);
      case 'firebase':
        return Image.asset("assets/images/project/firebase.png",);
      case 'react':
        return const FaIcon(FontAwesomeIcons.react,
            size: 16, color: Colors.cyan);
      case 'git':
        return Image.asset("assets/images/project/git.png",);
      case 'junit':
        return Image.asset("assets/images/project/junit.png",);
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
        return const FaIcon(FontAwesomeIcons.js, size: 16, color: Colors.orange);
      default:
        return const Icon(Icons.memory, size: 16, color: Colors.indigo);
    }
  }

  return ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    itemCount: projects.length,
    itemBuilder: (context, index) {
      final project = projects[index];
      bool isExpanded = false;

      return StatefulBuilder(builder: (context, setState) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // ignore: deprecated_member_use
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Material(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.1),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => setState(() => isExpanded = !isExpanded),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[900]
                                  : Color(0xFFe3f2fd),
                              child:
                                  Icon(Icons.work_outline, color: Colors.blue),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project["title"] ?? "Project Title",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    project["subtitle"] ??
                                        "Brief description...",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.open_in_new,
                                  color: Colors.blue),
                              tooltip: "Open Project",
                              onPressed: () async {
                                launchLink(
                                    // ignore: use_build_context_synchronously
                                    project["launch_url"] ?? exampleUrl,
                                    context);
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // /// Hero Image
                        // if (project["image"] != null && showImagesInProjectTab)
                        //   Hero(
                        //     tag: 'projectImage_${project["id"]}',
                        //     child: ClipRRect(
                        //       borderRadius: BorderRadius.circular(14),
                        //       child: isNetworkImage(project["image"]!)
                        //           ? Image.network(
                        //               project["image"]!,
                        //               height: 190,
                        //               width: double.infinity,
                        //               fit: BoxFit.cover,
                        //               loadingBuilder:
                        //                   (context, child, loadingProgress) {
                        //                 if (loadingProgress == null) {
                        //                   return child;
                        //                 }
                        //                 return Container(
                        //                   height: 190,
                        //                   alignment: Alignment.center,
                        //                   child:
                        //                       const CircularProgressIndicator(),
                        //                 );
                        //               },
                        //             )
                        //           : Image.asset(
                        //               project["image"]!,
                        //               height: 240,
                        //               width: double.infinity,
                        //               fit: BoxFit.cover
                        //             ),
                        //     ),
                        //   ),

                        const SizedBox(height: 14),

                        /// Tech Stack Chips
                        if (project["technologies"] != null &&
                            project["technologies"] is List)
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: (project["technologies"] as List)
                                .map<Widget>((tech) => Chip(
                                      label: Text(tech),
                                      backgroundColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.indigo.shade100
                                              : Colors.indigo.shade50,
                                      // backgroundColor: Colors.indigo.shade50,
                                      labelStyle:
                                          const TextStyle(color: Colors.indigo),
                                      avatar: getTechIcon(tech),
                                    ))
                                .toList(),
                          ),

                        const SizedBox(height: 20),

                        /// Expandable Section
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (project["image"] != null &&
                                  showImagesInProjectTab)
                                Hero(
                                  tag: 'projectImage_${project["id"]}',
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: isNetworkImage(project["image"]!)
                                        ? Image.network(
                                            project["image"]!,
                                            height: 190,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Container(
                                                height: 190,
                                                alignment: Alignment.center,
                                                child:
                                                    const CircularProgressIndicator(),
                                              );
                                            },
                                          )
                                        : Image.asset(project["image"]!,
                                            height: 240,
                                            width: double.infinity,
                                            fit: BoxFit.cover),
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Text(
                                "Updated: ${project["date"] ?? "Recently"}",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      launchLink(
                                          // ignore: use_build_context_synchronously
                                          project["launch_url"] ?? exampleUrl,
                                          context);
                                    },
                                    icon: const Icon(Icons.visibility_outlined),
                                    label: const Text("View"),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      launchLink(
                                          // ignore: use_build_context_synchronously
                                          project["github_url"] ?? exampleUrl,
                                          context);
                                    },
                                    icon: const Icon(Icons.code),
                                    label: const Text("Source"),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.deepPurple,
                                      side: const BorderSide(
                                          color: Colors.deepPurple),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}

bool isNetworkImage(String url) {
  return url.startsWith('http://') || url.startsWith('https://');
}
