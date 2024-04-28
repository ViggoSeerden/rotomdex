import 'dart:convert';

import 'package:flutter/material.dart';

class JsonServices {
  Future<dynamic> loadJsonData(String path, BuildContext context) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString(path);

    return jsonDecode(data);
  }
}
