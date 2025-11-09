import 'package:flutter/material.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/core/widgets/footer.dart';
import 'package:portfolio/features/portfolio/presentation/screens/panels/left_panel.dart';
import 'package:portfolio/features/portfolio/presentation/screens/panels/right_panel.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  // ignore: library_private_types_in_public_api
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: showBlogsTab ? 4 : 3, vsync: this);
  }

  void changeTab(int index) {
    if (index >= 0 && index < _tabController.length) {
      _tabController.animateTo(index);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;

        return Stack(
          fit: StackFit.expand,
          children: [
            // 🔹 Background Image
            Positioned.fill(
              child: Opacity(
                opacity: 0.4, // Adjust for dim effect
                child: Image.asset(
                  "assets/images/social/background_image_1.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 🔹 Foreground Content
            isWideScreen
                ? Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 1, child: leftPanel(context)),
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  rightPanel(context, _tabController),
                                  // if (showFooter) PortfolioFooter(context),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (showFooter)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: PortfolioFooter(context),
                        ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        leftPanel(context),
                        rightPanel(context, _tabController),
                        if (showFooter) PortfolioFooter(context),
                      ],
                    ),
                  ),
          ],
        );
      },
    );
  }
}
