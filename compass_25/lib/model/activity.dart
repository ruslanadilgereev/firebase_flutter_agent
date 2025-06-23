// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

enum TimeOfDay {
  any,
  morning,
  afternoon,
  evening,
  night;

  @override
  String toString() {
    return super.toString().split('.').last;
  }
}

@JsonSerializable()
class Activity {
  final String name;
  final String description;
  final String locationName;
  final int duration;
  final TimeOfDay timeOfDay;
  final bool familyFriendly;
  final int price;
  final String destinationRef;
  final String ref;
  final String imageUrl;

  Activity({
    required this.name,
    required this.description,
    required this.locationName,
    required this.duration,
    required this.timeOfDay,
    required this.familyFriendly,
    required this.price,
    required this.destinationRef,
    required this.ref,
    required this.imageUrl,
  });

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  @override
  String toString() {
    return 'Activity{name: $name}';
  }
}
