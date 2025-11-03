import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/features/portfolio/domain/entities/experience.dart';
import 'package:portfolio/features/portfolio/domain/entities/project.dart';
import 'package:portfolio/features/portfolio/domain/entities/skill.dart';
import 'package:portfolio/features/portfolio/presentation/screens/app_drawer.dart';
import 'package:portfolio/core/widgets/contact_dialog.dart';
import 'package:portfolio/core/widgets/contact_button.dart';
import 'package:portfolio/core/widgets/share_copy.dart';
import 'package:portfolio/features/chatbot/presentation/chat_bot.dart';
import 'body.dart';
import 'dart:async';

class Portfolio extends StatefulWidget {
  final VoidCallback toggleTheme;
  const Portfolio({super.key, required this.toggleTheme});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        drawer: screenWidth < 600 && showDrawer
            ? AppDrawer(
                glowAnimation: _glowAnimation,
                onToggleTheme: widget.toggleTheme,
                onContactTap: () => showContactDialog(context),
              )
            : null,
        appBar: AppBar(
          surfaceTintColor: screenWidth <= 950 ? Colors.transparent : null,
          elevation: 5.0,
          shadowColor: Colors.black12,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.6),
                            blurRadius: _glowAnimation.value,
                            spreadRadius: _glowAnimation.value / 2,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage(
                          'assets/images/social/profile_picture.jpeg',
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              const Text(
                "Samarth",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            if (showSearchButtonInAppBar)
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  final result = await showSearch<PortfolioSearchResult?>(
                    context: context,
                    delegate: PortfolioSearchDelegate(
                      projects: projects,
                      experiences: experiences,
                      skills: skills,
                    ),
                  );

                  if (result == null) return; // user dismissed

                  // Handle selection
                  switch (result.section) {
                    case SearchSection.projects:
                      // ignore: unused_local_variable
                      final p = result.payload as Map<String, dynamic>;
                      // Example: navigate to your project detail or open links
                      // final url = (p['launch_url'] ?? p['github_url'])?.toString();
                      // if (url != null) launchUrlString(url); // with url_launcher
                      break;
                    case SearchSection.experience:
                      // ignore: unused_local_variable
                      final e = result.payload as Map<String, dynamic>;
                      // Navigate to your Experience page or show a bottom sheet
                      break;
                    case SearchSection.skills:
                      // ignore: unused_local_variable
                      final skill = result.payload as String;
                      // Maybe filter your Projects page by this skill
                      break;
                  }
                },
              ),
            IconButton(
              onPressed: widget.toggleTheme,
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            ),
            Container(
              height: 18,
              width: 1,
              color: Colors.grey.shade400,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            ContactButton(
              buttonText: "Contact Me",
              icon: const FaIcon(
                FontAwesomeIcons.solidComments,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () {
                showContactDialog(context);
              },
              onLongPress: () => showShareCopyDialogByType(
                  context: context, option: PopupOption.contactme),
            ),
          ],
        ),
        body: const Body(),
        floatingActionButton: FloatingActionButton.small(
            tooltip: 'Chat with AI Bot',
            backgroundColor: Colors.transparent,
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => SimpleChat())),
            child: FaIcon(
              FontAwesomeIcons.robot,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            )));
  }
}

// portfolio_search.dart
// A unified (projects + experiences + skills) SearchDelegate.
// Works directly with your existing data structures.

/// ---------------- PUBLIC API ----------------

enum SearchSection { projects, experience, skills }

class PortfolioSearchResult {
  final SearchSection section;
  final String title;
  final String? subtitle;
  final String? trailing;
  final Object
      payload; // The original object (project map, experience map, or skill string)
  final int score;

  const PortfolioSearchResult({
    required this.section,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.payload,
    required this.score,
  });
}

class PortfolioSearchDelegate extends SearchDelegate<PortfolioSearchResult?> {
  PortfolioSearchDelegate({
    required this.projects, // List<Map<String, dynamic>>
    required this.experiences, // List<Map<String, dynamic>>
    required this.skills, // List<String>
  });

  final List<Project> projects;
  final List<Experience> experiences;
  final List<Skill> skills;

  // Which fields on your project map should be indexed:
  // static const _projectFields = [
  //   'title',
  //   'subtitle',
  //   'technologies',
  //   'github_url',
  //   'launch_url',
  //   'id',
  //   'image'
  // ];
  // static const _experienceFields = [
  //   'role',
  //   'company',
  //   'duration',
  //   'description'
  // ];

  final _debouncer = _Debouncer(milliseconds: 120);

  @override
  String get searchFieldLabel => 'Search projects, experience, skills';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          tooltip: 'Clear',
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      tooltip: 'Back',
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _search(query);
    return _ResultsView(
      query: query,
      results: results,
      onTap: (r) => close(context, r),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<PortfolioSearchResult>>(
      future: _debouncer.run(() async => _search(query)),
      builder: (context, snap) {
        final results = snap.data ?? const <PortfolioSearchResult>[];
        return _ResultsView(
          query: query,
          results: results,
          onTap: (r) => close(context, r),
          showSectionChips: true,
          limitPerSectionInSuggestions: 3,
        );
      },
    );
  }

  List<PortfolioSearchResult> _search(String q) {
    final text = q.trim().toLowerCase();
    if (text.isEmpty) return const [];

    final List<PortfolioSearchResult> out = [];

    // ---- Projects ----
    for (final p in projects) {
      final haystack = [
        p.title,
        p.subtitle,
        p.technologies.join(', '),
        p.githubUrl,
        p.launchUrl,
        p.id,
        p.image,
        // ignore: unnecessary_null_comparison
      ]
          .where((v) => v != null)
          .map((v) => v.toString())
          .join(' \n ')
          .toLowerCase();

      final score = _score(haystack, text);
      if (score > 0) {
        out.add(
          PortfolioSearchResult(
            section: SearchSection.projects,
            title: p.title,
            subtitle: p.subtitle,
            trailing: p.technologies.isNotEmpty
                ? p.technologies.take(3).join(' · ')
                : null,
            payload: p,
            score: score,
          ),
        );
      }
    }

    // ---- Experience ----
    for (final e in experiences) {
      final haystack = [
        e.role,
        e.company,
        e.duration,
        e.description,
        // ignore: unnecessary_null_comparison
      ]
          .where((v) => v != null)
          .map((v) => v.toString())
          .join(' \n ')
          .toLowerCase();

      final score = _score(haystack, text);
      if (score > 0) {
        out.add(
          PortfolioSearchResult(
            section: SearchSection.experience,
            title: e.role,
            subtitle: e.company,
            trailing: e.duration,
            payload: e,
            score: score,
          ),
        );
      }
    }

    // ---- Skills ----
    for (final s in skills) {
      final haystack = s.name.toLowerCase();
      final score = _score(haystack, text);
      if (score > 0) {
        out.add(
          PortfolioSearchResult(
            section: SearchSection.skills,
            title: s.name,
            payload: s,
            score: score,
          ),
        );
      }
    }

    // Sort by score desc, then section preference (projects > experience > skills)
    out.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      return a.section.index.compareTo(b.section.index);
    });

    return out;
  }
}

/// ---------------- UI: Results List ----------------

class _ResultsView extends StatelessWidget {
  const _ResultsView({
    required this.query,
    required this.results,
    required this.onTap,
    this.showSectionChips = false,
    this.limitPerSectionInSuggestions,
  });

  final String query;
  final List<PortfolioSearchResult> results;
  final void Function(PortfolioSearchResult) onTap;
  final bool showSectionChips;
  final int? limitPerSectionInSuggestions;

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) {
      return const _EmptyHint();
    }
    if (results.isEmpty) {
      return _NoResults(query: query);
    }

    final display = limitPerSectionInSuggestions == null
        ? results
        : _capPerSection(results, limitPerSectionInSuggestions!);

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: display.length + (showSectionChips ? 1 : 0),
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, i) {
        if (showSectionChips && i == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: SearchSection.values
                  .map((s) => Chip(
                        label: Text(_sectionLabel(s)),
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
          );
        }
        final r = display[showSectionChips ? i - 1 : i];
        return ListTile(
          leading: Icon(_sectionIcon(r.section)),
          title: _HighlightText(text: r.title, query: query),
          subtitle: _buildSubtitle(r, query),
          trailing: r.trailing != null
              ? Text(r.trailing!,
                  style: Theme.of(context).textTheme.labelMedium)
              : null,
          onTap: () => onTap(r),
        );
      },
    );
  }

  static List<PortfolioSearchResult> _capPerSection(
      List<PortfolioSearchResult> list, int cap) {
    final Map<SearchSection, int> counts = {};
    final out = <PortfolioSearchResult>[];
    for (final r in list) {
      final c = counts.update(r.section, (v) => v + 1, ifAbsent: () => 1);
      if (c <= cap) out.add(r);
    }
    return out;
  }

  static Widget? _buildSubtitle(PortfolioSearchResult r, String query) {
    switch (r.section) {
      case SearchSection.projects:
        return _HighlightText(
            text: r.subtitle ?? '', query: query, maxLines: 2);
      case SearchSection.experience:
        return _HighlightText(text: r.subtitle ?? '', query: query);
      case SearchSection.skills:
        return null;
    }
  }

  static String _sectionLabel(SearchSection s) {
    switch (s) {
      case SearchSection.projects:
        return 'Projects';
      case SearchSection.experience:
        return 'Experience';
      case SearchSection.skills:
        return 'Skills';
    }
  }

  static IconData _sectionIcon(SearchSection s) {
    switch (s) {
      case SearchSection.projects:
        return Icons.apps;
      case SearchSection.experience:
        return Icons.work_outline;
      case SearchSection.skills:
        return Icons.code;
    }
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Opacity(
          opacity: 0.7,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search, size: 42),
              const SizedBox(height: 12),
              Text('Search your portfolio',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              const Text(
                  'Try "Flutter Bloc", "E-Commerce", or a skill like "Regex"'),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});
  final String query;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 42),
            const SizedBox(height: 12),
            Text('No matches for "$query"'),
            const SizedBox(height: 6),
            const Text('Try different keywords or fewer filters'),
          ],
        ),
      ),
    );
  }
}

/// ---------------- Utilities ----------------

class _HighlightText extends StatelessWidget {
  const _HighlightText({
    required this.text,
    required this.query,
    this.maxLines,
  });

  final String text;
  final String query;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) {
      return Text(text, maxLines: maxLines, overflow: TextOverflow.ellipsis);
    }
    final q = query.toLowerCase();
    final t = text;
    final tl = t.toLowerCase();

    final spans = <TextSpan>[];
    int start = 0;
    while (true) {
      final idx = tl.indexOf(q, start);
      if (idx < 0) {
        spans.add(TextSpan(text: t.substring(start)));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: t.substring(start, idx)));
      }
      spans.add(TextSpan(
        text: t.substring(idx, idx + q.length),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      start = idx + q.length;
    }

    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(height: 1.2),
        children: spans,
      ),
    );
  }
}

int _score(String haystack, String needle) {
  // Simple fuzzy-ish score:
  // +5 for startsWith, +3 per occurrence, +1 if all tokens match parts.
  int score = 0;
  if (haystack.startsWith(needle)) score += 5;

  int idx = 0;
  while (true) {
    idx = haystack.indexOf(needle, idx);
    if (idx < 0) break;
    score += 3;
    idx += needle.length;
  }

  // Token bonus
  final tokens = needle.split(RegExp(r'\\s+')).where((e) => e.isNotEmpty);
  bool allHit = true;
  for (final t in tokens) {
    if (!haystack.contains(t)) {
      allHit = false;
      break;
    }
  }
  if (allHit) score += 1;

  return score;
}

class _Debouncer {
  _Debouncer({required this.milliseconds});
  final int milliseconds;
  Timer? _timer;

  Future<T> run<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), () async {
      try {
        completer.complete(await action());
      } catch (e, st) {
        completer.completeError(e, st);
      }
    });
    return completer.future;
  }

  void dispose() => _timer?.cancel();
}

/// ---------------- Example wiring ----------------
/// Add an IconButton in your AppBar to open search:
///
//  IconButton(
//    icon: const Icon(Icons.search),
//    onPressed: () async {
//      final result = await showSearch<PortfolioSearchResult?>(
//        context: context,
//        delegate: PortfolioSearchDelegate(
//          projects: projects,         // your List<Map<String, dynamic>>
//          experiences: experiences,   // your List<Map<String, dynamic>>
//          skills: skills,             // your List<String>
//        ),
//      );

//      if (result == null) return; // user dismissed

//      // Handle selection
//      switch (result.section) {
//        case SearchSection.projects:
//          final p = result.payload as Map<String, dynamic>;
//          // Example: navigate to your project detail or open links
//          // final url = (p['launch_url'] ?? p['github_url'])?.toString();
//          // if (url != null) launchUrlString(url); // with url_launcher
//          break;
//        case SearchSection.experience:
//          final e = result.payload as Map<String, dynamic>;
//          // Navigate to your Experience page or show a bottom sheet
//          break;
//        case SearchSection.skills:
//          final skill = result.payload as String;
//          // Maybe filter your Projects page by this skill
//          break;
//      }
//    },
//  )
///
/// Notes:
/// - If your project images are assets (e.g., 'assets/images/...'), use Image.asset when you show them.
///   For network links (https://...), use Image.network.
/// - The delegate returns the selected item so you can route however your app expects.
