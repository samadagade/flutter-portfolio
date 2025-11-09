import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/core/util/lauch_url.dart';
import 'package:portfolio/core/util/utility.dart';
import 'package:portfolio/core/widgets/share_copy.dart';
import 'package:portfolio/features/portfolio/domain/entities/project.dart';
import 'package:portfolio/features/portfolio/domain/entities/skill.dart';

Widget buildProjectsSection() {
  return _ProjectsSection(key: projectsSectionKey);
}

class _ProjectsSection extends StatefulWidget {
  const _ProjectsSection({super.key});
  @override
  State<_ProjectsSection> createState() => ProjectsSectionState();
}

class ProjectsSectionState extends State<_ProjectsSection> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? highlightProjectId;
  final Set<Skill> _selectedSkills = <Skill>{};

  late final Set<Skill> _allSkills;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _allSkills = _extractAllSkills();
  }

  void scrollToProject(Project p) {
    // Find project index
    final index = projects.indexWhere((x) => x.id == p.id);
    if (index == -1) return;
    setState(() {
      highlightProjectId = p.id;
    });
    // Wait a frame to ensure ListView is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use RenderBox to measure each card dynamically
      final listViewContext =
          _scrollController.position.context.notificationContext;
      if (listViewContext == null) return;

      final listViewBox = listViewContext.findRenderObject() as RenderBox?;
      if (listViewBox == null) return;

      // Try to locate the specific card
      final itemKey = GlobalObjectKey("project_$index");
      final itemContext = itemKey.currentContext;
      if (itemContext == null) {
        // fallback if not yet rendered
        _scrollController.animateTo(
          index * 250.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        return;
      }

      final box = itemContext.findRenderObject() as RenderBox?;
      if (box != null) {
        final offset = box.localToGlobal(Offset.zero, ancestor: listViewBox).dy;
        _scrollController.animateTo(
          _scrollController.offset + offset - 80, // small padding offset
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      }
    });

    Future.delayed(Duration(seconds: 2), (){
       if(mounted && highlightProjectId == p.id){
        setState(() {
          highlightProjectId = null;
        });
       }
    });
  }

  Set<Skill> _extractAllSkills() {
    final skills = <Skill>{};
    for (final project in projects) {
      final techs = project.technologies;
      skills.addAll(techs);
    }
    return skills;
  }

  void _toggleSkill(Skill skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  List<Project> get _filtered {
    final q = _searchCtrl.text.toLowerCase().trim();
    return projects.where((p) {
      final title = p.title.toLowerCase();
      final subtitle = p.subtitle.toLowerCase();

      final matchesQuery =
          q.isEmpty || title.contains(q) || subtitle.contains(q);

      final matchesSkills = _selectedSkills.isEmpty ||
          p.technologies.any(
            (tech) => _selectedSkills
                .any((s) => s.name.toLowerCase() == tech.name.toLowerCase()),
          );

      return matchesQuery && matchesSkills && p.isFeatured;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = FlipCardController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ======= Top bar: click-to-reveal search =======
        Visibility(
          visible: _isSearching,
          child: Container(
            width: 400,
            height: 45,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  // Animated space that turns into a search field
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, anim) => SizeTransition(
                        sizeFactor: anim,
                        axisAlignment: -1,
                        child: FadeTransition(opacity: anim, child: child),
                      ),
                      child: _isSearching
                          ? TextField(
                              key: const ValueKey('searchField'),
                              controller: _searchCtrl,
                              autofocus: true,
                              onChanged: (_) =>
                                  setState(() {}), // live filter while open
                              onSubmitted: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: "Search by title or description…",
                                prefixIcon: const Icon(Icons.search),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(
                              key: ValueKey('noSearchField')),
                    ),
                  ),

                  const SizedBox(width: 4),

                  // Toggle search open/close
                  // Tooltip(
                  //   message: _isSearching ? "Close search" : "Search",
                  //   child: IconButton.filledTonal(
                  //     onPressed: () {
                  //       setState(() {
                  //         _isSearching = !_isSearching;
                  //         if (!_isSearching) _searchCtrl.clear();
                  //       });
                  //     },
                  //     icon: Icon(_isSearching ? Icons.close : Icons.search),
                  //   ),
                  // ),

                  const SizedBox(width: 4),

                  Tooltip(
                    message: "Filter by skills",
                    child: IconButton.filledTonal(
                      onPressed: _openSkillsDialog,
                      icon: const Icon(Icons.tune),
                    ),
                  ),

                  const SizedBox(width: 4),

                  if ((_selectedSkills.isNotEmpty) ||
                      (_isSearching && _searchCtrl.text.isNotEmpty))
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedSkills.clear();
                          _searchCtrl.clear();
                          _isSearching = false;
                        });
                      },
                      icon: const Icon(Icons.clear_all),
                      label: const Text("Clear"),
                    ),
                ],
              ),
            ),
          ),
        ),

        // ======= Results count =======
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Tooltip(
                message: _isSearching ? "Close search" : "Search",
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (!_isSearching) _searchCtrl.clear();
                    });
                  },
                  icon: Icon(
                    _isSearching ? Icons.close : Icons.search,
                    size: 20,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${_filtered.length} project${_filtered.length == 1 ? '' : 's'}"
                  "${_selectedSkills.isEmpty ? '' : ' • ${_selectedSkills.length} skill filter(s)'}",
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: Colors.blueGrey),
                ),
              ),
            ],
          ),
        ),

        // ======= Project list =======
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            controller: _scrollController,
            itemCount: _filtered.length,
            itemBuilder: (context, index) {
              final project = _filtered[index];
              final isHighlight = highlightProjectId == project.id;
              return StatefulBuilder(
                builder: (context, setStateItem) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isHighlight
                          ? [
                              BoxShadow(
                                color: Colors.amberAccent.withOpacity(0.6),
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ]
                          : [],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onLongPress: () {
                          showShareCopyDialog(
                            context,
                            title: "🚀 ${project.title} is live!",
                            lines: [project.launchUrl],
                            shareLines: [
                              "💻 Live Demo : ${project.launchUrl}\n"
                                  "🌐 Source Code : ${project.githubUrl}\n",
                              "🐞 Have a Bug or Feature Idea? : ${project.githubUrl}/issues",
                            ],
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FlipCard(
                                flipOnTouch: true,
                                controller: controller,
                                direction: FlipDirection.VERTICAL,
                                side: CardSide.FRONT,
                                alignment: Alignment.center,
                                front: _buildFront(
                                    context: context, project: project),
                                back: _buildBack(
                                    context: context, project: project),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBack({required BuildContext context, required Project project}) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showImagesInProjectTab)
          Hero(
            tag: 'projectImage_${project.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: isNetworkImage(project.image)
                  ? Image.network(
                      project.image,
                      height: screenWidth > 900 ? 70 : 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          height: screenWidth > 900 ? 70 : 140,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
                      },
                    )
                  : Image.asset(
                      project.image,
                      height: screenWidth > 900 ? 70 : 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        const SizedBox(height: 10),
        Text(
          "Updated: ${project.date}",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            TextButton.icon(
              onPressed: () => launchLink(project.launchUrl, context),
              icon: const Icon(Icons.visibility_outlined),
              label: const Text("View"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
            ),
            const SizedBox(width: 6),
            OutlinedButton.icon(
              onPressed: () => launchLink(project.githubUrl, context),
              icon: const Icon(Icons.code),
              label: const Text("Source"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                side: const BorderSide(color: Colors.deepPurple),
              ),
            ),
            if (project.hasApk)
              Tooltip(
                message: 'Download APK',
                child: IconButton(
                  onPressed: () => launchLink(project.apkUrl, context),
                  icon: const Icon(Icons.android),
                ),
              ),
            Tooltip(
              message: 'See a bug? Have an idea? Tell us!',
              child: IconButton(
                onPressed: () =>
                    launchLink('${project.githubUrl}/issues', context),
                icon: const Icon(Icons.bug_report),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFront(
      {required BuildContext context, required Project project}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : const Color(0xFFe3f2fd),
              child: const Icon(Icons.work_outline, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project.subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.open_in_new, color: Colors.blue),
              tooltip: "Open Project",
              onPressed: () async {
                launchLink(project.launchUrl, context);
              },
            ),
          ],
        ),
        SizedBox(
          height: 14,
        ),
        if ((project.technologies as List).isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: (project.technologies as List)
                .map<Widget>((tech) => FilterChip(
                      label: Text(tech.name),
                      avatar: tech.icon,
                      selected: _selectedSkills.contains(tech),
                      onSelected: (_) => _toggleSkill(tech),
                      showCheckmark: false,
                      side: BorderSide(
                        color: _selectedSkills.contains(tech)
                            ? Colors.indigo
                            : Colors.indigo.shade100,
                      ),
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.indigo.shade100
                              : Colors.indigo.shade50,
                      selectedColor: Colors.indigo.withOpacity(0.18),
                      labelStyle: const TextStyle(color: Colors.indigo),
                    ))
                .toList(),
          ),
      ],
    );
  }

  Future<void> _openSkillsDialog() async {
    final temp = Set<Skill>.from(_selectedSkills);
    final allSkills = _allSkills.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    final TextEditingController searchCtrl = TextEditingController();
    String query = '';

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (ctx, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, _, __) {
        final curved =
            CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
            child: Dialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: StatefulBuilder(
                builder: (dialogCtx, setDialogState) {
                  final filtered = query.isEmpty
                      ? allSkills
                      : allSkills
                          .where((s) => s.name.toLowerCase().contains(query))
                          .toList();

                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 720,
                      maxHeight: MediaQuery.of(dialogCtx).size.height * 0.78,
                      minWidth: 360,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 18, 12, 0),
                          child: Row(
                            children: [
                              const Icon(Icons.tune, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Filter by skills',
                                style: Theme.of(dialogCtx)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const Spacer(),
                              if (temp.isNotEmpty)
                                TextButton(
                                  onPressed: () =>
                                      setDialogState(() => temp.clear()),
                                  child: const Text('Reset'),
                                ),
                              IconButton(
                                tooltip: 'Close',
                                onPressed: () => Navigator.pop(dialogCtx),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                        ),

                        // Search
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: TextField(
                            controller: searchCtrl,
                            enableSuggestions: true,
                            onChanged: (v) => setDialogState(
                                () => query = v.trim().toLowerCase()),
                            decoration: InputDecoration(
                              hintText: 'Search skills…',
                              prefixIcon: const Icon(Icons.search),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        // Selected summary
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Row(
                            children: [
                              const Icon(Icons.filter_alt,
                                  size: 18, color: Colors.indigo),
                              const SizedBox(width: 6),
                              Text(
                                temp.isEmpty
                                    ? 'No skills selected'
                                    : '${temp.length} selected',
                                style: Theme.of(dialogCtx)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.blueGrey),
                              ),
                              const Spacer(),
                              if (temp.isNotEmpty)
                                TextButton.icon(
                                  onPressed: () =>
                                      setDialogState(() => temp.clear()),
                                  icon: const Icon(Icons.clear),
                                  label: const Text('Clear'),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Chip grid
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Scrollbar(
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    if (filtered.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, top: 6),
                                        child: Text(
                                          'No skills match “${searchCtrl.text.trim()}”.',
                                          style: Theme.of(dialogCtx)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color: Colors.blueGrey),
                                        ),
                                      ),
                                    for (final skill in filtered)
                                      ChoiceChip(
                                        label: Text(skill.name),
                                        avatar: skill.icon,
                                        selected: temp.contains(skill),
                                        onSelected: (_) => setDialogState(() {
                                          temp.contains(skill)
                                              ? temp.remove(skill)
                                              : temp.add(skill);
                                        }),
                                        showCheckmark: false,
                                        side: BorderSide(
                                          color: temp.contains(skill)
                                              ? Colors.indigo
                                              : Colors.indigo.shade100,
                                        ),
                                        selectedColor:
                                            Colors.indigo.withOpacity(0.16),
                                        backgroundColor: Theme.of(context)
                                                    .brightness ==
                                                Brightness.dark
                                            ? Colors.indigo.withOpacity(0.08)
                                            : Colors.indigo.shade50,
                                        labelStyle: const TextStyle(
                                            color: Colors.indigo),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Actions
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: Theme.of(dialogCtx).dividerColor),
                            ),
                          ),
                          child: Row(
                            children: {
                              // Cancel
                              TextButton.icon(
                                onPressed: () => Navigator.pop(dialogCtx),
                                icon: const Icon(Icons.close),
                                label: const Text('Cancel'),
                              ),
                              const Spacer(),
                              // Apply
                              FilledButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _selectedSkills
                                      ..clear()
                                      ..addAll(temp);
                                  });
                                  Navigator.pop(dialogCtx);
                                },
                                icon: const Icon(Icons.check_circle),
                                label: const Text('Apply'),
                              ),
                            }.toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
