import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_appbar.dart';
import 'package:auto_asig/feature/add_screen/widgets/add_item_button.dart';
import 'package:auto_asig/feature/cars_reg/screens/register_car_screen.dart';
import 'package:auto_asig/feature/home_screen/cubit/home_screen_cubit.dart';
import 'package:auto_asig/feature/home_screen/screens/home_screen.dart';
import 'package:auto_asig/feature/home_screen/widgets/home_bottom_navigation_bar.dart';
import 'package:auto_asig/feature/id_cards_screen/screens/id_cards_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  static const path = 'add_screen';
  static const absolutePath = '${HomeScreen.path}/$path';

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeScreenCubit>();

    // List of buttons
    final List<Widget> buttons = [
      AddItemButton(
        // path: AddScreen.absolutePath,
        path:
            '${ReminderScreen.absolutePath}/${ReminderType.idCard.toString().split('.').last}',
        title: 'Carte de identitate',
        image: Image.asset(
          'assets/images/ci_img.jpg',
          width: 50,
        ),
      ),
      AddItemButton(
        // path: AddScreen.absolutePath,
        path:
            '${ReminderScreen.absolutePath}/${ReminderType.drivingLicense.toString().split('.').last}',
        title: 'Permis de conducere',
        image: Image.asset(
          'assets/images/driving_lic.png',
          width: 50,
        ),
      ),
      AddItemButton(
        path:
            '${ReminderScreen.absolutePath}/${ReminderType.passport.toString().split('.').last}',
        title: 'Pasaport',
        image: Image.asset(
          'assets/images/passport_img.jpg',
          width: 50,
        ),
      ),
      AddItemButton(
        path: RegisterCarScreen.absolutePath,
        title: 'ITP, Asigurare, Rovinieta',
        image: Image.asset(
          'assets/images/car_img.png',
          width: 50,
        ),
      ),
      AddItemButton(
        path: AddScreen.absolutePath,
        title: 'Alt document',
        image: Image.asset(
          'assets/images/other_doc_img.png',
          width: 50,
        ),
      ),
    ];

    return Scaffold(
      appBar: AlliatAppBar(),
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          color: Colors.white,
          padding: const EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Adauga o data de expirare',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: logoBlue,
                ),
              ),
              const SizedBox(height: 16), // Spacing below the title
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 16, // Space between items in the same row
                    runSpacing: 16, // Space between rows
                    alignment:
                        WrapAlignment.center, // Center items horizontally
                    children: buttons,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(homeCubit: homeCubit),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // FAB logic
          context.push(AddScreen.absolutePath);
        },
        backgroundColor: logoBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
