// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CompassAppAuth extends ValueNotifier<User?> {
  CompassAppAuth() : super(FirebaseAuth.instance.currentUser) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      value = user;
    });
  }

  String? get userId => value?.uid;
  bool get isLoggedIn => value != null;

  Future<void> login() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
