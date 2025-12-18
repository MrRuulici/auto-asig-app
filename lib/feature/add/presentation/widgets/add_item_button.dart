import 'package:auto_asig/core/helpers/refresh_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddItemButton extends StatelessWidget {
  const AddItemButton({
    super.key,
    required this.path,
    required this.title,
    required this.image,
  });

  final String path;
  final String title;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        refreshHomeScreenData(context);
        context.push(path);
      },
      child: Container(
        width: 160, // Fixed width for each button
        height: 180, // Fixed height for each button
        padding: const EdgeInsets.all(8.0),
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(10),
        //   border: Border.all(color: Colors.grey[300]!, width: 1.5),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, // Fixed size for the image container
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: FittedBox(
                fit: BoxFit.contain, // Ensure the image fits within the box
                child: image,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
