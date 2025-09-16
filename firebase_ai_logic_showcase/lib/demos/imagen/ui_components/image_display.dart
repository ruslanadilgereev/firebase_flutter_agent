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

import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../shared/ui/app_spacing.dart';
import '../../../shared/ui/blaze_warning.dart';

class ImageDisplay extends StatelessWidget {
  final bool loading;
  final List<Uint8List> images;

  const ImageDisplay({super.key, required this.loading, required this.images});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints.loose(
              Size(double.infinity, constraints.maxWidth),
            ),
            child: Center(
              child: loading
                  ? CircularProgressIndicator()
                  : images.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                          'Write a prompt below to generate images.',
                        ),
                        SizedBox.square(dimension: AppSpacing.s8),
                        BlazeWarning(),
                      ],
                    )
                  : CarouselView.weighted(
                      enableSplash: false,
                      itemSnapping: true,
                      flexWeights: [1, 6, 1],
                      children: images
                          .map((image) => Image.memory(image))
                          .toList(),
                    ),
            ),
          );
        },
      ),
    );
  }
}
