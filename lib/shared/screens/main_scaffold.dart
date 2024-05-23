import 'package:flutter/material.dart';
import 'package:rotomdex/dex/screens/collection.dart';
import 'package:rotomdex/scanner/screens/scanner.dart';
import 'package:rotomdex/dex/screens/abilities.dart';
import 'package:rotomdex/dex/screens/bookmarks.dart';
import 'package:rotomdex/dex/screens/moves.dart';
import 'package:rotomdex/dex/screens/pokedex.dart';
import 'package:rotomdex/shared/screens/about.dart';
import 'package:rotomdex/shared/screens/settings.dart';
import 'package:rotomdex/shared/data/themes.dart';
import 'package:rotomdex/shared/screens/theme_shop.dart';
import 'package:rotomdex/team_builder/screens/teams.dart';
import 'package:rotomdex/whos_that_pokemon/screens/title.dart';

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
    CollectionScreen(),
    ScannerScreen(),
    TeamBuilderScreen(),
    GameTitleScreen(),
    ThemeShopScreen(),
    AboutScreen(),
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
                      'Collection',
                      style: TextStyle(
                          color: BaseThemeColors.mainMenuListText,
                          fontSize: 20),
                    ),
                    selected: _selectedIndex == 4,
                    onTap: () {
                      _onItemTapped(4, 'Collection');
                      Navigator.pop(context);
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(color: BaseThemeColors.mainMenuListText,),
                  ),
                  ListTile(
                    title: const Text(
                      'Scanner',
                      style: TextStyle(
                          color: BaseThemeColors.mainMenuListText,
                          fontSize: 20),
                    ),
                    selected: _selectedIndex == 5,
                    onTap: () {
                      _onItemTapped(5, 'Scanner');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Team Builder',
                      style: TextStyle(
                          color: BaseThemeColors.mainMenuListText,
                          fontSize: 20),
                    ),
                    selected: _selectedIndex == 6,
                    onTap: () {
                      _onItemTapped(6, 'Team Builder');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text(
                      "Who's That Pokémon?",
                      style: TextStyle(
                          color: BaseThemeColors.mainMenuListText,
                          fontSize: 20),
                    ),
                    selected: _selectedIndex == 7,
                    onTap: () {
                      _onItemTapped(7, "Who's That Pokémon?");
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text(
                      "Theme Shop",
                      style: TextStyle(
                          color: BaseThemeColors.mainMenuListText,
                          fontSize: 20),
                    ),
                    selected: _selectedIndex == 8,
                    onTap: () {
                      _onItemTapped(8, "Theme Shop");
                      Navigator.pop(context);
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(),
                  ),
                  ListTile(
                    title: const Text(
                      "About",
                      style: TextStyle(
                          color: BaseThemeColors.mainMenuListText,
                          fontSize: 20),
                    ),
                    selected: _selectedIndex == 9,
                    onTap: () {
                      _onItemTapped(9, "About");
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text(
                      "Settings",
                      style: TextStyle(
                          color: BaseThemeColors.mainMenuListText,
                          fontSize: 20),
                    ),
                    selected: _selectedIndex == 10,
                    onTap: () {
                      _onItemTapped(10, "Settings");
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
