import 'package:auto_asig/core/app/app_data.dart';
import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/feature/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String path = 'about';
  static const String absolutePath = '${HomeScreen.path}/$path';

  final String backupUrl =
      'https://drive.google.com/file/d/141nqkEI2TYEPQQUvnJCuraJok1mngloo/view?usp=sharing';

  void _launchURL(BuildContext context) async {
    if (await canLaunch(updateUrl)) {
      await launch(updateUrl);
    } else {
      // showSnackbar(context, "Ups... adresa nu poate fi accesata.");
      try {
        await launch(backupUrl);
      } catch (e) {
        showErrorSnackbar(context, "Ups... adresa nu poate fi accesata.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // const List<String> chatRules = [
    //   "1. Fii respectuos: Tratează-i pe toți participanții cu respect, indiferent de opiniile, experiențele sau diferențele lor.",
    //   "2. Evită limbajul ofensator: Nu folosi cuvinte sau expresii jignitoare, vulgare sau agresive. Pe acest chat există copii și adolescenți.",
    //   "3. Fii constructiv: Dacă nu ești de acord cu cineva, exprimă-ți opinia într-un mod civilizat și constructiv.",
    //   "4. Nu incita la conflicte: Evită comportamentul provocator sau inflamator.",
    //   "5. Nu spam: Evită mesajele repetitive, excesive sau irelevante.",
    //   "6. Urările și felicitările în privat: Evită trimiterea de mesaje de urări, felicitări sau alte mesaje personale în public. Acestea pot fi trimise în privat pentru a menține chatul concentrat pe subiectele de discuție.",
    //   "7. Respectă intimitatea celorlalți: Nu împărtăși informații personale despre tine sau despre alți membri fără acordul lor.",
    //   "8. Păstrează discuțiile la subiect: Contribuie pozitiv la subiectul tratat.",
    //   "9. Fii empatic: Gândește-te cum s-ar simți ceilalți participanți înainte de a trimite un mesaj.",
    //   "10. Folosește un ton prietenos: Discuțiile prietenoase contribuie la o atmosferă pozitivă.",
    //   "11. Respectă moderarea: Urmează instrucțiunile antrenorilor și moderatorilor și nu contesta deciziile acestora în mod public."
    // ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Despre Aplicatie'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              'Aceasta este o aplicatie de testare si interfata nu este in totalitate functionala si UI-ul este doar pentru a demonstra functionalitatile.',
              style: TextStyle(fontSize: theFontSize),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            // GestureDetector(
            //   onTap: () => _launchURL(context),
            //   child: Text(
            //     'Apasa aici pentru a deschide Google Drive',
            //     style: TextStyle(
            //         fontSize: theFontSize,
            //         color: Colors.blue,
            //         decoration: TextDecoration.underline,
            //         decorationColor: Colors.blue),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // const SizedBox(height: 40),
            // Text(
            //   'Regulament Chat',
            //   style: TextStyle(
            //     fontSize: theFontSize,
            //     fontWeight: FontWeight.bold,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            // const SizedBox(height: 20),
            // Replace ListView with a Column to ensure it scrolls with SingleChildScrollView
            // Column(
            //   children: List.generate(
            //     chatRules.length,
            //     (index) {
            //       return Padding(
            //         padding: EdgeInsets.only(
            //             bottom: index == chatRules.length - 1 ? 50.0 : 10.0),
            //         child: Card(
            //           child: Padding(
            //             padding: const EdgeInsets.all(16.0),
            //             child: Text(
            //               chatRules[index],
            //               style: TextStyle(
            //                 fontSize: theFontSize,
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
