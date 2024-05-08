import 'package:flutter/material.dart';
import 'package:rotomdex/dex/service/bookmark_services.dart';
import 'package:rotomdex/shared/data/themes.dart';
import 'package:rotomdex/dex/widgets/list_items/ability_list_item.dart';
import 'package:rotomdex/dex/widgets/list_items/move_list_item.dart';
import 'package:rotomdex/dex/widgets/list_items/pokemon_list_item.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageStateState();
}

class _BookmarksPageStateState extends State<BookmarksPage> {
  List pokemonBookmarks = [];
  List moveBookmarks = [];
  List abilityBookmarks = [];

  BookmarkServices bookmarkServices = BookmarkServices();

  @override
  void initState() {
    super.initState();
    getBookmarks();
  }

  void getBookmarks() async {
    (List pBookmarks, List mBookmarks, List aBookmarks) bookmarks =
        await bookmarkServices.getBookmarks(context);

    setState(() {
      pokemonBookmarks = bookmarks.$1;
      moveBookmarks = bookmarks.$2;
      abilityBookmarks = bookmarks.$3;
    });
  }

  void removeFromBookmarks(String type, String value) async {
    bookmarkServices.removeFromBookmarks(type, value);
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
                                    return PokemonListItem(
                                      item: item,
                                      text: BaseThemeColors.detailContainerText,
                                      removeFromBookmarks: removeFromBookmarks,
                                      bg: BaseThemeColors.detailItemBg,
                                    );
                                  },
                                ),
                                ListView.separated(
                                  padding: const EdgeInsets.all(8),
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 10);
                                  },
                                  itemCount: moveBookmarks.length,
                                  itemBuilder: (context, index) {
                                    final move = moveBookmarks[index];
                                    return MoveListItem(
                                      item: move,
                                      shadowColor:
                                          const Color.fromARGB(125, 0, 0, 0),
                                      removeFromBookmarks: removeFromBookmarks,
                                      bg: BaseThemeColors.detailItemBg,
                                      text: BaseThemeColors.detailItemText,
                                      accentText:
                                          BaseThemeColors.detailItemAccentText,
                                    );
                                  },
                                ),
                                ListView.separated(
                                  padding: const EdgeInsets.all(8),
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 10);
                                  },
                                  itemCount: abilityBookmarks.length,
                                  itemBuilder: (context, index) {
                                    final ability = abilityBookmarks[index];
                                    return AbilityListItem(
                                      item: ability,
                                      shadowColor:
                                          const Color.fromARGB(125, 0, 0, 0),
                                      removeFromBookmarks: removeFromBookmarks,
                                      bg: BaseThemeColors.detailItemBg,
                                      text: BaseThemeColors.detailItemText,
                                      accentText:
                                          BaseThemeColors.detailItemAccentText,
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
