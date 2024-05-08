import 'package:flutter/material.dart';
import 'package:rotomdex/dex/screens/ability.dart';
import 'package:rotomdex/dex/screens/move.dart';
import 'package:rotomdex/dex/screens/pokemon.dart';
import 'package:rotomdex/dex/service/json_services.dart';
import 'package:rotomdex/shared/services/message_services.dart';

class NavigationServices {
  final JsonServices jsonServices;
  final MessageServices messageServices;

  NavigationServices(): jsonServices = JsonServices(), messageServices = MessageServices();

  void navigateToPokemonViaID(
      BuildContext context, int pokemonId, List pokemon) async {
    Map<String, dynamic>? specificPokemon = pokemon.firstWhere(
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

  void navigateToPokemon(
      BuildContext context, String pokemonName, String currentPokemon) async {
    MessageServices messageServices = MessageServices();

    List<dynamic> pokemonList = await jsonServices.loadJsonData(
        'assets/pokemon/data/kanto_expanded.json', context);

    Map<String, dynamic>? specificPokemon = pokemonList.firstWhere(
      (pokemon) =>
          pokemon['name'].toString().toLowerCase() == pokemonName.toLowerCase(),
      orElse: () => null,
    );

    if (specificPokemon != null) {
      if (specificPokemon['name'] != currentPokemon) {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) =>
                PokemonDetailScreen(pokemonData: specificPokemon),
          ),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      messageServices.showMessage(
          'There is no data on $pokemonName in this app.', context);
    }
  }

  void navigateToAbility(BuildContext context, String name) async {
    JsonServices jsonServices = JsonServices();

    List<dynamic> abilityList = await jsonServices.loadJsonData(
        'assets/pokemon/data/abilities.json', context);

    Map<String, dynamic>? ability = abilityList.firstWhere(
      (ability) => ability['name'] == name,
      orElse: () => null,
    );

    if (ability != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AbilityPage(abilityData: ability),
        ),
      );
    }
  }

  void navigateToMove(BuildContext context, String name) async {
    List<dynamic> movesList = await jsonServices.loadJsonData(
        'assets/pokemon/data/moves.json', context);

    Map<String, dynamic>? move = movesList.firstWhere(
      (move) => move['move'] == name,
      orElse: () => null,
    );

    if (move != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovePage(moveData: move),
        ),
      );
    }
  }
}
