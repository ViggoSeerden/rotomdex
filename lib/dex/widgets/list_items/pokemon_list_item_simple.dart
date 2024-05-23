import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rotomdex/dex/screens/pokemon.dart';
import 'package:rotomdex/shared/data/themes.dart';

class PokemonListItemSimple extends StatelessWidget {
  final Map item;
  final Color text;
  final Color bg;
  final Function(String, String)? removeFromBookmarks;

  const PokemonListItemSimple(
      {super.key,
      required this.item,
      required this.text,
      this.removeFromBookmarks,
      required this.bg});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetailScreen(pokemonData: item),
          ),
        );
      },
      onDoubleTap: () => removeFromBookmarks!('pokemon', item['name']),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: BaseThemeColors.dexItemBG,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(125, 0, 0, 0),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                width: 100,
                height: 130,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${item['id']}.png",
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          width: 70,
                          height: 70,
                          fadeInDuration: Durations.short1,
                          cacheKey: "pokemon_${item['id']}",
                          cacheManager: CacheManager(
                            Config(
                              "pokemon_images_cache",
                              maxNrOfCacheObjects: 500,
                              stalePeriod: const Duration(days: 7),
                            ),
                          ),
                        ),
                      ),
                      Text('${item['name']}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: text,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Text('#${item['id']}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: text,
                              fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
