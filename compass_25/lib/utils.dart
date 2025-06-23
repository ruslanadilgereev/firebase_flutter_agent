// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String dateFormatStartEnd(DateTimeRange dateTimeRange) {
  final start = dateTimeRange.start;
  final end = dateTimeRange.end;

  String addOrdinal(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  final dayStart = addOrdinal(start.day);
  final monthStart = DateFormat('MMMM').format(start);
  final dayMonthStart = '$dayStart $monthStart';

  final dayEnd = addOrdinal(end.day);
  final monthEnd = DateFormat('MMMM').format(end);
  final dayMonthEnd = '$dayEnd $monthEnd';

  return '$dayMonthStart - $dayMonthEnd';
}
