// Copyright 2025 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';

/// A service that handles all communication with the Firebase AI Imagen API.
///
/// This service demonstrates how to use the `imagenModel()` to generate images
/// from a text prompt. It showcases the text-to-image generation feature.
///
/// For more information, see the official documentation:
/// https://firebase.google.com/docs/ai-logic/generate-images-imagen?api=dev
///
/// This is a shared service, located in the /shared directory, because it is
/// used by multiple demos (Chat, Live API, and Imagen) to provide image
/// generation capabilities.
class ImagenService {
  final _model = FirebaseAI.googleAI().imagenModel(
    model: 'imagen-4.0-generate-001',
    generationConfig: ImagenGenerationConfig(numberOfImages: 1),
  );

  /// Generates a single image from a text prompt.
  ///
  /// Throws an exception if the API call fails, allowing the UI to handle it.
  Future<Uint8List> generateImage(String prompt) async {
    try {
      final res = await _model.generateImages(prompt);
      return res.images.first.bytesBase64Encoded;
    } catch (e) {
      log('Error generating image: $e');
      rethrow;
    }
  }

  /// Generates multiple images from a text prompt.
  ///
  /// Throws an exception if the API call fails, allowing the UI to handle it.
  Future<List<Uint8List>> generateImages(
    String prompt, {
    int numberOfImages = 4,
  }) async {
    try {
      final model = FirebaseAI.googleAI().imagenModel(
        model: 'imagen-4.0-generate-001',
        generationConfig: ImagenGenerationConfig(
          numberOfImages: numberOfImages,
        ),
      );
      final res = await model.generateImages(prompt);
      return res.images
          .map((ImagenInlineImage e) => e.bytesBase64Encoded)
          .toList();
    } catch (e) {
      log('Error generating images: $e');
      rethrow;
    }
  }
}
