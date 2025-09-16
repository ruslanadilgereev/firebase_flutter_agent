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
import 'package:url_launcher/link.dart';
import 'shared/ui/app_frame.dart';
import 'demos/chat/chat_demo.dart';
import 'demos/multimodal/multimodal_demo.dart';
import './demos/imagen/imagen_demo.dart';
import './demos/live_api/live_api_demo.dart';
import 'firebase_options.dart';

class Demo {
  final String name;
  final String description;
  final Widget icon;
  final Widget page;

  Demo({
    required this.name,
    required this.description,
    required this.icon,
    required this.page,
  });
}

List<Demo> demos = [
  Demo(
    name: 'Live API',
    description: 'Real-time bidirectional audio & video streaming with Gemini.',
    icon: Icon(size: 32, Icons.video_call),
    page: LiveAPIDemo(),
  ),
  Demo(
    name: 'Multimodal Prompt',
    description: 'Ask Gemini about an image, audio, video, or PDF file.',
    icon: Icon(size: 32, Icons.attach_file),
    page: MultimodalDemo(),
  ),
  Demo(
    name: 'Chat with Gemini * ',
    description:
        'Support for many models with chat history, tool calling, and image generation.',
    icon: Icon(size: 32, Icons.chat),
    page: ChatDemo(),
  ),
  Demo(
    name: 'Generate Images with Nano Banana *',
    description: 'Generate an image using a text prompt.',
    icon: Text(style: TextStyle(fontSize: 28), '🍌'),
    page: ImageGenerationDemo(),
  ),
];

class DemoHomeScreen extends StatelessWidget {
  const DemoHomeScreen({super.key});

  void showMoreInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        width: double.infinity,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Questions or Feedback?'),
            actions: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(textAlign: TextAlign.center, 'Please let us know!'),
                ],
              ),
              SelectableText(
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
                'github.com/firebase/flutterfire/issues',
              ),
              SizedBox.square(dimension: 32),
              Text(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                'Made with ❤️\nby the Flutter & Firebase AI Logic Teams',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 4, 8),
          child: Image.asset('assets/firebase-ai-logic.png'),
        ),
        title: Text(
          style: Theme.of(context).textTheme.titleLarge,
          'Flutter x Firebase AI Logic',
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(4, 8, 16, 8),
            child: IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () => showMoreInfo(context),
            ),
          ),
        ],
      ),
      body: AppFrame(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Text(
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
                "Build AI features for your Flutter apps using the Firebase AI Logic SDK.\nPowered by Google AI models.",
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final demo = demos[index];

                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => demo.page),
                      ),
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadiusGeometry.circular(16),
                      ),
                      leading: demo.icon,
                      title: Text(
                        demo.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(demo.description),
                      tileColor: Theme.of(context).colorScheme.primaryContainer,
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.primaryFixedDim,
                      ),
                    ),
                  );
                },
                itemCount: demos.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8.0,
              ),
              child: Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: '* Demo includes some features that require ',
                    ),
                    WidgetSpan(
                      baseline: TextBaseline.ideographic,
                      alignment: PlaceholderAlignment.top,
                      child: Link(
                        uri: Uri.parse('https://firebase.google.com/pricing'),
                        target: LinkTarget.blank,
                        builder: (context, followLink) => GestureDetector(
                          onTap: followLink,
                          child: Text(
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  height: 1.15,
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                            'Blaze plan',
                          ),
                        ),
                      ),
                    ),
                    TextSpan(text: ', which you can '),
                    WidgetSpan(
                      baseline: TextBaseline.ideographic,
                      alignment: PlaceholderAlignment.top,
                      child: Link(
                        uri: Uri.parse(
                          'https://console.firebase.google.com/project/${DefaultFirebaseOptions.currentPlatform.projectId}/overview?purchaseBillingPlan=metered',
                        ),
                        target: LinkTarget.blank,
                        builder: (context, followLink) => GestureDetector(
                          onTap: followLink,
                          child: Text(
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  height: 1.15,
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                            'enable in Firebase Console',
                          ),
                        ),
                      ),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
