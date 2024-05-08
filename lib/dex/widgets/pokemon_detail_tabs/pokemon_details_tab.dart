import 'package:flutter/material.dart';
import 'package:rotomdex/shared/data/themes.dart';

class PokemonDetailsTab extends StatefulWidget {
  final Map pokemonData;

  const PokemonDetailsTab({super.key, required this.pokemonData});

  @override
  State<PokemonDetailsTab> createState() => _PokemonDetailsTabState();
}

class _PokemonDetailsTabState extends State<PokemonDetailsTab> {
  @override
  Widget build(BuildContext context) {
    List<Widget> statWidgets = [];

    for (var entry in widget.pokemonData['ev_yield'].entries) {
      String statName = entry.key;
      int statValue = entry.value;

      if (statValue > 0) {
        Widget statRow = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${statValue.toString()} $statName',
              style: const TextStyle(
                  fontSize: 16, color: BaseThemeColors.detailContainerText),
              textAlign: TextAlign.start,
            ),
          ],
        );

        statWidgets.add(statRow);
      }
    }

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(125, 0, 0, 0),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      BaseThemeColors.detailContainerGradientTop,
                      BaseThemeColors.detailContainerGradientBottom,
                    ],
                  ),
                ),
                child: Center(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      const Text('Weaknesses',
                          style: TextStyle(
                              fontSize: 24,
                              color: BaseThemeColors.detailContainerText)),
                      const SizedBox(height: 10),
                      Wrap(alignment: WrapAlignment.center, children: [
                        if ((widget.pokemonData['weaknesses'] as List)
                            .isNotEmpty) ...[
                          for (var type
                              in widget.pokemonData['weaknesses']) ...[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                  'assets/images/icons/types/$type.png'),
                            ),
                          ]
                        ] else ...[
                          const Text(
                            'This Pokémon has no weaknesses.',
                            style: TextStyle(
                                fontSize: 20,
                                color: BaseThemeColors.detailContainerText),
                          )
                        ],
                      ]),
                      const SizedBox(height: 30),
                      const Text('Resistances',
                          style: TextStyle(
                              fontSize: 24,
                              color: BaseThemeColors.detailContainerText)),
                      const SizedBox(height: 10),
                      Wrap(alignment: WrapAlignment.center, children: [
                        if ((widget.pokemonData['resistances'] as List)
                            .isNotEmpty) ...[
                          for (var type
                              in widget.pokemonData['resistances']) ...[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                  'assets/images/icons/types/$type.png'),
                            ),
                          ]
                        ] else ...[
                          const Text(
                            'This Pokémon has no resistances.',
                            style: TextStyle(
                                fontSize: 20,
                                color: BaseThemeColors.detailContainerText),
                          )
                        ],
                      ]),
                      const SizedBox(height: 30),
                      const Text('Immunities',
                          style: TextStyle(
                              fontSize: 24,
                              color: BaseThemeColors.detailContainerText)),
                      const SizedBox(height: 10),
                      Wrap(alignment: WrapAlignment.center, children: [
                        if ((widget.pokemonData['zero_effect_types'] as List)
                            .isNotEmpty) ...[
                          for (var type
                              in widget.pokemonData['zero_effect_types']) ...[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                  'assets/images/icons/types/$type.png'),
                            ),
                          ]
                        ] else ...[
                          const Text(
                            'This Pokémon has no immunities.',
                            style: TextStyle(
                                fontSize: 20,
                                color: BaseThemeColors.detailContainerText),
                          )
                        ],
                      ]),
                      const SizedBox(height: 30),
                      const Text('Breeding',
                          style: TextStyle(
                              fontSize: 24,
                              color: BaseThemeColors.detailContainerText)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(children: [
                            const Text(
                              'Egg Group(s):',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            Text(widget.pokemonData['egg_group1'],
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                            if (widget.pokemonData['egg_group2'] != null &&
                                widget
                                    .pokemonData['egg_group2'].isNotEmpty) ...[
                              Text(widget.pokemonData['egg_group2'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color:
                                          BaseThemeColors.detailContainerText)),
                            ],
                          ]),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(children: [
                            const Text(
                              'Egg Cycles:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            Text(
                                '${widget.pokemonData['egg_cycles'].toString()} cycles',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                            Text(
                                '${widget.pokemonData['steps_to_hatch'].toString()} steps',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                          ]),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(children: [
                            const Text(
                              'Gender Ratio:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            Text(
                                '${widget.pokemonData['gender_ratio']['male']} male',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                            Text(
                                '${widget.pokemonData['gender_ratio']['male']} female',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text('Experience',
                          style: TextStyle(
                              fontSize: 24,
                              color: BaseThemeColors.detailContainerText)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(children: [
                            const Text(
                              'Base EXP Yield:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            Text(
                                '${widget.pokemonData['base_experience_yield']} EXP',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                          ]),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(children: [
                            const Text(
                              'EXP Growth Rate:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            Text(
                                widget.pokemonData['exp_growth_rate']
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text('Miscellaneous',
                          style: TextStyle(
                              fontSize: 24,
                              color: BaseThemeColors.detailContainerText)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(children: [
                            const Text(
                              'Catch Rate:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            Text(widget.pokemonData['catch_rate'].toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                          ]),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(children: [
                            const Text(
                              'Base Happiness:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText),
                            ),
                            Text(
                                widget.pokemonData['base_happiness'].toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color:
                                        BaseThemeColors.detailContainerText)),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          const Text('EV Yield:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BaseThemeColors.detailContainerText)),
                          Column(children: statWidgets)
                        ],
                      ),
                      const SizedBox(height: 30)
                    ],
                  ),
                )),
              ),
            ),
          ),
          const SizedBox(height: 30)
        ],
      ),
    );
  }
}
