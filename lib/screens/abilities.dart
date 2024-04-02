import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:rotomdex/detail/ability.dart';
import 'package:rotomdex/themes/themes.dart';

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
        .loadString('assets/pokemon/data/abilities.json');
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

  void searchAbilities(String input) {
    List<Map<String, dynamic>> filteredAbilities = _data
        .where((ability) => ability['name']
            .toString()
            .toLowerCase()
            .contains(input.toLowerCase()))
        .toList();
    setState(() {
      _displayedData = filteredAbilities;
    });
  }

  void reverseAbilities() {
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
            var ability = _displayedData[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AbilityPage(abilityData: ability),
                  ),
                );
              },
              child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: BaseThemeColors.dexItemBG,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ability['name'],
                        style:
                            const TextStyle(fontSize: 20, color: BaseThemeColors.dexItemText),
                      ),
                      Text(
                        ability['description'],
                        style: const TextStyle(
                            fontSize: 16,
                            color: BaseThemeColors.dexItemAccentText),
                      )
                    ],
                  )),
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
                      onChanged: (value) => searchAbilities(value),
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
                            style: TextStyle(fontSize: 20),
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
            title: "Reverse",
            iconColor: Colors.white,
            bubbleColor: const Color(0xffEF866B),
            icon: Icons.sort,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              reverseAbilities();
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
