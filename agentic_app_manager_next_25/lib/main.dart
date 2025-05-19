import 'package:agentic_app_manager/image_generator.dart';
import 'package:flutter/material.dart';
import 'package:feedback/feedback.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:typed_data';
import 'firebase_options.dart';
import 'fake_mail_screen/mail_screen.dart';
import 'agentic_app_manager/app_agent.dart';

import './app_state.dart';
import './agentic_app_manager/agentic_app_manager_demo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(AgenticAppManagerDemo());
}
