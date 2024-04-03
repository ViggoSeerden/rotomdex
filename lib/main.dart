import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rotomdex/detail/ability.dart';
import 'package:rotomdex/detail/move.dart';
import 'package:rotomdex/detail/pokemon.dart';
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
      child: const MaterialApp(
        title: MyApp.appTitle,
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: MyApp.appTitle),
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

  List<String>? lastItem = [];

  void _onItemTapped(int index, String name) {
    setState(() {
      _selectedIndex = index;
      _pageName = name;
    });
  }

  @override
  void initState() {
    super.initState();
    loadLastItem();
  }

  void loadLastItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lastItem = prefs.getStringList('lastItem');
    });
  }

  void navigateToLastItem(
      BuildContext context, String itemName, String type) async {
    switch (type) {
      case 'Pokémon':
        String data = await DefaultAssetBundle.of(context)
            .loadString('assets/pokemon/data/kanto_expanded.json');

        List<dynamic> pokemonList = json.decode(data);

        Map<String, dynamic>? specificPokemon = pokemonList.firstWhere(
          (pokemon) =>
              pokemon['name'].toString().toLowerCase() ==
              itemName.toLowerCase(),
          orElse: () => null,
        );

        if (specificPokemon != null) {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PokemonDetailScreen(pokemonData: specificPokemon),
            ),
          );
        }
        break;
      case 'Move':
        String data = await DefaultAssetBundle.of(context)
            .loadString('assets/pokemon/data/moves.json');

        List<dynamic> movesList = jsonDecode(data);

        Map<String, dynamic>? move = movesList.firstWhere(
          (move) => move['move'] == itemName,
          orElse: () => null,
        );

        if (move != null) {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovePage(moveData: move),
            ),
          );
        }
        break;
      case 'Ability':
        String data = await DefaultAssetBundle.of(context)
            .loadString('assets/pokemon/data/abilities.json');

        List<dynamic> abilityList = jsonDecode(data);

        Map<String, dynamic>? ability = abilityList.firstWhere(
          (ability) => ability['name'] == itemName,
          orElse: () => null,
        );

        if (ability != null) {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AbilityPage(abilityData: ability),
            ),
          );
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageName,
          style: const TextStyle(color: BaseThemeColors.mainAppBarText),
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
                      style: TextStyle(color: BaseThemeColors.mainMenuListText),
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
                      style: TextStyle(color: BaseThemeColors.mainMenuListText),
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
                      style: TextStyle(color: BaseThemeColors.mainMenuListText),
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
                      style: TextStyle(color: BaseThemeColors.mainMenuListText),
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
                      style: TextStyle(color: BaseThemeColors.mainMenuListText),
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
                      style: TextStyle(color: BaseThemeColors.mainMenuListText),
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
            // if (lastItem!.isNotEmpty) ...[
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Column(
            //         children: [
            //           const Text(
            //             'Last Viewed:',
            //             style: TextStyle(
            //                 fontSize: 20,
            //                 color: BaseThemeColors.mainMenuListText),
            //             textAlign: TextAlign.left,
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: GestureDetector(
            //               onTap: () => navigateToLastItem(context, lastItem![1], lastItem![0]),
            //               child: Container(
            //                 decoration: const BoxDecoration(
            //                     borderRadius: BorderRadius.all(Radius.circular(20)),
            //                     color: BaseThemeColors.dexItemBG),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(8),
            //                   child: Text(
            //                     '${lastItem![0]}: ${lastItem![1]}',
            //                     style: const TextStyle(
            //                         fontSize: 16,
            //                         color: BaseThemeColors.dexItemText),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ]
          ],
        ),
      ),
    );
  }
}
