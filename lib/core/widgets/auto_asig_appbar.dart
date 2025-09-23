import 'package:auto_asig/core/cubit/app_bar_cubit.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/profile_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlliatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ScrollController? scrollController;
  final double scrollTriggerOffset;

  AlliatAppBar({
    super.key,
    this.scrollController,
    this.scrollTriggerOffset = 200.0,
  }) {
    // Listen to scroll events inside the CustomAppBar
    scrollController?.addListener(() {
      if (scrollController!.offset > scrollTriggerOffset) {
        // Trigger the Cubit to change AppBar color
        appBarCubit.changeAppBarColor(Colors.white);
      } else {
        // Set a different color when scrolled back
        appBarCubit.changeAppBarColor(primaryBlue);
      }
    });
  }

  final AppBarCubit appBarCubit = AppBarCubit(); // Local instance of the Cubit

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBarCubit, Color>(
      bloc: appBarCubit, // Use the local Cubit instance
      builder: (context, appBarColor) {
        return AppBar(
          iconTheme: IconThemeData(
            color: appBarColor == Colors.white ? primaryBlue : Colors.white,
          ),
          backgroundColor: appBarColor,
          title: const ProfileButton(),
          // actions: [
          //   PopupMenuButton<int>(
          //     icon: Icon(Icons.add,
          //         color:
          //             appBarColor == Colors.white ? primaryBlue : Colors.white),
          //     onSelected: (int value) {
          //       switch (value) {
          //         case 1:
          //           // print('Option 1 selected');
          //           // context.push(ReminderScreen.absolutePath);
          //           context.go('${ReminderScreen.absolutePath}/idCard');
          //           break;
          //         case 2:
          //           // print('Option 2 selected');
          //           context.go('${ReminderScreen.absolutePath}/passport');
          //           break;
          //         case 3:
          //           // print('Option 3 selected');
          //           context.read<IdCardsCubit>().clearReminderData();
          //           context.go('${ReminderScreen.absolutePath}/drivingLicense');
          //           break;
          //         case 4:
          //           // print('Option 4 selected');
          //           // clear the CarInfoCubit variables
          //           context.read<CarInfoCubit>().clearCarInfo();
          //           context.push(RegisterCarScreen.absolutePath);
          //           break;
          //         case 5:
          //           // print('Option 5 selected');
          //           print('OTHER DOCUMENT SELECTED');
          //           break;
          //       }
          //     },
          //     itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
          //       const PopupMenuItem<int>(
          //         value: 1,
          //         child: Text('Cartea de identitate'),
          //       ),
          //       const PopupMenuItem<int>(
          //         value: 2,
          //         child: Text('Pașaport'),
          //       ),
          //       const PopupMenuItem<int>(
          //         value: 3,
          //         child: Text('⁠Permis de conducere'),
          //       ),
          //       const PopupMenuItem<int>(
          //         value: 4,
          //         child: Text('Vehicul'),
          //       ),
          //       const PopupMenuItem<int>(
          //         value: 5,
          //         child: Text('Alt document'),
          //       ),
          //     ],
          //   ),
          // ],
        );
      },
    );
  }
}
