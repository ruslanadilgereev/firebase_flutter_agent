// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

import 'destination.dart';

part 'continent.g.dart';

@JsonSerializable()
class Continent {
  final String name;
  final String imageUrl;
  final Location location;

  const Continent({
    required this.name,
    required this.imageUrl,
    required this.location,
  });

  factory Continent.fromJson(Map<String, dynamic> json) =>
      _$ContinentFromJson(json);

  Map<String, dynamic> toJson() => _$ContinentToJson(this);
}
