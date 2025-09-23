import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_empty.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:auto_asig/feature/auth/screens/create_account_screen.dart';
import 'package:auto_asig/feature/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const path = '/onboarding_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(padding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/simple_logo.png',
                width: 150,
              ),
              const Text(
                'alliat',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w900,
                  color: logoBlue,
                  fontSize: 40,
                  letterSpacing: 3.5,
                ),
              ),
              const Text(
                'protejăm zâmbete',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 100),
              AutoAsigButton(
                onPressed: () {
                  context.push(LoginScreen.absolutePath);
                },
                buttonWidth: 275,
                text: 'AUTENTIFICARE',
                textStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              AutoAsigButtonEmpty(
                onPressed: () {
                  context.push(CreateAccountScreen.absolutPath);
                },
                buttonWidth: 275,
                text: 'ÎNREGISTRARE',
                textStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
