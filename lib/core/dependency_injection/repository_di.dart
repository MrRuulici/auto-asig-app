import 'package:auto_asig/feature/authentication/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// provides app-wide repositories
class RepositoryDI extends StatelessWidget {
  const RepositoryDI({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => const AuthRepository(
              // context.read<SupabaseAuthProvider>(),
              // context.read<BiometricStorageProvider>(),
              ),
        ),
      ],
      child: child,
    );
  }
}
