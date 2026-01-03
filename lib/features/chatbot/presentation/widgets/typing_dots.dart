import 'package:flutter/material.dart';
import 'package:portfolio/core/util/utility.dart';

class TypingDots extends StatefulWidget {
  const TypingDots();

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController c;
  late final Animation<double> a1;
  late final Animation<double> a2;
  late final Animation<double> a3;

  @override
  void initState() {
    super.initState();
    c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat();
    a1 = CurvedAnimation(
        parent: c, curve: const Interval(0.0, 0.6, curve: Curves.easeInOut));
    a2 = CurvedAnimation(
        parent: c, curve: const Interval(0.2, 0.8, curve: Curves.easeInOut));
    a3 = CurvedAnimation(
        parent: c, curve: const Interval(0.4, 1.0, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget dot(Animation<double> a) => AnimatedBuilder(
          animation: a,
          builder: (_, __) => Transform.translate(
            offset: Offset(0, -3 * (a.value - 0.5).abs() * 2),
            child: Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[700],
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
    return Row(
        mainAxisSize: MainAxisSize.min, children: [dot(a1), dot(a2), dot(a3)]);
  }
}

class DaySeparator extends StatelessWidget {
  final DateTime date;
  const DaySeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final label = sameDay(date, now)
        ? 'Today'
        : sameDay(date, now.subtract(const Duration(days: 1)))
            ? 'Yesterday'
            : "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Expanded(child: Divider(height: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          const Expanded(child: Divider(height: 1)),
        ],
      ),
    );
  }
}
