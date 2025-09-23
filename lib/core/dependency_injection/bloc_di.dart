import 'package:auto_asig/core/cubit/app_bar_cubit.dart';
import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/feature/auth/cubit/auth_cubit.dart';
import 'package:auto_asig/feature/auth/cubit/forgot_password_cubit.dart';
import 'package:auto_asig/feature/auth/cubit/reg_country_picker_cubit.dart';
import 'package:auto_asig/feature/auth/cubit/registration_cubit.dart';
import 'package:auto_asig/feature/cars_reg/cubit/car_info_cubit.dart';
import 'package:auto_asig/feature/cars_reg/cubit/edit_vehicle_reminder_cubit.dart';
import 'package:auto_asig/feature/home_screen/cubit/home_screen_cubit.dart';
import 'package:auto_asig/feature/home_screen/cubit/unified_cubit.dart';
import 'package:auto_asig/feature/id_cards_screen/cubit/id_cards_cubit.dart';
import 'package:auto_asig/feature/home_screen/cubit/reminder_cubit.dart';
import 'package:auto_asig/feature/vehicle_journal_screen/cubit/edit_journal_entry_cubit.dart';
import 'package:auto_asig/feature/vehicle_journal_screen/cubit/vehicle_journals_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// provides app-wide cubits
class BlocDI extends StatelessWidget {
  const BlocDI({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationCubit>(
          create: (context) => AuthenticationCubit(FirebaseAuth.instance),
        ),
        BlocProvider<UserDataCubit>(
          create: (context) => UserDataCubit(),
        ),
        BlocProvider<ForgotPasswordCubit>(
          create: (context) => ForgotPasswordCubit(),
        ),
        BlocProvider<RegistrationCubit>(
          create: (context) => RegistrationCubit(FirebaseAuth.instance),
        ),
        BlocProvider<CarInfoCubit>(
          create: (context) => CarInfoCubit(),
        ),
        BlocProvider<IdCardsCubit>(
          create: (context) => IdCardsCubit(),
        ),
        BlocProvider<ReminderCubit>(
          create: (context) => ReminderCubit(),
        ),
        BlocProvider<AppBarCubit>(
          create: (context) => AppBarCubit(),
        ),
        BlocProvider<HomeScreenCubit>(
          create: (context) => HomeScreenCubit(),
        ),
        BlocProvider<CountryPickerCubit>(
          create: (context) => CountryPickerCubit(),
        ),
        BlocProvider<UnifiedCubit>(
          create: (context) => UnifiedCubit(),
        ),
        BlocProvider<VehicleJournalsCubit>(
          create: (context) => VehicleJournalsCubit(),
        ),
        BlocProvider<EditJournalEntryCubit>(
          create: (context) => EditJournalEntryCubit(),
        ),
        BlocProvider<EditVehicleReminderCubit>(
          create: (context) => EditVehicleReminderCubit(),
        ),
      ],
      child: child,
    );
  }
}
