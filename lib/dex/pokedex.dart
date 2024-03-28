import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'pokemon.dart';

class PokedexPage extends StatefulWidget {
  const PokedexPage({super.key});

  @override
  PokedexPageState createState() => PokedexPageState();
}

class PokedexPageState extends State<PokedexPage>
    with SingleTickerProviderStateMixin {
  List _data = [];

  List<String> types = [
    'Normal',
    'Fighting',
    'Flying',
    'Poison',
    'Ground',
    'Rock',
    'Bug',
    'Ghost',
    'Steel',
    'Fire',
    'Water',
    'Grass',
    'Electric',
    'Psychic',
    'Ice',
    'Dragon',
    'Dark',
    'Fairy'
  ];

  List<String> egggroups = [
    'Monster',
    'Human-Like',
    'Field',
    'Water 1',
    'Water 2',
    'Water 3',
    'Bug',
    'Flying',
    'Mineral',
    'Fairy',
    'Grass',
    'Dragon',
    'Amorphous',
    'Undiscovered',
    'Ditto'
  ];

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: animationController);

    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/pokemon_expanded.json');
    setState(() {
      _data = json.decode(data);
    });
  }

  void searchPokemon(String input) {
    List filteredPokemon = _data
        .where((pokemon) => pokemon['name']
            .toString()
            .toLowerCase()
            .contains(input.toLowerCase()))
        .toList();
    setState(() {
      _data = filteredPokemon;
    });
  }

  void filterPokemon(String argument, String input) {
    if (argument == 'type') {
      List filteredPokemon = _data
          .where(
            (pokemon) =>
                pokemon['type1'].toLowerCase() == input.toLowerCase() ||
                pokemon['type2'].toLowerCase() == input.toLowerCase(),
          )
          .toList();
      setState(() {
        _data = filteredPokemon;
      });
    } else if (argument == 'egg_group') {
      List filteredPokemon = _data
          .where(
            (pokemon) =>
                pokemon['egg_group1'].toLowerCase() == input.toLowerCase() ||
                pokemon['egg_group2'].toLowerCase() == input.toLowerCase(),
          )
          .toList();
      setState(() {
        _data = filteredPokemon;
      });
    } else {
      List filteredPokemon = _data
          .where(
            (pokemon) =>
                pokemon[argument].toString().toLowerCase() ==
                input.toLowerCase(),
          )
          .toList();
      setState(() {
        _data = filteredPokemon;
      });
    }
  }

  void sortPokemon(String argument, String argumentType) {
    _data.sort((a, b) {
      if (argumentType == 'int') {
        return a[argument].compareTo(b[argument]);
      } else {
        return a[argument].toString().compareTo(b[argument].toString());
      }
    });

    setState(() {
      _data = _data.toList();
    });
  }

  void reversePokemon() {
    setState(() {
      _data = _data.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GridView.builder(
        itemCount: _data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          final item = _data[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokemonDetailScreen(pokemonData: item),
                ),
              );
            },
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(360),
                        color: Colors.teal,
                      ),
                      width: 75,
                      height: 75,
                      child: OverflowBox(
                        maxWidth: 90,
                        maxHeight: 90,
                        child: Image.network(
                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${item['id']}.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Text('#${item['id']} ${item['name']}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset('assets/images/icons/types/${item['type1']}.png',
                      width: 25, height: 25),
                  if (item['type2'] != null && item['type2'].isNotEmpty) ...[
                    const SizedBox(width: 5),
                    Image.asset(
                        'assets/images/icons/types/${item['type2']}.png',
                        width: 25,
                        height: 25),
                  ],
                ]),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionBubble(
        onPress: () => {
          animationController.isCompleted
              ? animationController.reverse()
              : animationController.forward(),
        },
        backGroundColor: const Color(0xffEF866B),
        animation: animation,
        iconColor: Colors.white,
        iconData: Icons.settings,
        items: <Bubble>[
          Bubble(
            title: "Search",
            iconColor: Colors.white,
            bubbleColor: const Color(0xffEF866B),
            icon: Icons.search,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Enter Name:',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    content: SearchBar(
                      onChanged: (value) => searchPokemon(value),
                    ),
                    backgroundColor: const Color(0xffEF866B),
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
              animationController.reverse();
            },
          ),
          Bubble(
            title: "Filter",
            iconColor: Colors.white,
            bubbleColor: const Color(0xffEF866B),
            icon: Icons.filter_alt,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xffEF866B),
                    title: const Text(
                      'Filter By:',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    content: SizedBox(
                      height: 100,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Type',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              DropdownButton<String>(
                                dropdownColor: Colors.white,
                                focusColor: Colors.white,
                                value: types.first,
                                items: types.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) => {
                                  filterPokemon('type', value!),
                                  Navigator.of(context).pop()
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Egg Group',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              DropdownButton<String>(
                                dropdownColor: Colors.white,
                                focusColor: Colors.white,
                                value: egggroups.first,
                                items: egggroups.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) => {
                                  filterPokemon('egg_group', value!),
                                  Navigator.of(context).pop()
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
              animationController.reverse();
            },
          ),
          Bubble(
            title: "Sort",
            iconColor: Colors.white,
            bubbleColor: const Color(0xffEF866B),
            icon: Icons.sort,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xffEF866B),
                    title: const Text(
                      'Sort By:',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            sortPokemon('id', 'int');
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Number',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            sortPokemon('name', 'string');
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Name',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              reversePokemon();
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Reverse',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
              animationController.reverse();
            },
          ),
          // Bubble(
          //   title: "Layout",
          //   iconColor: Colors.white,
          //   bubbleColor: const Color(0xffEF866B),
          //   icon: Icons.grid_3x3,
          //   titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          //   onPress: () {
          //     animationController.reverse();
          //   },
          // ),
          Bubble(
            title: "Reset",
            iconColor: Colors.white,
            bubbleColor: const Color(0xffEF866B),
            icon: Icons.backspace,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _loadJsonData();
              animationController.reverse();
            },
          ),
        ],
      ),
    );
  }
}
