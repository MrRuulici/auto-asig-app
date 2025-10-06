import 'package:auto_asig/feature/authentication/data/repositories/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// provides data providers
class DataProviderDI extends StatelessWidget {
  const DataProviderDI({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => const AuthRepository(),
        ),
      ],
      child: child,
    );
  }
}
