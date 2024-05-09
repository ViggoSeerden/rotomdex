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
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  color: BaseThemeColors.dexItemBG,
                ),
                width: 65,
                height: 65,
              ),
              CachedNetworkImage(
                imageUrl:
                    "https://projectpokemon.org/images/sprites-models/sv-sprites-home/${item['id'].toString().padLeft(4, '0')}.png",
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
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
            ],
          ),
          Text('#${item['id']} ${item['name']}',
              style: TextStyle(color: text, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
