import 'package:flutter/material.dart';
import 'package:rotomdex/service/json_services.dart';
import 'package:rotomdex/service/search_services.dart';
import 'package:rotomdex/utils/themes.dart';
import 'package:rotomdex/widgets/floating_action_bubble.dart';
import 'package:rotomdex/widgets/list_items/pokemon_list_item.dart';

class PokedexPage extends StatefulWidget {
  const PokedexPage({super.key});

  @override
  PokedexPageState createState() => PokedexPageState();
}

class PokedexPageState extends State<PokedexPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _data = [];
  List<Map<String, dynamic>> _displayedData = [];

  int perPage = 24;
  int currentPage = 0;
  int prefetchThreshold = 6;
  bool isLoading = false;

  ScrollController scrollController = ScrollController();

  JsonServices jsonServices = JsonServices();
  SearchServices searchServices = SearchServices();

  @override
  void initState() {
    super.initState();
    _loadData();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent -
                scrollController.position.viewportDimension &&
        !isLoading) {
      _loadMoreData();
    }
  }

  Future<void> _loadData() async {
    var data = await jsonServices.loadJsonData(
        'assets/pokemon/data/kanto_expanded.json', context);
    setState(() {
      _data = List<Map<String, dynamic>>.from(data);
      _loadMoreData();
    });
  }

  Future<void> _loadMoreData() async {
    if (isLoading) return;

    isLoading = true;

    // Calculate the index range for the next page
    int startIndex = currentPage * perPage;
    int endIndex =
        startIndex + perPage + prefetchThreshold; // Preload additional items

    // Ensure endIndex does not exceed total Pokemon count
    if (endIndex > _data.length) {
      endIndex = _data.length;
    }

    List<Map<String, dynamic>> newPokemon =
        _data.getRange(startIndex, endIndex).toList();

    // Check for duplicates before adding
    for (var pokemon in newPokemon) {
      if (!_displayedData.contains(pokemon)) {
        _displayedData.add(pokemon);
      }
    }

    setState(() {
      currentPage++;
      isLoading = false;
    });
  }

  void searchPokemon(String input) {
    setState(() {
      _displayedData = searchServices.searchItem(_data, input);
    });
  }

  void filterPokemon(String argument, String input) {
    setState(() {
      _displayedData = searchServices.filterPokemon(_data, argument, input);
    });
  }

  void sortPokemon(String argument, String argumentType) {
    setState(() {
      _displayedData = searchServices.sortItem(_data, argumentType, argument);
    });
  }

  void reversePokemon() {
    setState(() {
      _displayedData = _data.reversed.toList();
    });
  }

  void resetPokemon() {
    setState(() {
      _displayedData = _data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: _displayedData.length,
          controller: scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
          itemBuilder: (context, index) {
            final item = _displayedData[index];
            return PokemonListItem(
              item: item,
              text: BaseThemeColors.dexItemText,
              bg: BaseThemeColors.detailItemBg,
            );
          },
        ),
        floatingActionButton: FABubble(
            searchFunction: searchPokemon,
            reverseFunction: reversePokemon,
            resetFunction: resetPokemon,
            filterFunction: filterPokemon,
            sortingFunction: sortPokemon,
            filterOptions: const ['Type', "Egg Group"],
            sortingOptions: const ["ID", "Name"]));
  }
}
