import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './agentic_app_manager/agentic_app_manager_demo.dart';
import './audio_app_manager/audio_app_manager_demo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(AgenticAppManagerDemo());

  // Run this app instead for realtime audio streaming:
  // runApp(AudioAgenticAppManagerDemo());
}
