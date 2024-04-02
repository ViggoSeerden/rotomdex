import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:rotomdex/detail/move.dart';
import 'package:rotomdex/themes/themes.dart';

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

  List<String> types = [
    'Normal',
    'Fighting',
    'Flying',
    'Poison',
    'Ground',
    'Rock',
    'Bug',
    'Ghost',
    'Steel',
    'Fire',
    'Water',
    'Grass',
    'Electric',
    'Psychic',
    'Ice',
    'Dragon',
    'Dark',
    'Fairy'
  ];

  late AnimationController animationController;
  late Animation<double> animation;

  ScrollController scrollController = ScrollController();

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
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/moves.json');
    setState(() {
      _data = List<Map<String, dynamic>>.from(json.decode(data));
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

    setState(() {
      _displayedData.addAll(_data.getRange(startIndex, endIndex));
      currentPage++;
      isLoading = false;
    });
  }

  void searchMoves(String input) {
    List<Map<String, dynamic>> filteredMoves = _data
        .where((move) =>
            move['move'].toString().toLowerCase().contains(input.toLowerCase()))
        .toList();
    setState(() {
      _displayedData = filteredMoves;
    });
  }

  void filterMoves(String argument, String input) {
    List<Map<String, dynamic>> filteredPokemon = _data
        .where(
          (pokemon) =>
              pokemon[argument].toString().toLowerCase() == input.toLowerCase(),
        )
        .toList();
    setState(() {
      _displayedData = filteredPokemon;
    });
  }

  void sortMoves(String argument, String argumentType) {
    _data.sort((a, b) {
      if (argumentType == 'int') {
        return a[argument].compareTo(b[argument]);
      } else {
        return a[argument].toString().compareTo(b[argument].toString());
      }
    });

    setState(() {
      _displayedData = _data.toList();
    });
  }

  void reverseMoves() {
    setState(() {
      _displayedData = _data.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 10);
        },
        controller: scrollController,
        itemCount: _displayedData.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _displayedData.length) {
            var move = _displayedData[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovePage(moveData: move),
                  ),
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    width: 150,
                    child: Text(
                      move['move'],
                      style: const TextStyle(fontSize: 20, color: BaseThemeColors.dexItemText),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Power: ${move['power']}',
                        style: const TextStyle(
                            fontSize: 16,
                            color: BaseThemeColors.dexItemAccentText),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'Accuracy: ${move['accuracy']}',
                        style: const TextStyle(
                            fontSize: 16,
                            color: BaseThemeColors.dexItemAccentText),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'PP: ${move['pp']}',
                        style: const TextStyle(
                            fontSize: 16,
                            color: BaseThemeColors.dexItemAccentText),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )),
                  const SizedBox(
                    width: 20,
                  ),
                  if (move['category'].toString() != '--') ...[
                    Image.asset(
                      'assets/images/icons/moves/${move['category'].toString().toLowerCase()}_color.png',
                      width: 35,
                      height: 35,
                    ),
                  ]
                ]),
              ),
            );
          } else {
            return _buildLoader(); // Show loading indicator
          }
        },
      ),
      floatingActionButton: FloatingActionBubble(
        onPress: () => {
          animationController.isCompleted
              ? animationController.reverse()
              : animationController.forward(),
        },
        backGroundColor: const Color(0xffEF866B),
        animation: animation,
        iconColor: Colors.white,
        iconData: Icons.settings,
        items: <Bubble>[
          Bubble(
            title: "Search",
            iconColor: Colors.white,
            bubbleColor: const Color(0xffEF866B),
            icon: Icons.search,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Enter Name:',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: BaseThemeColors.fabPopupText),
                    ),
                    content: SearchBar(
                      onChanged: (value) => searchMoves(value),
                    ),
                    backgroundColor: BaseThemeColors.fabPopupBG,
                    actions: <Widget>[
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Close',
                            style: TextStyle(fontSize: 20, color: BaseThemeColors.fabPopupButtonText),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
              animationController.reverse();
            },
          ),
          Bubble(
            title: "Filter",
            iconColor: Colors.white,
            bubbleColor: const Color(0xffEF866B),
            icon: Icons.filter_alt,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: BaseThemeColors.fabPopupBG,
                    title: const Text(
                      'Filter By:',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: BaseThemeColors.fabPopupText),
                    ),
                    content: SizedBox(
                      height: 100,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Type',
                                style: TextStyle(
                                    fontSize: 20, color: BaseThemeColors.fabPopupText),
                              ),
                              const SizedBox(width: 10),
                              DropdownButton<String>(
                                dropdownColor: Colors.grey,
                                focusColor: Colors.grey,
                                value: types.first,
                                items: types.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(color: BaseThemeColors.detailContainerText)),
                                  );
                                }).toList(),
                                onChanged: (String? value) => {
                                  filterMoves('type', value!),
                                  Navigator.of(context).pop()
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 20, color: BaseThemeColors.fabPopupButtonText),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
              animationController.reverse();
            },
          ),
          Bubble(
            title: "Sort",
            iconColor: Colors.white,
            bubbleColor: const Color(0xffEF866B),
            icon: Icons.sort,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: BaseThemeColors.fabPopupBG,
                    title: const Text(
                      'Sort By:',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: BaseThemeColors.fabPopupText),
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            sortMoves('id', 'int');
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Generation',
                            style: TextStyle(fontSize: 20, color: BaseThemeColors.fabPopupButtonText),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            sortMoves('move', 'string');
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Name',
                            style: TextStyle(fontSize: 20, color: BaseThemeColors.fabPopupButtonText),
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              reverseMoves();
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Reverse',
                              style: TextStyle(fontSize: 20, color: BaseThemeColors.fabPopupButtonText),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 20, color: BaseThemeColors.fabPopupButtonText),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
              animationController.reverse();
            },
          ),
          Bubble(
            title: "Reset",
            iconColor: Colors.white,
            bubbleColor: const Color(0xffEF866B),
            icon: Icons.backspace,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              setState(() {
                _displayedData = _data;
              });
              animationController.reverse();
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildLoader() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
