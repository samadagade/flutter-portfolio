import 'package:flutter/material.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/widgets/tabs/blogs_section_tab.dart';
import 'package:portfolio/widgets/tabs/experience_section_tab.dart';
import 'package:portfolio/widgets/tabs/project_section_tab.dart';
import 'package:portfolio/widgets/tabs/skill_section_tab.dart';

Widget rightPanel(BuildContext context, TabController tabController) {
  final double screenHeight = MediaQuery.of(context).size.height;
  final double dynamicHeight = screenHeight * 0.7;

  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TabBar(
          controller: tabController,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(text: "Experience"),
            Tab(text: "Projects"),
            Tab(text: "Skills"),
            if (showBlogsTab) Tab(text: "Blogs"),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: dynamicHeight,
          child: TabBarView(
            controller: tabController,
            children: [
              buildExperienceSection(),
              buildProjectsSection(),
              buildSkillsSection(),
              if (showBlogsTab) buildBlogsSection(),
            ],
          ),
        ),
      ],
    ),
  );
}