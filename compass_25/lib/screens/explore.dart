// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cupertino_compass/adaptive/bottom_sheet.dart';
import 'package:cupertino_compass/adaptive/loading.dart';
import 'package:cupertino_compass/router.dart';
import 'package:cupertino_compass/screens/activities.dart';
import 'package:cupertino_compass/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/app_data.dart';
import '../model/destination.dart';
import '../widgets/destination.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Destination>? _destinations;
  List<Destination>? _visibleDestinations;
  DateTimeRange? _dateTimeRange;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    var appData = Provider.of<CompassAppData>(context, listen: false);
    var result = await appData.getDestinations();
    setState(() {
      _destinations = result;
      _visibleDestinations = _destinations?.toList();
    });
  }

  void _filterBySearch(Search search) {
    setState(() {
      if (search.continent == null) {
        _visibleDestinations = _destinations;
      } else {
        _visibleDestinations =
            _destinations
                ?.where((d) => d.continent == search.continent?.name)
                .toList();
      }
      _dateTimeRange = search.dateTimeRange;
    });
  }

  @override
  Widget build(BuildContext context) {
    var destinations = _visibleDestinations;
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(width: 128, child: Image.asset('assets/logo.png')),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showBottomSheetAdaptive(
                navigatorState: navigatorKey.currentState,
                context: context,
                child: SearchScreen(
                  onSearch: (search) {
                    _filterBySearch(search);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (destinations != null)
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, idx) {
                  return AspectRatio(
                    aspectRatio: 7 / 5,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DestinationWidget(
                        destination: destinations[idx],
                        onTap: () {
                          navigatorKey.currentState!.push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return ActivitiesScreen(
                                  destination: destinations[idx],
                                  dateTimeRange: _dateTimeRange,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                itemCount: destinations.length,
              ),
            )
          else
            Expanded(child: Center(child: AdaptiveLoadingIndicator())),
        ],
      ),
    );
  }
}
