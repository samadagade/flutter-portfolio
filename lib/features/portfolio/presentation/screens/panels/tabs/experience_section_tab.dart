import 'package:flutter/material.dart';
import 'package:portfolio/app_config.dart';
import 'package:portfolio/core/widgets/share_copy.dart';

Widget buildExperienceSection() {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final scheme = theme.colorScheme;
      final isDark = theme.brightness == Brightness.dark;

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        itemCount: experiences.length,
        itemBuilder: (context, index) {
          final exp = experiences[index];

          return Stack(
            children: [
              // Timeline line
              Positioned(
                left: 32,
                top: 0,
                bottom: index == experiences.length - 1 ? 25 : 0,
                child: Container(
                  width: 2,
                  color: scheme.primary.withOpacity(0.5),
                ),
              ),

              // Card
              InkWell(
                splashColor: Colors.transparent,
                onLongPress: () {
                  showShareCopyDialog(
                    context,
                    title: "Let's See Experience!",
                    lines: [
                      experiences.first.role,
                      experiences.first.company,
                      experiences.first.duration,
                      experiences.first.description,
                    ],
                    shareLines: [
                      experiences.first.role,
                      experiences.first.company,
                      experiences.first.duration,
                    ],
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 60, bottom: 40),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.4)
                            : Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        exp.role,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Company + duration
                      Text(
                        "${exp.company} • ${exp.duration}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color
                              ?.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Description
                      Text(
                        exp.description,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

              // Timeline dot
              Positioned(
                left: 20,
                top: 12,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: scheme.primary, // theme-aware
                  child: Icon(Icons.work, size: 16, color: scheme.onPrimary),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
