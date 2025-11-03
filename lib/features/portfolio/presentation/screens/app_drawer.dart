import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/core/util/coming_soon_snackbar.dart';
import 'package:portfolio/core/util/lauch_url.dart';
import 'package:portfolio/core/util/utility.dart';
import 'package:portfolio/core/widgets/app_info.dart';
import 'package:portfolio/core/widgets/share_copy.dart';


class AppDrawer extends StatelessWidget {
  final Animation<double> glowAnimation;
  final VoidCallback onToggleTheme;
  final VoidCallback onContactTap;

  // ignore: use_key_in_widget_constructors
  const AppDrawer({
    required this.glowAnimation,
    required this.onToggleTheme,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
  
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode(context)
                      ? [Colors.blueGrey.shade800, Colors.blueGrey.shade700]
                      : [Colors.blue.shade50, Colors.blue.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: glowAnimation,
                    builder: (context, _) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.6),
                              blurRadius: glowAnimation.value,
                              spreadRadius: glowAnimation.value / 2,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage(
                            'assets/images/social/profile_picture.jpeg',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Samarth",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Flutter Developer",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    
            // Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerTile(
                    leadingIcon: FontAwesomeIcons.house,
                    title: "Home",
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerTile(
                    leadingIcon: FontAwesomeIcons.code,
                    title: "Projects",
                    onTap: () {
                      comingSoonSnackbar(context);
                      Navigator.pop(context);
                    },
                  ),
                  _DrawerTile(
                    leadingIcon: FontAwesomeIcons.toolbox,
                    title: "Skills",
                    onTap: () {
                      comingSoonSnackbar(context);
                      Navigator.pop(context);
                    },
                  ),
                  _DrawerTile(
                    leadingIcon: FontAwesomeIcons.addressCard,
                    title: "Experience",
                    onTap: () {
                      comingSoonSnackbar(context);
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(height: 20),
    
                  // Theme toggle
                  SwitchListTile.adaptive(
                    secondary: const Icon(Icons.brightness_6_rounded),
                    title: const Text("Toggle Theme"),
                    value: isDarkMode(context),
                    onChanged: (_) {
                      Navigator.pop(context);
                      onToggleTheme();
                    },
                  ),
    
                  _DrawerTile(
                    leadingIcon: FontAwesomeIcons.solidComments,
                    title: "Contact Me",
                    onTap: () {
                      Navigator.pop(context);
                      onContactTap();
                    },
                    onLongPress: (){
                      Navigator.pop(context);
                      showShareCopyDialogByType(context: context, option :  PopupOption.contactme);
                    },
                  ),
    
                  // External links (optional)
                  _DrawerTile(
                    leadingIcon: FontAwesomeIcons.github,
                    title: 'GitHub',
                    onTap: () {
                      Navigator.pop(context);
                      launchLink(githubProfileUrl, context);
                    },
                    onLongPress: (){
                      Navigator.pop(context);
                      showShareCopyDialogByType(context: context, option : PopupOption.github);
                    },
                    trailingIcon: FontAwesomeIcons.externalLink,
                  ),
                  _DrawerTile(
                    leadingIcon: FontAwesomeIcons.linkedin,
                    title: "LinkedIn",
                    onTap: () {
                      Navigator.pop(context);
                      launchLink(linkedinProfileUrl, context);
                    },
                    onLongPress: () {
                      Navigator.pop(context);
                      showShareCopyDialogByType(context: context, option :  PopupOption.linkedin);
                    },
                    trailingIcon: FontAwesomeIcons.externalLink,
                  ),
    
                  _DrawerTile(
                    leadingIcon: Icons.android,
                    title: 'Download Android APK',
                    onTap: () {
                      Navigator.pop(context);
                      launchLink(androidAPKUrl, context);
                    },
                    onLongPress: () {
                    Navigator.pop(context);
                    showShareCopyDialogByType(context: context,  option : PopupOption.androidapk);
                    },
                    trailingIcon: Icons.update,         
                  ),
    
                  _DrawerTile(
                    leadingIcon: Icons.apple_rounded,
                    title: 'Download IOS IPA',
                    onTap: () {
                      Navigator.pop(context);
                      comingSoonSnackbar(context,
                          message: "The iOS version coming soon. Stay tuned!");
                    },
                    onLongPress: () {
                      Navigator.pop(context);
                      comingSoonSnackbar(context,
                          message: "The iOS version coming soon. Stay tuned!");
                    },
                  ),
                  
                  _DrawerTile(
                    leadingIcon: Icons.info,
                    title: 'App Info',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AppInfoPage()));
                    },
                    onLongPress: () {
                      Navigator.pop(context);
                      comingSoonSnackbar(context,
                          message: "The iOS version coming soon. Stay tuned!");
                    },
                  ),
                ],
              ),
            ),
    
            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    getColor(context,
                        lightColor: Colors.blueAccent,
                        darkColor: Colors.tealAccent),
                    getColor(context,
                        lightColor: Colors.purpleAccent,
                        darkColor: Colors.orangeAccent),
                  ],
                ).createShader(bounds),
                child: Text(
                  '© $year Samarth Dagade',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white, // Needed for ShaderMask
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final VoidCallback onTap;
  final IconData? trailingIcon;
  // ignore: prefer_typing_uninitialized_variables
  final onLongPress;
  const _DrawerTile({
    required this.leadingIcon,
    required this.title,
    required this.onTap,
    this.onLongPress,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FaIcon(leadingIcon, size: 18),
      title: Text(title),
      trailing: FaIcon(trailingIcon, size: 18),
      dense: true,
      minLeadingWidth: 22,
      onTap: onTap,
      onLongPress: onLongPress,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      visualDensity: VisualDensity.compact,
    );
  }
}