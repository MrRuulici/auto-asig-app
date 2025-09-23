import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:auto_asig/feature/auth/cubit/forgot_password_cubit.dart';
import 'package:auto_asig/feature/auth/cubit/forgot_password_state.dart';
import 'package:auto_asig/feature/auth/screens/create_account_screen.dart';
import 'package:auto_asig/feature/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  static const path = 'forgot-password';
  static const absolutePath = '${LoginScreen.absolutePath}/$path';

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: Scaffold(
        body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Email pentru resetarea parolei a fost trimis! Verifică-ți căsuța de e-mail.',
                  ),
                ),
              );
              _emailController.clear();
            } else if (state is ForgotPasswordError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                children: [
                  SizedBox(height: screenHeight! * 0.05),
                  // Header Row
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
                  const Spacer(flex: 1),

                  // Title Section
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ai uitat\nParola?',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: logoBlue,
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),

                  // Email Input
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      // labelText: 'Email sau număr de telefon',
                      hintText: 'Email',
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),

                  // Reset Password Button
                  AutoAsigButton(
                    text: 'Resetează Parola',
                    onPressed: state is ForgotPasswordLoading
                        ? null // Disable button while loading
                        : () {
                            final email = _emailController.text.trim();
                            context
                                .read<ForgotPasswordCubit>()
                                .resetPassword(email);
                          },
                    child: state is ForgotPasswordLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          )
                        : const Text(
                            'TRIMITE',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const Spacer(flex: 2),

                  // Bottom "Create Account" Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Nu ai un cont?',
                        style: TextStyle(
                          fontSize: theFontSize,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push(CreateAccountScreen.absolutPath);
                        },
                        child: const Text(
                          'Creazã acum unul.',
                          style: TextStyle(
                            fontSize: theFontSize,
                            fontFamily: 'Poppins',
                            color: logoBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(flex: 1),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
