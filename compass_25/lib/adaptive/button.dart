// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;
  final BorderRadius? borderRadius;
  final bool small;

  const Button({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.borderRadius,
    this.small = false, // Added the small parameter with a default value
  });

  @override
  Widget build(BuildContext context) {
    final buttonPadding =
    small
        ? const EdgeInsets.symmetric(horizontal: 16.0)
        : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
    final buttonTextStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: small ? Theme.of(context).textTheme.bodyMedium?.fontSize : null,
    );

    final fullyRoundedRadius = 24.0; // A sufficiently large radius

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return CupertinoButton(
        onPressed: onPressed,
        color: color,
        borderRadius: BorderRadius.circular(fullyRoundedRadius),
        padding: EdgeInsets.zero,
        child: Padding(
          padding: buttonPadding,
          child: DefaultTextStyle(
            style: buttonTextStyle ?? const TextStyle(),
            child: child,
          ),
        ),
      );
    } else {
      return MaterialButton(
        onPressed: onPressed,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(fullyRoundedRadius),
        ),
        padding: buttonPadding,
        child: DefaultTextStyle(
          style: buttonTextStyle ?? const TextStyle(),
          child: child,
        ),
      );
    }
  }
}