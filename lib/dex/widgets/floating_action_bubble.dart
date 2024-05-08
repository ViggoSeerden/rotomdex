import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:rotomdex/dex/service/json_services.dart';
import 'package:rotomdex/shared/data/themes.dart';

class FABubble extends StatefulWidget {
  final List filterOptions;
  final List sortingOptions;
  final Function(String, String)? filterFunction;
  final Function(String, String)? sortingFunction;
  final Function(String) searchFunction;
  final Function reverseFunction;
  final Function resetFunction;

  const FABubble(
      {super.key,
      this.filterFunction,
      this.sortingFunction,
      required this.searchFunction,
      required this.reverseFunction,
      required this.resetFunction,
      required this.filterOptions,
      required this.sortingOptions});

  @override
  State<FABubble> createState() => _FABubbleState();
}

class _FABubbleState extends State<FABubble>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  JsonServices jsonServices = JsonServices();

  List<Widget> filterWidgets = [];
  List<Widget> sortingWidgets = [];

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: animationController);

    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
    loadFilters();
    loadSorting();
  }

  void loadFilters() async {
    List filters = await jsonServices.loadJsonData(
        'assets/pokemon/data/filter_options.json', context);

    for (String option in widget.filterOptions) {
      var specificFilter = filters
          .firstWhere((filter) => filter['name'] == option.toLowerCase(), orElse: () => null);

      if (specificFilter != null) {
        Widget filterWidget = Row(
          children: [
            Text(
              option,
              style: const TextStyle(
                  fontSize: 20, color: BaseThemeColors.fabPopupText),
            ),
            const SizedBox(width: 10),
            DropdownButton<String>(
              dropdownColor: Colors.grey,
              focusColor: Colors.grey,
              value: specificFilter['values'].first,
              items: specificFilter['values']
                  .map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: const TextStyle(
                          color: BaseThemeColors.detailContainerText)),
                );
              }).toList(),
              onChanged: (String? value) => {
                widget.filterFunction!(option.toLowerCase(), value!),
                Navigator.of(context).pop()
              },
            ),
          ],
        );

        filterWidgets.add(filterWidget);
      }
    }
  }

  void loadSorting() async {
    List sorting = await jsonServices.loadJsonData(
        'assets/pokemon/data/sorting_options.json', context);

    for (String option in widget.sortingOptions) {
      var specificSorting = sorting.firstWhere((sort) => sort['name'] == option.toLowerCase(),
          orElse: () => null);

      if (specificSorting != null) {
        Widget sortingWidget = TextButton(
          onPressed: () {
            widget.sortingFunction!(option.toLowerCase(), specificSorting['type']);
            Navigator.of(context).pop();
          },
          child: Text(
            option,
            style: const TextStyle(
                fontSize: 20, color: BaseThemeColors.fabPopupButtonText),
          ),
        );

        sortingWidgets.add(sortingWidget);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionBubble(
        onPress: () => {
              animationController.isCompleted
                  ? animationController.reverse()
                  : animationController.forward(),
            },
        backGroundColor: const Color(0xffEF866B),
        animation: animation,
        iconColor: Colors.white,
        iconData: Icons.settings,
        items: [
          Bubble(
            title: "Search",
            iconColor: Colors.white,
            bubbleColor: const Color(0xffEF866B),
            icon: Icons.search,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Enter Name:',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: BaseThemeColors.fabPopupText),
                    ),
                    content: SearchBar(
                      onChanged: (value) => widget.searchFunction(value),
                    ),
                    backgroundColor: BaseThemeColors.fabPopupBG,
                    actions: <Widget>[
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Close',
                            style: TextStyle(
                                fontSize: 20,
                                color: BaseThemeColors.fabPopupButtonText),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
              animationController.reverse();
            },
          ),
          if (widget.filterOptions.isNotEmpty) ...[
            Bubble(
              title: "Filter",
              iconColor: Colors.white,
              bubbleColor: const Color(0xffEF866B),
              icon: Icons.filter_alt,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: BaseThemeColors.fabPopupBG,
                      title: const Text(
                        'Filter By:',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: BaseThemeColors.fabPopupText),
                      ),
                      content: SizedBox(
                        height: 100,
                        child: Column(
                          children: filterWidgets,
                        ),
                      ),
                      actions: <Widget>[
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: BaseThemeColors.fabPopupButtonText),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
                animationController.reverse();
              },
            ),
          ],
          if (widget.filterOptions.isNotEmpty) ...[
            Bubble(
              title: "Sort",
              iconColor: Colors.white,
              bubbleColor: const Color(0xffEF866B),
              icon: Icons.sort,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: BaseThemeColors.fabPopupBG,
                      title: const Text(
                        'Sort By:',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: BaseThemeColors.fabPopupText),
                      ),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: sortingWidgets,
                      ),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                widget.reverseFunction();
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Reverse',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: BaseThemeColors.fabPopupButtonText),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: BaseThemeColors.fabPopupButtonText),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
                animationController.reverse();
              },
            ),
          ] else ...[
            Bubble(
              title: "Reverse",
              iconColor: Colors.white,
              bubbleColor: const Color(0xffEF866B),
              icon: Icons.sort,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                widget.reverseFunction();
                animationController.reverse();
              },
            ),
          ],
          Bubble(
            title: "Reset",
            iconColor: Colors.white,
            bubbleColor: const Color(0xffEF866B),
            icon: Icons.backspace,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              widget.resetFunction();
              animationController.reverse();
            },
          ),
        ]);
  }
}
