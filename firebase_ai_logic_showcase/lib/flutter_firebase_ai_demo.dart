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
import 'shared/ui/blaze_warning.dart';

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
    name: 'Gemini Live API',
    description: 'Real-time bidirectional audio & video streaming with Gemini.',
    icon: Icon(size: 32, Icons.video_call),
    page: LiveAPIDemo(),
  ),
  Demo(
    name: 'Multimodal Prompt',
    description:
        'Ask a Gemini model about an image, audio, video, or PDF file.',
    icon: Icon(size: 32, Icons.attach_file),
    page: MultimodalDemo(),
  ),
  Demo(
    name: 'Create & Edit Images with Nano Banana *',
    description:
        'Chat with a Gemini model, including a chat history, tool calling, and even image generation.',
    icon: Text(style: TextStyle(fontSize: 28), '🍌'),
    page: ChatDemo(),
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
          'Flutter AI Playground',
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
                "Build AI features in your Flutter apps – use the Firebase AI Logic SDK to access Google's AI models directly from your app.",
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
            BlazeFooter(),
          ],
        ),
      ),
    );
  }
}
