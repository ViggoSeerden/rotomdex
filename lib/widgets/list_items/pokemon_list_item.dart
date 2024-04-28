import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rotomdex/detail/pokemon.dart';
import 'package:rotomdex/utils/themes.dart';

class PokemonListItem extends StatelessWidget {
  final Map item;
  final Color text;
  final Color bg;
  final Function(String, String)? removeFromBookmarks;

  const PokemonListItem(
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
      child: Tooltip(
        richMessage: TextSpan(text: item['height']['meters'], children: [
          TextSpan(text: '\n${item['weight']['kilograms']}'),
          const TextSpan(text: '\nAbilities:'),
          TextSpan(text: '\n  ${item['ability1']}'),
          if (item['ability2'].isNotEmpty) ...[
            TextSpan(text: '\n  ${item['ability2']}'),
          ],
          if (item['hidden_ability'].isNotEmpty) ...[
            TextSpan(text: '\n  ${item['hidden_ability']} (H)'),
          ],
          TextSpan(
              text:
                  '\nBST: ${(item['base_stats']['HP'] + item['base_stats']['Attack'] + item['base_stats']['Defense'] + item['base_stats']['Speed'] + item['base_stats']['SpAttack'] + item['base_stats']['SpDefense']).toString()}'),
        ]),
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
                      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${item['id']}.png",
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset('assets/images/icons/types/${item['type1']}.png',
                  width: 20, height: 20),
              if (item['type2'] != null && item['type2'].isNotEmpty) ...[
                const SizedBox(width: 5),
                Image.asset('assets/images/icons/types/${item['type2']}.png',
                    width: 20, height: 20),
              ],
            ]),
          ],
        ),
      ),
    );
  }
}
