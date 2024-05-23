import 'package:flutter/material.dart';
import 'package:rotomdex/shared/data/themes.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) searchFunction;

  const SearchBarWidget({super.key, required this.searchFunction});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchBar(
          onChanged: (value) => widget.searchFunction(value),
          padding: const MaterialStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              return BaseThemeColors.mainMenuListBG;
            //   if (states.contains(MaterialState.disabled)) {
            //     // Return color for disabled state
            //     return Colors.grey;
            //   }
            //   // Return default color
            //   return Colors.white;
            },
          ),
          textStyle: const MaterialStatePropertyAll<TextStyle>(
            TextStyle(color: Colors.white)
          ),
          leading: const Icon(Icons.search, color: Colors.white,),
          trailing: <Widget>[
            Tooltip(
              message: 'Change brightness mode',
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_alt, color: Colors.white,),
              ),
            )
          ],
        ));
  }
}
