import 'package:flutter/material.dart';
import 'package:rotomdex/shared/data/themes.dart';
import 'package:rotomdex/shared/screens/main_scaffold.dart';
import 'package:rotomdex/shared/services/theme_services.dart';
import 'package:themed/themed.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = '';

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Map<ThemeRef, Object> _savedTheme = BaseThemeColors.rotomTheme;
  final ThemeServices themeServices = ThemeServices();

  @override
  void initState() {
    super.initState();
    setTheme();
  }

  void setTheme() async {
    Map<ThemeRef, Object> theme = await themeServices.loadSavedTheme();
    setState(() {
      _savedTheme = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Themed(
      defaultTheme: _savedTheme,
      child: MaterialApp(
        title: MyApp.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              scrolledUnderElevation: 5,
              shadowColor: Colors.black,
              elevation: 5),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.white, // Change to your desired color
          ),
          // fontFamily: 'Raleway'
        ),
        home: const Main(),
      ),
    );
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavScaffold();
  }
}
