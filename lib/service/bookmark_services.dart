import 'package:flutter/material.dart';
import 'package:rotomdex/service/json_services.dart';
import 'package:rotomdex/service/message_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkServices {
  final MessageServices messageServices;
  final JsonServices jsonServices;
  late SharedPreferences prefs;

  BookmarkServices()
      : jsonServices = JsonServices(),
        messageServices = MessageServices();

  Future<void> saveBookmark(
      String type, String item, BuildContext context) async {
    prefs = await SharedPreferences.getInstance();

    List<String>? bookmarks = prefs.getStringList('${type}_bookmarks') ?? [];
    if (bookmarks.length >= 15) {
      messageServices.showMessage(
          'You have reached the maximum amount of $type bookmarks.', context);
    } else if (!bookmarks.contains(item)) {
      bookmarks.add(item);
      await prefs.setStringList('${type}_bookmarks', bookmarks);
      messageServices.showMessage(
          '$item was added to your bookmarks.', context);
    } else {
      messageServices.showMessage('$item is already bookmarked.', context);
    }
  }

  Future<void> removeFromBookmarks(String type, String value) async {
    prefs = await SharedPreferences.getInstance();

    switch (type) {
      case 'pokemon':
        List<String>? pokemon = prefs.getStringList('pokemon_bookmarks') ?? [];
        pokemon.remove(value);
        await prefs.setStringList('pokemon_bookmarks', pokemon);
        break;
      case 'move':
        List<String>? moves = prefs.getStringList('move_bookmarks') ?? [];
        moves.remove(value);
        await prefs.setStringList('move_bookmarks', moves);
        break;
      case 'ability':
        List<String>? abilities =
            prefs.getStringList('ability_bookmarks') ?? [];
        abilities.remove(value);
        await prefs.setStringList('ability_bookmarks', abilities);
        break;
      default:
        break;
    }
  }

  Future<(List, List, List)> getBookmarks(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();

    List<String>? pokemon = prefs.getStringList('pokemon_bookmarks') ?? [];
    List<String>? moves = prefs.getStringList('move_bookmarks') ?? [];
    List<String>? abilities = prefs.getStringList('ability_bookmarks') ?? [];

    print(pokemon);

    List pokemonData = [];
    List moveData = [];
    List abilityData = [];

    List pdata = await jsonServices.loadJsonData(
        'assets/pokemon/data/kanto_expanded.json', context);
    List mdata = await jsonServices.loadJsonData(
        'assets/pokemon/data/moves.json', context);
    List adata = await jsonServices.loadJsonData(
        'assets/pokemon/data/abilities.json', context);

    for (var pokemon in pokemon) {
      Map<String, dynamic>? specificPokemon = pdata.firstWhere(
        (curpokemon) =>
            curpokemon['name'].toLowerCase() == pokemon.toLowerCase(),
        orElse: () => null,
      );

      if (specificPokemon != null) {
        pokemonData.add(specificPokemon);
      }
    }

    for (var move in moves) {
      Map<String, dynamic>? specificMove = mdata.firstWhere(
        (curmove) => curmove['name'] == move,
        orElse: () => null,
      );

      if (specificMove != null) {
        moveData.add(specificMove);
      }
    }

    for (var ability in abilities) {
      Map<String, dynamic>? specificAbility = adata.firstWhere(
        (curability) => curability['name'] == ability,
        orElse: () => null,
      );

      if (specificAbility != null) {
        abilityData.add(specificAbility);
      }
    }

    return (pokemonData, moveData, abilityData);
  }
}
