import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void toggle(Brightness currentBrightness) {
    if (state == ThemeMode.system) {
      emit(
        currentBrightness == Brightness.dark
            ? ThemeMode.light
            : ThemeMode.dark,
      );
      return;
    }
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  void setMode(ThemeMode mode) => emit(mode);
}
