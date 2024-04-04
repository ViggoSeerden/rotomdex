import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rotomdex/detail/pokemon.dart';
import 'package:rotomdex/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbilityPage extends StatefulWidget {
  final Map abilityData;

  const AbilityPage({Key? key, required this.abilityData}) : super(key: key);

  @override
  AbilityPageState createState() => AbilityPageState();
}

class AbilityPageState extends State<AbilityPage> {
  List pokemon = [];

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/kanto_expanded.json');

    List pokemonData = json.decode(data);

    List filteredPokemon = pokemonData
        .where(
          (pokemon) =>
              pokemon['ability1'].toLowerCase() ==
                  widget.abilityData['name'].toLowerCase() ||
              pokemon['ability2'].toLowerCase() ==
                  widget.abilityData['name'].toLowerCase() ||
              pokemon['hidden_ability'].toLowerCase() ==
                  widget.abilityData['name'].toLowerCase(),
        )
        .toList();

    setState(() {
      pokemon = filteredPokemon;
    });
  }

  void navigateToPokemonViaID(BuildContext context, int pokemonId) async {
    Map<String, dynamic>? specificPokemon = pokemon.firstWhere(
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

  Future<void> saveBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarks = prefs.getStringList('ability_bookmarks') ?? [];
    if (bookmarks.length >= 15) {
      showMessage('You have reached the maximum amount of ability bookmarks.');
    } else if (!bookmarks.contains(widget.abilityData['name'])) {
      bookmarks.add('${widget.abilityData['name']}');
      await prefs.setStringList('ability_bookmarks', bookmarks);
      showMessage('${widget.abilityData['name']} was added to your bookmarks.');
    } else {
      showMessage('${widget.abilityData['name']} is already bookmarked.');
    }
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            message,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.abilityData['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: BaseThemeColors.detailAppBarText),
        centerTitle: true,
        foregroundColor: BaseThemeColors.detailAppBarText,
        backgroundColor: BaseThemeColors.detailAppBarBG,
        actions: [
          IconButton(onPressed: saveBookmark, icon: const Icon(Icons.bookmark)),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              BaseThemeColors.detailBGGradientTop,
              BaseThemeColors.detailBGGradientBottom,
            ],
          ),
        ),
        padding: EdgeInsets.zero,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Padding(
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
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.abilityData['description'],
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: BaseThemeColors.detailContainerText),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Pokémon that can have this ability:',
                            style: TextStyle(
                                fontSize: 24,
                                color: BaseThemeColors.detailContainerText),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 500,
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: pokemon.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 20,
                              ),
                              itemBuilder: (context, index) {
                                final item = pokemon[index];
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
                                                  BorderRadius.circular(360),
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
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                fit: BoxFit.cover,
                                                fadeInDuration:
                                                    Durations.short1,
                                                cacheKey:
                                                    "pokemon_${item['id']}",
                                                cacheManager: CacheManager(
                                                  Config(
                                                    "pokemon_images_cache",
                                                    maxNrOfCacheObjects: 500,
                                                    stalePeriod:
                                                        const Duration(days: 7),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
