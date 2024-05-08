class SearchServices {
  List<Map<String, dynamic>> sortItem(
      List<Map<String, dynamic>> data, String argumentType, String argument) {
    data.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
      if (argumentType == 'int') {
        return a[argument].compareTo(b[argument]);
      } else {
        return a[argument].toString().compareTo(b[argument].toString());
      }
    });
    return data;
  }

  List<Map<String, dynamic>> searchItem(var data, String input) {
    List<Map<String, dynamic>> filteredData = data
        .where((item) =>
            item['name'].toString().toLowerCase().contains(input.toLowerCase()))
        .toList();
    return filteredData;
  }

  List<Map<String, dynamic>> filterPokemon(
      var data, String argument, String input) {
    List<Map<String, dynamic>> filteredData = [];

    if (argument == 'type') {
      filteredData = data
          .where(
            (pokemon) =>
                pokemon['type1'].toLowerCase() == input.toLowerCase() ||
                pokemon['type2'].toLowerCase() == input.toLowerCase(),
          )
          .toList();
    } else if (argument == 'egg_group') {
      filteredData = data
          .where(
            (pokemon) =>
                pokemon['egg_group1'].toLowerCase() == input.toLowerCase() ||
                pokemon['egg_group2'].toLowerCase() == input.toLowerCase(),
          )
          .toList();
    } else {
      filteredData = data
          .where(
            (pokemon) =>
                pokemon[argument].toString().toLowerCase() ==
                input.toLowerCase(),
          )
          .toList();
    }

    return filteredData;
  }

  List<Map<String, dynamic>> filterMoves(
      var data, String argument, String input) {
    List<Map<String, dynamic>> filteredData = data
        .where(
          (move) =>
              move[argument].toString().toLowerCase() == input.toLowerCase(),
        )
        .toList();
    return filteredData;
  }
}
