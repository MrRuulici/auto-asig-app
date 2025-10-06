import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:auto_asig/feature/authentication/presentation/cubit/auth_cubit.dart';
import 'package:auto_asig/feature/authentication/presentation/cubit/auth_state.dart';
import 'package:auto_asig/feature/authentication/presentation/screens/create_account_screen.dart';
import 'package:auto_asig/feature/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:auto_asig/feature/authentication/presentation/screens/onboarding_screen.dart';
import 'package:auto_asig/feature/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static const path = 'login_screen';
  static const absolutePath = '${OnboardingScreen.path}/$path';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSuccess) {
            context.go(HomeScreen.path);
          } else if (state is AuthenticationFailure) {
            showSnackbar(
              context,
              state.errorMessage,
            );
          }
        },
        builder: (context, state) {
          final isPasswordVisible = state is PasswordVisibilityState
              ? state.isPasswordVisible
              : false;

          return SafeArea(
            child: GestureDetector(
              onTap: () {
                // Dismiss keyboard when tapping outside
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Top Row (Back Icon + Logo)
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

                        const SizedBox(height: 30),

                        // Welcome Text
                        const Text(
                          'Salut!\nBun venit,',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Poppins',
                            color: logoBlue,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Text Fields
                        TextField(
                          style: const TextStyle(fontSize: theFontSize),
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontSize: theFontSize,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          style: const TextStyle(fontSize: theFontSize),
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              fontSize: theFontSize,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                            labelText: 'Parola',
                            suffixIcon: IconButton(
                              icon: Icon(isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                BlocProvider.of<AuthenticationCubit>(context)
                                    .togglePasswordVisibility();
                              },
                            ),
                          ),
                          obscureText: !isPasswordVisible,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                context.push(ForgotPasswordScreen.absolutePath);
                              },
                              child: Text(
                                'Ai uitat parola?',
                                style: TextStyle(
                                  fontSize: theFontSize,
                                  fontFamily: 'Poppins',
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Authentication Button and Sign-Up Text
                        Column(
                          children: [
                            AutoAsigButton(
                              buttonWidth: 200,
                              textStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              onPressed: () async {
                                showLoadingDialog(context);

                                //print(emailController.text);

                                BlocProvider.of<AuthenticationCubit>(context)
                                    .login(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  context: context,
                                );

                                Navigator.of(context).pop();
                              },
                              text: 'AUTENTIFICARE',
                            ),
                            const SizedBox(height: 16),
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
                                    context
                                        .push(CreateAccountScreen.absolutPath);
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
