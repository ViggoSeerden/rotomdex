import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:rotomdex/detail/ability.dart';

class AbilityDexPage extends StatefulWidget {
  const AbilityDexPage({super.key});

  @override
  AbilityDexPageState createState() => AbilityDexPageState();
}

class AbilityDexPageState extends State<AbilityDexPage>
    with SingleTickerProviderStateMixin {
  List _data = [];

  late AnimationController animationController;
  late Animation<double> animation;

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
  }

  Future<void> _loadJsonData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/abilities.json');
    setState(() {
      _data = json.decode(data);
    });
  }

  void searchAbilities(String input) {
    List filteredAbilities = _data
        .where((ability) => ability['abilities']
            .toString()
            .toLowerCase()
            .contains(input.toLowerCase()))
        .toList();
    setState(() {
      _data = filteredAbilities;
    });
  }

  void reverseMoves() {
    setState(() {
      _data = _data.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(children: [
          for (var ability in _data) ...[
            GestureDetector(
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
                    color: Colors.teal,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ability['name'],
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        ability['description'],
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(170, 255, 255, 255)),
                      )
                    ],
                  )),
            ),
            const SizedBox(
              height: 10,
            )
          ]
        ]),
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
                      style: TextStyle(color: Colors.white),
                    ),
                    content: SearchBar(
                      onChanged: (value) => searchAbilities(value),
                    ),
                    backgroundColor: const Color(0xffEF866B),
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
              reverseMoves();
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
              _loadJsonData();
              animationController.reverse();
            },
          ),
        ],
      ),
    );
  }
}
