import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rotomdex/shared/services/message_services.dart';
import 'package:rotomdex/shared/services/preference_services.dart';
import 'package:rotomdex/shared/services/theme_services.dart';
import 'package:rotomdex/shared/data/themes.dart';
import 'package:rotomdex/shared/data/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  PreferenceServices preferenceServices = PreferenceServices();
  ThemeServices themeServices = ThemeServices();
  MessageServices messageServices = MessageServices();

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
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(125, 0, 0, 0),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
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
                              onChanged: (String? value) => {
                                themeServices
                                    .setTheme(value.toString().toLowerCase())
                              },
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
                                preferenceServices.savePreference(
                                    'heightunit', value.toString())
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
                                preferenceServices.savePreference(
                                    'weightunit', value.toString())
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
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffEF866B),
                                    elevation: 5.0),
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
                            ElevatedButton(
                                onPressed: preferenceServices.clearBookmarks,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffEF866B),
                                    elevation: 5.0),
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
                            ElevatedButton(
                                onPressed: () => {
                                      DefaultCacheManager().emptyCache(),
                                      messageServices.showMessage(
                                          'Cache cleared successfully.',
                                          context)
                                    },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffEF866B),
                                    elevation: 5.0),
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
