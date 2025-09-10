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

import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../../shared/ui/app_frame.dart';
import '../../shared/ui/app_spacing.dart';
import '../../shared/firebaseai_imagen_service.dart';
import './ui_components/ui_components.dart';

class ImagenDemo extends StatefulWidget {
  const ImagenDemo({super.key});

  @override
  State<ImagenDemo> createState() => _ImagenDemoState();
}

class _ImagenDemoState extends State<ImagenDemo> {
  // Service for interacting with the Gemini API.
  final _imagenService = ImagenService();

  // UI State
  bool _loading = false;
  List<Uint8List> images = [];
  TextEditingController promptController = TextEditingController(
    text:
        'Hot air balloons rising over the San Francisco Bay at golden hour '
        'with a view of the Golden Gate Bridge. Make it anime style.',
  );

  void generateImages(BuildContext context, String prompt) async {
    setState(() {
      _loading = true;
      images = []; // Clear previous images while loading
    });

    try {
      final newImages = await _imagenService.generateImages(
        prompt,
        numberOfImages: 4,
      );
      setState(() {
        images = newImages;
      });
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Imagen Demo')),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: AppFrame(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s8),
            child: Column(
              children: [
                ImageDisplay(loading: _loading, images: images),
                const SizedBox.square(dimension: AppSpacing.s8),
                PromptInput(
                  promptController: promptController,
                  loading: _loading,
                  generateImages: generateImages,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
