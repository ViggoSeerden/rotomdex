import 'package:flutter/material.dart';
import 'package:rotomdex/service/detail_services.dart';
import 'package:rotomdex/utils/themes.dart';
import 'package:rotomdex/widgets/list_items/move_list_item.dart';

class PokemonMovesTab extends StatefulWidget {
  final Map pokemonData;

  const PokemonMovesTab({super.key, required this.pokemonData});

  @override
  State<PokemonMovesTab> createState() => _PokemonMovesTabState();
}

DetailServices detailServices = DetailServices();

class _PokemonMovesTabState extends State<PokemonMovesTab> {
  List levelUpMoves = [];
  List levelUpLevels = [];
  List tmMoves = [];
  List eggMoves = [];
  String source = '';

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    (List levelUp, List levelUpLvls, List tm, List egg, String source) moveset =
        await detailServices.getPokemonMoveset(
            widget.pokemonData['id'], context);
    setState(() {
      levelUpMoves = moveset.$1;
      levelUpLevels = moveset.$2;
      tmMoves = moveset.$3;
      eggMoves = moveset.$4;
      source = moveset.$5;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  borderRadius: BorderRadius.all(Radius.circular(20)),
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
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          scrolledUnderElevation: 0,
                          automaticallyImplyLeading: false,
                          centerTitle: true,
                          title: Text(
                            'Learnable Moves ($source)',
                            style: const TextStyle(
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
                          ListView.separated(
                            padding: const EdgeInsets.all(8),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 10);
                            },
                            itemCount: levelUpMoves.length,
                            itemBuilder: (context, index) {
                              final move = levelUpMoves[index];
                              return MoveListItem(
                                item: move,
                                level: levelUpLevels[index].toString(),
                                shadowColor: const Color.fromARGB(125, 0, 0, 0),
                                bg: BaseThemeColors.detailItemBg,
                                text: BaseThemeColors.detailItemText,
                                accentText: BaseThemeColors.detailItemAccentText,
                              );
                            },
                          ),
                          ListView.separated(
                            padding: const EdgeInsets.all(8),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 10);
                            },
                            itemCount: tmMoves.length,
                            itemBuilder: (context, index) {
                              final move = tmMoves[index];
                              return MoveListItem(
                                item: move,
                                shadowColor: const Color.fromARGB(125, 0, 0, 0),
                                bg: BaseThemeColors.detailItemBg,
                                text: BaseThemeColors.detailItemText,
                                accentText: BaseThemeColors.detailItemAccentText,
                              );
                            },
                          ),
                          ListView.separated(
                            padding: const EdgeInsets.all(8),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 10);
                            },
                            itemCount: eggMoves.length,
                            itemBuilder: (context, index) {
                              final move = eggMoves[index];
                              return MoveListItem(
                                item: move,
                                shadowColor: const Color.fromARGB(125, 0, 0, 0),
                                bg: BaseThemeColors.detailItemBg,
                                text: BaseThemeColors.detailItemText,
                                accentText: BaseThemeColors.detailItemAccentText,
                              );
                            },
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
}
