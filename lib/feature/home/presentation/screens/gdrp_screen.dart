import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/feature/authentication/presentation/screens/onboarding_screen.dart';
import 'package:auto_asig/feature/home/presentation/helpers/text_format_helper.dart';
import 'package:flutter/material.dart';

class GDPRScreen extends StatelessWidget {
  static const path = 'gdpr_screen';
  static const absolutePath = '${OnboardingScreen.path}/$path';

  const GDPRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // title: const Text('Prevederi GDPR'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
          // vertical: 16.0,
          horizontal: padding,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Titlul principal
              const Text(
                'Politica de Confidențialitate și Protecția Datelor Personale (GDPR)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: logoBlue,
                ),
              ),
              const SizedBox(height: 10),
              // Data actualizării
              const Text(
                'Ultima actualizare: [Data actualizării]',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              // Secțiuni
              buildSectionTitle('1. Introducere'),
              buildSectionContent(
                'Această Politică de Confidențialitate explică modul în care [Numele Aplicației] '
                'colectează, utilizează, stochează și protejează informațiile personale ale utilizatorilor. '
                'Ne angajăm să respectăm Regulamentul General privind Protecția Datelor (GDPR) și alte reglementări aplicabile în domeniul protecției datelor.',
              ),
              buildSectionContent(
                'Prin utilizarea aplicației noastre, acceptați această Politică de Confidențialitate. '
                'Dacă nu sunteți de acord cu termenii, vă rugăm să nu utilizați aplicația.',
              ),
              const SizedBox(height: 20),
              buildSectionTitle('2. Informațiile pe care le colectăm'),
              buildSectionContent(
                'Aplicația noastră poate colecta următoarele date personale:\n'
                '- Informații de identificare personală: Nume, Prenume, Cod Numeric Personal (CNP), Data nașterii, Seria și numărul cărții de identitate, data expirării documentului.\n'
                '- Informații de contact: Număr de telefon, Adresa de email.\n'
                '- Informații de autentificare: Parola utilizatorului (stocată într-un format securizat, ex. hash).\n'
                '- Informații despre autovehicule: Marca, modelul, numărul de înmatriculare, detalii despre asigurări (tipuri, date de expirare).\n'
                '- Date de utilizare: Informații despre modul în care utilizați aplicația, inclusiv loguri ale sesiunilor.\n'
                '- Date financiare: Informații despre plăți și tranzacții, dacă este cazul.',
              ),
              const SizedBox(height: 20),
              buildSectionTitle('3. Scopul colectării datelor'),
              buildSectionContent(
                'Folosim datele personale pentru următoarele scopuri:\n'
                '- Crearea și gestionarea contului utilizatorului.\n'
                '- Procesarea comenzilor și furnizarea serviciilor (ex. generarea de asigurări auto/sănătate).\n'
                '- Comunicări legate de serviciile noastre (notificări despre expirarea polițelor, confirmări de tranzacții, etc.).\n'
                '- Conformarea cu cerințele legale și protecția împotriva activităților frauduloase.\n'
                '- Îmbunătățirea funcționalității aplicației și personalizarea experienței utilizatorului.',
              ),
              const SizedBox(height: 20),
              // Continuare pentru restul secțiunilor
              buildSectionTitle('4. Baza legală pentru prelucrarea datelor'),
              buildSectionContent(
                'Prelucrăm datele dvs. personale în baza consimțământului, executării unui contract, obligațiilor legale sau interesului legitim al companiei noastre.',
              ),
              const SizedBox(height: 20),
              buildSectionTitle('11. Contact'),
              buildSectionContent(
                'Pentru întrebări sau solicitări legate de Politica de Confidențialitate, ne puteți contacta la:\n'
                '- Email: [Adresa de email]\n'
                '- Telefon: [Număr de telefon]',
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
