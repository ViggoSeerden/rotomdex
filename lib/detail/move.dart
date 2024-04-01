import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rotomdex/detail/pokemon.dart';

class MovePage extends StatefulWidget {
  final Map moveData;

  const MovePage({Key? key, required this.moveData}) : super(key: key);

  @override
  MovePageState createState() => MovePageState();
}

class MovePageState extends State<MovePage> {
  List levelUpPokemon = [];
  List tmPokemon = [];
  List eggPokemon = [];

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    List movesets = json.decode(await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/kanto_moves.json'));

    List pokemon = json.decode(await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/kanto_expanded.json'));

    List levelUp = [];
    List tm = [];
    List egg = [];

    String moveId = widget.moveData['move'];

    for (var moveset in movesets) {
      var pokemonId = moveset['pokemon_id'];

      // Check level up moves
      for (var move in moveset['level_up']) {
        if (move['move_name'] == moveId) {
          var pokemonData = pokemon.firstWhere((p) => p['id'] == pokemonId,
              orElse: () => null);
          if (pokemonData != null) {
            levelUp.add(pokemonData);
            break; // no need to keep checking level up moves for this Pokemon
          }
        }
      }

      // Check TM moves
      if (moveset['tm'].contains(moveId)) {
        var pokemonData =
            pokemon.firstWhere((p) => p['id'] == pokemonId, orElse: () => null);
        if (pokemonData != null) {
          tm.add(pokemonData);
        }
      }

      // Check Egg moves
      if (moveset['egg'].contains(moveId)) {
        var pokemonData =
            pokemon.firstWhere((p) => p['id'] == pokemonId, orElse: () => null);
        if (pokemonData != null) {
          egg.add(pokemonData);
        }
      }
    }

    print(levelUp);

    setState(() {
      levelUpPokemon = levelUp;
      tmPokemon = tm;
      eggPokemon = egg;
    });

    setState(() {
      levelUpPokemon = levelUp;
      tmPokemon = tm;
      eggPokemon = egg;
    });
  }

  void navigateToPokemonViaID(BuildContext context, int pokemonId) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/kanto_expanded.json');

    List<dynamic> pokemonList = jsonDecode(data);

    Map<String, dynamic>? specificPokemon = pokemonList.firstWhere(
      (pokemon) => pokemon['id'] == pokemonId,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.moveData['move'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff878787),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff64B6ED),
              Color(0xffB7FCFB),
            ],
          ),
        ),
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                height: 710,
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.moveData['description'],
                            style: const TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Type',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                Image.asset(
                                    'assets/images/icons/types/${widget.moveData['type']}.png')
                              ],
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Category',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                if (widget.moveData['category'].toString() !=
                                    '--') ...[
                                  Image.asset(
                                      'assets/images/icons/moves/${widget.moveData['category'].toString().toLowerCase()}_color.png')
                                ] else ...[
                                  const Text(
                                    'Varies',
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Power',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  widget.moveData['power'],
                                  style: const TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Accuracy',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  widget.moveData['accuracy'],
                                  style: const TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Column(
                              children: [
                                const Text(
                                  'PP',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  widget.moveData['pp'].toString(),
                                  style: const TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 350,
                          child: DefaultTabController(
                            length: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Scaffold(
                                backgroundColor: Colors.transparent,
                                appBar: AppBar(
                                  automaticallyImplyLeading: false,
                                  centerTitle: true,
                                  title: const Text(
                                    'Pokémon that can learn this move:',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  bottom: const TabBar(
                                      labelColor: Colors.black,
                                      indicatorColor: Color(0xffEF866B),
                                      dividerColor: Color(0xffEF866B),
                                      tabs: [
                                        Tab(text: 'Level Up'),
                                        Tab(text: 'TM Moves'),
                                        Tab(text: 'Egg Moves'),
                                      ]),
                                ),
                                body: TabBarView(children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: levelUpPokemon.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 20,
                                      ),
                                      itemBuilder: (context, index) {
                                        final item = levelUpPokemon[index];
                                        return GestureDetector(
                                          onTap: () => navigateToPokemonViaID(
                                              context, item['id']),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              360),
                                                      color: Colors.white,
                                                    ),
                                                    width: 75,
                                                    height: 75,
                                                    child: OverflowBox(
                                                      maxWidth: 85,
                                                      maxHeight: 85,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${item['id']}.png",
                                                        placeholder: (context,
                                                                url) =>
                                                            const CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                        fit: BoxFit.cover,
                                                        fadeInDuration:
                                                            Durations.short1,
                                                        cacheKey:
                                                            "pokemon_${item['id']}",
                                                        cacheManager:
                                                            CacheManager(
                                                          Config(
                                                            "pokemon_images_cache",
                                                            maxNrOfCacheObjects:
                                                                500,
                                                            stalePeriod:
                                                                const Duration(
                                                                    days: 7),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                  '#${item['id']} ${item['name']}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      'assets/images/icons/types/${item['type1']}.png',
                                                      width: 25,
                                                      height: 25),
                                                  if (item['type2'] != null &&
                                                      item['type2']
                                                          .isNotEmpty) ...[
                                                    const SizedBox(width: 5),
                                                    Image.asset(
                                                        'assets/images/icons/types/${item['type2']}.png',
                                                        width: 25,
                                                        height: 25),
                                                  ],
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: tmPokemon.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 20,
                                      ),
                                      itemBuilder: (context, index) {
                                        final item = tmPokemon[index];
                                        return GestureDetector(
                                          onTap: () => navigateToPokemonViaID(
                                              context, item['id']),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              360),
                                                      color: Colors.white,
                                                    ),
                                                    width: 75,
                                                    height: 75,
                                                    child: OverflowBox(
                                                      maxWidth: 85,
                                                      maxHeight: 85,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${item['id']}.png",
                                                        placeholder: (context,
                                                                url) =>
                                                            const CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                        fit: BoxFit.cover,
                                                        fadeInDuration:
                                                            Durations.short1,
                                                        cacheKey:
                                                            "pokemon_${item['id']}",
                                                        cacheManager:
                                                            CacheManager(
                                                          Config(
                                                            "pokemon_images_cache",
                                                            maxNrOfCacheObjects:
                                                                500,
                                                            stalePeriod:
                                                                const Duration(
                                                                    days: 7),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                  '#${item['id']} ${item['name']}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      'assets/images/icons/types/${item['type1']}.png',
                                                      width: 25,
                                                      height: 25),
                                                  if (item['type2'] != null &&
                                                      item['type2']
                                                          .isNotEmpty) ...[
                                                    const SizedBox(width: 5),
                                                    Image.asset(
                                                        'assets/images/icons/types/${item['type2']}.png',
                                                        width: 25,
                                                        height: 25),
                                                  ],
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: eggPokemon.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 20,
                                      ),
                                      itemBuilder: (context, index) {
                                        final item = eggPokemon[index];
                                        return GestureDetector(
                                          onTap: () => navigateToPokemonViaID(
                                              context, item['id']),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              360),
                                                      color: Colors.white,
                                                    ),
                                                    width: 75,
                                                    height: 75,
                                                    child: OverflowBox(
                                                      maxWidth: 85,
                                                      maxHeight: 85,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${item['id']}.png",
                                                        placeholder: (context,
                                                                url) =>
                                                            const CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                        fit: BoxFit.cover,
                                                        fadeInDuration:
                                                            Durations.short1,
                                                        cacheKey:
                                                            "pokemon_${item['id']}",
                                                        cacheManager:
                                                            CacheManager(
                                                          Config(
                                                            "pokemon_images_cache",
                                                            maxNrOfCacheObjects:
                                                                500,
                                                            stalePeriod:
                                                                const Duration(
                                                                    days: 7),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                  '#${item['id']} ${item['name']}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      'assets/images/icons/types/${item['type1']}.png',
                                                      width: 25,
                                                      height: 25),
                                                  if (item['type2'] != null &&
                                                      item['type2']
                                                          .isNotEmpty) ...[
                                                    const SizedBox(width: 5),
                                                    Image.asset(
                                                        'assets/images/icons/types/${item['type2']}.png',
                                                        width: 25,
                                                        height: 25),
                                                  ],
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
