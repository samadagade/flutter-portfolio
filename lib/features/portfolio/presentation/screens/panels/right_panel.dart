import 'package:flutter/material.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/features/portfolio/presentation/screens/panels/tabs/blogs_section_tab.dart';
import 'package:portfolio/features/portfolio/presentation/screens/panels/tabs/experience_section_tab.dart';
import 'package:portfolio/features/portfolio/presentation/screens/panels/tabs/project_section_tab.dart';
import 'package:portfolio/features/portfolio/presentation/screens/panels/tabs/skill_section_tab.dart';
import 'package:portfolio/core/util/utility.dart';

Widget rightPanel(BuildContext context, TabController tabController) {
  final double screenHeight = MediaQuery.of(context).size.height;
  final double dynamicHeight = screenHeight * 0.7;

  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TabBar(
          isScrollable: false,
          controller: tabController,
          unselectedLabelColor: getColor(context,
              lightColor: Colors.black, darkColor: Colors.grey),
          indicatorColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
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
