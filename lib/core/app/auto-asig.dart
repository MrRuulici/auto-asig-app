import 'package:auto_asig/core/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:auto_asig/core/app/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AutoAsig extends StatelessWidget {
  const AutoAsig({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: logoBlue,
          shape: CircleBorder(),
        ),
      ),
      // Add localization support
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ro', 'RO'),
      ],
      locale: const Locale('ro', 'RO'), // Set Romanian as default
      routerConfig: appRouter,
      builder: (context, child) {
        var finalChild = child!;
        return finalChild;
      },
    );
  }
}