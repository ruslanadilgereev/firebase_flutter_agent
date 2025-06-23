// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'booking.g.dart';

@JsonSerializable()
class Booking {
  final DateTime startDate;
  final DateTime endDate;
  final String destinationRef;
  final List<String> activitiesRefs;

  Booking({
    required this.startDate,
    required this.endDate,
    required this.destinationRef,
    required this.activitiesRefs,
  });

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
