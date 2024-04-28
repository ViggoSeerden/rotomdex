import 'package:flutter/material.dart';
import 'package:rotomdex/detail/ability.dart';
import 'package:rotomdex/utils/themes.dart';

class AbilityListItem extends StatelessWidget {
  final Map item;
  final Color shadowColor;
  final Color bg;
  final Color text;
  final Color accentText;
  final Function(String, String)? removeFromBookmarks;

  const AbilityListItem(
      {super.key,
      required this.item,
      this.shadowColor = Colors.transparent,
      this.removeFromBookmarks,
      required this.bg,
      required this.text,
      required this.accentText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AbilityPage(abilityData: item),
          ),
        );
      },
      onDoubleTap: () => removeFromBookmarks!('ability', item['name']),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: BaseThemeColors.dexItemBG,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                spreadRadius: 0,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['name'],
                style: const TextStyle(
                    fontSize: 18, color: BaseThemeColors.dexItemText),
              ),
              Text(
                item['description'],
                style: const TextStyle(
                    fontSize: 14, color: BaseThemeColors.dexItemAccentText),
              )
            ],
          )),
    );
  }
}
