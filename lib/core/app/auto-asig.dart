import 'package:auto_asig/core/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:auto_asig/core/app/router.dart';

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
      // onGenerateTitle: (context) => context.l10n.appName,
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
      // theme: lightTheme,
      builder: (context, child) {
        var finalChild = child!;
        return finalChild;
      },
    );
  }
}
