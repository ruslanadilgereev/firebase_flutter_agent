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
import '../../../shared/ui/app_spacing.dart';

class PromptInput extends StatelessWidget {
  final TextEditingController promptController;
  final bool loading;
  final void Function(BuildContext, String) generateImages;

  const PromptInput({
    super.key,
    required this.promptController,
    required this.loading,
    required this.generateImages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.s8),
            child: TextField(
              decoration: InputDecoration(
                label: const Text('Prompt'),
                fillColor: Theme.of(context).colorScheme.onSecondaryFixed,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.s16),
                ),
              ),
              maxLines: 4,
              controller: promptController,
              enabled: !loading,
              onTap: () {
                promptController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: promptController.text.length,
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.s8),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.s16),
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            onPressed: loading
                ? null
                : () => generateImages(context, promptController.text),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.s24,
                horizontal: 0,
              ),
              child: Column(
                children: [
                  const Icon(size: 32, Icons.brush),
                  const SizedBox.square(dimension: AppSpacing.s8),
                  const Text(textAlign: TextAlign.center, 'Create\nImage'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
