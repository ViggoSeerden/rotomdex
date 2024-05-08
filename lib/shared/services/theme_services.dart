import 'package:rotomdex/shared/services/preference_services.dart';
import 'package:rotomdex/shared/data/themes.dart';
import 'package:themed/themed.dart';

class ThemeServices {
  final PreferenceServices preferenceServices;

  ThemeServices(): preferenceServices = PreferenceServices(); 

  Future<Map<ThemeRef, Object>> loadSavedTheme() async {
    String? savedTheme = await preferenceServices.loadPreference('theme');

    switch (savedTheme) {
      case 'rotom':
        return BaseThemeColors.rotomTheme;
      case 'light':
        return BaseThemeColors.lightTheme;
      case 'dark':
        return BaseThemeColors.darkTheme;
      default:
        return BaseThemeColors.rotomTheme;
    }
  }

  void setTheme(String theme) {
    switch (theme) {
      case 'rotom':
        Themed.currentTheme = BaseThemeColors.rotomTheme;
        break;
      case 'light':
        Themed.currentTheme = BaseThemeColors.lightTheme;
        break;
      case 'dark':
        Themed.currentTheme = BaseThemeColors.darkTheme;
        break;
      default:
        Themed.currentTheme = BaseThemeColors.rotomTheme;
        break;
    }

    preferenceServices.savePreference('theme', theme);
  }
}
