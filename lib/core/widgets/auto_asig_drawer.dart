import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/feature/auth/cubit/auth_cubit.dart';
import 'package:auto_asig/feature/auth/screens/onboarding_screen.dart';
import 'package:auto_asig/feature/home_screen/screens/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AutoAsigDrawer extends StatelessWidget {
  const AutoAsigDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    void logout() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Delogare',
            style: TextStyle(fontSize: theFontSize),
          ),
          content: const Text(
            'Ești sigur că vrei să te deloghezi?',
            style: TextStyle(
              fontSize: theFontSize,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Nu',
                style: TextStyle(fontSize: theFontSize),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Da',
                style: TextStyle(
                  fontSize: theFontSize,
                ),
              ),
            ),
          ],
        ),
      ).then((value) {
        if (value == true) {
          context.read<UserDataCubit>().clearUserData();
          context.read<AuthenticationCubit>().signOut();
          context.go(OnboardingScreen.path);
        }
      });
    }

    return Drawer(
      elevation: 4,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8),
                // Wrap Text in a ConstrainedBox to limit the width
                BlocBuilder<UserDataCubit, UserDataState>(
                  builder: (context, state) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width -
                            32, // Set the max width based on margins (16 on both sides)
                      ),
                      child: Text(
                        state.member.firstName,
                        style: const TextStyle(
                          fontSize: theFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis, // To handle long names
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                // Profile
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [primaryBlue, blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    title: const Text(
                      'Profil',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    leading: const Icon(Icons.person, color: Colors.white),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                    onTap: () {
                      // Handle profile action
                    },
                  ),
                ),
                // About App
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [primaryBlue, blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    title: const Text(
                      'Despre Aplicație',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    leading:
                        const Icon(Icons.info_rounded, color: Colors.white),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                    onTap: () {
                      context.push(AboutScreen.absolutePath);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Logout button
          Container(
            width: double.maxFinite,
            margin: const EdgeInsets.only(
              bottom: padding,
              top: padding,
              left: 8,
              right: 8,
            ),
            padding: const EdgeInsets.symmetric(horizontal: padding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.redAccent.shade700,
                  Colors.orangeAccent.shade200
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ElevatedButton.icon(
              onPressed: logout,
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Delogare',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                // padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
