import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rotomdex/themes/themes.dart';
import 'package:themed/themed.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  List<String> themes = ['Rotom', 'Light', 'Dark'];

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
                        TextButton(
                            onPressed: () => DefaultCacheManager().emptyCache(),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xffEF866B))),
                            child: const Text(
                              'Clear Cache',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                            const SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Theme: ', style: TextStyle(fontSize: 18, color: BaseThemeColors.detailContainerText),),
                                DropdownButton<String>(
                                    dropdownColor: Colors.grey,
                                    focusColor: Colors.grey,
                                    value: themes.first,
                                    items: themes.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value, style: const TextStyle(color: BaseThemeColors.detailContainerText),),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) => {
                                      setTheme(value.toString().toLowerCase())
                                    },
                                  ),
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
