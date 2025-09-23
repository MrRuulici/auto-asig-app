import 'package:flutter/material.dart';

class ProgressColoredBar extends StatelessWidget {
  const ProgressColoredBar({
    super.key,
    required this.progressValue,
    required this.progressColor,
    required this.isExpired,
  });

  final int progressValue;
  final Color progressColor;
  final bool isExpired;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background container (empty bar)
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            height: 16,
            color: Colors.grey[100],
          ),
        ),
        // Filled bar, with conditional width based on isExpired
        if (!isExpired)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: (progressValue > 60 ? 1.0 : progressValue / 60) *
                    MediaQuery.of(context).size.width,
                height: 16,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      progressColor,
                      progressColor.withOpacity(0.75),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
