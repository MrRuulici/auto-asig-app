import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/feature/auth/screens/onboarding_screen.dart';
import 'package:auto_asig/feature/home_screen/helpers/text_format_helper.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  static const path = 'terms_and_conditions_screen';
  static const absolutePath = '${OnboardingScreen.path}/$path';

  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // title: const Text('Termeni și Condiții'),
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
          vertical: 16.0,
          horizontal: padding,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titlul principal
              const Text(
                'Termenii și Condițiile',
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
                'Acești Termeni și Condiții guvernează utilizarea aplicației [Numele Aplicației] și a serviciilor furnizate de [Numele Companiei]. '
                'Prin crearea unui cont și utilizarea aplicației, sunteți de acord să respectați acești termeni. '
                'Dacă nu sunteți de acord cu acești termeni, vă rugăm să nu utilizați aplicația noastră.',
              ),
              const SizedBox(height: 20),
              buildSectionTitle('2. Definiții'),
              buildSectionContent(
                '- **Aplicație:** [Numele Aplicației], disponibilă pe platformele [iOS/Android].\n'
                '- **Utilizator:** Persoana care descarcă, creează un cont și utilizează aplicația.\n'
                '- **Servicii:** Funcționalitățile oferite de aplicație, cum ar fi generarea de asigurări auto și de sănătate.\n'
                '- **Companie:** [Numele Companiei], operatorul aplicației.',
              ),
              const SizedBox(height: 20),
              buildSectionTitle('3. Eligibilitate'),
              buildSectionContent(
                'Pentru a utiliza aplicația, trebuie să:\n'
                '- Aveți cel puțin 18 ani.\n'
                '- Furnizați informații corecte, complete și actualizate la crearea contului.\n'
                '- Respectați toate legile aplicabile.',
              ),
              const SizedBox(height: 20),
              buildSectionTitle('4. Crearea și gestionarea contului'),
              buildSectionContent(
                '- **Obligațiile utilizatorului:** Sunteți responsabil pentru păstrarea confidențialității datelor de autentificare și pentru toate activitățile desfășurate în contul dvs.\n'
                '- **Securitate:** Dacă suspectați o utilizare neautorizată a contului, trebuie să ne informați imediat.\n'
                '- **Suspendare sau închidere:** Compania își rezervă dreptul de a suspenda sau închide contul în cazul încălcării acestor termeni.',
              ),
              const SizedBox(height: 20),
              buildSectionTitle('5. Utilizarea aplicației'),
              buildSectionContent(
                'Aplicația și serviciile noastre pot fi utilizate exclusiv pentru scopuri legale. Este interzis:\n'
                '- Utilizarea aplicației pentru activități frauduloase sau ilegale.\n'
                '- Încercarea de a accesa sistemele noastre fără autorizație.\n'
                '- Furnizarea de informații false sau incomplete.',
              ),
              const SizedBox(height: 20),
              buildSectionTitle('6. Serviciile oferite'),
              buildSectionContent(
                '[Numele Aplicației] oferă utilizatorilor posibilitatea de a:\n'
                '- Completa datele necesare pentru generarea asigurărilor auto și de sănătate.\n'
                '- Gestiona polițele de asigurare și primirea notificărilor legate de expirarea acestora.\n'
                '- Efectua plăți (dacă este cazul).\n\n'
                '**Notă:** Compania nu este responsabilă pentru erorile apărute din cauza furnizării unor informații incorecte sau incomplete de către utilizator.',
              ),
              const SizedBox(height: 20),
              buildSectionTitle('7. Drepturi de proprietate intelectuală'),
              buildSectionContent(
                'Toate drepturile asupra aplicației, inclusiv designul, logo-urile, codul sursă și alte materiale, aparțin [Numele Companiei]. '
                'Utilizatorii nu au dreptul să copieze, modifice, distribuie sau să utilizeze aplicația în scopuri comerciale fără acordul scris al companiei.',
              ),
              const SizedBox(height: 20),
              buildSectionTitle('11. Contact'),
              buildSectionContent(
                'Pentru întrebări sau asistență, ne puteți contacta la:\n'
                '- **Email:** [Adresa de email]\n'
                '- **Telefon:** [Număr de telefon]',
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
