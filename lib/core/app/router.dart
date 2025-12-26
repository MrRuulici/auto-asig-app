import 'package:auto_asig/core/models/vehicle_jorunal_model.dart';
import 'package:auto_asig/feature/add/presentation/screens/add_screen.dart';
import 'package:auto_asig/feature/authentication/presentation/screens/create_account_screen.dart';
import 'package:auto_asig/feature/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:auto_asig/feature/authentication/presentation/screens/login_screen.dart';
import 'package:auto_asig/feature/authentication/presentation/screens/onboarding_screen.dart';
import 'package:auto_asig/feature/user/presentation/screens/norification_test_screen.dart';
import 'package:auto_asig/feature/user/presentation/screens/profile_screen.dart';
import 'package:auto_asig/feature/vehicles/presentation/screens/edit_car_screen.dart';
import 'package:auto_asig/feature/vehicles/presentation/screens/register_car_screen.dart';
import 'package:auto_asig/feature/home/presentation/screens/about_screen.dart';
import 'package:auto_asig/feature/home/presentation/screens/gdrp_screen.dart';
import 'package:auto_asig/feature/home/presentation/screens/home_screen.dart';
import 'package:auto_asig/feature/home/presentation/screens/terms_and_conditions_screen.dart';
import 'package:auto_asig/feature/documents/presentation/screens/id_cards_screen.dart';
import 'package:auto_asig/feature/intro/presentation/screens/maintenance_screen.dart';
import 'package:auto_asig/feature/intro/presentation/screens/no_internet_screen.dart';
import 'package:auto_asig/feature/intro/presentation/screens/old_version_screen.dart';
import 'package:auto_asig/feature/intro/presentation/screens/splash_screen.dart';
import 'package:auto_asig/core/models/reminder.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/feature/vehicles/vehicle_journal/screens/edit_journal_entry_screen.dart';
import 'package:auto_asig/feature/vehicles/vehicle_journal/screens/vehicle_journal_screen.dart';
import 'package:go_router/go_router.dart';

final _publicPaths = {
  SplashScreen.path,
  HomeScreen.path,
  LoginScreen.path,
  ForgotPasswordScreen.path,
};

final appRouter = GoRouter(
  redirect: (context, state) {
    // This redirect callback allows us to protect routes that require authenticated members.
    final path = state.uri.toString();

    if (path == '/') {
      // Don't redirect from SplashScreen
      return null;
    }

    // Additional redirection logic
    return null;
  },
  routes: [
    GoRoute(
      path: SplashScreen.path,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: NoInternetScreen.path,
      builder: (context, state) => const NoInternetScreen(),
    ),
    GoRoute(
      path: OldVersionScreen.path,
      builder: (context, state) => const OldVersionScreen(),
    ),
    GoRoute(
      path: MaintenanceScreen.path,
      builder: (context, state) => const MaintenanceScreen(),
    ),
    GoRoute(
      path: OnboardingScreen.path,
      builder: (context, state) => const OnboardingScreen(),
      routes: [
        GoRoute(
          path: LoginScreen.path,
          builder: (context, state) => LoginScreen(),
          routes: [
            GoRoute(
              path: ForgotPasswordScreen.path,
              builder: (context, state) => ForgotPasswordScreen(),
            ),
          ],
        ),
        GoRoute(
          path: CreateAccountScreen.path,
          builder: (context, state) => CreateAccountScreen(),
        ),
        GoRoute(
          path: GDPRScreen.path,
          builder: (context, state) => const GDPRScreen(),
        ),
        GoRoute(
          path: TermsAndConditionsScreen.path,
          builder: (context, state) => const TermsAndConditionsScreen(),
        ),
      ],
    ),
    // Add notification test route here
    GoRoute(
      path: '/notification-test',
      builder: (context, state) => const NotificationTestScreen(),
    ),
    GoRoute(
      path: HomeScreen.path,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: AddScreen.path,
          builder: (context, state) => const AddScreen(),
        ),
        GoRoute(
          path: AboutScreen.path,
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: RegisterCarScreen.path,
          builder: (context, state) => const RegisterCarScreen(),
        ),
        GoRoute(
          path: EditCarScreen.path,
          builder: (context, state) => const EditCarScreen(),
        ),
        GoRoute(
          path: ProfileScreen.path,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: VehicleJournalScreen.path,
          builder: (context, state) => const VehicleJournalScreen(),
          routes: [
            GoRoute(
              path: EditJournalEntryScreen.path,
              builder: (context, state) {
                final JournalEntry entry = state.extra as JournalEntry;
                return const EditJournalEntryScreen();
              },
            ),
          ],
        ),
        GoRoute(
          path: '${ReminderScreen.path}/:type',
          builder: (context, state) {
            // Retrieve the ReminderType from the path parameter
            final String typeString = state.pathParameters['type']!;
            final ReminderType reminderType = ReminderType.values
                .firstWhere((e) => e.toString().split('.').last == typeString);

            // Retrieve Reminder for editing if provided
            final Reminder? reminder = state.extra as Reminder?;

            return ReminderScreen(
              reminder: reminder,
              type: reminderType,
            );
          },
        ),
      ],
    ),
  ],
);
