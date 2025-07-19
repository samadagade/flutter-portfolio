import 'package:flutter/material.dart';
import 'package:portfolio/app_config.dart';

Widget buildExperienceSection() {
  return ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
    itemCount: experiences.length,
    itemBuilder: (context, index) {
      final exp = experiences[index];
      return Stack(
        children: [
          Positioned(
            left: 32,
            top: 0,
            bottom: index == experiences.length - 1 ? 25 : 0,
            child: Container(
              width: 2,
              // ignore: deprecated_member_use
              color: Colors.blue.withOpacity(0.5),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 60, bottom: 40),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exp["role"]!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${exp["company"]!} • ${exp["duration"]!}",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  exp["description"]!,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 20,
            top: 12,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.blue,
              child: Icon(Icons.work, size: 16, color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
