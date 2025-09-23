// Example cubit for dynamic AppBar color or other states
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarCubit extends Cubit<Color> {
  AppBarCubit() : super(Colors.white);

  void changeAppBarColor(Color color) => emit(color);
}
