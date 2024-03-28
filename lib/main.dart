import 'package:flutter/material.dart';
import 'package:rotomdex/scanning/gallery.dart';
import 'dex/pokedex.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = '';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: appTitle),
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
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    PokedexPage(),
    Text(
      'Move Dex',
      style: optionStyle,
    ),
    Text(
      'Ability Dex',
      style: optionStyle,
    ),
    Text(
      'Item Dex',
      style: optionStyle,
    ),
    GalleryScreen(),
    Text(
      'Settings',
      style: optionStyle,
    ),
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
        title: Text(_pageName),
        backgroundColor: const Color(0xff6ae2f2),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff32A6B0),
            Color(0xff3DC8B6),
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
        backgroundColor: const Color(0xff6ae2f2),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffEF866B),
              ),
              child: Image(image: AssetImage('assets/images/rotomHQNoBG.png')),
            ),
            ListTile(
              title: const Text('Pokédex'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0, 'Pokédex');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Move Dex'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1, 'Move Dex');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Ability Dex'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2, 'Ability Dex');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item Dex'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3, 'Item Dex');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Scanner'),
              selected: _selectedIndex == 4,
              onTap: () {
                _onItemTapped(4, 'Scanner');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Settings'),
              selected: _selectedIndex == 4,
              onTap: () {
                _onItemTapped(5, 'Settings');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
