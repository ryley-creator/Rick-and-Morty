import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:task/imports/imports.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final Box themeBox = Hive.box('theme');

  ThemeBloc()
    : super(
        ThemeState(
          Hive.box('theme').get('themeMode', defaultValue: false)
              ? ThemeMode.dark
              : ThemeMode.light,
        ),
      ) {
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    final isDark = state.themeMode == ThemeMode.light;

    // save to Hive
    themeBox.put('themeMode', isDark);

    emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
  }
}
