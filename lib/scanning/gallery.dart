/*
 * Copyright 2023 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../scanning/image_classification_helper.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/gestures.dart';
import 'package:rotomdex/dex/pokemon.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  ImageClassificationHelper? imageClassificationHelper;
  final imagePicker = ImagePicker();
  String? imagePath;
  img.Image? image;
  Map<String, double>? classification;
  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;

  @override
  void initState() {
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper!.initHelper();
    super.initState();
  }

  // Clean old results when press some take picture button
  void cleanResult() {
    imagePath = null;
    image = null;
    classification = null;
    setState(() {});
  }

  // Process picked image
  Future<void> processImage() async {
    if (imagePath != null) {
      // Read image bytes from file
      final imageData = File(imagePath!).readAsBytesSync();

      // Decode image using package:image/image.dart (https://pub.dev/image)
      image = img.decodeImage(imageData);
      setState(() {});
      classification = await imageClassificationHelper?.inferenceImage(image!);
      setState(() {});
    }
  }

  Future<void> navigateToPokemon(
      BuildContext context, String pokemonName) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/pokemon/data/pokemon_expanded.json');

    List<dynamic> pokemonList = jsonDecode(data);

    Map<String, dynamic>? specificPokemon = pokemonList.firstWhere(
      (pokemon) => pokemon['name'].toString().toLowerCase() == pokemonName,
      orElse: () => null,
    );

    if (specificPokemon != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PokemonDetailScreen(pokemonData: specificPokemon),
        ),
      );
    } else {
      print('Pokemon not found!');
    }
  }

  @override
  void dispose() {
    imageClassificationHelper?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (cameraIsAvailable)
                TextButton.icon(
                  onPressed: () async {
                    cleanResult();
                    final result = await imagePicker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (result != null) {
                      final croppedImage = await ImageCropper().cropImage(
                          sourcePath: result.path,
                          aspectRatioPresets: [
                            CropAspectRatioPreset.square,
                            CropAspectRatioPreset.ratio3x2,
                            CropAspectRatioPreset.original,
                            CropAspectRatioPreset.ratio4x3,
                            CropAspectRatioPreset.ratio16x9
                          ],
                          uiSettings: [
                            AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor: const Color(0xff6ae2f2),
                                toolbarWidgetColor: Colors.black,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                            IOSUiSettings(
                              title: 'Cropper',
                            ),
                          ]);

                      if (croppedImage != null) {
                        imagePath = croppedImage.path;
                        setState(() {});
                        processImage();
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 48,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Take a photo",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              TextButton.icon(
                onPressed: () async {
                  cleanResult();
                  final result = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (result != null) {
                    final croppedImage = await ImageCropper().cropImage(
                        sourcePath: result.path,
                        aspectRatioPresets: [
                          CropAspectRatioPreset.square,
                          CropAspectRatioPreset.ratio3x2,
                          CropAspectRatioPreset.original,
                          CropAspectRatioPreset.ratio4x3,
                          CropAspectRatioPreset.ratio16x9
                        ],
                        uiSettings: [
                          AndroidUiSettings(
                              toolbarTitle: 'Cropper',
                              toolbarColor: const Color(0xff6ae2f2),
                              toolbarWidgetColor: Colors.black,
                              initAspectRatio: CropAspectRatioPreset.original,
                              lockAspectRatio: false),
                          IOSUiSettings(
                            title: 'Cropper',
                          ),
                        ]);

                    if (croppedImage != null) {
                      imagePath = croppedImage.path;
                      setState(() {});
                      processImage();
                    }
                  }
                },
                icon: const Icon(
                  Icons.photo,
                  size: 48,
                  color: Colors.white,
                ),
                label: const Text(
                  "Pick from gallery",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white),
          Expanded(
              child: Stack(
            alignment: Alignment.center,
            children: [
              if (imagePath != null) Image.file(File(imagePath!)),
              if (image == null)
                const Text(
                  "Take a photo or choose one from the gallery to "
                  "inference.",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (image != null) ...[
                    if (imageClassificationHelper?.inputTensor != null)
                      Text(
                        'Input: (shape: ${imageClassificationHelper?.inputTensor.shape} type: '
                        '${imageClassificationHelper?.inputTensor.type})',
                      ),
                    if (imageClassificationHelper?.outputTensor != null)
                      Text(
                        'Output: (shape: ${imageClassificationHelper?.outputTensor.shape} '
                        'type: ${imageClassificationHelper?.outputTensor.type})',
                      ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\n\nThis Pokemon is...',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                  const Spacer(),
                  // Show classification result
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        if (classification != null)
                          ...(classification!.entries.toList()
                                ..sort(
                                  (a, b) => a.value.compareTo(b.value),
                                ))
                              .reversed
                              .take(3)
                              .map(
                                (e) => Container(
                                  padding: const EdgeInsets.all(12),
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  e.key.split(' ').skip(1).join(' '),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  String pokemonName = (e.key
                                                          .split(' ')
                                                          .skip(1)
                                                          .join(' '))
                                                      .toLowerCase();
                                                  navigateToPokemon(
                                                      context, pokemonName);
                                                },
                                            ),
                                            const TextSpan(
                                                text: '  '), // Add some spacing
                                          ],
                                        ),
                                      ),
                                      Text(
                                          '${(e.value * 100).toStringAsFixed(0)}%',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18))
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }
}
