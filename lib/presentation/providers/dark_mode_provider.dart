import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';

class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier() : super(false);

  void setDarkMode(bool isDarkMode) {
    state = isDarkMode;
  }
}

final isDarkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>(
  (ref) => DarkModeNotifier(),
);



final themeNotifierProvider = 
  StateNotifierProvider.family<ThemeNotifier, AppTheme, bool>((ref, isDarkMode) {



    return ThemeNotifier(isDarkMode: isDarkMode);
  } );

class ThemeNotifier extends StateNotifier<AppTheme> {

  bool isDarkMode;
  ThemeNotifier({required this.isDarkMode}): 
  super( AppTheme(isDarkMode: isDarkMode) );

  void setDarkMode(bool isDarkMode) {
    state = state.copyWith(isDarkMode: isDarkMode);
  }

}