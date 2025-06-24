// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AdaptiveBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return _buildAndroidBackButton(context);
    } else {
      return ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 38,
            height: 38,
            color: Colors.white.withValues(alpha: 0.2),
            child: Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  borderRadius: BorderRadius.circular(30),
                  onPressed: () {
                    onPressed();
                  },
                  child: const Icon(CupertinoIcons.xmark, color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildAndroidBackButton(BuildContext context) {
    return SizedBox(
      height: 40.0,
      width: 40.0,
      child: Material(
        color: Color(0xCCFFFFFF),
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            onPressed();
          },
          child: const Center(
            child: Icon(Icons.arrow_back, size: 24.0, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
