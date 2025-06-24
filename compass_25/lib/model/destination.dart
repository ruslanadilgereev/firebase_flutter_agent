// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'destination.g.dart';

@JsonSerializable()
class Destination {
  /// e.g. 'alaska'
  final String ref;

  /// e.g. 'Alaska'
  final String name;

  /// e.g. 'United States'
  final String country;

  /// e.g. 'North America'
  final String continent;

  /// e.g. 'Alaska is a haven for outdoor enthusiasts ...'
  final String knownFor;

  /// e.g. 'Alaska is a haven for outdoor enthusiasts ...'
  final List<String> tags;

  /// e.g. 'https://storage.googleapis.com/tripedia-images/destinations/alaska.jpg'
  final String imageUrl;

  /// e.g. {"latitude": 64.2008, "longitude": -149.4937}
  final Location location;

  Destination(
    this.ref,
    this.name,
    this.country,
    this.continent,
    this.knownFor,
    this.tags,
    this.imageUrl,
    this.location,
  );

  factory Destination.fromJson(Map<String, dynamic> json) =>
      _$DestinationFromJson(json);

  Map<String, dynamic> toJson() => _$DestinationToJson(this);
}

@JsonSerializable()
class Location {
  final double latitude;
  final double longitude;

  const Location(this.latitude, this.longitude);

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
