import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  static const path = '/maintenance_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                // under maintenance message
                'Ne pare rău, aplicație este momentan în mentenanță. Te rugăm să încerci mai târziu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: theFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),
              AutoAsigButton(
                onPressed: () {
                  // close the app
                  closeApp();
                },
                text: 'Închide aplicația',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void closeApp() {
    // Close the app
    SystemNavigator.pop();
  }
}
