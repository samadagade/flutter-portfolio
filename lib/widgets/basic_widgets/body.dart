import 'package:flutter/material.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/widgets/footer.dart';
import 'package:portfolio/widgets/panels/left_panel.dart';
import 'package:portfolio/widgets/panels/right_panel.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: showBlogsTab ? 4 : 3, vsync: this);
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

        //Layout for large devices
        if (isWideScreen) {
          return Row(
            children: [
              Expanded(flex: 1, child: leftPanel(context)),
              Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      rightPanel(context, _tabController),
                      if (showFooter) PortfolioFooter(context),
                    ],
                  ))),
            ],
          );
        }

        // Portrait layout for small devices
        return SingleChildScrollView(
          child: Column(
            children: [
              leftPanel(context),
              rightPanel(context, _tabController),
              if (showFooter) PortfolioFooter(context),
            ],
          ),
        );
      },
    );
  }
}