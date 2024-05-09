import 'package:flutter/material.dart';
import 'package:rotomdex/dex/service/bookmark_services.dart';
import 'package:rotomdex/dex/service/detail_services.dart';
import 'package:rotomdex/shared/services/navigation_services.dart';
import 'package:rotomdex/shared/data/themes.dart';
import 'package:rotomdex/dex/widgets/list_items/pokemon_list_item.dart';

class AbilityPage extends StatefulWidget {
  final Map abilityData;

  const AbilityPage({Key? key, required this.abilityData}) : super(key: key);

  @override
  AbilityPageState createState() => AbilityPageState();
}

class AbilityPageState extends State<AbilityPage> {
  List normalPokemon = [];
  List hiddenPokemon = [];

  BookmarkServices bookmarkServices = BookmarkServices();
  DetailServices detailServices = DetailServices();
  NavigationServices navigationServices = NavigationServices();

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    List normal = await detailServices.getPokemonWithAbility(
        widget.abilityData['name'].toLowerCase(), context, 'normal');

    if (!mounted) return; 

    List hidden = await detailServices.getPokemonWithAbility(
        widget.abilityData['name'].toLowerCase(), context, 'hidden');

    setState(() {
      normalPokemon = normal;
      hiddenPokemon = hidden;
    });
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
          IconButton(
              onPressed: () => bookmarkServices.saveBookmark(
                  'ability', widget.abilityData['name'], context),
              icon: const Icon(Icons.bookmark)),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(125, 0, 0, 0),
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
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
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
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
                            fontSize: 20,
                            color: BaseThemeColors.detailContainerText),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: DefaultTabController(
                        length: 2,
                        child: Scaffold(
                          backgroundColor: Colors.transparent,
                          appBar: AppBar(
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            scrolledUnderElevation: 0,
                            automaticallyImplyLeading: false,
                            centerTitle: true,
                            title: const Text(
                              'Pokémon that can have this ability:',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            backgroundColor: Colors.transparent,
                            bottom: const TabBar(
                                labelColor: BaseThemeColors.detailContainerText,
                                indicatorColor: Color(0xffEF866B),
                                dividerColor: Color(0xffEF866B),
                                tabs: [
                                  Tab(text: 'Normal'),
                                  Tab(text: 'Hidden'),
                                ]),
                          ),
                          body: TabBarView(children: [
                            GridView.builder(
                              padding: const EdgeInsets.all(8.0),
                              shrinkWrap: true,
                              itemCount: normalPokemon.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                              ),
                              itemBuilder: (context, index) {
                                final item = normalPokemon[index];
                                return PokemonListItem(
                                  item: item,
                                  text: BaseThemeColors.detailContainerText,
                                  bg: BaseThemeColors.detailItemBg,
                                );
                              },
                            ),
                            GridView.builder(
                              padding: const EdgeInsets.all(8.0),
                              shrinkWrap: true,
                              itemCount: hiddenPokemon.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                              ),
                              itemBuilder: (context, index) {
                                final item = hiddenPokemon[index];
                                return PokemonListItem(
                                  item: item,
                                  text: BaseThemeColors.detailContainerText,
                                  bg: BaseThemeColors.detailItemBg,
                                );
                              },
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
