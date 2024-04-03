import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rotomdex/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:themed/themed.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  List<String> themes = ['Rotom', 'Light', 'Dark'];
  List<String> heightunits = ['Meters', 'Feet/Inches'];
  List<String> weightunits = ['Kilograms', 'Pounds'];

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

    savePreference('theme', theme);
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
    showMessage('Bookmarks cleared successfully.');
  }

  void clearPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('theme');
    await prefs.remove('heightunit');
    await prefs.remove('weightunit');
    showMessage('Preferences cleared successfully.');
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            message,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        BaseThemeColors.detailContainerGradientTop,
                        BaseThemeColors.detailContainerGradientBottom,
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(children: [
                        const Text(
                          'Preferences',
                          style: TextStyle(
                              fontSize: 24,
                              color: BaseThemeColors.detailContainerText),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Theme: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            DropdownButton<String>(
                              dropdownColor: Colors.grey,
                              focusColor: Colors.grey,
                              value: themes.first,
                              items: themes.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: BaseThemeColors
                                            .detailContainerText),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) =>
                                  {setTheme(value.toString().toLowerCase())},
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Height Units: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            DropdownButton<String>(
                              dropdownColor: Colors.grey,
                              focusColor: Colors.grey,
                              value: heightunits.first,
                              items: heightunits.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: BaseThemeColors
                                            .detailContainerText),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) => {
                                savePreference('heightunit', value.toString())
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Weight Units: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            DropdownButton<String>(
                              dropdownColor: Colors.grey,
                              focusColor: Colors.grey,
                              value: weightunits.first,
                              items: weightunits.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: BaseThemeColors
                                            .detailContainerText),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) => {
                                savePreference('weightunit', value.toString())
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Storage',
                          style: TextStyle(
                              fontSize: 24,
                              color: BaseThemeColors.detailContainerText),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xffEF866B))),
                                child: const Text(
                                  'Clear Preferences',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                                onPressed: clearBookmarks,
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xffEF866B))),
                                child: const Text(
                                  'Clear Bookmarks',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                                onPressed: () => {
                                      DefaultCacheManager().emptyCache(),
                                      showMessage('Cache cleared successfully.')
                                    },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xffEF866B))),
                                child: const Text(
                                  'Clear Cache',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
