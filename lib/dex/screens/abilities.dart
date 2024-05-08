import 'package:flutter/material.dart';
import 'package:rotomdex/dex/service/json_services.dart';
import 'package:rotomdex/dex/service/search_services.dart';
import 'package:rotomdex/shared/data/themes.dart';
import 'package:rotomdex/dex/widgets/list_items/ability_list_item.dart';
import 'package:rotomdex/dex/widgets/floating_action_bubble.dart';

class AbilityDexPage extends StatefulWidget {
  const AbilityDexPage({super.key});

  @override
  AbilityDexPageState createState() => AbilityDexPageState();
}

class AbilityDexPageState extends State<AbilityDexPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _data = [];
  List<Map<String, dynamic>> _displayedData = [];
  int perPage = 20;
  int currentPage = 0;
  bool isLoading = false;
  int prefetchThreshold = 5;

  ScrollController scrollController = ScrollController();

  JsonServices jsonServices = JsonServices();
  SearchServices searchServices = SearchServices();

  @override
  void initState() {
    super.initState();
    _loadJsonData();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent -
                scrollController.position.viewportDimension &&
        !isLoading) {
      loadMoreData();
    }
  }

  Future<void> _loadJsonData() async {
    var data = await jsonServices.loadJsonData(
        'assets/pokemon/data/abilities.json', context);
    setState(() {
      _data = List<Map<String, dynamic>>.from(data);
      loadMoreData();
    });
    currentPage = 1;
  }

  Future<void> loadMoreData() async {
    if (isLoading) return;

    isLoading = true;

    int startIndex = currentPage * perPage;
    int endIndex = startIndex + perPage + prefetchThreshold;
    if (endIndex > _data.length) {
      endIndex = _data.length;
    }

    List<Map<String, dynamic>> newAbilities =
        _data.getRange(startIndex, endIndex).toList();

    for (var ability in newAbilities) {
      if (!_displayedData.contains(ability)) {
        _displayedData.add(ability);
      }
    }

    setState(() {
      currentPage++;
      isLoading = false;
    });
  }

  void searchAbilities(String input) {
    setState(() {
      _displayedData = searchServices.searchItem(_data, input);
    });
  }

  void reverseAbilities() {
    setState(() {
      _displayedData = _data.reversed.toList();
    });
  }

  void resetAbilities() {
    setState(() {
      _displayedData = _data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView.separated(
          padding: const EdgeInsets.all(8.0),
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 10);
          },
          controller: scrollController,
          itemCount: _displayedData.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < _displayedData.length) {
              var ability = _displayedData[index];
              return AbilityListItem(
                item: ability,
                bg: BaseThemeColors.detailItemBg,
                text: BaseThemeColors.detailItemText,
                accentText: BaseThemeColors.detailItemAccentText,
              );
            } else {
              return _buildLoader(); // Show loading indicator
            }
          },
        ),
        floatingActionButton: FABubble(
            searchFunction: searchAbilities,
            reverseFunction: reverseAbilities,
            resetFunction: resetAbilities,
            filterOptions: const [],
            sortingOptions: const []));
  }
}

Widget _buildLoader() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
