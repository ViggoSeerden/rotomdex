import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rotomdex/detail/ability.dart';
import 'package:rotomdex/detail/move.dart';
import 'package:rotomdex/detail/pokemon.dart';
import 'package:rotomdex/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageStateState();
}

class _BookmarksPageStateState extends State<BookmarksPage> {
  late List pokemonBookmarks;
  late List moveBookmarks;
  late List abilityBookmarks;

  @override
  void initState() {
    super.initState();
    getBookmarks();
  }

  Future<void> getBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? pokemon = prefs.getStringList('pokemon_bookmarks') ?? [];
    List<String>? moves = prefs.getStringList('move_bookmarks') ?? [];
    List<String>? abilities = prefs.getStringList('ability_bookmarks') ?? [];

    List pokemonData = [];
    List moveData = [];
    List abilityData = [];

    // ignore: use_build_context_synchronously
    List pdata = json.decode(await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/kanto_expanded.json'));
    // ignore: use_build_context_synchronously
    List mdata = json.decode(await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/moves.json'));
    // ignore: use_build_context_synchronously
    List adata = json.decode(await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/abilities.json'));

    for (var pokemon in pokemon) {
      Map<String, dynamic>? specificPokemon = pdata.firstWhere(
        (curpokemon) =>
            curpokemon['name'].toLowerCase() == pokemon.toLowerCase(),
        orElse: () => null,
      );

      if (specificPokemon != null) {
        pokemonData.add(specificPokemon);
      }
    }

    for (var move in moves) {
      Map<String, dynamic>? specificMove = mdata.firstWhere(
        (curmove) => curmove['move'] == move,
        orElse: () => null,
      );

      if (specificMove != null) {
        moveData.add(specificMove);
      }
    }

    for (var ability in abilities) {
      Map<String, dynamic>? specificAbility = adata.firstWhere(
        (curability) => curability['name'] == ability,
        orElse: () => null,
      );

      if (specificAbility != null) {
        abilityData.add(specificAbility);
      }
    }

    setState(() {
      pokemonBookmarks = pokemonData;
      moveBookmarks = moveData;
      abilityBookmarks = abilityData;
    });
  }

  void navigateToPokemon(BuildContext context, String pokemonName) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/kanto_expanded.json');

    List<dynamic> pokemonList = json.decode(data);

    Map<String, dynamic>? specificPokemon = pokemonList.firstWhere(
      (pokemon) =>
          pokemon['name'].toString().toLowerCase() == pokemonName.toLowerCase(),
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

  void navigateToMove(BuildContext context, String moveName) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/moves.json');

    List<dynamic> movesList = jsonDecode(data);

    Map<String, dynamic>? move = movesList.firstWhere(
      (move) => move['move'] == moveName,
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
  }

  void navigateToAbility(BuildContext context, String abilityName) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/abilities.json');

    List<dynamic> abilityList = jsonDecode(data);

    Map<String, dynamic>? ability = abilityList.firstWhere(
      (ability) => ability['name'] == abilityName,
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
  }

  void removeFromBookmarks(String type, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (type) {
      case 'pokemon':
        List<String>? pokemon = prefs.getStringList('pokemon_bookmarks') ?? [];
        pokemon.remove(value);
        await prefs.setStringList('pokemon_bookmarks', pokemon);
        break;
      case 'move':
        List<String>? moves = prefs.getStringList('move_bookmarks') ?? [];
        moves.remove(value);
        await prefs.setStringList('move_bookmarks', moves);
        break;
      case 'ability':
        List<String>? abilities =
            prefs.getStringList('ability_bookmarks') ?? [];
        abilities.remove(value);
        await prefs.setStringList('ability_bookmarks', abilities);
        break;
      default:
        break;
    }

    getBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          BaseThemeColors.detailContainerGradientTop,
                          BaseThemeColors.detailContainerGradientBottom,
                        ],
                      ),
                    ),
                    child: Center(
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
                                  'Bookmarks',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color:
                                          BaseThemeColors.detailContainerText),
                                ),
                                backgroundColor: Colors.transparent,
                                bottom: const TabBar(
                                    labelColor:
                                        BaseThemeColors.detailContainerText,
                                    indicatorColor: Color(0xffEF866B),
                                    dividerColor: Color(0xffEF866B),
                                    tabs: [
                                      Tab(text: 'Pokémon'),
                                      Tab(text: 'Moves'),
                                      Tab(text: 'Abilities'),
                                    ]),
                              ),
                              body: TabBarView(children: [
                                GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 20,
                                  ),
                                  itemCount: pokemonBookmarks.length,
                                  itemBuilder: (context, index) {
                                    final item = pokemonBookmarks[index];
                                    return GestureDetector(
                                      onTap: () => navigateToPokemon(
                                          context, item['name']),
                                      onLongPress: () => removeFromBookmarks(
                                          'pokemon', item['name']),
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
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    fadeInDuration:
                                                        Durations.short1,
                                                    cacheKey:
                                                        "pokemon_${item['id']}",
                                                    cacheManager: CacheManager(
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
                                          Text('#${item['id']} ${item['name']}',
                                              style: const TextStyle(
                                                  color: BaseThemeColors
                                                      .detailContainerText,
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                  'assets/images/icons/types/${item['type1']}.png',
                                                  width: 25,
                                                  height: 25),
                                              if (item['type2'] != null &&
                                                  item['type2'].isNotEmpty) ...[
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
                                ListView.separated(
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 10);
                                  },
                                  itemCount: moveBookmarks.length,
                                  itemBuilder: (context, index) {
                                    var move = moveBookmarks[index];
                                    return GestureDetector(
                                      onTap: () => navigateToMove(
                                          context, move['move']),
                                      onLongPress: () => removeFromBookmarks(
                                          'move', move['move']),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: BaseThemeColors.dexItemBG,
                                        ),
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(children: [
                                          Image.asset(
                                            'assets/images/icons/types/${move['type']}.png',
                                            width: 35,
                                            height: 35,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: 110,
                                            child: Text(
                                              move['move'],
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: BaseThemeColors
                                                      .dexItemText),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Power: ${move['power']}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: BaseThemeColors
                                                        .dexItemAccentText),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                'Accuracy: ${move['accuracy']}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: BaseThemeColors
                                                        .dexItemAccentText),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                'PP: ${move['pp']}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: BaseThemeColors
                                                        .dexItemAccentText),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          )),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          if (move['category'].toString() !=
                                              '--') ...[
                                            Image.asset(
                                              'assets/images/icons/moves/${move['category'].toString().toLowerCase()}_color.png',
                                              width: 35,
                                              height: 35,
                                            ),
                                          ]
                                        ]),
                                      ),
                                    );
                                  },
                                ),
                                ListView.separated(
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 10);
                                  },
                                  itemCount: abilityBookmarks.length,
                                  itemBuilder: (context, index) {
                                    var ability = abilityBookmarks[index];
                                    return GestureDetector(
                                      onTap: () => navigateToAbility(
                                          context, ability['name']),
                                      onLongPress: () => removeFromBookmarks(
                                          'ability', ability['name']),
                                      child: Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            color: BaseThemeColors.dexItemBG,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ability['name'],
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: BaseThemeColors
                                                        .dexItemText),
                                              ),
                                              Text(
                                                ability['description'],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: BaseThemeColors
                                                        .dexItemAccentText),
                                              )
                                            ],
                                          )),
                                    );
                                  },
                                ),
                              ]),
                            ),
                          )),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
