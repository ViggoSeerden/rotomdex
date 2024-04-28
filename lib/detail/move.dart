import 'package:flutter/material.dart';
import 'package:rotomdex/service/bookmark_services.dart';
import 'package:rotomdex/service/detail_services.dart';
import 'package:rotomdex/service/navigation_services.dart';
import 'package:rotomdex/utils/themes.dart';
import 'package:rotomdex/widgets/list_items/pokemon_list_item.dart';

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

  BookmarkServices bookmarkServices = BookmarkServices();
  DetailServices detailServices = DetailServices();
  NavigationServices navigationServices = NavigationServices();

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    List levelUp = await detailServices.getPokemonWithMove(
        widget.moveData['name'], context, 'level_up');
    List tm = await detailServices.getPokemonWithMove(
        widget.moveData['name'], context, 'tm');
    List egg = await detailServices.getPokemonWithMove(
        widget.moveData['name'], context, 'egg');

    setState(() {
      levelUpPokemon = levelUp;
      tmPokemon = tm;
      eggPokemon = egg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.moveData['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: BaseThemeColors.detailAppBarText),
        centerTitle: true,
        foregroundColor: BaseThemeColors.detailAppBarText,
        backgroundColor: BaseThemeColors.detailAppBarBG,
        actions: [
          IconButton(
              onPressed: () => bookmarkServices.saveBookmark(
                  'move', widget.moveData['name'], context),
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
                    Text(
                      widget.moveData['description'],
                      style: const TextStyle(
                          fontSize: 20,
                          color: BaseThemeColors.detailContainerText),
                      textAlign: TextAlign.center,
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
                              style: TextStyle(
                                  fontSize: 20,
                                  color: BaseThemeColors.detailContainerText),
                              textAlign: TextAlign.center,
                            ),
                            Image.asset(
                                'assets/images/icons/types/${widget.moveData['type']}.png',
                                width: 50,
                                height: 50)
                          ],
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Column(
                          children: [
                            const Text(
                              'Category',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: BaseThemeColors.detailContainerText),
                              textAlign: TextAlign.center,
                            ),
                            if (widget.moveData['category'].toString() !=
                                '--') ...[
                              Image.asset(
                                  'assets/images/icons/moves/${widget.moveData['category'].toString().toLowerCase()}_color.png',
                                  width: 50,
                                  height: 50)
                            ] else ...[
                              const Text(
                                'Varies',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: BaseThemeColors.detailContainerText),
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
                              style: TextStyle(
                                  fontSize: 20,
                                  color: BaseThemeColors.detailContainerText),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.moveData['power'],
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: BaseThemeColors.detailContainerText),
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
                              style: TextStyle(
                                  fontSize: 20,
                                  color: BaseThemeColors.detailContainerText),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.moveData['accuracy'],
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: BaseThemeColors.detailContainerText),
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
                              style: TextStyle(
                                  fontSize: 20,
                                  color: BaseThemeColors.detailContainerText),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.moveData['pp'].toString(),
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: BaseThemeColors.detailContainerText),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      ],
                    ),
                    Expanded(
                      child: DefaultTabController(
                        length: 3,
                        child: Scaffold(
                          backgroundColor: Colors.transparent,
                          appBar: AppBar(
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            scrolledUnderElevation: 0,
                            automaticallyImplyLeading: false,
                            centerTitle: true,
                            title: const Text(
                              'Pokémon that can learn this move:',
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
                                  Tab(text: 'Level Up'),
                                  Tab(text: 'TM Moves'),
                                  Tab(text: 'Egg Moves'),
                                ]),
                          ),
                          body: TabBarView(children: [
                            GridView.builder(
                              padding: const EdgeInsets.all(8.0),
                              shrinkWrap: true,
                              itemCount: levelUpPokemon.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                              ),
                              itemBuilder: (context, index) {
                                final item = levelUpPokemon[index];
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
                              itemCount: tmPokemon.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                              ),
                              itemBuilder: (context, index) {
                                final item = tmPokemon[index];
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
                              itemCount: eggPokemon.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                              ),
                              itemBuilder: (context, index) {
                                final item = eggPokemon[index];
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
