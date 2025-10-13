import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_empty.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  static const path = '/no_internet_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight! * 0.1),
            SizedBox(
              width: screenWidth!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image:
                            const AssetImage('assets/images/simple_logo.png'),
                        width: screenWidth! * 0.4,
                      ),
                      const Text(
                        'alliat',
                        style: TextStyle(
                          fontSize: 40,
                          color: logoBlue,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            Image(
              image: const AssetImage('assets/images/warning.png'),
              width: screenWidth! < 600 ? screenWidth! * 0.1 : 200,
            ),
            const Expanded(
              child: Text(
                'Salut! \nTe rugăm să te conectezi la internet pentru a putea folosi aplicația. Verifică conexiunea și apoi restartează aplicația.',
                style: TextStyle(
                  fontSize: 20,
                  color: logoBlue,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            AutoAsigButtonEmpty(
              onPressed: () {
                // close the app
                // SystemNavigator.pop();

                // reload the splash screen to check for internet connection and reload everything
                context.go('/');
              },
              text: 'REÎNCEARCĂ',
              textStyle: const TextStyle(
                fontSize: 20,
                color: logoBlue,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
