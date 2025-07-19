import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portfolio/app_config.dart';

Widget buildSkillsSection() {
  return _MovingBubbles();
}

//Need To Understand This
class _MovingBubbles extends StatefulWidget {
  @override
  _MovingBubblesState createState() => _MovingBubblesState();
}

class _MovingBubblesState extends State<_MovingBubbles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Bubble> bubbles;

  // List of colors for bubbles
  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    bubbles = List.generate(skills.length,
        (index) => _Bubble(index, colors[index % colors.length]));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _BubblePainter(bubbles, skills, constraints),
              child: Container(height: constraints.maxHeight),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// class _Bubble {
//   double x = Random().nextDouble() * 300;
//   double y = Random().nextDouble() * 500;
//   double radius = Random().nextDouble() * 40 + 30; // Bubble size
//   double speedX = Random().nextDouble() * 2 - 1; // Random speed in X
//   double speedY = Random().nextDouble() * 2 - 1; // Random speed in Y
//   int skillIndex;
//   Color color;

//   _Bubble(this.skillIndex, this.color);

//   void move(Size size) {
//     x += speedX;
//     y += speedY;

//     // Bounce off walls (keep bubbles inside the screen)
//     if (x < radius || x > size.width - radius) {
//       speedX = -speedX; // Reverse direction
//     }
//     if (y < radius || y > size.height - radius) {
//       speedY = -speedY; // Reverse direction
//     }
//   }
// }

// class _BubblePainter extends CustomPainter {
//   final List<_Bubble> bubbles;
//   final List<String> skills;
//   final BoxConstraints constraints;

//   _BubblePainter(this.bubbles, this.skills, this.constraints);

//   @override
//   void paint(Canvas canvas, Size size) {
//     for (var bubble in bubbles) {
//       bubble.move(size); // Move bubble randomly

//       // ignore: deprecated_member_use
//       Paint paint = Paint()..color = bubble.color.withOpacity(0.8);
//       canvas.drawCircle(Offset(bubble.x, bubble.y), bubble.radius, paint);

//       // ✅ Fix: Correctly get skill name using bubble.skillIndex
//       String skillName = skills[bubble.skillIndex];

//       // Draw skill name in center of bubble
//       final textSpan = TextSpan(
//         text: skillName, // Correctly display skill name
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: bubble.radius * 0.4, // Scale text size dynamically
//           //fontWeight: FontWeight.bold,
//         ),
//       );

//       final textPainter = TextPainter(
//         text: textSpan,
//         textAlign: TextAlign.center,
//         textDirection: TextDirection.ltr,
//       );

//       textPainter.layout();
//       textPainter.paint(
//           canvas,
//           Offset(bubble.x - textPainter.width / 2,
//               bubble.y - textPainter.height / 2));
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }


class _Bubble {
  double x = Random().nextDouble() * 300;
  double y = Random().nextDouble() * 500;
  double radius = Random().nextDouble() * 40 + 30; // Bubble size
  double speedX = Random().nextDouble() * 2 - 1; // Random speed in X
  double speedY = Random().nextDouble() * 2 - 1; // Random speed in Y
  int skillIndex;
  Color color;

  _Bubble(this.skillIndex, this.color);

  void move(Size size) {
    x += speedX;
    y += speedY;

    // Add a small buffer to prevent bubbles from sticking to the edge
    const double buffer = 1.0;

    if (x - radius <= 0 + buffer || x + radius >= size.width - buffer) {
      speedX = -speedX;
      x = x.clamp(radius + buffer, size.width - radius - buffer);
    }

    if (y - radius <= 0 + buffer || y + radius >= size.height - buffer) {
      speedY = -speedY;
      y = y.clamp(radius + buffer, size.height - radius - buffer);
    }
  }
}

class _BubblePainter extends CustomPainter {
  final List<_Bubble> bubbles;
  final List<String> skills;
  final BoxConstraints constraints;

  _BubblePainter(this.bubbles, this.skills, this.constraints);

  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
      bubble.move(size);

      Paint paint = Paint()..color = bubble.color.withOpacity(0.8);
     canvas.drawCircle(Offset(bubble.x, bubble.y), bubble.radius, paint);

      String skillName = skills[bubble.skillIndex];

      final textSpan = TextSpan(
        text: skillName,
        style: TextStyle(
          color: Colors.white,
          fontSize: bubble.radius * 0.4,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(bubble.x - textPainter.width / 2,
            bubble.y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
