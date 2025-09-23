import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = context.read<UserDataCubit>().state;

    return GestureDetector(
      onTap: () {
        // Todo - Load the profile page
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular profile picture
          CircleAvatar(
            radius: 20,
            // Todo - Replace with the actual profile picture URL
            backgroundImage: const NetworkImage(
              defaultProfilePictureUrl,
              // userData.member
              //     .profilePictureUrl,
            ),
            backgroundColor:
                Colors.grey[200], // Fallback color if no image is available
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
