import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rotomdex/dex/service/json_services.dart';

class DetailServices {
  final JsonServices jsonServices;

  DetailServices() : jsonServices = JsonServices();

  Future<List> getPokemonWithAbility(
      String ability, BuildContext context, String type) async {
    var pokemonData = await jsonServices.loadJsonData(
        'assets/pokemon/data/kanto_expanded.json', context);
        
    List filteredPokemon = [];

    if (type == 'hidden') {
      filteredPokemon = pokemonData
          .where(
            (pokemon) =>
                pokemon['hidden_ability'].toLowerCase() == ability,
          )
          .toList();
    } else {
      filteredPokemon = pokemonData
          .where(
            (pokemon) =>
                pokemon['ability1'].toLowerCase() == ability ||
                pokemon['ability2'].toLowerCase() == ability
          )
          .toList();
    }

    return filteredPokemon;
  }

  Future<List> getPokemonWithMove(
      String moveName, BuildContext context, String movetype) async {
    var pokemon = await jsonServices.loadJsonData(
        'assets/pokemon/data/kanto_expanded.json', context);

    var movesets = await jsonServices.loadJsonData(
        'assets/pokemon/data/kanto_moves.json', context);

    List pokemonWithMove = [];

    for (var moveset in movesets) {
      var pokemonId = moveset['pokemon_id'];
      if (movetype == 'level_up') {
        for (var move in moveset['level_up']) {
          if (move['move_name'] == moveName) {
            var pokemonData = pokemon.firstWhere((p) => p['id'] == pokemonId,
                orElse: () => null);
            if (pokemonData != null) {
              pokemonWithMove.add(pokemonData);
              break; // no need to keep checking level up moves for this Pokemon
            }
          }
        }
      } else {
        if (moveset[movetype].contains(moveName)) {
          var pokemonData = pokemon.firstWhere((p) => p['id'] == pokemonId,
              orElse: () => null);
          if (pokemonData != null) {
            pokemonWithMove.add(pokemonData);
          }
        }
      }
    }

    return pokemonWithMove;
  }

  Future<(List, List, List, List, String)> getPokemonMoveset(
      int pokemonId, BuildContext context) async {
    List<dynamic> data = await jsonServices.loadJsonData(
        'assets/pokemon/data/kanto_moves.json', context);

    var moveset = data.firstWhere((set) => set['pokemon_id'] == pokemonId);
    String source = moveset['data'];

    // ignore: use_build_context_synchronously
    List<dynamic> moveData = await jsonServices.loadJsonData(
        'assets/pokemon/data/moves.json', context);

    List<dynamic> levelUp = [];
    List<dynamic> levelUpLvls = [];
    for (var move in moveset['level_up'] as List) {
      var moveName = move['move_name'];
      var moveDetails = moveData.firstWhere((move) => move['name'] == moveName,
          orElse: () => null);
      if (moveDetails != null) {
        levelUp.add(moveDetails);
        levelUpLvls.add(move['level']);
      }
    }

    List tm = [];
    for (String moveName in moveset['tm']) {
      var moveDetails = moveData.firstWhere((move) => move['name'] == moveName,
          orElse: () => null);
      if (moveDetails != null) {
        tm.add(moveDetails);
      }
    }

    List egg = [];
    for (String moveName in moveset['egg']) {
      var moveDetails = moveData.firstWhere((move) => move['name'] == moveName,
          orElse: () => null);
      if (moveDetails != null) {
        egg.add(moveDetails);
      }
    }

    return (levelUp, levelUpLvls, tm, egg, source);
  }
}
