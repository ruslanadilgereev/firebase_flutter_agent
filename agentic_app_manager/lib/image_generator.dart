import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';

class AIImageGenerator {
  ImagenModel model = FirebaseAI.vertexAI().imagenModel(
    model: 'imagen-3.0-generate-002',
    generationConfig: ImagenGenerationConfig(numberOfImages: 4),
  );

  Future<List<Uint8List>> generateImages(String prompt) async {
    final res = await model.generateImages(prompt);

    final images =
        res.images.map((ImagenInlineImage e) => e.bytesBase64Encoded).toList();

    return images;
  }
}
