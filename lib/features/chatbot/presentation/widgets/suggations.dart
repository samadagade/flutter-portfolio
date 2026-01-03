import 'package:flutter/material.dart';

class Suggestions extends StatelessWidget {
  final void Function(String) onPick;
  const Suggestions({required this.onPick});

  @override
  Widget build(BuildContext context) {
    final chips = [
      'projects',
      'skills',
      'experience',
      'open portfolio',
      'resume',
      'apk',
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: chips
              .map((c) => ActionChip(
                    label: Text(c),
                    onPressed: () => onPick(c),
                  ))
              .toList(),
        ),
      ),
    );
  }
}