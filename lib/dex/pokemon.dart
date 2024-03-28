import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:audioplayers/audioplayers.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Map pokemonData;

  const PokemonDetailScreen({Key? key, required this.pokemonData})
      : super(key: key);

  @override
  PokemonDetailScreenState createState() => PokemonDetailScreenState();
}

class PokemonDetailScreenState extends State<PokemonDetailScreen> {
  int _selectedIndex = 0;
  late String modelPath;
  late String imageUrl;
  late bool shiny;

  @override
  void initState() {
    super.initState();
    shiny = false;
    imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemonData['id']}.png';
    modelPath =
        'assets/pokemon/models/${widget.pokemonData['id'].toString()}.glb';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void navigateToPokemon(BuildContext context, String pokemonName) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/pokemon_expanded.json');

    List<dynamic> pokemonList = jsonDecode(data);

    Map<String, dynamic>? specificPokemon = pokemonList.firstWhere(
      (pokemon) =>
          pokemon['name'].toString().toLowerCase() == pokemonName.toLowerCase(),
      orElse: () => null,
    );

    if (specificPokemon != null) {
      if (specificPokemon['name'] != widget.pokemonData['name']) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PokemonDetailScreen(pokemonData: specificPokemon),
          ),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'There is no data on $pokemonName in this app.',
              textAlign: TextAlign.center,
            ),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    void playSound() {
      AudioPlayer player = AudioPlayer();
      player.play(UrlSource(
          "https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/${widget.pokemonData['id']}.ogg"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '#${widget.pokemonData['id'].toString()} ${widget.pokemonData['name']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff878787),
        actions: [
          IconButton(onPressed: playSound, icon: const Icon(Icons.volume_up))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff64B6ED),
            Color(0xffB7FCFB),
          ],
        )),
        padding: EdgeInsets.zero,
        child: _buildBody(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffACACAC),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.waving_hand_outlined),
            label: 'Moves',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.threed_rotation),
            label: 'Model',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildInfoTab();
      case 1:
        return _buildMovesTab();
      case 2:
        return _buildDetailsTab();
      case 3:
        return _buildARTab();
      default:
        return Container();
    }
  }

  Widget _buildInfoTab() {
    List<Widget> statWidgets = [];
    int bst = 0;

    for (var entry in widget.pokemonData['base_stats'].entries) {
      String statName = entry.key;
      int statValue = entry.value;

      bst += statValue;

      Widget statRow = Padding(
        padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  statName,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: Text(
                  statValue.toString(),
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      );

      statWidgets.add(statRow);
    }

    void toggleShiny() {
      setState(() {
        if (shiny) {
          imageUrl =
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemonData['id']}.png';
        } else {
          imageUrl =
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/${widget.pokemonData['id']}.png';
        }
        shiny = !shiny;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Center(
          child: GestureDetector(
            onTap: toggleShiny,
            child: Image.network(
              imageUrl,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 50),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffFFFFFF),
                    Color(0xffC6C6C6),
                  ],
                ),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50))),
            width: 10000,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    '${widget.pokemonData['category']} Pokémon',
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Text(
                      '${widget.pokemonData['pokedex_entry']}',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Image.asset(
                        'assets/images/icons/types/${widget.pokemonData['type1']}.png'),
                    if (widget.pokemonData['type2'] != null &&
                        widget.pokemonData['type2'].isNotEmpty) ...[
                      const SizedBox(width: 20),
                      Image.asset(
                          'assets/images/icons/types/${widget.pokemonData['type2']}.png'),
                    ],
                  ]),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.pokemonData['height']['meters']}',
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '${widget.pokemonData['weight']['kilograms']}',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text('Abilities', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xffEF866B))),
                        child: Text(
                          widget.pokemonData['ability1'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                      if (widget.pokemonData['ability2'] != null &&
                          widget.pokemonData['ability2'].isNotEmpty) ...[
                        TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xffEF866B))),
                            child: Text(widget.pokemonData['ability2'],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20))),
                      ],
                      if (widget.pokemonData['hidden_ability'] != null &&
                          widget.pokemonData['hidden_ability'].isNotEmpty) ...[
                        TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xffEF866B))),
                            child: Text(
                                '${widget.pokemonData['hidden_ability']} (Hidden)',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20))),
                      ],
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text('Base Stats', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 10),
                  Column(children: statWidgets),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                        child: Column(
                          children: [
                            const Divider(
                              color: Colors.black,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(
                                    child: Text(
                                  'Total',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 20),
                                )),
                                Expanded(
                                    child: Text(
                                  bst.toString(),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(fontSize: 20),
                                ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text('Evolution Chain:', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      if ((widget.pokemonData['evolution_family'] as List)
                          .isNotEmpty) ...[
                        for (var evo
                            in widget.pokemonData['evolution_family']) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => navigateToPokemon(
                                    context, evo['from_name']),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(360),
                                        color: Colors.white,
                                      ),
                                      width: 75,
                                      height: 75,
                                      child: OverflowBox(
                                        maxWidth: 85,
                                        maxHeight: 85,
                                        child: Image.network(
                                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${evo['from_id']}.png',
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Text(
                                        '#${evo['from_id']} ${evo['from_name']}')
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                children: [
                                  const Icon(Icons.arrow_right_alt),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      evo['method'],
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.center,
                                      maxLines:
                                          4,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () =>
                                    navigateToPokemon(context, evo['to_name']),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(360),
                                        color: Colors.white,
                                      ),
                                      width: 75,
                                      height: 75,
                                      child: OverflowBox(
                                        maxWidth: 85,
                                        maxHeight: 85,
                                        child: Image.network(
                                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${evo['to_id']}.png',
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Text('#${evo['to_id']} ${evo['to_name']}')
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ]
                      ] else ...[
                        const Text(
                          'This Pokémon has no evolution chain.',
                          style: TextStyle(fontSize: 18),
                        )
                      ]
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovesTab() {
    return const Center(
      child: Text('Moves Tab'),
    );
  }

  Widget _buildDetailsTab() {
    List<Widget> statWidgets = [];

    for (var entry in widget.pokemonData['ev_yield'].entries) {
      String statName = entry.key;
      int statValue = entry.value;

      if (statValue > 0) {
        Widget statRow = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${statValue.toString()} $statName',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.start,
            ),
          ],
        );

        statWidgets.add(statRow);
      }
    }

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: 10000,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xffFFFFFF),
                      Color(0xffC6C6C6),
                    ],
                  ),
                ),
                child: Center(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      const Text('Weaknesses', style: TextStyle(fontSize: 24)),
                      const SizedBox(height: 10),
                      Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            if ((widget.pokemonData['weaknesses'] as List)
                                .isNotEmpty) ...[
                              for (var type
                                  in widget.pokemonData['weaknesses']) ...[
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.asset(
                                      'assets/images/icons/types/$type.png'),
                                ),
                              ]
                            ] else ...[
                              const Text('This Pokémon has no weaknesses.')
                            ],
                          ]),
                      const SizedBox(height: 30),
                      const Text('Resistances', style: TextStyle(fontSize: 24)),
                      const SizedBox(height: 10),
                      Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            if ((widget.pokemonData['resistances'] as List)
                                .isNotEmpty) ...[
                              for (var type
                                  in widget.pokemonData['resistances']) ...[
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.asset(
                                      'assets/images/icons/types/$type.png'),
                                ),
                              ]
                            ] else ...[
                              const Text('This Pokémon has no resistances.')
                            ],
                          ]),
                      const SizedBox(height: 30),
                      const Text('Immunities', style: TextStyle(fontSize: 24)),
                      const SizedBox(height: 10),
                      Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            if ((widget.pokemonData['zero_effect_types']
                                    as List)
                                .isNotEmpty) ...[
                              for (var type in widget
                                  .pokemonData['zero_effect_types']) ...[
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.asset(
                                      'assets/images/icons/types/$type.png'),
                                ),
                              ]
                            ] else ...[
                              const Text(
                                'This Pokémon has no immunities.',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ]),
                      const SizedBox(height: 30),
                      const Text('Breeding', style: TextStyle(fontSize: 24)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(children: [
                            const Text(
                              'Egg Group(s):',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(widget.pokemonData['egg_group1'],
                                style: const TextStyle(fontSize: 16)),
                            if (widget.pokemonData['egg_group2'] != null &&
                                widget
                                    .pokemonData['egg_group2'].isNotEmpty) ...[
                              Text(widget.pokemonData['egg_group2'],
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ]),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(children: [
                            const Text(
                              'Egg Cycles:',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text('${widget.pokemonData['egg_cycles'].toString()} cycles',
                                style: const TextStyle(fontSize: 16)),
                            Text(
                                '${widget.pokemonData['steps_to_hatch'].toString()} steps',
                                style: const TextStyle(fontSize: 16)),
                          ]),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(children: [
                            const Text(
                              'Gender Ratio:',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                                '${widget.pokemonData['gender_ratio']['male']} male',
                                style: const TextStyle(fontSize: 16)),
                            Text(
                                '${widget.pokemonData['gender_ratio']['male']} female',
                                style: const TextStyle(fontSize: 16)),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text('Experience', style: TextStyle(fontSize: 24)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(children: [
                            const Text(
                              'Base EXP Yield:',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                                '${widget.pokemonData['base_experience_yield']} EXP',
                                style: const TextStyle(fontSize: 16)),
                          ]),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(children: [
                            const Text(
                              'EXP Growth Rate:',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                                widget.pokemonData['exp_growth_rate']
                                    .toString(),
                                style: const TextStyle(fontSize: 16)),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text('Miscellaneous',
                          style: TextStyle(fontSize: 24)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(children: [
                            const Text(
                              'Catch Rate:',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(widget.pokemonData['catch_rate'].toString(),
                                style: const TextStyle(fontSize: 16)),
                          ]),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(children: [
                            const Text(
                              'Base Happiness:',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                                widget.pokemonData['base_happiness'].toString(),
                                style: const TextStyle(fontSize: 16)),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          const Text('EV Yield:',
                              style: TextStyle(fontSize: 18)),
                          Column(children: statWidgets)
                        ],
                      ),
                      const SizedBox(height: 30)
                    ],
                  ),
                )),
              ),
            ),
          ),
          const SizedBox(height: 30)
        ],
      ),
    );
  }

  Widget _buildARTab() {
    return Center(
      child: ModelViewer(src: modelPath, ar: true),
    );
  }
}