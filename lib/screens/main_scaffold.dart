import 'package:flutter/material.dart';
import 'package:rotomdex/screens/scanner.dart';
import 'package:rotomdex/screens/abilities.dart';
import 'package:rotomdex/screens/bookmarks.dart';
import 'package:rotomdex/screens/moves.dart';
import 'package:rotomdex/screens/pokedex.dart';
import 'package:rotomdex/screens/settings.dart';
import 'package:rotomdex/utils/themes.dart';

class NavScaffold extends StatefulWidget {
  const NavScaffold({super.key});

  @override
  State<NavScaffold> createState() => _NavScaffoldState();
}

class _NavScaffoldState extends State<NavScaffold> {
  int _selectedIndex = 0;
  String _pageName = 'Pokédex';
  static const List<Widget> _widgetOptions = <Widget>[
    PokedexPage(),
    MoveDexPage(),
    AbilityDexPage(),
    BookmarksPage(),
    ScannerScreen(),
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
          style: const TextStyle(
              color: BaseThemeColors.mainAppBarText,
              // fontFamily: 'Zekton',
              fontSize: 28),
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
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        backgroundColor: BaseThemeColors.mainMenuListBG,
        child: Column(
          children: [
            Expanded(
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
                      style: TextStyle(
                          color: BaseThemeColors.mainMenuListText,
                          fontSize: 20),
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
                      style: TextStyle(
                          color: BaseThemeColors.mainMenuListText,
                          fontSize: 20),
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
                      style: TextStyle(
                          color: BaseThemeColors.mainMenuListText,
                          fontSize: 20),
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
                      style: TextStyle(
                          color: BaseThemeColors.mainMenuListText,
                          fontSize: 20),
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
                      style: TextStyle(
                          color: BaseThemeColors.mainMenuListText,
                          fontSize: 20),
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
                      style: TextStyle(
                          color: BaseThemeColors.mainMenuListText,
                          fontSize: 20),
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
