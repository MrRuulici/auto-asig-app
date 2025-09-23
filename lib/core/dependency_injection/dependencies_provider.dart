import 'package:auto_asig/core/dependency_injection/bloc_di.dart';
import 'package:auto_asig/core/dependency_injection/data_provider.dart';
import 'package:auto_asig/core/dependency_injection/repository_di.dart';
import 'package:flutter/material.dart';

class DependenciesProvider extends StatelessWidget {
  const DependenciesProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DataProviderDI(
      child: RepositoryDI(
        child: BlocDI(
          child: child,
        ),
      ),
    );
  }
}
