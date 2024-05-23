import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:rotomdex/dex/service/bookmark_services.dart';
import 'package:rotomdex/shared/data/themes.dart';
import 'package:rotomdex/dex/widgets/pokemon_detail_tabs/pokemon_details_tab.dart';
import 'package:rotomdex/dex/widgets/pokemon_detail_tabs/pokemon_info_tab.dart';
import 'package:rotomdex/dex/widgets/pokemon_detail_tabs/pokemon_moves_tab.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Map pokemonData;

  const PokemonDetailScreen({Key? key, required this.pokemonData})
      : super(key: key);

  @override
  PokemonDetailScreenState createState() => PokemonDetailScreenState();
}

class PokemonDetailScreenState extends State<PokemonDetailScreen> {
  int _selectedIndex = 0;
  late String modelPath;

  BookmarkServices bookmarkServices = BookmarkServices();

  @override
  void initState() {
    super.initState();
    modelPath =
        'https://raw.githubusercontent.com/ViggoSeerden/rotomdex-models/main/models/${widget.pokemonData['id'].toString()}.glb';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    void playSound() {
      AudioPlayer player = AudioPlayer();
      player.play(UrlSource(
          "https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/${widget.pokemonData['id']}.ogg"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '#${widget.pokemonData['id'].toString()} ${widget.pokemonData['name']}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        iconTheme: const IconThemeData(color: BaseThemeColors.detailAppBarText),
        foregroundColor: BaseThemeColors.detailAppBarText,
        backgroundColor: BaseThemeColors.detailAppBarBG,
        actions: [
          IconButton(onPressed: playSound, icon: const Icon(Icons.volume_up)),
          IconButton(
              onPressed: () => bookmarkServices.saveBookmark(
                  'pokemon', widget.pokemonData['name'], context),
              icon: const Icon(Icons.bookmark)),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            BaseThemeColors.detailBGGradientTop,
            BaseThemeColors.detailBGGradientBottom,
          ],
        )),
        padding: EdgeInsets.zero,
        child: _buildBody(),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (Set<MaterialState> states) =>
                states.contains(MaterialState.selected)
                    ? const TextStyle(color: BaseThemeColors.detailNavBarTextActive)
                    : const TextStyle(color: BaseThemeColors.detailNavBarText),
          ),
        ),
        child: NavigationBar(
          backgroundColor: BaseThemeColors.detailNavBarBG,
          indicatorColor: BaseThemeColors.detailNavBarTextActive,
          shadowColor: Colors.black,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(
                Icons.info,
                color: Colors.white,
              ),
              label: 'General',
            ),
            NavigationDestination(
              icon: Icon(Icons.waving_hand_outlined, color: Colors.white),
              label: 'Moves',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz, color: Colors.white),
              label: 'Details',
            ),
            NavigationDestination(
              icon: Icon(Icons.threed_rotation, color: Colors.white),
              label: 'Model',
            ),
          ],
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return PokemonInfoTab(
          pokemonData: widget.pokemonData,
        );
      case 1:
        return PokemonMovesTab(
          pokemonData: widget.pokemonData,
        );
      case 2:
        return PokemonDetailsTab(
          pokemonData: widget.pokemonData,
        );
      case 3:
        return _buildARTab();
      default:
        return Container();
    }
  }

  Widget _buildARTab() {
    return Center(
      child: ModelViewer(src: modelPath, ar: true),
    );
  }
}
