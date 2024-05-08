import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:rotomdex/dex/service/json_services.dart';
import 'package:rotomdex/dex/service/navigation_services.dart';
import 'package:rotomdex/shared/services/preference_services.dart';
import 'package:rotomdex/shared/data/themes.dart';
import 'package:themed/themed.dart';

class PokemonInfoTab extends StatefulWidget {
  final Map pokemonData;

  const PokemonInfoTab({super.key, required this.pokemonData});

  @override
  State<PokemonInfoTab> createState() => _PokemonInfoTabState();
}

JsonServices jsonServices = JsonServices();
NavigationServices navigationServices = NavigationServices();
PreferenceServices preferenceServices = PreferenceServices();

class _PokemonInfoTabState extends State<PokemonInfoTab> {
  late String imageUrl;
  late bool shiny;
  String? heightUnits = 'Meters';
  String? weightUnits = 'Kilograms';

  @override
  void initState() {
    super.initState();
    shiny = false;
    imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemonData['id']}.png';
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    String heightunit = await preferenceServices.loadPreference('heightunit');
    String weightunit = await preferenceServices.loadPreference('weightunit');
    setState(() {
      heightUnits = heightunit;
      weightUnits = weightunit;
    });
  }

  @override
  Widget build(BuildContext context) {
    int bst = 0;

    for (var entry in widget.pokemonData['base_stats'].entries) {
      int statValue = entry.value;

      bst += statValue;
    }

    const ticks = [50, 100, 150, 200];
    var features = [
      "HP: ${widget.pokemonData['base_stats']['HP']}",
      "  Attack: ${widget.pokemonData['base_stats']['Attack']}",
      "  Defense: ${widget.pokemonData['base_stats']['Defense']}",
      "Speed: ${widget.pokemonData['base_stats']['Speed']}",
      "SpDefense: ${widget.pokemonData['base_stats']['SpDefense']}",
      "SpAttack: ${widget.pokemonData['base_stats']['SpAttack']}"
    ];
    var data = [
      [
        widget.pokemonData['base_stats']['HP'] as num,
        widget.pokemonData['base_stats']['Attack'] as num,
        widget.pokemonData['base_stats']['Defense'] as num,
        widget.pokemonData['base_stats']['Speed'] as num,
        widget.pokemonData['base_stats']['SpDefense'] as num,
        widget.pokemonData['base_stats']['SpAttack'] as num,
      ],
    ];

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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.pokemonData['id'] > 1) ...[
              IconButton(
                  onPressed: () async =>
                      navigationServices.navigateToPokemonViaID(
                          context,
                          widget.pokemonData["id"] - 1,
                          await jsonServices.loadJsonData(
                              'assets/pokemon/data/kanto_expanded.json',
                              context)),
                  icon: const Icon(
                    Icons.arrow_left_rounded,
                    size: 40,
                    color: BaseThemeColors.detailContainerText,
                  )),
              const SizedBox(
                width: 50,
              )
            ] else ...[
              const Icon(
                Icons.arrow_left,
                color: Colors.transparent,
              ),
              const SizedBox(
                width: 70,
              )
            ],
            GestureDetector(
              onTap: toggleShiny,
              child: Image.network(
                imageUrl,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            if (widget.pokemonData['id'] < 151) ...[
              const SizedBox(
                width: 50,
              ),
              IconButton(
                  onPressed: () async =>
                      navigationServices.navigateToPokemonViaID(
                          context,
                          widget.pokemonData["id"] + 1,
                          await jsonServices.loadJsonData(
                              'assets/pokemon/data/kanto_expanded.json',
                              context)),
                  icon: const Icon(
                    Icons.arrow_right_rounded,
                    size: 40,
                    color: BaseThemeColors.detailContainerText,
                  )),
            ] else ...[
              const SizedBox(
                width: 70,
              ),
              const Icon(
                Icons.arrow_right,
                color: Colors.transparent,
              )
            ],
          ],
        ),
        const SizedBox(height: 50),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    BaseThemeColors.detailContainerGradientTop,
                    BaseThemeColors.detailContainerGradientBottom,
                  ],
                ),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    '${widget.pokemonData['category']} Pokémon',
                    style: const TextStyle(
                        fontSize: 30,
                        color: BaseThemeColors.detailContainerText),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Text(
                      '${widget.pokemonData['pokedex_entry']}',
                      style: const TextStyle(
                          fontSize: 20,
                          color: BaseThemeColors.detailContainerText),
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
                        heightUnits == 'Meters'
                            ? widget.pokemonData['height']['meters']
                            : widget.pokemonData['height']['feet_inches'],
                        style: const TextStyle(
                            fontSize: 24,
                            color: BaseThemeColors.detailContainerText),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        weightUnits == 'Kilograms'
                            ? widget.pokemonData['weight']['kilograms']
                            : widget.pokemonData['weight']['lbs'],
                        style: const TextStyle(
                            fontSize: 24,
                            color: BaseThemeColors.detailContainerText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text('Abilities',
                      style: TextStyle(
                          fontSize: 24,
                          color: BaseThemeColors.detailContainerText)),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => navigationServices.navigateToAbility(
                            context, widget.pokemonData['ability1']),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffEF866B),
                            elevation: 5.0),
                        child: Text(
                          widget.pokemonData['ability1'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                      if (widget.pokemonData['ability2'] != null &&
                          widget.pokemonData['ability2'].isNotEmpty) ...[
                        ElevatedButton(
                            onPressed: () =>
                                navigationServices.navigateToAbility(
                                    context, widget.pokemonData['ability2']),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffEF866B),
                                elevation: 5.0),
                            child: Text(widget.pokemonData['ability2'],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20))),
                      ],
                      if (widget.pokemonData['hidden_ability'] != null &&
                          widget.pokemonData['hidden_ability'].isNotEmpty) ...[
                        ElevatedButton(
                            onPressed: () =>
                                navigationServices.navigateToAbility(context,
                                    widget.pokemonData['hidden_ability']),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffEF866B),
                                elevation: 5.0),
                            child: Text(
                                '${widget.pokemonData['hidden_ability']} (Hidden)',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20))),
                      ],
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text('Base Stats',
                      style: TextStyle(
                          fontSize: 24,
                          color: BaseThemeColors.detailContainerText)),
                  if (Themed.ifCurrentThemeIs(BaseThemeColors.darkTheme)) ...[
                    SizedBox(
                      height: 240,
                      child: RadarChart.dark(
                        ticks: ticks,
                        features: features,
                        data: data,
                        useSides: true,
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      height: 240,
                      child: RadarChart.light(
                        ticks: ticks,
                        features: features,
                        data: data,
                        useSides: true,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Text('Base Stat Total: $bst',
                      style: const TextStyle(
                          fontSize: 20,
                          color: BaseThemeColors.detailContainerText)),
                  const SizedBox(height: 30),
                  const Text('Evolution Family:',
                      style: TextStyle(
                          fontSize: 24,
                          color: BaseThemeColors.detailContainerText)),
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
                                onTap: () =>
                                    navigationServices.navigateToPokemon(
                                        context,
                                        evo['from_name'],
                                        widget.pokemonData['name']),
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
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${evo['from_id']}.png",
                                          width: 100,
                                          height: 100,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                          fadeInDuration: Durations.short1,
                                          cacheKey: "pokemon_${evo['from_id']}",
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
                                    Text(
                                      '#${evo['from_id']} ${evo['from_name']}',
                                      style: const TextStyle(
                                          color: BaseThemeColors
                                              .detailContainerText),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.arrow_right_alt,
                                    color: BaseThemeColors.detailContainerText,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      evo['method'],
                                      style: const TextStyle(
                                          color: BaseThemeColors
                                              .detailContainerText),
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.center,
                                      maxLines: 4,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () =>
                                    navigationServices.navigateToPokemon(
                                        context,
                                        evo['to_name'],
                                        widget.pokemonData['name']),
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
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${evo['to_id']}.png",
                                          width: 100,
                                          height: 100,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                          fadeInDuration: Durations.short1,
                                          cacheKey: "pokemon_${evo['to_id']}",
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
                                    Text('#${evo['to_id']} ${evo['to_name']}',
                                        style: const TextStyle(
                                            color: BaseThemeColors
                                                .detailContainerText))
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
                          style: TextStyle(
                              fontSize: 18,
                              color: BaseThemeColors.detailContainerText),
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
}
