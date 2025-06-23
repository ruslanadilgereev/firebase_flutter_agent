// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth.dart';
import 'firebase_options.dart';
import 'model/app_data.dart';
import 'router.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const CompassApp());
}

class CompassApp extends StatefulWidget {
  const CompassApp({super.key});

  @override
  State<CompassApp> createState() => _CompassAppState();
}

class _CompassAppState extends State<CompassApp> {
  late final CompassAppData _appData;
  late final CompassAppAuth _auth;
  late final CompassAppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _auth = CompassAppAuth();
    _appData = CompassAppData(auth: _auth);
    _appRouter = CompassAppRouter(_auth);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CompassAppData>.value(value: _appData),
        ChangeNotifierProvider<CompassAppAuth>.value(value: _auth),
      ],
      child: MaterialApp.router(
        title: 'Compass',
        routerConfig: _appRouter.router,
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
      ),
    );
  }
}
