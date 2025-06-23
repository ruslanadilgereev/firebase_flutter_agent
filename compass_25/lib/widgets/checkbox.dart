// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.backgroundColor,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: 24,
      onTap: () => onChanged(!value),
      splashColor: Colors.transparent, // Remove splash effect
      highlightColor: Colors.transparent, // Remove highlight effect
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(24),
          color:
          value
              ? backgroundColor ?? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          child: SizedBox(
            width: 24,
            height: 24,
            child: Visibility(
              visible: value,
              child: Icon(
                Icons.check,
                size: 18,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}