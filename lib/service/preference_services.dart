import 'package:shared_preferences/shared_preferences.dart';

class PreferenceServices {
  late SharedPreferences prefs;

  PreferenceServices() {
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void savePreference(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  void clearBookmarks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('pokemon_bookmarks');
    await prefs.remove('move_bookmarks');
    await prefs.remove('ability_bookmarks');
    // showMessage('Bookmarks cleared successfully.');
  }

  void clearPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('theme');
    await prefs.remove('heightunit');
    await prefs.remove('weightunit');
    // showMessage('Preferences cleared successfully.');
  }

  Future<String> loadPreference(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key)!;
  }
}
