import 'package:auto_asig/core/data/constants.dart';
import 'package:flutter/material.dart';

class NoElements extends StatelessWidget {
  const NoElements({super.key, this.topPadding});

  final double? topPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topPadding ?? screenHeight! * 0.1),
          // Main greeting text
          const Text(
            'Salut!',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: logoBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Adaugă primul tău document.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: logoBlue,
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.black, // Regular text color
              ),
              children: [
                const TextSpan(
                  text: 'Pentru a adăuga documente apasă mai jos butonul ',
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: logoBlue,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
