import 'package:flutter/material.dart';
import 'package:rotomdex/scanning/gallery.dart';
import 'package:rotomdex/screens/abilities.dart';
import 'package:rotomdex/screens/bookmarks.dart';
import 'package:rotomdex/screens/moves.dart';
import 'package:rotomdex/screens/settings.dart';
import 'package:rotomdex/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:themed/themed.dart';
import 'screens/pokedex.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = '';

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late Map<ThemeRef, Object> _savedTheme;

  @override
  void initState() {
    super.initState();
    _loadSavedTheme();
  }

  // Method to load the saved theme from shared preferences
  Future<void> _loadSavedTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTheme = prefs.getString('theme');

    switch (savedTheme) {
      case 'rotom':
        setState(() {
          _savedTheme = BaseThemeColors.rotomTheme;
        });
        break;
      case 'light':
        setState(() {
          _savedTheme = BaseThemeColors.lightTheme;
        });
        break;
      case 'dark':
        setState(() {
          _savedTheme = BaseThemeColors.darkTheme;
        });
        break;
      default:
        setState(() {
          _savedTheme = BaseThemeColors.rotomTheme;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Themed(
      defaultTheme: _savedTheme,
      child: MaterialApp(
        title: MyApp.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Raleway'),
        home: const MyHomePage(title: MyApp.appTitle),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String _pageName = 'Pokédex';
  static const List<Widget> _widgetOptions = <Widget>[
    PokedexPage(),
    MoveDexPage(),
    AbilityDexPage(),
    BookmarksPage(),
    GalleryScreen(),
    SettingsPage()
  ];

  void _onItemTapped(int index, String name) {
    setState(() {
      _selectedIndex = index;
      _pageName = name;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageName,
          style: const TextStyle(color: BaseThemeColors.mainAppBarText, fontFamily: 'Zekton', fontSize: 28),
        ),
        backgroundColor: BaseThemeColors.mainAppBarBG,
        iconTheme: const IconThemeData(color: BaseThemeColors.mainAppBarText),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            BaseThemeColors.dexBGGradientTop,
            BaseThemeColors.dexBGGradientBottom,
          ],
        )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: _widgetOptions[_selectedIndex],
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: BaseThemeColors.mainMenuListBG,
        child: Column(
          children: [
            SizedBox(
              height: 800,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: BaseThemeColors.mainMenuLogoBG,
                    ),
                    child: Image(
                        image: AssetImage('assets/images/rotomHQNoBG.png')),
                  ),
                  ListTile(
                    title: const Text(
                      'Pokédex',
                      style: TextStyle(color: BaseThemeColors.mainMenuListText, fontSize: 20),
                    ),
                    selected: _selectedIndex == 0,
                    onTap: () {
                      _onItemTapped(0, 'Pokédex');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Move Dex',
                      style: TextStyle(color: BaseThemeColors.mainMenuListText, fontSize: 20),
                    ),
                    selected: _selectedIndex == 1,
                    onTap: () {
                      _onItemTapped(1, 'Move Dex');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Ability Dex',
                      style: TextStyle(color: BaseThemeColors.mainMenuListText, fontSize: 20),
                    ),
                    selected: _selectedIndex == 2,
                    onTap: () {
                      _onItemTapped(2, 'Ability Dex');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Bookmarks',
                      style: TextStyle(color: BaseThemeColors.mainMenuListText, fontSize: 20),
                    ),
                    selected: _selectedIndex == 3,
                    onTap: () {
                      _onItemTapped(3, 'Bookmarks');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Scanner',
                      style: TextStyle(color: BaseThemeColors.mainMenuListText, fontSize: 20),
                    ),
                    selected: _selectedIndex == 4,
                    onTap: () {
                      _onItemTapped(4, 'Scanner');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Settings',
                      style: TextStyle(color: BaseThemeColors.mainMenuListText, fontSize: 20),
                    ),
                    selected: _selectedIndex == 5,
                    onTap: () {
                      _onItemTapped(5, 'Settings');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
