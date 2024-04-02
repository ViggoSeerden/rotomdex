import 'package:flutter/material.dart';
import 'package:rotomdex/scanning/gallery.dart';
import 'package:rotomdex/screens/abilities.dart';
import 'package:rotomdex/screens/moves.dart';
import 'package:rotomdex/screens/settings.dart';
import 'package:rotomdex/themes/themes.dart';
import 'package:themed/themed.dart';
import 'screens/pokedex.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = '';

  @override
  Widget build(BuildContext context) {
    return Themed(
      defaultTheme: BaseThemeColors.rotomTheme,
      child: const MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: appTitle),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageName, style: const TextStyle(color: BaseThemeColors.mainAppBarText),),
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: BaseThemeColors.mainMenuLogoBG,
              ),
              child: Image(image: AssetImage('assets/images/rotomHQNoBG.png')),
            ),
            ListTile(
              title: const Text('Pokédex', style: TextStyle(color: BaseThemeColors.mainMenuListText),),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0, 'Pokédex');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Move Dex', style: TextStyle(color: BaseThemeColors.mainMenuListText),),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1, 'Move Dex');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Ability Dex', style: TextStyle(color: BaseThemeColors.mainMenuListText),),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2, 'Ability Dex');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Scanner', style: TextStyle(color: BaseThemeColors.mainMenuListText),),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3, 'Scanner');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Settings', style: TextStyle(color: BaseThemeColors.mainMenuListText),),
              selected: _selectedIndex == 4,
              onTap: () {
                _onItemTapped(4, 'Settings');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}