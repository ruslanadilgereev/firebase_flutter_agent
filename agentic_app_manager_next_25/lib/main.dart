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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    BetterFeedback(
      theme: FeedbackThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      child: ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppState manager = context.watch<AppState>();

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: manager.appColor),
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: context.watch<AppState>().fontFamily,
          fontSizeFactor: context.watch<AppState>().fontSizeFactor,
        ),
      ),
      home: const MyHomePage(title: 'myMail'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppAgent appAgent = AppAgent();

  @override
  void initState() {
    super.initState();
    appAgent.initialize();
  }

  void submitFeedback() {
    BetterFeedback.of(context).show((UserFeedback feedback) {
      appAgent.submitFeedback(context, feedback.screenshot, feedback.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: submitFeedback, icon: Icon(Icons.bug_report)),
        ],
      ),
      body: MyMailScreen(),
    );
  }
}
