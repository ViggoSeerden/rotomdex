import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rotomdex/detail/pokemon.dart';

class AbilityPage extends StatefulWidget {
  final Map abilityData;

  const AbilityPage({Key? key, required this.abilityData}) : super(key: key);

  @override
  AbilityPageState createState() => AbilityPageState();
}

class AbilityPageState extends State<AbilityPage> {
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
          widget.abilityData['name'],
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
                              widget.abilityData['description'],
                              style: const TextStyle(fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30,),
                          const Text(
                              'Pokémon that can have this ability:',
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
