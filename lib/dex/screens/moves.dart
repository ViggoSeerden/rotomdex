import 'package:flutter/material.dart';
import 'package:rotomdex/dex/service/json_services.dart';
import 'package:rotomdex/dex/service/search_services.dart';
import 'package:rotomdex/shared/data/themes.dart';
import 'package:rotomdex/dex/widgets/floating_action_bubble.dart';
import 'package:rotomdex/dex/widgets/list_items/move_list_item.dart';

class MoveDexPage extends StatefulWidget {
  const MoveDexPage({super.key});

  @override
  MoveDexPageState createState() => MoveDexPageState();
}

class MoveDexPageState extends State<MoveDexPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _data = [];
  List<Map<String, dynamic>> _displayedData = [];
  int perPage = 20; // Moves per page
  int currentPage = 0; // Current page
  bool isLoading = false;
  int prefetchThreshold = 5;

  late AnimationController animationController;
  late Animation<double> animation;

  ScrollController scrollController = ScrollController();

  JsonServices jsonServices = JsonServices();
  SearchServices searchServices = SearchServices();

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: animationController);

    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

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
        'assets/pokemon/data/moves.json', context);
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

    List<Map<String, dynamic>> newMoves =
        _data.getRange(startIndex, endIndex).toList();

    // Check for duplicates before adding
    for (var move in newMoves) {
      if (!_displayedData.contains(move)) {
        _displayedData.add(move);
      }
    }

    setState(() {
      currentPage++;
      isLoading = false;
    });
  }

  void searchMoves(String input) {
    setState(() {
      _displayedData = searchServices.searchItem(_data, input);
    });
  }

  void filterMoves(String argument, String input) {
    setState(() {
      _displayedData = searchServices.filterMoves(_data, argument, input);
    });
  }

  void sortMoves(String argument, String argumentType) {
    setState(() {
      _displayedData = searchServices.sortItem(_data, argumentType, argument);
    });
  }

  void reverseMoves() {
    setState(() {
      _displayedData = _data.reversed.toList();
    });
  }

  void resetMoves() {
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
              var move = _displayedData[index];
              return MoveListItem(
                item: move,
                bg: BaseThemeColors.dexItemBG,
                text: BaseThemeColors.dexItemText,
                accentText: BaseThemeColors.dexItemAccentText,
              );
            } else {
              return _buildLoader(); // Show loading indicator
            }
          },
        ),
        floatingActionButton: FABubble(
            searchFunction: searchMoves,
            reverseFunction: reverseMoves,
            resetFunction: resetMoves,
            filterFunction: filterMoves,
            sortingFunction: sortMoves,
            filterOptions: const ['Type'],
            sortingOptions: const ['ID', 'Name']));
  }
}

Widget _buildLoader() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
