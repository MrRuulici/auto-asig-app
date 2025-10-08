import 'package:auto_asig/core/app/app_data.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OldVersionScreen extends StatelessWidget {
  const OldVersionScreen({super.key});

  static const path = '/old_version_screen';

  @override
  Widget build(BuildContext context) {
    void launchURL() {
      // const url =
      //     'https://drive.google.com/file/d/105Wi4ZSUEYN3awDEXDlh7zz3brkRFOco/view?usp=drive_link';

      // convert to Uri
      final Uri uri = Uri.parse(updateUrl);

      launchUrl(uri);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Această versiune a aplicației nu mai este suportată. Te rugăm să o actualizezi folosind butonul de mai jos.',
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
                  // open url
                  launchURL();
                },
                text: 'Actualizează',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
