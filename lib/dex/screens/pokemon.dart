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
        'assets/pokemon/models/${widget.pokemonData['id'].toString()}.glb';
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: BaseThemeColors.detailAppBarText),
        centerTitle: true,
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffACACAC),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.waving_hand_outlined),
            label: 'Moves',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.threed_rotation),
            label: 'Model',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
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
