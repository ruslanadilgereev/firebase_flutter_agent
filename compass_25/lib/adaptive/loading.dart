// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

/// A widget that switches between CircularProgressIndicator on Android,
/// and CupertinoActivityIndicator on iOS.
class AdaptiveLoadingIndicator extends StatelessWidget {
  final double? radius;
  final Color? color;

  const AdaptiveLoadingIndicator({super.key, this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(radius: radius ?? 10);
    } else {
      return CircularProgressIndicator(color: color);
    }
  }
}
