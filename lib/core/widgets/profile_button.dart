import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/feature/home/presentation/screens/home_screen.dart';
import 'package:auto_asig/feature/user/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = context.read<UserDataCubit>().state;
    
    // Determine which image to show
    ImageProvider profileImage;
    if (userData.member.profilePictureUrl.isNotEmpty &&
        userData.member.profilePictureUrl.startsWith('data:image')) {
      // Base64 image
      profileImage = MemoryImage(
        base64Decode(userData.member.profilePictureUrl.split(',')[1]),
      );
    } else {
      // Default image
      profileImage = const NetworkImage(defaultProfilePictureUrl);
    }

    return GestureDetector(
      onTap: () {
        context.go('${HomeScreen.path}/${ProfileScreen.path}');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular profile picture
          CircleAvatar(
            radius: 20,
            backgroundImage: profileImage,
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      '${userData.member.firstName} ${userData.member.lastName}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}