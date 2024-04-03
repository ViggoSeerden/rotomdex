import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:rotomdex/detail/ability.dart';
import 'package:rotomdex/detail/move.dart';
import 'package:rotomdex/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:themed/themed.dart';

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
  String? heightUnits = 'Meters';
  String? weightUnits = 'Kilograms';

  List levelUpMoves = [];
  List levelUpLevels = [];
  List tmMoves = [];
  List eggMoves = [];

  @override
  void initState() {
    super.initState();
    shiny = false;
    imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemonData['id']}.png';
    modelPath =
        'assets/pokemon/models/${widget.pokemonData['id'].toString()}.glb';
    _loadPreferences();
    _loadJsonData();
    setLastItem();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void setLastItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('lastItem', ['Pokémon', widget.pokemonData['name']]);
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

  Future<void> saveBookmark(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarks = prefs.getStringList('pokemon_bookmarks') ?? [];
    if (bookmarks.length >= 15) {
      showMessage('You have reached the maximum amount of Pokémon bookmarks.');
    } else if (!bookmarks.contains(widget.pokemonData['name'])) {
      bookmarks.add('${widget.pokemonData['name']}');
      await prefs.setStringList('pokemon_bookmarks', bookmarks);
      showMessage('${widget.pokemonData['name']} was added to your bookmarks');
    } else {
      showMessage('${widget.pokemonData['name']} is already bookmarked.');
    }
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      heightUnits = prefs.getString('heightunit');
      weightUnits = prefs.getString('weightunit');
    });
  }

  Future<void> _loadJsonData() async {
    List<dynamic> data = json.decode(await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/kanto_moves.json'));

    var moveset =
        data.firstWhere((set) => set['pokemon_id'] == widget.pokemonData['id']);

    // ignore: use_build_context_synchronously
    List<dynamic> moveData = json.decode(await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/moves.json'));

    List<dynamic> levelUp = [];
    List<dynamic> levelUpLvls = [];
    for (var move in moveset['level_up'] as List) {
      var moveId = move['move_name'];
      var moveDetails = moveData.firstWhere((move) => move['move'] == moveId,
          orElse: () => null);
      if (moveDetails != null) {
        levelUp.add(moveDetails);
        levelUpLvls.add(move['level']);
      }
    }

    List tm = [];
    for (String moveId in moveset['tm']) {
      var moveDetails = moveData.firstWhere((move) => move['move'] == moveId,
          orElse: () => null);
      if (moveDetails != null) {
        tm.add(moveDetails);
      }
    }

    List egg = [];
    for (String moveId in moveset['egg']) {
      var moveDetails = moveData.firstWhere((move) => move['move'] == moveId,
          orElse: () => null);
      if (moveDetails != null) {
        egg.add(moveDetails);
      }
    }

    setState(() {
      levelUpMoves = levelUp;
      levelUpLevels = levelUpLvls;
      tmMoves = tm;
      eggMoves = egg;
    });
  }

  void navigateToPokemon(BuildContext context, String pokemonName) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/kanto_expanded.json');

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
      showMessage('There is no data on $pokemonName in this app.');
    }
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

  void navigateToAbility(BuildContext context, String name) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/abilities.json');

    List<dynamic> abilityList = jsonDecode(data);

    Map<String, dynamic>? ability = abilityList.firstWhere(
      (ability) => ability['name'] == name,
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

  void navigateToMove(BuildContext context, String name) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/moves.json');

    List<dynamic> movesList = jsonDecode(data);

    Map<String, dynamic>? move = movesList.firstWhere(
      (move) => move['move'] == name,
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
        iconTheme: const IconThemeData(color: BaseThemeColors.detailAppBarText),
        centerTitle: true,
        foregroundColor: BaseThemeColors.detailAppBarText,
        backgroundColor: BaseThemeColors.detailAppBarBG,
        actions: [
          IconButton(onPressed: playSound, icon: const Icon(Icons.volume_up)),
          IconButton(onPressed: () => saveBookmark(context), icon: const Icon(Icons.save)),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            BaseThemeColors.detailBGGradientTop,
            BaseThemeColors.detailBGGradientBottom,
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
                  onPressed: () => navigateToPokemonViaID(
                      context, widget.pokemonData["id"] - 1),
                  icon: const Icon(
                    Icons.arrow_left,
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
                  onPressed: () => navigateToPokemonViaID(
                      context, widget.pokemonData["id"] + 1),
                  icon: const Icon(
                    Icons.arrow_right,
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
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50))),
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
                      TextButton(
                        onPressed: () => navigateToAbility(
                            context, widget.pokemonData['ability1']),
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
                            onPressed: () => navigateToAbility(
                                context, widget.pokemonData['ability2']),
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
                            onPressed: () => navigateToAbility(
                                context, widget.pokemonData['hidden_ability']),
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

  Widget _buildMovesTab() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 30),
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
                            'Learnable Moves',
                            style: TextStyle(
                                fontSize: 24,
                                color: BaseThemeColors.detailContainerText),
                          ),
                          backgroundColor: Colors.transparent,
                          bottom: const TabBar(
                              labelColor: BaseThemeColors.detailContainerText,
                              indicatorColor: Color(0xffEF866B),
                              dividerColor: Color(0xffEF866B),
                              tabs: [
                                Tab(
                                  text: 'Level Up',
                                ),
                                Tab(text: 'TM Moves'),
                                Tab(text: 'Egg Moves')
                              ]),
                        ),
                        body: TabBarView(children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var move in levelUpMoves) ...[
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        navigateToMove(context, move['move']),
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
                                            Text(
                                              'Level: ${levelUpLevels[levelUpMoves.indexOf(move)]}',
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
                                  ),
                                ]
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var move in tmMoves) ...[
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        navigateToMove(context, move['move']),
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
                                  ),
                                ]
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var move in eggMoves) ...[
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        navigateToMove(context, move['move']),
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
                                            'assets/images/icons/moves/${move['category'].toString().toLowerCase()}.png',
                                            width: 35,
                                            height: 35,
                                          ),
                                        ]
                                      ]),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30)
        ],
      ),
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
              style: const TextStyle(
                  fontSize: 16, color: BaseThemeColors.detailContainerText),
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
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      const Text('Weaknesses',
                          style: TextStyle(
                              fontSize: 24,
                              color: BaseThemeColors.detailContainerText)),
                      const SizedBox(height: 10),
                      Wrap(alignment: WrapAlignment.center, children: [
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
                          const Text(
                            'This Pokémon has no weaknesses.',
                            style: TextStyle(
                                fontSize: 20,
                                color: BaseThemeColors.detailContainerText),
                          )
                        ],
                      ]),
                      const SizedBox(height: 30),
                      const Text('Resistances',
                          style: TextStyle(
                              fontSize: 24,
                              color: BaseThemeColors.detailContainerText)),
                      const SizedBox(height: 10),
                      Wrap(alignment: WrapAlignment.center, children: [
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
                          const Text(
                            'This Pokémon has no resistances.',
                            style: TextStyle(
                                fontSize: 20,
                                color: BaseThemeColors.detailContainerText),
                          )
                        ],
                      ]),
                      const SizedBox(height: 30),
                      const Text('Immunities',
                          style: TextStyle(
                              fontSize: 24,
                              color: BaseThemeColors.detailContainerText)),
                      const SizedBox(height: 10),
                      Wrap(alignment: WrapAlignment.center, children: [
                        if ((widget.pokemonData['zero_effect_types'] as List)
                            .isNotEmpty) ...[
                          for (var type
                              in widget.pokemonData['zero_effect_types']) ...[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                  'assets/images/icons/types/$type.png'),
                            ),
                          ]
                        ] else ...[
                          const Text(
                            'This Pokémon has no immunities.',
                            style: TextStyle(
                                fontSize: 20,
                                color: BaseThemeColors.detailContainerText),
                          )
                        ],
                      ]),
                      const SizedBox(height: 30),
                      const Text('Breeding',
                          style: TextStyle(
                              fontSize: 24,
                              color: BaseThemeColors.detailContainerText)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(children: [
                            const Text(
                              'Egg Group(s):',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            Text(widget.pokemonData['egg_group1'],
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                            if (widget.pokemonData['egg_group2'] != null &&
                                widget
                                    .pokemonData['egg_group2'].isNotEmpty) ...[
                              Text(widget.pokemonData['egg_group2'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color:
                                          BaseThemeColors.detailContainerText)),
                            ],
                          ]),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(children: [
                            const Text(
                              'Egg Cycles:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            Text(
                                '${widget.pokemonData['egg_cycles'].toString()} cycles',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                            Text(
                                '${widget.pokemonData['steps_to_hatch'].toString()} steps',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                          ]),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(children: [
                            const Text(
                              'Gender Ratio:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            Text(
                                '${widget.pokemonData['gender_ratio']['male']} male',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                            Text(
                                '${widget.pokemonData['gender_ratio']['male']} female',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text('Experience',
                          style: TextStyle(
                              fontSize: 24,
                              color: BaseThemeColors.detailContainerText)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(children: [
                            const Text(
                              'Base EXP Yield:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            Text(
                                '${widget.pokemonData['base_experience_yield']} EXP',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                          ]),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(children: [
                            const Text(
                              'EXP Growth Rate:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            Text(
                                widget.pokemonData['exp_growth_rate']
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text('Miscellaneous',
                          style: TextStyle(
                              fontSize: 24,
                              color: BaseThemeColors.detailContainerText)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(children: [
                            const Text(
                              'Catch Rate:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            Text(widget.pokemonData['catch_rate'].toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                          ]),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(children: [
                            const Text(
                              'Base Happiness:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            Text(
                                widget.pokemonData['base_happiness'].toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          const Text('EV Yield:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText)),
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
