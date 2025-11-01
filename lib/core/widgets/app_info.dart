import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/core/util/coming_soon_snackbar.dart';
import 'package:portfolio/core/util/lauch_url.dart';
import 'package:portfolio/core/util/mail_to.dart';
import 'package:portfolio/core/util/utility.dart';

import '../util/app_details.dart';

class AppInfoPage extends StatefulWidget {
  const AppInfoPage({super.key});

  @override
  State<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final versionDisplay = AppInfo.buildNumber.isNotEmpty
        ? 'v${AppInfo.version} (${AppInfo.buildNumber})'
        : 'v${AppInfo.version}';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
            iconTheme: IconThemeData(color: Colors.white, size: 20),
            expandedHeight: 240,
            pinned: true,
            elevation: 0,
            backgroundColor: cs.surface,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final collapsed = constraints.maxHeight <= kToolbarHeight + 40;
                return FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  titlePadding:
                      const EdgeInsetsDirectional.only(start: 16, bottom: 12),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Portfolio — Samarth Dagade',
                        style: t.titleSmall?.copyWith(
                          color: getColor(
                            context,
                            lightColor: Colors.white,
                            darkColor: Colors.white,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (collapsed && AppInfo.version.isNotEmpty)
                        Text(
                          versionDisplay,
                          style: t.labelSmall?.copyWith(
                            color: getColor(
                              context,
                              lightColor: Colors.black54,
                              darkColor: Colors.white70,
                            ),
                          ),
                        ),
                    ],
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/social/background_picture.png',
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.10),
                                Colors.black.withOpacity(0.35),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Header card with app identity & version
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _SurfaceCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.apps_rounded),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('About this app', style: t.titleMedium),
                          const SizedBox(height: 4),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 280),
                            child: Text(
                              AppInfo.version.isEmpty
                                  ? 'Loading version…'
                                  : 'Version: $versionDisplay',
                              key: ValueKey(
                                  AppInfo.version + AppInfo.buildNumber),
                              style: t.bodySmall
                                  ?.copyWith(color: cs.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: launchMailto,
                      icon: const Icon(Icons.email),
                      label: const Text('Email'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Story / timeline
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverList.list(
              children: [
                _SectionTitle('Story'),
                _StoryTile(
                  title: '💡 The Idea',
                  subtitle:
                      'This app was born from a desire to make productivity fun.',
                ),
                _StoryTile(
                  title: '🎨 The Design',
                  subtitle:
                      'Minimal UI, smooth animations, and a joyful user experience.',
                ),
                const _StoryTile(
                  title: '⚙️ Development',
                  subtitle: 'Built in Flutter.',
                ),
                const _StoryTile(
                  title: '🚀 Launch',
                  subtitle:
                      'Released on Netlify with responsive design for all devices.',
                ),
              ],
            ),
          ),

          // Tech stack chips
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('🔧 Tech stack'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      _TechChip('Flutter'),
                      _TechChip('Dart'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Stats row
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: const [
                  Expanded(child: _StatCard(value: '23', label: 'Downloads')),
                  SizedBox(width: 12),
                  Expanded(child: _StatCard(value: '4.8★', label: 'Rating')),
                  SizedBox(width: 12),
                  Expanded(child: _StatCard(value: '20+', label: 'Features')),
                ],
              ),
            ),
          ),

          // Links grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('🌐 Links'),
                  _buildLinksGrid(context),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 28)),
        ],
      ),
    );
  }

  // --- Links UI ------------------------------------------------------------
  Widget _buildLinksGrid(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width >= 980
        ? 3
        : width >= 640
            ? 2
            : 2;

    final tiles = <Widget>[
      _LinkButton(
        icon: const FaIcon(
          FontAwesomeIcons.android,
        ),
        label: 'Android',
        // ignore: unnecessary_null_comparison
        onTap: () => androidAPKUrl == null
            ? comingSoonSnackbar(context)
            : launchLink(androidAPKUrl, context),
      ),
      const _LinkButton(
        icon: FaIcon(FontAwesomeIcons.apple),
        label: 'iOS',
        // iOS is coming soon
      ),
      _LinkButton(
        icon: const FaIcon(FontAwesomeIcons.globe),
        label: 'Web',
        onTap: () => launchLink(webUrl, context),
      ),
      _LinkButton(
        icon: const FaIcon(FontAwesomeIcons.github),
        label: 'GitHub',
        onTap: () => launchLink(githubProfileUrl, context),
      ),
      _LinkButton(
        icon: const FaIcon(FontAwesomeIcons.linkedin),
        label: 'LinkedIn',
        onTap: () => launchLink(linkedinProfileUrl, context),
      ),
      _LinkButton(
        icon: Image.network(
          'https://img.icons8.com/?size=256&id=AbQBhN9v62Ob&format=png',
          height: 20,
          width: 20,
          color: getColor(
            context,
            lightColor: const Color(0xFF32CD32),
            darkColor: const Color(0xFF32CD32),
          ),
        ),
        label: 'GFG',
        onTap: () => launchLink(gfgProfileUrl, context),
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 26 / 7,
      children: tiles,
    );
  }
}

// ========================= Helper widgets ================================

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: cs.outlineVariant.withOpacity(0.4)),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class _StoryTile extends StatelessWidget {
  const _StoryTile({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: _SurfaceCard(
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          title: Text(title, style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
          ),
        ),
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  const _TechChip(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Chip(
      label: Text(label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      backgroundColor: cs.primaryContainer.withOpacity(0.25),
      side: BorderSide(color: cs.primaryContainer.withOpacity(0.6)),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(label, style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final enabled = onTap != null;

    return Material(
      color: cs.secondaryContainer.withOpacity(enabled ? 0.30 : 0.18),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap ?? () => comingSoonSnackbar(context),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 24, height: 24, child: Center(child: icon)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                size: 18,
                color: enabled
                    ? cs.onSecondaryContainer
                    : cs.onSecondaryContainer.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
