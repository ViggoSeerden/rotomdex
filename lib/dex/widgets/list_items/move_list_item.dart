import 'package:flutter/material.dart';
import 'package:rotomdex/dex/screens/move.dart';
import 'package:rotomdex/shared/data/themes.dart';

class MoveListItem extends StatelessWidget {
  final Map item;
  final String? level;
  final Color shadowColor;
  final Color bg;
  final Color text;
  final Color accentText;
  final Function(String, String)? removeFromBookmarks;

  const MoveListItem(
      {super.key,
      required this.item,
      this.level,
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
            builder: (context) => MovePage(moveData: item),
          ),
        );
      },
      onDoubleTap: () => removeFromBookmarks!('move', item['name']),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: BaseThemeColors.dexItemBG,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Image.asset(
            'assets/images/icons/types/${item['type']}.png',
            width: 30,
            height: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 130,
            child: Text(
              item['name'],
              style: const TextStyle(
                  fontSize: 18, color: BaseThemeColors.dexItemText),
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
                'Power: ${item['power']}',
                style: const TextStyle(
                    fontSize: 14, color: BaseThemeColors.dexItemAccentText),
                textAlign: TextAlign.start,
              ),
              Text(
                'Accuracy: ${item['accuracy']}',
                style: const TextStyle(
                    fontSize: 14, color: BaseThemeColors.dexItemAccentText),
                textAlign: TextAlign.start,
              ),
              Text(
                'PP: ${item['pp']}',
                style: const TextStyle(
                    fontSize: 14, color: BaseThemeColors.dexItemAccentText),
                textAlign: TextAlign.start,
              ),
              if (level != null) ...[
                Text(
                  'Level: $level',
                  style: const TextStyle(
                      fontSize: 14, color: BaseThemeColors.dexItemAccentText),
                  textAlign: TextAlign.start,
                ),
              ]
            ],
          )),
          const SizedBox(
            width: 20,
          ),
          if (item['category'].toString() != '--') ...[
            Image.asset(
              'assets/images/icons/moves/${item['category'].toString().toLowerCase()}_color.png',
              width: 30,
              height: 30,
            ),
          ]
        ]),
      ),
    );
  }
}
