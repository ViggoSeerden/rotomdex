import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:rotomdex/detail/move.dart';

class MoveDexPage extends StatefulWidget {
  const MoveDexPage({super.key});

  @override
  MoveDexPageState createState() => MoveDexPageState();
}

class MoveDexPageState extends State<MoveDexPage>
    with SingleTickerProviderStateMixin {
  List _data = [];

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
        .loadString('assets/pokemon/data/moves.json');
    setState(() {
      _data = json.decode(data);
    });
  }

  void searchMoves(String input) {
    List filteredMoves = _data
        .where((move) =>
            move['move'].toString().toLowerCase().contains(input.toLowerCase()))
        .toList();
    setState(() {
      _data = filteredMoves;
    });
  }

  void filterMoves(String argument, String input) {
    List filteredPokemon = _data
        .where(
          (pokemon) =>
              pokemon[argument].toString().toLowerCase() == input.toLowerCase(),
        )
        .toList();
    setState(() {
      _data = filteredPokemon;
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
      _data = _data.toList();
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
          for (var move in _data) ...[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MovePage(moveData: move),
                  ),
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.teal,
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
                      style: const TextStyle(fontSize: 20, color: Colors.white),
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
                            color: Color.fromARGB(170, 255, 255, 255)),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'Accuracy: ${move['accuracy']}',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(170, 255, 255, 255)),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'PP: ${move['pp']}',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(170, 255, 255, 255)),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )),
                  const SizedBox(
                    width: 20,
                  ),
                  if (move['category'].toString() != '--') ...[
                    Image.asset(
                      'assets/images/icons/moves/${move['category'].toString().toLowerCase()}.png',
                      width: 35,
                      height: 35,
                    ),
                  ]
                ]),
              ),
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
                      onChanged: (value) => searchMoves(value),
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
                    backgroundColor: const Color(0xffEF866B),
                    title: const Text(
                      'Filter By:',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
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
                                    fontSize: 20, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              DropdownButton<String>(
                                dropdownColor: Colors.white,
                                focusColor: Colors.white,
                                value: types.first,
                                items: types.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
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
                    backgroundColor: const Color(0xffEF866B),
                    title: const Text(
                      'Sort By:',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
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
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            sortMoves('move', 'string');
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Name',
                            style: TextStyle(fontSize: 20),
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
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 20),
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
          // Bubble(
          //   title: "Layout",
          //   iconColor: Colors.white,
          //   bubbleColor: const Color(0xffEF866B),
          //   icon: Icons.grid_3x3,
          //   titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          //   onPress: () {
          //     animationController.reverse();
          //   },
          // ),
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
