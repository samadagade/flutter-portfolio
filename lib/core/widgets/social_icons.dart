import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/core/util/coming_soon_snackbar.dart';
import 'package:portfolio/core/util/lauch_url.dart';
import 'package:portfolio/core/util/utility.dart';
import 'package:portfolio/core/widgets/app_info.dart';
import 'package:portfolio/core/widgets/share_copy.dart';
import '../util/app_details.dart';

/// -------------------------------
/// Helpers (dynamic sizing & model)
/// -------------------------------
double _iconSizeFor(BuildContext context, {bool footer = false}) {
  final w = MediaQuery.sizeOf(context).width;
  if (footer) {
    // Keep tiny in footer but scale a touch on larger widths
    if (w < 360) return 12;
    if (w < 600) return 12; // same default
    return 14; // slightly up on roomy screens
  } else {
    // Main row: preserve 40 on roomy screens, scale down on small
    if (w < 360) return 28;
    if (w < 800) return 34;
    return 40;
  }
}

bool _hasUrl(String? url) => (url != null && url.trim().isNotEmpty);

void _openOrSoon(BuildContext context, String? url) {
  if (_hasUrl(url)) {
    launchLink(url!, context);
  } else {
    comingSoonSnackbar(context);
  }
}

class _IconEntry {
  final Widget iconWidget; // FaIcon or Image
  final Color Function(BuildContext) colorOf;
  final String? url;
  final String? tooltip;
  final VoidCallback? overrideOnTap; // e.g., comingSoon
  final VoidCallback? onLongPress;

  const _IconEntry({
    required this.iconWidget,
    required this.colorOf,
    this.url,
    this.tooltip,
    this.overrideOnTap,
    this.onLongPress,
  });
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    final size = _iconSizeFor(context);
    final entries = <_IconEntry>[
      _IconEntry(
        tooltip: 'LinkedIn',
        iconWidget: const FaIcon(FontAwesomeIcons.linkedin),
        colorOf: (ctx) => getColor(ctx,
            lightColor: const Color(0xFF0D5EC8),
            darkColor: const Color(0xFF0A66C2)),
        url: linkedinProfileUrl,
      ),
      _IconEntry(
        tooltip: 'GitHub',
        iconWidget: const FaIcon(FontAwesomeIcons.github),
        colorOf: (ctx) => getColor(ctx,
            lightColor: const Color(0xFF171515), darkColor: Colors.white),
        url: githubProfileUrl,
      ),
      _IconEntry(
        tooltip: 'GeeksforGeeks',
        iconWidget: Image.network(
          "https://img.icons8.com/?size=256&id=AbQBhN9v62Ob&format=png",
          height: size,
          width: size,
          color: getColor(context,
              lightColor: Colors.white, darkColor: const Color(0xFF32CD32)),
        ),
        colorOf: (ctx) => Colors.transparent, // color baked into Image above
        url: gfgProfileUrl,
      ),
    ];

    return Row(
      children: [
        // Keep IconButtons exactly as before; Image uses GestureDetector as before.
        ...entries.map((e) {
          if (e.iconWidget is FaIcon) {
            return IconButton(
              tooltip: e.tooltip,
              iconSize: size,
              color: e.colorOf(context),
              icon: e.iconWidget,
              onPressed: () => _openOrSoon(context, e.url),
              mouseCursor: SystemMouseCursors.click,
            );
          } else {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _openOrSoon(context, e.url),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: e.iconWidget,
              ),
            );
          }
        }),
      ],
    );
  }
}

Widget buttonRowForFooter(BuildContext context) {
  final size = _iconSizeFor(context, footer: true);

  final entries = <_IconEntry>[
    // LinkedIn
    _IconEntry(
        tooltip: 'LinkedIn',
        iconWidget: const FaIcon(FontAwesomeIcons.linkedin),
        colorOf: (ctx) => getColor(ctx,
            lightColor: const Color(0xFF0D5EC8),
            darkColor: const Color(0xFF0A66C2)),
        url: linkedinProfileUrl,
        onLongPress: () => showShareCopyDialogByType(
            context: context, option: PopupOption.linkedin)),
    // GitHub
    _IconEntry(
        tooltip: 'GitHub',
        iconWidget: const FaIcon(FontAwesomeIcons.github),
        colorOf: (ctx) => getColor(ctx,
            lightColor: const Color(0xFF171515), darkColor: Colors.white),
        url: githubProfileUrl,
        onLongPress: () => showShareCopyDialogByType(
            context: context, option: PopupOption.github)),
    // Google Play (Android)
    _IconEntry(
        tooltip: 'Download for Android',
        iconWidget: const FaIcon(FontAwesomeIcons.android),
        colorOf: (ctx) => getColor(ctx,
            lightColor: const Color(0xFF34A853),
            darkColor: const Color(0xFF34A853)),
        url: androidAPKUrl,
        onLongPress: () => showShareCopyDialogByType(
            context: context, option: PopupOption.androidapk)),
    // Spacer (kept)
    _IconEntry(
      iconWidget: const SizedBox(width: 4),
      colorOf: (ctx) => Colors.transparent,
    ),
    // App Store (iOS) — show Coming Soon unless you add a real URL
    _IconEntry(
      tooltip: 'Download for IOS',
      iconWidget: const FaIcon(FontAwesomeIcons.apple),
      colorOf: (ctx) => getColor(ctx,
          lightColor: const Color(0xFF0D96F6),
          darkColor: const Color(0xFF66B8FF)),
      // If you add `iosAppUrl`, it will open; otherwise shows snackbar.
      url: null, // replace with iosAppUrl when available
      overrideOnTap: null, // kept null so _openOrSoon shows snackbar
      onLongPress: null,
    ),
    _IconEntry(
      iconWidget: const SizedBox(width: 4),
      colorOf: (ctx) => Colors.transparent,
    ),

    _IconEntry(
      iconWidget: const FaIcon(FontAwesomeIcons.infoCircle),
      colorOf: (context) => Colors.blue,
      tooltip: 'Info',
      overrideOnTap : () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AppInfoPage()),
        );
      },
      onLongPress: () {
         showShareCopyDialog(context,
          title: "App Information",
          lines: [
            'App Version: ${AppInfo.version} (${AppInfo.buildNumber})',
          ],
          shareLines: [
            'App Version: ${AppInfo.version} (${AppInfo.buildNumber})',
          ],);
      },
    ),
  ];

  return Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 0,
    runSpacing: 6,
    children: entries.map((e) {
      // Keep exact IconButton usage where appropriate
      if (e.iconWidget is FaIcon) {
        return IconButton(
            tooltip: e.tooltip,
            iconSize: size,
            color: e.colorOf(context),
            icon: e.iconWidget,
            onPressed: e.overrideOnTap ?? () => _openOrSoon(context, e.url),
            mouseCursor: SystemMouseCursors.click,
            //onLongPress: e.onLongPress
        );
      } else {
        // SizedBox spacer or Image/etc.
        return e.iconWidget;
      }
    }).toList(),
  );
}
