// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';

class AdaptiveTextField extends Widget {
  final TextEditingController? controller;
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool expands;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final InputDecoration? decoration;
  final BoxDecoration? cupertinoDecoration;
  final EdgeInsetsGeometry? padding;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool readOnly;
  final bool autofocus;
  final Color? cursorColor;
  final Radius? cursorRadius;
  final double cursorWidth;

  const AdaptiveTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.expands = false,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.decoration,
    this.cupertinoDecoration,
    this.padding,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.readOnly = false,
    this.autofocus = false,
    this.cursorColor,
    this.cursorRadius,
    this.cursorWidth = 2.0,
  });

  @override
  Element createElement() {
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS ||
      TargetPlatform.macOS => CupertinoTextFieldElement(this),
      _ => MaterialTextFieldElement(this),
    };
  }
}

class MaterialTextFieldElement extends ComponentElement {
  MaterialTextFieldElement(AdaptiveTextField super.widget);

  @override
  Widget build() {
    final adaptiveWidget = widget as AdaptiveTextField;
    return material.TextFormField(
      controller: adaptiveWidget.controller,
      decoration:
          adaptiveWidget.decoration ??
          material.InputDecoration(hintText: adaptiveWidget.placeholder),
      keyboardType: adaptiveWidget.keyboardType,
      obscureText: adaptiveWidget.obscureText,
      validator: adaptiveWidget.validator,
      onChanged: adaptiveWidget.onChanged,
      onFieldSubmitted: adaptiveWidget.onSubmitted,
      focusNode: adaptiveWidget.focusNode,
      textInputAction: adaptiveWidget.textInputAction,
      maxLines: adaptiveWidget.maxLines,
      minLines: adaptiveWidget.minLines,
      maxLength: adaptiveWidget.maxLength,
      expands: adaptiveWidget.expands,
      textCapitalization: adaptiveWidget.textCapitalization,
      style: adaptiveWidget.style,
      textAlign: adaptiveWidget.textAlign,
      textAlignVertical: adaptiveWidget.textAlignVertical,
      readOnly: adaptiveWidget.readOnly,
      autofocus: adaptiveWidget.autofocus,
      cursorColor: adaptiveWidget.cursorColor,
      cursorRadius: adaptiveWidget.cursorRadius,
      cursorWidth: adaptiveWidget.cursorWidth,
    );
  }
}

class CupertinoTextFieldElement extends ComponentElement {
  CupertinoTextFieldElement(AdaptiveTextField super.widget);

  @override
  Widget build() {
    final adaptiveWidget = widget as AdaptiveTextField;
    return cupertino.CupertinoTextField(
      controller: adaptiveWidget.controller,
      placeholder: adaptiveWidget.placeholder,
      keyboardType: adaptiveWidget.keyboardType,
      obscureText: adaptiveWidget.obscureText,
      onChanged: adaptiveWidget.onChanged,
      onSubmitted: adaptiveWidget.onSubmitted,
      focusNode: adaptiveWidget.focusNode,
      textInputAction: adaptiveWidget.textInputAction,
      maxLines: adaptiveWidget.maxLines,
      minLines: adaptiveWidget.minLines,
      maxLength: adaptiveWidget.maxLength,
      expands: adaptiveWidget.expands,
      textCapitalization: adaptiveWidget.textCapitalization,
      style: adaptiveWidget.style,
      decoration: adaptiveWidget.cupertinoDecoration,
      padding: adaptiveWidget.padding ?? EdgeInsets.all(7.0),
      textAlign: adaptiveWidget.textAlign,
      textAlignVertical: adaptiveWidget.textAlignVertical,
      readOnly: adaptiveWidget.readOnly,
      autofocus: adaptiveWidget.autofocus,
      cursorColor: adaptiveWidget.cursorColor,
      cursorRadius: adaptiveWidget.cursorRadius ?? const Radius.circular(2.0),
      cursorWidth: adaptiveWidget.cursorWidth,
    );
  }
}
