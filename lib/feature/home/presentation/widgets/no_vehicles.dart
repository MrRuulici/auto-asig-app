import 'package:auto_asig/core/data/constants.dart';
import 'package:flutter/material.dart';

class NoVehicles extends StatelessWidget {
  const NoVehicles({super.key, this.topPadding});

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
          const Text(
            'Nu este niciun vehicul adăugat.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: logoBlue,
            ),
          ),
        ],
      ),
    );
  }
}