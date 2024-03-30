import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rotomdex/detail/pokemon.dart';

class MovePage extends StatefulWidget {
  final Map moveData;

  const MovePage({Key? key, required this.moveData}) : super(key: key);

  @override
  MovePageState createState() => MovePageState();
}

class MovePageState extends State<MovePage> {
  @override
  void initState() {
    super.initState();
  }

  void navigateToPokemonViaID(BuildContext context, int pokemonId) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/kanto_expanded.json');

    List<dynamic> pokemonList = jsonDecode(data);

    Map<String, dynamic>? specificPokemon = pokemonList.firstWhere(
      (pokemon) => pokemon['id'] == pokemonId,
      orElse: () => null,
    );

    if (specificPokemon != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PokemonDetailScreen(pokemonData: specificPokemon),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.moveData['move'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff878787),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff64B6ED),
            Color(0xffB7FCFB),
          ],
        )),
        padding: EdgeInsets.zero,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    width: 10000,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffFFFFFF),
                          Color(0xffC6C6C6),
                        ],
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.moveData['description'],
                              style: const TextStyle(fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Type',
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                  Image.asset('assets/images/icons/types/${widget.moveData['type']}.png')
                                ],
                              ),
                              const SizedBox(width: 50,),
                              Column(
                                children: [
                                  const Text(
                                    'Category',
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                  Image.asset('assets/images/icons/moves/${widget.moveData['category'].toString().toLowerCase()}_color.png')
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Power',
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    widget.moveData['power'],
                                    style: const TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 50,),
                              Column(
                                children: [
                                  const Text(
                                    'Accuracy',
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    widget.moveData['accuracy'],
                                    style: const TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 50,),
                              Column(
                                children: [
                                  const Text(
                                    'PP',
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    widget.moveData['pp'].toString(),
                                    style: const TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 30,),
                          const Text(
                              'Pokémon that can learn this move:',
                              style: TextStyle(fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
