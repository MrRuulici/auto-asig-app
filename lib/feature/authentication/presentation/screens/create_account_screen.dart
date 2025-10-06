import 'package:auto_asig/core/helpers/authentication_helper.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_empty.dart';
import 'package:auto_asig/feature/home/presentation/screens/gdrp_screen.dart';
import 'package:auto_asig/feature/home/presentation/screens/terms_and_conditions_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_asig/feature/authentication/presentation/cubit/registration_cubit.dart';
import 'package:auto_asig/feature/authentication/presentation/cubit/registration_state.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/feature/authentication/presentation/screens/onboarding_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_asig/feature/authentication/presentation/screens/login_screen.dart';

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});

  static const path = 'create_account_screen';
  static const absolutPath = '${OnboardingScreen.path}/create_account_screen';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final FlCountryCodePicker countryPicker = const FlCountryCodePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegistrationCubit, RegistrationState>(
        listener: (context, state) {


          //NOU: caz nou pentru stare noua, email de verificare trimis
          if(state is RegistrationVerificationEmailSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Cont creat! Te rugăm să-ți verifici emailul ${emailController.text} pentru a te putea loga!')),
            );
            context.go('${OnboardingScreen.path}/${LoginScreen.path}'); // Redirecționează utilizatorul la ecranul de login
          }


          else if (state is RegistrationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          bool isChecked =
              state is RegistrationCheckboxState && state.isChecked;


          //animatie de incarcare la inregistrare
          if (state is RegistrationLoading) {
            return const Center(child: CircularProgressIndicator());
          }


          return Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: screenHeight! * 0.075,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 30,
                          color: logoBlue,
                        ),
                      ),
                      Image.asset(
                        'assets/images/simple_logo.png',
                        height: 75,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Crează\nCont Nou,',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Poppins',
                      color: logoBlue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: 'Prenume'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: firstNameController,
                    decoration: const InputDecoration(labelText: 'Nume'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Telefon'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Parolă',
                      helperText: 'Minim 6 caractere',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirmă Parola',
                      helperText: 'Reintrodu parola',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          context
                              .read<RegistrationCubit>()
                              .toggleCheckbox(value ?? false);
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'Sunt de acord cu ',
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Termenii și Condițiile',
                                style: const TextStyle(
                                  color: logoBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Navigate to Terms
                                    context.push(
                                      TermsAndConditionsScreen.absolutePath,
                                    );
                                  },
                              ),
                              const TextSpan(
                                text: ' și prevederile ',
                              ),
                              TextSpan(
                                text: 'GDPR',
                                style: const TextStyle(
                                  color: logoBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Navigate to GDPR
                                    context.push(GDPRScreen.absolutePath);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        AutoAsigButtonEmpty(
                          buttonWidth: 275,
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: logoBlue,
                          ),
                          text: 'ÎNREGISTRARE',
                          onPressed: isChecked
                              ? () {
                                  if (passwordController.text.length < 6) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Parola trebuie sa aiba minim 6 caractere!'),
                                      ),
                                    );
                                    return;
                                  }
                                  // do the checks before registering
                                  else if (passwordController.text !=
                                      confirmPasswordController.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Parolele trebuie sa fie identince!'),
                                      ),
                                    );
                                    return;
                                  } else if (phoneController.text.length < 10) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Numarul de telefon trebuie sa aiba minim 10 caractere!'),
                                      ),
                                    );
                                    return;
                                  } else if (phoneController.text.length > 13) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Numarul de telefon trebuie sa aiba maxim 13 caractere!'),
                                      ),
                                    );
                                    return;
                                  } else if (emailController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Email-ul nu poate fi gol!'),
                                      ),
                                    );
                                    return;
                                  } else if (firstNameController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Numele nu poate fi gol!'),
                                      ),
                                    );
                                    return;
                                  } else if (lastNameController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Prenumele nu poate fi gol!'),
                                      ),
                                    );
                                    return;
                                  } else if (phoneController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Numarul de telefon nu poate fi gol!'),
                                      ),
                                    );
                                    return;
                                  }

                                  final cubit =
                                      context.read<RegistrationCubit>();
                                  cubit.register(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    phone: phoneController.text,
                                    country: const CountryCode(
                                      name: 'Romania',
                                      code: 'RO',
                                      dialCode: '+40',
                                    ),
                                  );
                                }
                              : null, // Disable button if checkbox is not selected
                        ),
                        AutoAsigButtonEmpty(
                          buttonWidth: 275,
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: logoBlue,
                          ),
                          preTextIcon: const Icon(
                            FontAwesomeIcons.apple,
                            color: Colors.black,
                          ),
                          text: 'APPLE',
                          onPressed: isChecked
                              // ? () => handleAppleSignIn(
                              //       context: context,
                              //       email: emailController.text,
                              //       firstName: firstNameController.text,
                              //       lastName: lastNameController.text,
                              //     )
                              ? () {}
                              : null,
                        ),
                        AutoAsigButtonEmpty(
                          buttonWidth: 275,
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: logoBlue,
                          ),
                          preTextIcon: const Icon(
                            FontAwesomeIcons.google,
                            color: Color.fromRGBO(199, 22, 16, 1),
                          ),
                          text: 'GOOGLE',
                          onPressed: isChecked
                              ? () async {
                                  // show loading indicator
                                  // signInWithGoogle();

                                  // hide loading indicator
                                }
                              : null,
                        ),
                        // Apple Sign-In Button (only show if platform is iOS)
                        // if (Theme.of(context).platform == TargetPlatform.iOS)
                        // ElevatedButton.icon(
                        //   icon: const Icon(Icons.apple, color: Colors.white),
                        //   label: const Text('ÎNREGISTRARE CU APPLE'),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor:
                        //         Colors.black, // Apple branding color
                        //   ),
                        //   onPressed: () {
                        //     handleAppleSignIn(
                        //       context: context,
                        //       email: emailController.text,
                        //       firstName: firstNameController.text,
                        //       lastName: lastNameController.text,
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      // bottomNavigationBar: SafeArea(
      //   child: BlocBuilder<RegistrationCubit, RegistrationState>(
      //     builder: (context, state) {
      //       bool isChecked =
      //           state is RegistrationCheckboxState && state.isChecked;

      //       return Container(
      //         color: Colors.white,
      //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //         child: Column(
      //           children: [
      //             AutoAsigButtonEmpty(
      //               buttonWidth: 275,
      //               textStyle: const TextStyle(
      //                 fontSize: 18,
      //                 fontWeight: FontWeight.bold,
      //                 color: logoBlue,
      //               ),
      //               text: 'ÎNREGISTRARE',
      //               onPressed: isChecked
      //                   ? () {
      //                       if (passwordController.text.length < 6) {
      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           const SnackBar(
      //                             content: Text(
      //                                 'Parola trebuie sa aiba minim 6 caractere!'),
      //                           ),
      //                         );
      //                         return;
      //                       }
      //                       // do the checks before registering
      //                       else if (passwordController.text !=
      //                           confirmPasswordController.text) {
      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           const SnackBar(
      //                             content: Text(
      //                                 'Parolele trebuie sa fie identince!'),
      //                           ),
      //                         );
      //                         return;
      //                       } else if (phoneController.text.length < 10) {
      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           const SnackBar(
      //                             content: Text(
      //                                 'Numarul de telefon trebuie sa aiba minim 10 caractere!'),
      //                           ),
      //                         );
      //                         return;
      //                       } else if (phoneController.text.length > 13) {
      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           const SnackBar(
      //                             content: Text(
      //                                 'Numarul de telefon trebuie sa aiba maxim 13 caractere!'),
      //                           ),
      //                         );
      //                         return;
      //                       } else if (emailController.text.isEmpty) {
      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           const SnackBar(
      //                             content: Text('Email-ul nu poate fi gol!'),
      //                           ),
      //                         );
      //                         return;
      //                       } else if (firstNameController.text.isEmpty) {
      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           const SnackBar(
      //                             content: Text('Numele nu poate fi gol!'),
      //                           ),
      //                         );
      //                         return;
      //                       } else if (lastNameController.text.isEmpty) {
      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           const SnackBar(
      //                             content: Text('Prenumele nu poate fi gol!'),
      //                           ),
      //                         );
      //                         return;
      //                       } else if (phoneController.text.isEmpty) {
      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           const SnackBar(
      //                             content: Text(
      //                                 'Numarul de telefon nu poate fi gol!'),
      //                           ),
      //                         );
      //                         return;
      //                       }

      //                       final cubit = context.read<RegistrationCubit>();
      //                       cubit.register(
      //                         email: emailController.text,
      //                         password: passwordController.text,
      //                         firstName: firstNameController.text,
      //                         lastName: lastNameController.text,
      //                         phone: phoneController.text,
      //                         country: const CountryCode(
      //                           name: 'Romania',
      //                           code: 'RO',
      //                           dialCode: '+40',
      //                         ),
      //                       );
      //                     }
      //                   : null, // Disable button if checkbox is not selected
      //             ),
      //             SizedBox(height: 20),
      //             // Google Sign-In Button
      //             ElevatedButton.icon(
      //               icon: Icon(Icons.g_mobiledata, color: Colors.white),
      //               label: Text('ÎNREGISTRARE CU GOOGLE'),
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: Colors.red, // Google branding color
      //               ),
      //               onPressed: () {
      //                 handleGoogleSignIn(
      //                   context: context,
      //                   email: emailController.text,
      //                   firstName: firstNameController.text,
      //                   lastName: lastNameController.text,
      //                 );
      //               },
      //             ),
      //             const SizedBox(height: 10),
      //             // Apple Sign-In Button (only show if platform is iOS)
      //             if (Theme.of(context).platform == TargetPlatform.iOS)
      //               ElevatedButton.icon(
      //                 icon: const Icon(Icons.apple, color: Colors.white),
      //                 label: const Text('ÎNREGISTRARE CU APPLE'),
      //                 style: ElevatedButton.styleFrom(
      //                   backgroundColor: Colors.black, // Apple branding color
      //                 ),
      //                 onPressed: () {
      //                   handleAppleSignIn(
      //                     context: context,
      //                     email: emailController.text,
      //                     firstName: firstNameController.text,
      //                     lastName: lastNameController.text,
      //                   );
      //                 },
      //               ),
      //           ],
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
