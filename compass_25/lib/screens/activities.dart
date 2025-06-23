// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cupertino_compass/adaptive/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../adaptive/loading.dart';
import '../adaptive/widgets.dart' as adaptive;
import '../model/activity.dart';
import '../model/app_data.dart';
import '../model/booking.dart';
import '../model/destination.dart';
import '../theme.dart';
import '../widgets/activity.dart';
import 'booking.dart';

class ActivitiesScreen extends StatefulWidget {
  final Destination destination;
  final DateTimeRange? dateTimeRange;
  const ActivitiesScreen({
    required this.destination,
    this.dateTimeRange,
    super.key,
  });

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  List<Activity>? _activities;
  List<bool> _selected = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  List<Activity> get _selectedActivities {
    if (_activities == null) {
      return [];
    }
    var result = <Activity>[];
    for (var i = 0; i < _activities!.length; i++) {
      if (_selected[i] == true) {
        result.add(_activities![i]);
      }
    }
    return result;
  }

  Future<void> _loadActivities() async {
    var result = await Provider.of<CompassAppData>(
      context,
      listen: false,
    ).getActivities(widget.destination.ref);

    setState(() {
      _activities = result;
      _selected = List.filled(result.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var activities = _activities;

    return Scaffold(
      appBar: AppBar(title: Text('Activities')),
      body: Column(
        children: [
          if (activities != null)
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int idx) {
                  return ActivityEntry(
                    activity: activities[idx],
                    selected: _selected[idx],
                    showCheckbox: true,
                    onChanged: (bool? value) {
                      setState(() {
                        _selected[idx] = !_selected[idx];
                      });
                    },
                  );
                },
                itemCount: activities.length,
              ),
            )
          else
            Expanded(child: Center(child: AdaptiveLoadingIndicator())),
          _BottomArea(
            onPressed: () {
              showBottomSheetAdaptive(
                context: context,
                child: BookingScreen(
                  booking: Booking(
                    destinationRef: widget.destination.ref,
                    startDate: widget.dateTimeRange?.start ?? DateTime.now(),
                    endDate: widget.dateTimeRange?.end ?? DateTime.now(),
                    activitiesRefs:
                        _selectedActivities.map((e) => e.ref).toList(),
                  ),
                  appData: context.read<CompassAppData>(),
                ),
              );
            },
            selectedActivities: _selectedActivities,
          ),
        ],
      ),
    );
  }
}

class _BottomArea extends StatelessWidget {
  final VoidCallback onPressed;
  final List<Activity> selectedActivities;
  const _BottomArea({
    required this.onPressed,
    required this.selectedActivities,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${selectedActivities.length} selected",
                style: TextTheme.of(
                  context,
                ).bodyLarge!.copyWith(color: Colors.grey.shade500),
              ),
            ),
            adaptive.Button(
              onPressed: selectedActivities.isNotEmpty ? onPressed : null,
              color: AppColors.primary,
              small: true,
              child: Text(
                'Confirm',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
